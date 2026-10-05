import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../domain/models/player_state_data.dart';
import '../../../auth/data/datasources/token_storage.dart';
import '../../../../features/track_detail/data/repositories/track_detail_repository.dart';
import '../../data/services/app_audio_handler.dart';
import '../../../tracking/application/playback_tracker.dart';
import '../../../tracking/presentation/providers/playback_tracker_provider.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
 final player = AudioPlayer();
 ref.onDispose(() => player.dispose());
 return player;
});

final audioHandlerProvider = Provider<AppAudioHandler>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

final playerNotifierProvider = StateNotifierProvider<PlayerNotifier, AsyncValue<PlayerStateData>>((ref) {
 final audioHandler = ref.watch(audioHandlerProvider);
 final player = ref.watch(audioPlayerProvider);
 final trackDetailRepo = ref.watch(trackDetailRepositoryProvider);
 final tracker = ref.watch(playbackTrackerProvider);
 return PlayerNotifier(player, trackDetailRepo, audioHandler, tracker: tracker);
});

class PlayerNotifier extends StateNotifier<AsyncValue<PlayerStateData>> {
 final AudioPlayer _player;
 final TrackDetailRepository _trackDetailRepo;
 final AppAudioHandler _audioHandler;

 // Listening tracking (position sync every 10s + count a view on full completion).
 // Optional so existing tests / callers that build a PlayerNotifier are unaffected.
 final PlaybackTracker? _tracker;

 // ── Spotify-style Queue: tự quản lý playlist + index thay vì dùng ConcatenatingAudioSource ──
 // Lý do: ConcatenatingAudioSource.seek(index) trên just_audio_windows_plus gây ra transient states
 // (bắn index 0 rác), corrupt player state khi bấm Next/Prev nhanh, và không tự resume playback
 // sau khi buffer bị hủy. Spotify giải quyết bằng cách load từng bài đơn lẻ.
 List<TrackQueueItem> _playlist = [];
 int _currentIndex = 0;

 List<int> _shuffledIndices = [];
 bool _isShuffle = false;
 RepeatState _repeatMode = RepeatState.off;

 // Guard: chặn positionStream/bufferedPositionStream cập nhật UI khi đang load bài mới

 int? _getNextIndex() {
 if (_playlist.isEmpty) return null;
 if (_repeatMode == RepeatState.one) return _currentIndex;

 if (_isShuffle) {
 int pos = _shuffledIndices.indexOf(_currentIndex);
 if (pos < _shuffledIndices.length - 1) return _shuffledIndices[pos + 1];
 return _repeatMode == RepeatState.all ? _shuffledIndices.first : null;
 } else {
 if (_currentIndex < _playlist.length - 1) return _currentIndex + 1;
 return _repeatMode == RepeatState.all ? 0 : null;
 }
 }

 int? _getPreviousIndex() {
 if (_playlist.isEmpty) return null;
 if (_repeatMode == RepeatState.one) return _currentIndex;

 if (_isShuffle) {
 int pos = _shuffledIndices.indexOf(_currentIndex);
 if (pos > 0) return _shuffledIndices[pos - 1];
 return _repeatMode == RepeatState.all ? _shuffledIndices.last : null;
 } else {
 if (_currentIndex > 0) return _currentIndex - 1;
 return _repeatMode == RepeatState.all ? _playlist.length - 1 : null;
 }
 }

 void toggleShuffle() {
 _isShuffle = !_isShuffle;
 if (_isShuffle && _playlist.isNotEmpty) {
 _shuffledIndices = List.generate(_playlist.length, (i) => i)..shuffle();
 _shuffledIndices.remove(_currentIndex);
 _shuffledIndices.insert(0, _currentIndex);
 }
 state = state.whenData((data) => data.copyWith(
 isShuffle: _isShuffle,
 hasNext: _getNextIndex() != null,
 hasPrevious: _getPreviousIndex() != null,
 ));
 }

 void toggleRepeat() {
 switch (_repeatMode) {
 case RepeatState.off: _repeatMode = RepeatState.all; break;
 case RepeatState.all: _repeatMode = RepeatState.one; break;
 case RepeatState.one: _repeatMode = RepeatState.off; break;
 }
 state = state.whenData((data) => data.copyWith(
 repeatMode: _repeatMode,
 hasNext: _getNextIndex() != null,
 hasPrevious: _getPreviousIndex() != null,
 ));
 }

 bool _isLoadingTrack = false;

 // Mỗi lần gọi _loadAndPlayCurrentTrack, tăng _loadId lên 1.
 // Nếu một load cũ đang chạy dở mà load mới bắt đầu, load cũ sẽ tự hủy khi thấy _loadId đã thay đổi.
 int _loadId = 0;
  PlayerNotifier(this._player, this._trackDetailRepo, this._audioHandler, {this._tracker}) : super(const AsyncData(PlayerStateData())) {
    _audioHandler.onSkipToNextCb = () => next();
    _audioHandler.onSkipToPreviousCb = () => previous();
 _initStreams();
 }

 void _initStreams() {
 _player.playerStateStream.listen((playerState) {
 final isPlaying = playerState.playing;
 state = state.whenData((data) => data.copyWith(isPlaying: isPlaying));

 // Auto-advance: bài hát phát xong tự nhiên → chuyển sang bài kế tiếp
 if (playerState.processingState == ProcessingState.completed) {
 // Báo cho tracker: bài hát phát xong tự nhiên (tracker tự lọc trùng / chưa nghe đủ).
 _tracker?.onCompleted();
  final nextIdx = _getNextIndex();
  if (nextIdx != null) {
  _currentIndex = nextIdx;
  _loadAndPlayCurrentTrack();
  } else {
  _player.seek(Duration.zero);
  _player.pause();
  }
 }
 }, onError: (Object e, StackTrace st) {
 state = AsyncError("Lỗi khi phát nhạc: ${e.toString()}", st);
 });

 _player.positionStream.listen((position) {
 if (_isLoadingTrack) return;
 _tracker?.onPosition(position);
 state = state.whenData((data) => data.copyWith(position: position));
 });

 _player.bufferedPositionStream.listen((bufferedPosition) {
 if (_isLoadingTrack) return;
 state = state.whenData((data) => data.copyWith(bufferedPosition: bufferedPosition));
 });

 _player.durationStream.listen((duration) {
 if (duration != null) {
  _tracker?.updateDuration(duration);
  state = state.whenData((data) => data.copyWith(duration: duration));
 }
 });
 }

 // ══════════════════════════════════════════════════════════
 // Core: Load và phát bài hát tại _currentIndex
 // ══════════════════════════════════════════════════════════
 Future<void> _loadAndPlayCurrentTrack() async {
 if (_playlist.isEmpty || _currentIndex < 0 || _currentIndex >= _playlist.length) return;

 // Tăng loadId: mọi lần load cũ đang chạy sẽ tự nhận ra mình bị lỗi thời và dừng lại
 _loadId++;
 final myLoadId = _loadId;
 _isLoadingTrack = true;

 final item = _playlist[_currentIndex];

 // Bắt đầu phiên nghe mới (bỏ phiên cũ => skip không bị tính lượt nghe).
 _tracker?.startTrack(trackId: item.id, duration: item.duration);

 // Cập nhật UI ngay lập tức (Optimistic UI)
 state = state.whenData((data) => data.copyWith(
      currentTrackId: item.id,
      title: item.title,
      artist: item.artist,
      coverUrl: item.coverUrl,
      duration: item.duration,
      hasNext: _getNextIndex() != null,
      hasPrevious: _getPreviousIndex() != null,
      position: Duration.zero,
      bufferedPosition: Duration.zero,
      isLiked: false, // Tạm thời set false, sẽ check api sau
    ));
    
    // Cập nhật lên Notification / Lockscreen
    _audioHandler.updateCurrentMediaItem(
      id: item.id,
      title: item.title,
      artist: item.artist,
      artUri: item.coverUrl,
      duration: item.duration,
    );

    // Gọi API check isFavorite ngầm (không chặn UI)
    _trackDetailRepo.checkIsFavorite(int.tryParse(item.id) ?? 0).then((isLiked) {
      if (mounted && _loadId == myLoadId) {
        state = state.whenData((data) => data.copyWith(isLiked: isLiked));
      }
    }).catchError((_) {});


 try {
 // Chỉ stop nếu đang có bài hát, tránh lỗi MediaFoundation trên Windows khi stop player rỗng
 if (_player.audioSource != null) {
  await _player.stop();
 }
 if (_loadId != myLoadId) return; // Load đã bị supersede

 final token = await TokenStorage.instance.getAccessToken();
 final streamUrl = '${ApiEndpoints.baseUrl}/api/tracks/stream/${item.id}?token=${token ?? ""}';

 AudioSource source;
 if (Platform.isWindows) {
  source = AudioSource.uri(Uri.parse(streamUrl), tag: item);
 } else {
  final cacheDir = await getApplicationDocumentsDirectory();
  if (_loadId != myLoadId) return;
  // ignore: experimental_member_use
  source = LockCachingAudioSource(
  Uri.parse(streamUrl),
  tag: item,
  cacheFile: File('${cacheDir.path}/music4_cache_${item.id}.mp3'),
  );
 }

 // Ép player reset về 0 để tránh kẹt trạng thái
 await _player.setAudioSource(source, initialPosition: Duration.zero);
 if (_loadId != myLoadId) return;

 _player.play().catchError((e) {
  debugPrint("Lỗi auto-play: $e");
 });

 // Workaround: Khắc phục lỗi MediaFoundation (Windows) "nuốt" lệnh play ở lần chạy đầu tiên.
 // Kiểm tra lại sau 150ms, nếu vẫn chưa play (do bị ignore) thì gọi ép lại.
 Future.delayed(const Duration(milliseconds: 150), () {
  if (_loadId == myLoadId && !_player.playing) {
  debugPrint("Retry auto-play do Windows nuốt lệnh...");
  _player.play();
  }
 });
 } catch (e, st) {
 // Chỉ báo lỗi nếu đây vẫn là lần load hiện hành (không bị supersede)
 if (_loadId == myLoadId) {
  state = AsyncError("Không thể tải bài hát.", st);
 }
 } finally {
 if (_loadId == myLoadId) {
  _isLoadingTrack = false;
 }
 }
 }

 // ══════════════════════════════════════════════════════════
 // Public API: Khởi tạo playlist
 // ══════════════════════════════════════════════════════════
 Future<void> playPlaylist(List<TrackQueueItem> playlist, int initialIndex) async {
 _playlist = List.from(playlist);
 _currentIndex = initialIndex.clamp(0, playlist.length - 1);
 
 _shuffledIndices = List.generate(_playlist.length, (i) => i);
 if (_isShuffle) {
 _shuffledIndices.shuffle();
 _shuffledIndices.remove(_currentIndex);
 _shuffledIndices.insert(0, _currentIndex);
 }
 await _loadAndPlayCurrentTrack();
 }

 // ══════════════════════════════════════════════════════════
 // Next / Previous với Debounce
 // ══════════════════════════════════════════════════════════
 DateTime _lastSeekRequestTime = DateTime.fromMillisecondsSinceEpoch(0);
 static const _seekDebounce = Duration(milliseconds: 150);

 Future<void> next() async {
 final nextIdx = _getNextIndex();
 if (nextIdx == null) return;

 _currentIndex = nextIdx;
 _lastSeekRequestTime = DateTime.now();

 final item = _playlist[_currentIndex];
 state = state.whenData((data) => data.copyWith(
 currentTrackId: item.id,
 title: item.title,
 artist: item.artist,
 coverUrl: item.coverUrl,
 duration: item.duration,
 hasNext: _getNextIndex() != null,
 hasPrevious: true,
 position: Duration.zero,
 bufferedPosition: Duration.zero,
 ));

 final myRequestTime = _lastSeekRequestTime;
 await Future.delayed(_seekDebounce);
 if (_lastSeekRequestTime != myRequestTime) return;

 await _loadAndPlayCurrentTrack();
 }

 Future<void> previous() async {
 if (_playlist.isEmpty) return;

 // Nếu đang phát quá 3 giây → restart bài hiện tại (UX chuẩn Spotify)
 if (_player.position > const Duration(seconds: 3)) {
 await _player.seek(Duration.zero);
 return;
 }

 // Nếu đã ở bài đầu tiên → restart bài hiện tại
 if (_currentIndex <= 0) {
 await _player.seek(Duration.zero);
 return;
 }

 _currentIndex--;
 _lastSeekRequestTime = DateTime.now();

 // Optimistic UI update
 final item = _playlist[_currentIndex];
 state = state.whenData((data) => data.copyWith(
 currentTrackId: item.id,
 title: item.title,
 artist: item.artist,
 coverUrl: item.coverUrl,
 duration: item.duration,
 hasNext: true,
 hasPrevious: _currentIndex > 0,
 position: Duration.zero,
 bufferedPosition: Duration.zero,
 ));

 final myRequestTime = _lastSeekRequestTime;
 await Future.delayed(_seekDebounce);
 if (_lastSeekRequestTime != myRequestTime) return; // superseded

 await _loadAndPlayCurrentTrack();
 }

 // ══════════════════════════════════════════════════════════
 // Play / Pause / Seek
 // ══════════════════════════════════════════════════════════
   Future<void> toggleFavorite() async {
    final currentState = state.value;
    if (currentState == null || currentState.currentTrackId == null) return;
    
    try {
      final isLiked = await _trackDetailRepo.toggleFavorite(int.tryParse(currentState.currentTrackId!) ?? 0);
      if (mounted) {
        state = AsyncValue.data(currentState.copyWith(isLiked: isLiked));
      }
    } catch (e) {
      debugPrint('Lỗi thả tim: ');
    }
  }


 Future<void> play() async {
 try {
 await _player.play();
 } catch (e, st) {
 state = AsyncError("Không thể phát nhạc. Vui lòng thử lại.", st);
 }
 }

 Future<void> pause() async {
 try {
 await _player.pause();
 } catch (e, st) {
 state = AsyncError("Lỗi khi tạm dừng.", st);
 }
 }

 Future<void> seek(Duration position) async {
 try {
 await _player.seek(position);
 } catch (e, st) {
 state = AsyncError("Lỗi khi tua nhạc.", st);
 }
 }
}
