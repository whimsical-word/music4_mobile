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
      final processingState = playerState.processingState;

      if (processingState == ProcessingState.completed) {
        // Auto pause or next track logic can go here
      }

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
      final currentSource = sequenceState.currentSource;
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

  Future<void> playTrack({
    required String trackId,
    required String title,
    required String artist,
    String? coverUrl,
    Duration? duration,
  }) async {
    try {
      state = const AsyncLoading();
      
      await _player.stop();
      
      final token = await TokenStorage.instance.getAccessToken();
      final streamUrl = '${ApiEndpoints.baseUrl}/api/tracks/stream/$trackId?token=${token ?? ""}';
      
      _player.play(); // Auto-play as soon as source is ready
      
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(streamUrl),
          tag: {
            'id': trackId,
            'title': title,
            'artist': artist,
            'coverUrl': coverUrl,
          },
        ),
      );
      
      state = AsyncData(PlayerStateData(
        currentTrackId: trackId,
        title: title,
        artist: artist,
        coverUrl: coverUrl,
        isPlaying: true, // Optimistic update
        duration: duration ?? Duration.zero,
      ));
    } catch (e, st) {
      state = AsyncError("Không thể tải luồng nhạc. Vui lòng thử lại.", st);
    }
  }

  Future<void> playPlaylist(List<TrackQueueItem> playlist, int initialIndex) async {
    try {
      state = const AsyncLoading();
      await _player.stop();

      final token = await TokenStorage.instance.getAccessToken();
      
      final audioSources = playlist.map((item) {
        final streamUrl = '${ApiEndpoints.baseUrl}/api/tracks/stream/${item.id}?token=${token ?? ""}';
        return AudioSource.uri(
          Uri.parse(streamUrl),
          tag: item,
        );
      }).toList();

      // ignore: deprecated_member_use
      final playlistSource = ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: audioSources,
      );

      _player.play(); // Auto-play

      await _player.setAudioSource(
        playlistSource,
        initialIndex: initialIndex,
        initialPosition: Duration.zero,
      );
      
      state = state.whenData((data) => data.copyWith(isPlaying: true));
    } catch (e, st) {
      state = AsyncError("Lỗi khi tải danh sách phát.", st);
    }
  }

  Future<void> next() async {
    if (_player.hasNext) {
      await _player.seekToNext();
    }
  }

  Future<void> previous() async {
    // If playing for more than 3 seconds, restart the song
    if (_player.position > const Duration(seconds: 3)) {
      await _player.seek(Duration.zero);
    } else {
      // Otherwise go to previous song if it exists, else just restart
      if (_player.hasPrevious) {
        await _player.seekToPrevious();
      } else {
        await _player.seek(Duration.zero);
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
