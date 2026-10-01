import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../domain/models/player_state_data.dart';
import '../../../auth/data/datasources/token_storage.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

final playerNotifierProvider = StateNotifierProvider<PlayerNotifier, AsyncValue<PlayerStateData>>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return PlayerNotifier(player);
});

class PlayerNotifier extends StateNotifier<AsyncValue<PlayerStateData>> {
  final AudioPlayer _player;

  PlayerNotifier(this._player) : super(const AsyncData(PlayerStateData())) {
    _initStreams();
  }

  void _initStreams() {
    _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      state = state.whenData((data) => data.copyWith(isPlaying: isPlaying));
    }, onError: (Object e, StackTrace st) {
      state = AsyncError("Lỗi khi phát nhạc: ${e.toString()}", st);
    });

    _player.positionStream.listen((position) {
      state = state.whenData((data) => data.copyWith(position: position));
    });

    _player.bufferedPositionStream.listen((bufferedPosition) {
      state = state.whenData((data) => data.copyWith(bufferedPosition: bufferedPosition));
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        state = state.whenData((data) => data.copyWith(duration: duration));
      }
    });

    _player.sequenceStateStream.listen((sequenceState) {
      final currentSource = sequenceState?.currentSource;
      if (currentSource == null) return;
      if (currentSource.tag is TrackQueueItem) {
        final tag = currentSource.tag as TrackQueueItem;
        state = state.whenData((data) => data.copyWith(
          currentTrackId: tag.id,
          title: tag.title,
          artist: tag.artist,
          coverUrl: tag.coverUrl,
          duration: tag.duration,
          hasNext: _player.hasNext,
          hasPrevious: _player.hasPrevious,
        ));
      }
    });
  }

  Future<void> playPlaylist(List<TrackQueueItem> playlist, int initialIndex) async {
    try {
      final currentData = state.value ?? const PlayerStateData();
      state = AsyncData(currentData); // Keep as AsyncData
      
      await _player.stop();

      final token = await TokenStorage.instance.getAccessToken();
      
      final audioSources = playlist.map((item) {
        final streamUrl = '${ApiEndpoints.baseUrl}/api/tracks/stream/${item.id}?token=${token ?? ""}';
        return AudioSource.uri(
          Uri.parse(streamUrl),
          tag: item,
        );
      }).toList();

      // Use lazy preparation: only buffer next 1-2 tracks, not the whole playlist at once.
      // Loading ALL tracks simultaneously (useLazyPreparation: false) floods the backend
      // with N concurrent S3 requests, causing connection pool exhaustion and seek lag.
      // ignore: deprecated_member_use
      final playlistSource = ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: audioSources,
      );

      // Await loading completion before calling play()
      await _player.setAudioSource(
        playlistSource,
        initialIndex: initialIndex,
        initialPosition: Duration.zero,
      );
      
      _player.play();
      
    } catch (e, st) {
      state = AsyncError("Lỗi khi tải danh sách phát.", st);
    }
  }

  // Debounce seek: tracks the desired target index, executes seek after a short idle window.
  // This lets the user click Next/Prev as fast as they want — only the final target is acted upon.
  int? _targetSeekIndex;
  DateTime _lastSeekRequestTime = DateTime.fromMillisecondsSinceEpoch(0);
  static const _seekDebounce = Duration(milliseconds: 150);

  Future<void> next() async {
    final sequence = _player.sequence;
    if (sequence == null) return;

    final currentIndex = _targetSeekIndex ?? _player.currentIndex ?? 0;
    final nextIndex = currentIndex + 1;
    if (nextIndex >= sequence.length) return;

    _targetSeekIndex = nextIndex;
    _lastSeekRequestTime = DateTime.now();

    // Optimistic UI update immediately
    final tag = sequence[nextIndex].tag;
    if (tag is TrackQueueItem) {
      state = state.whenData((data) => data.copyWith(
        currentTrackId: tag.id,
        title: tag.title,
        artist: tag.artist,
        coverUrl: tag.coverUrl,
        duration: tag.duration,
        hasNext: nextIndex < sequence.length - 1,
        hasPrevious: true,
        position: Duration.zero,
        bufferedPosition: Duration.zero,
      ));
    }

    // Wait for debounce window — if more clicks come in, this one is superseded
    final myRequestTime = _lastSeekRequestTime;
    await Future.delayed(_seekDebounce);
    if (_lastSeekRequestTime != myRequestTime) return; // superseded by newer click

    // Execute the actual seek to the final target
    try {
      await _player.seek(Duration.zero, index: nextIndex);
    } finally {
      if (_lastSeekRequestTime == myRequestTime) {
        _targetSeekIndex = null;
      }
    }
  }

  Future<void> previous() async {
    final sequence = _player.sequence;
    if (sequence == null) return;

    final currentIndex = _targetSeekIndex ?? _player.currentIndex ?? 0;

    // If user is already at the beginning of progress or rapid prev click, go to prev song
    if (_player.position > const Duration(seconds: 3) && _targetSeekIndex == null) {
      // First press while position > 3s: restart current song
      await _player.seek(Duration.zero);
      return;
    }

    final prevIndex = currentIndex - 1;
    if (prevIndex < 0) {
      await _player.seek(Duration.zero);
      return;
    }

    _targetSeekIndex = prevIndex;
    _lastSeekRequestTime = DateTime.now();

    // Optimistic UI update immediately
    final tag = sequence[prevIndex].tag;
    if (tag is TrackQueueItem) {
      state = state.whenData((data) => data.copyWith(
        currentTrackId: tag.id,
        title: tag.title,
        artist: tag.artist,
        coverUrl: tag.coverUrl,
        duration: tag.duration,
        hasNext: true,
        hasPrevious: prevIndex > 0,
        position: Duration.zero,
        bufferedPosition: Duration.zero,
      ));
    }

    final myRequestTime = _lastSeekRequestTime;
    await Future.delayed(_seekDebounce);
    if (_lastSeekRequestTime != myRequestTime) return; // superseded

    // Execute the actual seek to the final target
    try {
      await _player.seek(Duration.zero, index: prevIndex);
    } finally {
      if (_lastSeekRequestTime == myRequestTime) {
        _targetSeekIndex = null;
      }
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
