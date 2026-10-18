import 'dart:async';

import '../data/tracking_repository.dart';
import '../domain/listening_session.dart';

/// Decides WHEN to talk to the tracking API while the Player is playing.
///
/// Rules:
/// - Guest / Artist / Admin (no [resolveListenerId]) -> nothing is sent.
/// - Preview playback -> nothing is sent.
/// - Every 10s of continuous listening -> `PUT /sync-time` (resume position).
/// - Track genuinely completes (>= 80% really played, once) ->
///   `POST /history`, then [onTrackCompleted] (Home silent refresh).
/// - Play tap, pause, resume, seek, skip, closing the Player -> nothing.
class PlaybackTracker {
  final TrackingRepository _repository;

  /// Returns the signed-in listener's id, or null for guest / artist.
  final int? Function() _resolveListenerId;

  /// Called after a completion was recorded successfully.
  final void Function()? _onTrackCompleted;

  ListeningSession? _session;

  // Requests run one after another, so a late position sync can never
  // overwrite the "position = 0" the backend sets on completion.
  Future<void> _queue = Future.value();

  PlaybackTracker({
    required this._repository,
    required this._resolveListenerId,
    this._onTrackCompleted,
  });

  /// A new track starts loading. Replaces (and drops) the previous session,
  /// which is how skipping avoids being tracked.
  void startTrack({
    required String trackId,
    Duration? duration,
    bool isPreview = false,
  }) {
    final id = int.tryParse(trackId);
    _session = (id == null || isPreview)
        ? null
        : ListeningSession(trackId: id, duration: duration);
  }

  void updateDuration(Duration duration) {
    _session?.duration = duration;
  }

  void onPosition(Duration position) {
    final session = _session;
    if (session == null) return;

    final syncPosition = session.onPosition(position);
    if (syncPosition == null) return;

    final userId = _resolveListenerId();
    if (userId == null) return;

    _enqueue(
      () => _repository.syncPlaybackPosition(
        userId: userId,
        trackId: session.trackId,
        positionSeconds: syncPosition.inSeconds,
      ),
    );
  }

  /// The audio player reported `completed` (it may report it more than once).
  void onCompleted() {
    final session = _session;
    if (session == null || !session.tryMarkCompletionReported()) return;
    if (!session.isFullyListened) return;

    final userId = _resolveListenerId();
    if (userId == null) return;

    _enqueue(() async {
      await _repository.recordCompletion(session.trackId);
      _onTrackCompleted?.call();
    });
  }

  /// Tracking must never interrupt playback, so failures are swallowed.
  void _enqueue(Future<void> Function() action) {
    _queue = _queue.then((_) => action()).catchError((Object _) {});
  }

  /// Completes when every queued request has finished (used by tests).
  Future<void> get idle => _queue;
}
