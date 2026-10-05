import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/player/data/services/app_audio_handler.dart';
import 'package:music4_mobile/features/player/domain/models/player_state_data.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';
import 'package:music4_mobile/features/tracking/application/playback_tracker.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

class MockTrackDetailRepo extends Mock implements TrackDetailRepository {}

class MockAppAudioHandler extends Mock implements AppAudioHandler {}

class MockPlaybackTracker extends Mock implements PlaybackTracker {}

const _durationA = Duration(seconds: 100);

TrackQueueItem _item(String id) => TrackQueueItem(
  id: id,
  title: 'Track $id',
  artist: 'Artist',
  duration: _durationA,
);

void main() {
  late MockAudioPlayer player;
  late MockPlaybackTracker tracker;
  late PlayerNotifier notifier;

  late StreamController<PlayerState> playerStateController;
  late StreamController<Duration> positionController;
  late StreamController<Duration?> durationController;
  late StreamController<Duration> bufferedController;

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    player = MockAudioPlayer();
    tracker = MockPlaybackTracker();

    playerStateController = StreamController<PlayerState>.broadcast();
    positionController = StreamController<Duration>.broadcast();
    durationController = StreamController<Duration?>.broadcast();
    bufferedController = StreamController<Duration>.broadcast();

    when(() => player.playerStateStream)
        .thenAnswer((_) => playerStateController.stream);
    when(() => player.positionStream)
        .thenAnswer((_) => positionController.stream);
    when(() => player.durationStream)
        .thenAnswer((_) => durationController.stream);
    when(() => player.bufferedPositionStream)
        .thenAnswer((_) => bufferedController.stream);
    when(() => player.play()).thenAnswer((_) async {});
    when(() => player.pause()).thenAnswer((_) async {});
    when(() => player.seek(any())).thenAnswer((_) async {});

    final trackDetailRepo = MockTrackDetailRepo();
    when(() => trackDetailRepo.checkIsFavorite(any()))
        .thenAnswer((_) async => false);

    notifier = PlayerNotifier(
      player,
      trackDetailRepo,
      MockAppAudioHandler(),
      tracker: tracker,
    );
  });

  tearDown(() {
    playerStateController.close();
    positionController.close();
    durationController.close();
    bufferedController.close();
  });

  Future<void> pumpStreams() => Future<void>.delayed(Duration.zero);

  group('[CE190284] Player -> PlaybackTracker wiring', () {
    test('starting a playlist starts a listening session', () async {
      await notifier.playPlaylist([_item('5')], 0);

      verify(() => tracker.startTrack(trackId: '5', duration: _durationA))
          .called(1);
      verifyNever(() => tracker.onCompleted());
    });

    test('position ticks and duration are forwarded to the tracker', () async {
      await notifier.playPlaylist([_item('5')], 0);

      positionController.add(const Duration(seconds: 1));
      durationController.add(const Duration(seconds: 90));
      await pumpStreams();

      verify(() => tracker.onPosition(const Duration(seconds: 1))).called(1);
      verify(() => tracker.updateDuration(const Duration(seconds: 90)))
          .called(1);
    });

    test('processingState.completed is forwarded to the tracker', () async {
      await notifier.playPlaylist([_item('5')], 0);

      playerStateController.add(PlayerState(false, ProcessingState.completed));
      await pumpStreams();

      verify(() => tracker.onCompleted()).called(1);
    });

    test('pause alone does not report a completion', () async {
      await notifier.playPlaylist([_item('5')], 0);

      playerStateController.add(PlayerState(true, ProcessingState.ready));
      await notifier.pause();
      playerStateController.add(PlayerState(false, ProcessingState.ready));
      await pumpStreams();

      verifyNever(() => tracker.onCompleted());
    });

    test('skipping starts a new session without reporting a completion', () async {
      await notifier.playPlaylist([_item('5'), _item('6')], 0);

      await notifier.next();

      verify(() => tracker.startTrack(trackId: '6', duration: _durationA))
          .called(1);
      verifyNever(() => tracker.onCompleted());
    });
  });
}
