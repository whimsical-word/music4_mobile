import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AppAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player;
  
  // Callbacks to trigger Riverpod logic
  void Function()? onSkipToNextCb;
  void Function()? onSkipToPreviousCb;

  AppAudioHandler(this._player) {
    _player.playbackEventStream.listen(_broadcastState);
  }

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    ));
  }

  // Cập nhật thông tin bài hát lên màn hình khóa
  void updateCurrentMediaItem({
    required String id,
    required String title,
    required String artist,
    required String? artUri,
    required Duration? duration,
  }) {
    mediaItem.add(MediaItem(
      id: id,
      title: title,
      artist: artist,
      artUri: artUri != null ? Uri.tryParse(artUri) : null,
      duration: duration,
    ));
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    if (onSkipToNextCb != null) onSkipToNextCb!();
  }

  @override
  Future<void> skipToPrevious() async {
    if (onSkipToPreviousCb != null) onSkipToPreviousCb!();
  }
}
