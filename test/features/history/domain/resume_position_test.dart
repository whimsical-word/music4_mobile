import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/features/history/domain/resume_position.dart';

void main() {
  group('[CE190284] resumePositionFor', () {
    test('a partly listened track resumes at the saved second', () {
      expect(
        resumePositionFor(playbackPositionSeconds: 120, durationSeconds: 200),
        const Duration(seconds: 120),
      );
    });

    test('position 0 (finished or never synced) starts from the beginning', () {
      expect(
        resumePositionFor(playbackPositionSeconds: 0, durationSeconds: 200),
        Duration.zero,
      );
    });

    test('a negative position is ignored', () {
      expect(
        resumePositionFor(playbackPositionSeconds: -3, durationSeconds: 200),
        Duration.zero,
      );
    });

    test('within the last $resumeEndMarginSeconds seconds the track counts as finished', () {
      expect(
        resumePositionFor(playbackPositionSeconds: 195, durationSeconds: 200),
        Duration.zero,
      );
      expect(
        resumePositionFor(playbackPositionSeconds: 199, durationSeconds: 200),
        Duration.zero,
      );
    });

    test('just before the margin is still resumed', () {
      expect(
        resumePositionFor(playbackPositionSeconds: 194, durationSeconds: 200),
        const Duration(seconds: 194),
      );
    });

    test('an unknown duration (0) still resumes', () {
      expect(
        resumePositionFor(playbackPositionSeconds: 40, durationSeconds: 0),
        const Duration(seconds: 40),
      );
    });
  });

  group('[CE190284] formatListenTime', () {
    test('formats minutes and seconds', () {
      expect(formatListenTime(const Duration(seconds: 75)), '1:15');
      expect(formatListenTime(const Duration(seconds: 120)), '2:00');
      expect(formatListenTime(const Duration(seconds: 9)), '0:09');
    });

    test('adds hours when needed', () {
      expect(formatListenTime(const Duration(seconds: 3725)), '1:02:05');
    });
  });
}
