import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/tracking/application/playback_tracker.dart';
import 'package:music4_mobile/features/tracking/data/tracking_repository.dart';

class MockTrackingRepository extends Mock implements TrackingRepository {}

void main() {
  late MockTrackingRepository repository;
  late PlaybackTracker tracker;
  late int? listenerId;
  late int completedCallbacks;

  /// One position tick per second, like continuous playback.
  void listen(int seconds) {
    for (var s = 1; s <= seconds; s++) {
      tracker.onPosition(Duration(seconds: s));
    }
  }

  setUp(() {
    repository = MockTrackingRepository();
    listenerId = 7;
    completedCallbacks = 0;

    when(
      () => repository.syncPlaybackPosition(
        userId: any(named: 'userId'),
        trackId: any(named: 'trackId'),
        positionSeconds: any(named: 'positionSeconds'),
      ),
    ).thenAnswer((_) async {});
    when(() => repository.recordCompletion(any())).thenAnswer((_) async {});

    tracker = PlaybackTracker(
      repository: repository,
      resolveListenerId: () => listenerId,
      onTrackCompleted: () => completedCallbacks++,
    );
  });

  void verifyNothingSent() {
    verifyNever(
      () => repository.syncPlaybackPosition(
        userId: any(named: 'userId'),
        trackId: any(named: 'trackId'),
        positionSeconds: any(named: 'positionSeconds'),
      ),
    );
    verifyNever(() => repository.recordCompletion(any()));
  }

  group('[CE190284] PlaybackTracker - authenticated listener', () {
    test('syncs the playback position every 10s of listening', () async {
      tracker.startTrack(trackId: '5', duration: const Duration(seconds: 100));

      listen(25);
      await tracker.idle;

      verify(
        () => repository.syncPlaybackPosition(
          userId: 7,
          trackId: 5,
          positionSeconds: 10,
        ),
      ).called(1);
      verify(
        () => repository.syncPlaybackPosition(
          userId: 7,
          trackId: 5,
          positionSeconds: 20,
        ),
      ).called(1);
      verifyNever(() => repository.recordCompletion(any()));
      expect(completedCallbacks, 0);
    });

    test('records the view once when the track is fully listened', () async {
      tracker.startTrack(trackId: '5', duration: const Duration(seconds: 100));

      listen(100);
      tracker.onCompleted();
      await tracker.idle;

      verify(() => repository.recordCompletion(5)).called(1);
      expect(completedCallbacks, 1);
    });

    test('the last position sync is sent before the completion', () async {
      tracker.startTrack(trackId: '5', duration: const Duration(seconds: 100));

      listen(100);
      tracker.onCompleted();
      await tracker.idle;

      verifyInOrder([
        () => repository.syncPlaybackPosition(
          userId: 7,
          trackId: 5,
          positionSeconds: 100,
        ),
        () => repository.recordCompletion(5),
      ]);
    });

    test('duplicate completed events record only one view', () async {
      tracker.startTrack(trackId: '5', duration: const Duration(seconds: 100));

      listen(100);
      tracker.onCompleted();
      tracker.onCompleted();
      tracker.onCompleted();
      await tracker.idle;

      verify(() => repository.recordCompletion(5)).called(1);
      expect(completedCallbacks, 1);
    });

    test('seeking to the end does not record a view', () async {
      tracker.startTrack(trackId: '5', duration: const Duration(seconds: 100));

      listen(5);
      tracker.onPosition(const Duration(seconds: 99));
      tracker.onPosition(const Duration(seconds: 100));
      tracker.onCompleted();
      await tracker.idle;

      verifyNever(() => repository.recordCompletion(any()));
      expect(completedCallbacks, 0);
    });

    test('skipping to another track records nothing for the skipped one', () async {
      tracker.startTrack(trackId: '5', duration: const Duration(seconds: 100));
      listen(6);

      // Skip: a new session replaces the old one without completion.
      tracker.startTrack(trackId: '6', duration: const Duration(seconds: 100));
      await tracker.idle;

      verifyNothingSent();
    });

    test('play, pause and resume alone send nothing', () async {
      tracker.startTrack(trackId: '5', duration: const Duration(seconds: 100));

      // Play, listen 4s, pause (no ticks), resume, listen 3s more.
      listen(4);
      for (var s = 4; s <= 7; s++) {
        tracker.onPosition(Duration(seconds: s));
      }
      await tracker.idle;

      verifyNothingSent();
    });

    test('a failed completion request does not throw or refresh Home', () async {
      when(
        () => repository.recordCompletion(any()),
      ).thenAnswer((_) async => throw const TrackingException('Lỗi'));

      tracker.startTrack(trackId: '5', duration: const Duration(seconds: 100));

      listen(100);
      tracker.onCompleted();
      await tracker.idle;

      verify(() => repository.recordCompletion(5)).called(1);
      expect(completedCallbacks, 0);
    });
  });

  group('[CE190284] PlaybackTracker - guest / artist / preview', () {
    test('guest (no listener id) is never tracked', () async {
      listenerId = null;
      tracker.startTrack(trackId: '5', duration: const Duration(seconds: 100));

      listen(100);
      tracker.onCompleted();
      await tracker.idle;

      verifyNothingSent();
      expect(completedCallbacks, 0);
    });

    test('preview playback is never tracked', () async {
      tracker.startTrack(
        trackId: '5',
        duration: const Duration(seconds: 30),
        isPreview: true,
      );

      listen(30);
      tracker.onCompleted();
      await tracker.idle;

      verifyNothingSent();
      expect(completedCallbacks, 0);
    });

    test('an invalid track id is ignored', () async {
      tracker.startTrack(trackId: 'abc', duration: const Duration(seconds: 100));

      listen(100);
      tracker.onCompleted();
      await tracker.idle;

      verifyNothingSent();
    });
  });
}
