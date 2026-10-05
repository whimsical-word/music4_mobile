import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';
import 'package:music4_mobile/features/player/domain/models/player_state_data.dart';
import 'dart:async';

class MockAudioPlayer extends Mock implements AudioPlayer {}
class MockTrackDetailRepo extends Mock implements TrackDetailRepository {}

void main() {
  group('[CE190036] PlayerNotifier & Audio Streaming Logic Tests', () {
    late MockAudioPlayer mockAudioPlayer;
    late MockTrackDetailRepo mockTrackDetailRepo;
    late PlayerNotifier playerNotifier;
    
    late StreamController<PlayerState> playerStateController;
    late StreamController<Duration> positionController;
    late StreamController<Duration> durationController;
    late StreamController<Duration> bufferedController;

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockTrackDetailRepo = MockTrackDetailRepo();
      
      playerStateController = StreamController<PlayerState>.broadcast();
      positionController = StreamController<Duration>.broadcast();
      durationController = StreamController<Duration>.broadcast();
      bufferedController = StreamController<Duration>.broadcast();

      when(() => mockAudioPlayer.playerStateStream).thenAnswer((_) => playerStateController.stream);
      when(() => mockAudioPlayer.positionStream).thenAnswer((_) => positionController.stream);
      when(() => mockAudioPlayer.durationStream).thenAnswer((_) => durationController.stream);
      when(() => mockAudioPlayer.bufferedPositionStream).thenAnswer((_) => bufferedController.stream);
      
      when(() => mockAudioPlayer.play()).thenAnswer((_) async {});
      when(() => mockAudioPlayer.pause()).thenAnswer((_) async {});
      
      playerNotifier = PlayerNotifier(mockAudioPlayer, mockTrackDetailRepo);
    });

    tearDown(() {
      playerStateController.close();
      positionController.close();
      durationController.close();
      bufferedController.close();
    });

    test('formatDuration should format duration string correctly', () {
      final stateData = PlayerStateData(duration: const Duration(minutes: 3, seconds: 45));
      expect(stateData.durationText, '03:45');
      
      final stateDataHours = PlayerStateData(duration: const Duration(hours: 1, minutes: 5, seconds: 9));
      expect(stateDataHours.durationText, '1:05:09');
    });

    test('play() should call player.play() and update state when stream emits', () async {
      // Act
      await playerNotifier.play();

      // Assert
      verify(() => mockAudioPlayer.play()).called(1);
      
      // Simulate stream emitting playing = true
      playerStateController.add(PlayerState(true, ProcessingState.ready));
      
      // Wait for stream to be processed
      await Future.delayed(Duration.zero);
      
      expect(playerNotifier.state.value!.isPlaying, isTrue);
    });

    test('pause() should call player.pause() and update state when stream emits', () async {
      // Setup initial state as playing
      playerStateController.add(PlayerState(true, ProcessingState.ready));
      await Future.delayed(Duration.zero);
      expect(playerNotifier.state.value!.isPlaying, isTrue);
      
      // Act
      await playerNotifier.pause();

      // Assert
      verify(() => mockAudioPlayer.pause()).called(1);
      
      // Simulate stream emitting playing = false
      playerStateController.add(PlayerState(false, ProcessingState.ready));
      await Future.delayed(Duration.zero);
      
      expect(playerNotifier.state.value!.isPlaying, isFalse);
    });
  });
}
