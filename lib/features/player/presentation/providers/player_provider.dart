import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/services/audio_cache_service.dart';
import '../../domain/models/player_state_data.dart';
import '../../../auth/data/datasources/token_storage.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
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
 final notifier = PlayerNotifier(player, trackDetailRepo, audioHandler, tracker: tracker);

 ref.listen<AuthState>(authNotifierProvider, (previous, next) {
   if (next is AuthAuthenticated) {
     notifier.onUserAuthenticated();
   } else if (next is AuthUnauthenticated) {
     notifier.onUserLoggedOut();
   }
 });

 return notifier;
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
  _tracker?.onCompleted();

  final isPreview = state.value?.isPreview ?? false;
  if (isPreview) {
    _player.pause();
    state = state.whenData((data) => data.copyWith(
      isPlaying: false,
      showLoginPrompt: true,
    ));
    return;
  }
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

 final isPreview = state.value?.isPreview ?? false;
 if (isPreview && position >= const Duration(seconds: 30)) {
   if (_player.playing) {
     _player.pause();
   }
   if (state.value?.showLoginPrompt != true || state.value?.isPlaying == true || state.value?.position != const Duration(seconds: 30)) {
     state = state.whenData((data) => data.copyWith(
       position: const Duration(seconds: 30),
       isPlaying: false,
       showLoginPrompt: true,
     ));
   }
   return;
 }

 state = state.whenData((data) => data.copyWith(position: position));
 });

 _player.bufferedPositionStream.listen((bufferedPosition) {
 if (_isLoadingTrack) return;
 state = state.whenData((data) => data.copyWith(bufferedPosition: bufferedPosition));
 });

 _player.durationStream.listen((duration) {
 if (duration != null) {
  _tracker?.updateDuration(duration);
  final isPreview = state.value?.isPreview ?? false;
  state = state.whenData((data) => data.copyWith(
    duration: isPreview ? const Duration(seconds: 30) : duration,
  ));
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

 final token = await TokenStorage.instance.getAccessToken();
 final bool isPreview = token == null || token.isEmpty;

 // Cập nhật UI ngay lập tức (Optimistic UI)
 state = state.whenData((data) => data.copyWith(
      currentTrackId: item.id,
      title: item.title,
      artist: item.artist,
      coverUrl: item.coverUrl,
      duration: isPreview ? const Duration(seconds: 30) : item.duration,
      hasNext: _getNextIndex() != null,
      hasPrevious: _getPreviousIndex() != null,
      position: Duration.zero,
      bufferedPosition: Duration.zero,
      isLiked: false, // Tạm thời set false, sẽ check api sau
      isPreview: isPreview,
      showLoginPrompt: false,
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

 final String streamUrl;
 if (!isPreview) {
   streamUrl = '${ApiEndpoints.baseUrl}/api/tracks/stream/${item.id}?token=$token';
 } else {
   streamUrl = '${ApiEndpoints.baseUrl}/api/tracks/stream/preview/${item.id}';
 }

 debugPrint('[AUDIO_STREAM] Track: ${item.id} | Mode: ${isPreview ? "PREVIEW 30s (Guest)" : "FULL (Logged in)"} | URL: $streamUrl');

 final source = await _createAudioSource(
  item: item,
  streamUrl: streamUrl,
  isPreview: isPreview,
 );
 if (_loadId != myLoadId) return;

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
  final errStr = e.toString();
  final errorMsg = errStr.contains('SocketException') || errStr.contains('Failed host lookup')
      ? "Mất kết nối mạng. Bài hát này chưa được lưu để nghe offline."
      : "Không thể tải bài hát.";
  state = AsyncError(errorMsg, st);
 }
 } finally {
 if (_loadId == myLoadId) {
  _isLoadingTrack = false;
 }
 }
 }

  // ══════════════════════════════════════════════════════════
  // Offline Audio Cache Helper (UC42)
  // ══════════════════════════════════════════════════════════
  Future<AudioSource> _createAudioSource({
    required TrackQueueItem item,
    required String streamUrl,
    required bool isPreview,
  }) async {
    final cacheFile = await AudioCacheService.instance.getCacheFile(item.id);
    final isCached = await AudioCacheService.instance.isTrackCached(item.id);

    if (isCached) {
      debugPrint('[AUDIO_CACHE] Phát từ file cache cục bộ (hoàn toàn offline): ${cacheFile.path}');
      state = state.whenData((data) => data.copyWith(isOfflineCached: true));
      return AudioSource.file(cacheFile.path, tag: item);
    }

    state = state.whenData((data) => data.copyWith(isOfflineCached: false));

    if (Platform.isWindows || isPreview) {
      if (Platform.isWindows && !isPreview) {
        _cacheTrackForWindows(item.id, streamUrl, cacheFile);
      }
      return AudioSource.uri(Uri.parse(streamUrl), tag: item);
    }

    // Android / iOS: Dùng LockCachingAudioSource vừa stream vừa ghi cache an toàn
    // ignore: experimental_member_use
    return LockCachingAudioSource(
      Uri.parse(streamUrl),
      tag: item,
      cacheFile: cacheFile,
    );
  }

  void _cacheTrackForWindows(String trackId, String streamUrl, File cacheFile) {
    if (cacheFile.existsSync() && cacheFile.lengthSync() > 102400) return;
    final tmpFile = File('${cacheFile.path}.tmp');
    DioClient().dio.download(
      streamUrl,
      tmpFile.path,
    ).then((_) async {
      if (await tmpFile.exists() && await tmpFile.length() > 102400) {
        await tmpFile.rename(cacheFile.path);
        debugPrint('[WINDOWS_CACHE] Đã lưu cache offline cho bài hát $trackId (${cacheFile.lengthSync()} bytes)');
      } else if (await tmpFile.exists()) {
        await tmpFile.delete();
      }
    }).catchError((e) {
      debugPrint('[WINDOWS_CACHE] Lỗi tải cache ngầm trên Windows: $e');
    });
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
 duration: (state.value?.isPreview ?? false) ? const Duration(seconds: 30) : item.duration,
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
 duration: (state.value?.isPreview ?? false) ? const Duration(seconds: 30) : item.duration,
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


  Future<void> onUserLoggedOut() async {
    try {
      _loadId++;
      _tracker?.onCompleted();
      await _player.stop();
      _playlist = [];
      _currentIndex = 0;
      state = const AsyncData(PlayerStateData());
      await _audioHandler.stop();
    } catch (e) {
      debugPrint("Lỗi dừng nhạc khi đăng xuất: $e");
    }
  }

  Future<void> onUserAuthenticated() async {
    final isPreview = state.value?.isPreview ?? false;
    if (isPreview && _playlist.isNotEmpty && _currentIndex >= 0 && _currentIndex < _playlist.length) {
      final currentPos = state.value?.position ?? Duration.zero;
      await _upgradeToFullStream(resumePosition: currentPos);
    }
  }

  Future<void> _upgradeToFullStream({Duration? resumePosition}) async {
    if (_playlist.isEmpty || _currentIndex < 0 || _currentIndex >= _playlist.length) return;
    final item = _playlist[_currentIndex];
    final token = await TokenStorage.instance.getAccessToken();
    if (token == null || token.isEmpty) return;

    final seekTo = resumePosition ?? state.value?.position ?? Duration.zero;

    _loadId++;
    final myLoadId = _loadId;
    _isLoadingTrack = true;

    state = state.whenData((data) => data.copyWith(
      duration: item.duration,
      isPreview: false,
      showLoginPrompt: false,
      isPlaying: true,
    ));

    _audioHandler.updateCurrentMediaItem(
      id: item.id,
      title: item.title,
      artist: item.artist,
      artUri: item.coverUrl,
      duration: item.duration,
    );

    try {
      if (_player.audioSource != null) {
        await _player.stop();
      }
      if (_loadId != myLoadId) return;

      final streamUrl = '${ApiEndpoints.baseUrl}/api/tracks/stream/${item.id}?token=$token';
      debugPrint('[AUDIO_STREAM] UPGRADE TO FULL: Track ${item.id} -> $streamUrl (resuming at $seekTo)');

      final source = await _createAudioSource(
        item: item,
        streamUrl: streamUrl,
        isPreview: false,
      );
      if (_loadId != myLoadId) return;

      await _player.setAudioSource(source, initialPosition: seekTo);
      if (_loadId != myLoadId) return;

      _player.play().catchError((e) {
        debugPrint("Lỗi auto-play sau khi upgrade full: $e");
      });

      if (Platform.isWindows) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (_loadId == myLoadId && !_player.playing) {
            _player.play();
          }
        });
      }
    } catch (e, st) {
      if (_loadId == myLoadId) {
        state = AsyncError("Không thể tiếp tục phát bản full.", st);
      }
    } finally {
      if (_loadId == myLoadId) {
        _isLoadingTrack = false;
      }
    }
  }

 Future<void> play() async {
   final isPreview = state.value?.isPreview ?? false;
   final token = await TokenStorage.instance.getAccessToken();
   final hasToken = token != null && token.isNotEmpty;

   // Nếu trước đó đang nghe Preview (30s) mà bây giờ đã đăng nhập có token:
   // Tự động nâng cấp sang bản Full và phát tiếp từ điểm đang nghe dở!
   if (isPreview && hasToken) {
     final currentPos = state.value?.position ?? Duration.zero;
     await _upgradeToFullStream(resumePosition: currentPos);
     return;
   }

   final currentPos = state.value?.position ?? Duration.zero;
   if (isPreview && currentPos >= const Duration(seconds: 30)) {
     state = state.whenData((data) => data.copyWith(
       isPlaying: false,
       showLoginPrompt: true,
     ));
     return;
   }
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

 void dismissLoginPrompt() {
   state = state.whenData((data) => data.copyWith(showLoginPrompt: false));
 }

 Future<void> seek(Duration position) async {
   final isPreview = state.value?.isPreview ?? false;
   final token = await TokenStorage.instance.getAccessToken();
   final hasToken = token != null && token.isNotEmpty;

   // Nếu trước đó là Preview mà giờ đã có token -> nâng cấp sang Full stream và tua tới vị trí mong muốn
   if (isPreview && hasToken) {
     await _upgradeToFullStream(resumePosition: position);
     return;
   }

   if (isPreview && position >= const Duration(seconds: 30)) {
     if (_player.playing) {
       await _player.pause();
     }
     await _player.seek(const Duration(seconds: 30));
     state = state.whenData((data) => data.copyWith(
       position: const Duration(seconds: 30),
       isPlaying: false,
       showLoginPrompt: true,
     ));
     return;
   }

 try {
 await _player.seek(position);
 } catch (e, st) {
 state = AsyncError("Lỗi khi tua nhạc.", st);
 }
 }
}
