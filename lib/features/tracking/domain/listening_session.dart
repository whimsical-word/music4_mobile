/// Tracks how much of ONE track was genuinely listened to.
///
/// Pure Dart (no Flutter / network) so the rules are easy to unit test:
/// - Only continuous forward playback counts. A seek (any jump bigger than
///   [maxContinuousStep], or backwards) adds nothing.
/// - A position sync is due every [syncInterval] of continuous listening.
/// - A track counts as "fully listened" once [completionRatio] of its duration
///   was actually played (so seeking straight to the end does not count).
class ListeningSession {
  static const Duration maxContinuousStep = Duration(seconds: 5);
  static const Duration syncInterval = Duration(seconds: 10);
  static const double completionRatio = 0.8;

  final int trackId;
  Duration? duration;

  Duration _lastPosition = Duration.zero;
  Duration _listened = Duration.zero;
  Duration _sinceSync = Duration.zero;
  bool _completionReported = false;

  ListeningSession({required this.trackId, this.duration});

  Duration get listened => _listened;

  /// Feed every player position tick. Returns the position to persist when
  /// another [syncInterval] of continuous listening has elapsed, else null.
  Duration? onPosition(Duration position) {
    final delta = position - _lastPosition;
    _lastPosition = position;

    if (delta <= Duration.zero || delta > maxContinuousStep) return null;

    _listened += delta;
    _sinceSync += delta;

    if (_sinceSync >= syncInterval) {
      _sinceSync = Duration.zero;
      return position;
    }
    return null;
  }

  /// True when enough of the track was really played to count as a listen.
  bool get isFullyListened {
    final total = duration;
    if (total == null || total <= Duration.zero) return false;
    final threshold = (total.inMilliseconds * completionRatio).floor();
    return _listened.inMilliseconds >= threshold;
  }

  /// Returns true only the first time it is called (dedupes repeated
  /// `completed` events from the audio player).
  bool tryMarkCompletionReported() {
    if (_completionReported) return false;
    _completionReported = true;
    return true;
  }
}
