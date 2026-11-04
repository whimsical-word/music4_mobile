/// A saved position this close to the end of the track is treated as finished.
const int resumeEndMarginSeconds = 5;

/// Where "Nghe tiếp" (resume playback) starts for a history item.
///
/// The backend keeps the listening position in seconds (`playbackPosition`):
/// 0 for a finished listen, otherwise the last second the app synced. Returns
/// [Duration.zero] (play from the beginning) when there is nothing to resume,
/// or when the track was practically finished.
Duration resumePositionFor({
  required int playbackPositionSeconds,
  required int durationSeconds,
}) {
  if (playbackPositionSeconds <= 0) return Duration.zero;

  final practicallyFinished = durationSeconds > 0 &&
      playbackPositionSeconds >= durationSeconds - resumeEndMarginSeconds;
  if (practicallyFinished) return Duration.zero;

  return Duration(seconds: playbackPositionSeconds);
}

/// 75s -> "1:15", 3725s -> "1:02:05".
String formatListenTime(Duration position) {
  String two(int n) => n.toString().padLeft(2, '0');

  final hours = position.inHours;
  final minutes = position.inMinutes.remainder(60);
  final seconds = position.inSeconds.remainder(60);

  return hours > 0
      ? '$hours:${two(minutes)}:${two(seconds)}'
      : '$minutes:${two(seconds)}';
}
