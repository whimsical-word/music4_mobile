import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/features/tracking/domain/listening_session.dart';

/// Simulates continuous playback: one position tick per second.
/// Returns every position a sync was requested at.
List<Duration> _play(ListeningSession session, {int from = 1, int to = 10}) {
  final syncs = <Duration>[];
  for (var s = from; s <= to; s++) {
    final sync = session.onPosition(Duration(seconds: s));
    if (sync != null) syncs.add(sync);
  }
  return syncs;
}

void main() {
  group('[CE190284] ListeningSession', () {
    test('requests a position sync every 10s of continuous listening', () {
      final session = ListeningSession(
        trackId: 1,
        duration: const Duration(seconds: 200),
      );

      final syncs = _play(session, to: 35);

      expect(syncs, [
        const Duration(seconds: 10),
        const Duration(seconds: 20),
        const Duration(seconds: 30),
      ]);
    });

    test('no sync before 10s have been listened', () {
      final session = ListeningSession(trackId: 1);

      expect(_play(session, to: 9), isEmpty);
    });

    test('a seek (forward or backward) is not counted as listening', () {
      final session = ListeningSession(
        trackId: 1,
        duration: const Duration(seconds: 200),
      );

      _play(session, to: 3);
      expect(session.listened, const Duration(seconds: 3));

      // Forward seek to 150s, then a backward seek to 10s.
      expect(session.onPosition(const Duration(seconds: 150)), isNull);
      expect(session.onPosition(const Duration(seconds: 10)), isNull);

      expect(session.listened, const Duration(seconds: 3));
    });

    test('isFullyListened is false while the duration is unknown', () {
      final session = ListeningSession(trackId: 1);

      _play(session, to: 100);

      expect(session.isFullyListened, isFalse);
    });

    test('isFullyListened is true after listening >= 80% of the track', () {
      final session = ListeningSession(
        trackId: 1,
        duration: const Duration(seconds: 100),
      );

      _play(session, to: 79);
      expect(session.isFullyListened, isFalse);

      _play(session, from: 80, to: 80);
      expect(session.isFullyListened, isTrue);
    });

    test('seeking straight to the end does not count as fully listened', () {
      final session = ListeningSession(
        trackId: 1,
        duration: const Duration(seconds: 200),
      );

      _play(session, to: 20);
      session.onPosition(const Duration(seconds: 199));
      session.onPosition(const Duration(seconds: 200));

      expect(session.isFullyListened, isFalse);
    });

    test('completion can be reported only once', () {
      final session = ListeningSession(trackId: 1);

      expect(session.tryMarkCompletionReported(), isTrue);
      expect(session.tryMarkCompletionReported(), isFalse);
    });
  });
}
