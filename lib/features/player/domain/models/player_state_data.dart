enum RepeatState { off, all, one }

class TrackQueueItem {
  final String id;
  final String title;
  final String artist;
  final String? coverUrl;
  final Duration duration;

  const TrackQueueItem({
    required this.id,
    required this.title,
    required this.artist,
    this.coverUrl,
    required this.duration,
  });
}

class PlayerStateData {
  final String? currentTrackId;
  final String title;
  final String artist;
  final String? coverUrl;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;

  final bool hasNext;
  final bool hasPrevious;

  final bool isShuffle;
  final RepeatState repeatMode;

  const PlayerStateData({
    this.currentTrackId,
    this.title = 'Unknown Title',
    this.artist = 'Unknown Artist',
    this.coverUrl,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.bufferedPosition = Duration.zero,
    this.hasNext = false,
    this.hasPrevious = false,
    this.isShuffle = false,
    this.repeatMode = RepeatState.off,
  });

  PlayerStateData copyWith({
    String? currentTrackId,
    String? title,
    String? artist,
    String? coverUrl,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    Duration? bufferedPosition,
    bool? hasNext,
    bool? hasPrevious,
    bool? isShuffle,
    RepeatState? repeatMode,
  }) {
    return PlayerStateData(
      currentTrackId: currentTrackId ?? this.currentTrackId,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      coverUrl: coverUrl ?? this.coverUrl,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      isShuffle: isShuffle ?? this.isShuffle,
      repeatMode: repeatMode ?? this.repeatMode,
    );
  }

  String get durationText => _formatDuration(duration);
  String get positionText => _formatDuration(position);

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    if (d.inHours > 0) {
      return "${d.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
