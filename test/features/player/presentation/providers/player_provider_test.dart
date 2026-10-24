import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';
import 'package:music4_mobile/features/player/data/services/app_audio_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';
import 'package:music4_mobile/features/player/domain/models/player_state_data.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'dart:async';

import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_with_google_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}
class MockTrackDetailRepo extends Mock implements TrackDetailRepository {}
class MockAppAudioHandler extends Mock implements AppAudioHandler {}
class FakeAudioSource extends Fake implements AudioSource {}

class _MockLoginUseCase extends Mock implements LoginUseCase {}
class _MockLogoutUseCase extends Mock implements LogoutUseCase {}
class _MockAuthRepository extends Mock implements AuthRepository {}
class _MockTokenStorage extends Mock implements TokenStorage {}
class _MockLoginWithGoogleUseCase extends Mock implements LoginWithGoogleUseCase {}

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(AuthState initial)
      : super(
          loginUseCase: _MockLoginUseCase(),
          logoutUseCase: _MockLogoutUseCase(),
          repository: _MockAuthRepository(),
          tokenStorage: _MockTokenStorage(),
          loginWithGoogleUseCase: _MockLoginWithGoogleUseCase(),
        ) {
    state = initial;
  }
}

final testRefProvider = Provider<Ref>((ref) => ref);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage.setMockInitialValues({});
  group('[CE190036] PlayerNotifier & Audio Streaming Logic Tests', () {
    late MockAudioPlayer mockAudioPlayer;
    late MockTrackDetailRepo mockTrackDetailRepo;
    late MockAppAudioHandler mockAppAudioHandler;
    late PlayerNotifier playerNotifier;
    
    late StreamController<PlayerState> playerStateController;
    late StreamController<Duration> positionController;
    late StreamController<Duration> durationController;
    late StreamController<Duration> bufferedController;

    setUpAll(() {
      registerFallbackValue(FakeAudioSource());
      registerFallbackValue(Duration.zero);
    });

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      mockTrackDetailRepo = MockTrackDetailRepo();
      mockAppAudioHandler = MockAppAudioHandler();
      
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
      when(() => mockAudioPlayer.stop()).thenAnswer((_) async {});
      when(() => mockAudioPlayer.seek(any())).thenAnswer((_) async {});
      when(() => mockAudioPlayer.audioSource).thenReturn(null);
      when(() => mockAudioPlayer.setAudioSource(any(), initialPosition: any(named: 'initialPosition'))).thenAnswer((_) async => null);
      when(() => mockAudioPlayer.playing).thenReturn(true);
      when(() => mockTrackDetailRepo.checkIsFavorite(any())).thenAnswer((_) async => false);
      
      playerNotifier = PlayerNotifier(mockAudioPlayer, mockTrackDetailRepo, mockAppAudioHandler);
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
    test('preview mode reaching 30 seconds triggers login prompt and pauses', () async {
      // Set state to preview mode
      playerNotifier.state = AsyncData(
        playerNotifier.state.value!.copyWith(isPreview: true, isPlaying: true),
      );

      // Emit position >= 30 seconds
      positionController.add(const Duration(seconds: 30));
      await Future.delayed(Duration.zero);

      verify(() => mockAudioPlayer.pause()).called(1);
      expect(playerNotifier.state.value!.isPlaying, isFalse);
      expect(playerNotifier.state.value!.showLoginPrompt, isTrue);

      // Dismiss prompt
      playerNotifier.dismissLoginPrompt();
      expect(playerNotifier.state.value!.showLoginPrompt, isFalse);
    });

    test('seek past 30s in preview mode should pause and trigger login prompt', () async {
      when(() => mockAudioPlayer.seek(any())).thenAnswer((_) async {});
      playerNotifier.state = AsyncData(
        playerNotifier.state.value!.copyWith(isPreview: true, isPlaying: true),
      );

      await playerNotifier.seek(const Duration(seconds: 45));

      verify(() => mockAudioPlayer.seek(const Duration(seconds: 30))).called(1);
      verify(() => mockAudioPlayer.pause()).called(1);
      expect(playerNotifier.state.value!.showLoginPrompt, isTrue);
    });

    test('durationStream clamps to 30 seconds in preview mode', () async {
      playerNotifier.state = AsyncData(
        playerNotifier.state.value!.copyWith(isPreview: true),
      );

      durationController.add(const Duration(minutes: 3, seconds: 45));
      await Future.delayed(Duration.zero);

      expect(playerNotifier.state.value!.duration, const Duration(seconds: 30));
    });

    test('guest (unauthenticated) forces isPreview = true even if TokenStorage has token', () async {
      final container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(const AuthInitial())),
        ],
      );
      addTearDown(container.dispose);

      // Giả lập storage còn sót token từ session cũ
      await TokenStorage.instance.saveTokens(accessToken: 'stale_token_123');

      final notifierWithRef = PlayerNotifier(
        mockAudioPlayer,
        mockTrackDetailRepo,
        mockAppAudioHandler,
        ref: container.read(testRefProvider),
      );

      final testItem = TrackQueueItem(
        id: '1',
        title: 'Song Test',
        artist: 'Artist Test',
        coverUrl: 'http://example.com/cover.jpg',
        duration: const Duration(minutes: 3, seconds: 45),
      );

      await notifierWithRef.playPlaylist([testItem], 0);

      expect(notifierWithRef.state.value!.isPreview, isTrue);
      expect(notifierWithRef.state.value!.duration, const Duration(seconds: 30));
    });

    test('authenticated user plays full song (isPreview = false and full duration)', () async {
      const testUser = UserEntity(
        id: 1,
        username: 'ariana',
        displayName: 'Ariana Grande',
        email: 'ariana@gmail.com',
        isArtist: true,
      );

      final container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(const AuthAuthenticated(testUser))),
        ],
      );
      addTearDown(container.dispose);

      await TokenStorage.instance.saveTokens(accessToken: 'valid_token_123');

      final notifierWithRef = PlayerNotifier(
        mockAudioPlayer,
        mockTrackDetailRepo,
        mockAppAudioHandler,
        ref: container.read(testRefProvider),
      );

      final testItem = TrackQueueItem(
        id: '1',
        title: 'Song Test',
        artist: 'Artist Test',
        coverUrl: 'http://example.com/cover.jpg',
        duration: const Duration(minutes: 3, seconds: 45),
      );

      await notifierWithRef.playPlaylist([testItem], 0);

      expect(notifierWithRef.state.value!.isPreview, isFalse);
      expect(notifierWithRef.state.value!.duration, const Duration(minutes: 3, seconds: 45));
    });

    group('resume playback (start position)', () {
      const listener = UserEntity(
        id: 1,
        username: 'listener',
        displayName: 'Listener',
        email: 'listener@gmail.com',
        isArtist: false,
      );

      TrackQueueItem item({Duration duration = const Duration(minutes: 3, seconds: 45)}) {
        return TrackQueueItem(
          id: '1',
          title: 'Song Test',
          artist: 'Artist Test',
          coverUrl: 'http://example.com/cover.jpg',
          duration: duration,
        );
      }

      Future<PlayerNotifier> notifierFor(AuthState auth, {required String token}) async {
        final container = ProviderContainer(
          overrides: [
            authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(auth)),
          ],
        );
        addTearDown(container.dispose);

        await TokenStorage.instance.saveTokens(accessToken: token);

        return PlayerNotifier(
          mockAudioPlayer,
          mockTrackDetailRepo,
          mockAppAudioHandler,
          ref: container.read(testRefProvider),
        );
      }

      test('resumePlaylist starts the full stream at the saved position', () async {
        final notifier = await notifierFor(
          const AuthAuthenticated(listener),
          token: 'valid_token_123',
        );

        await notifier.resumePlaylist(
          [item()],
          0,
          startPosition: const Duration(seconds: 42),
        );

        verify(
          () => mockAudioPlayer.setAudioSource(
            any(),
            initialPosition: const Duration(seconds: 42),
          ),
        ).called(1);
        expect(notifier.state.value!.isPreview, isFalse);
        expect(notifier.state.value!.position, const Duration(seconds: 42));
      });

      test('playPlaylist still starts from the beginning', () async {
        final notifier = await notifierFor(
          const AuthAuthenticated(listener),
          token: 'valid_token_123',
        );

        await notifier.playPlaylist([item()], 0);

        verify(
          () => mockAudioPlayer.setAudioSource(any(), initialPosition: Duration.zero),
        ).called(1);
      });

      test('the start position applies to one load only', () async {
        final notifier = await notifierFor(
          const AuthAuthenticated(listener),
          token: 'valid_token_123',
        );

        await notifier.resumePlaylist(
          [item()],
          0,
          startPosition: const Duration(seconds: 42),
        );
        await notifier.playPlaylist([item()], 0);

        verify(
          () => mockAudioPlayer.setAudioSource(
            any(),
            initialPosition: const Duration(seconds: 42),
          ),
        ).called(1);
        verify(
          () => mockAudioPlayer.setAudioSource(any(), initialPosition: Duration.zero),
        ).called(1);
      });

      test('a start position at or after the end of the track is ignored', () async {
        final notifier = await notifierFor(
          const AuthAuthenticated(listener),
          token: 'valid_token_123',
        );

        await notifier.resumePlaylist(
          [item(duration: const Duration(seconds: 60))],
          0,
          startPosition: const Duration(seconds: 90),
        );

        verify(
          () => mockAudioPlayer.setAudioSource(any(), initialPosition: Duration.zero),
        ).called(1);
      });

      test('a guest preview never resumes (always starts at 0)', () async {
        final notifier = await notifierFor(
          const AuthInitial(),
          token: 'stale_token_123',
        );

        await notifier.resumePlaylist(
          [item()],
          0,
          startPosition: const Duration(seconds: 42),
        );

        expect(notifier.state.value!.isPreview, isTrue);
        verify(
          () => mockAudioPlayer.setAudioSource(any(), initialPosition: Duration.zero),
        ).called(1);
        verifyNever(
          () => mockAudioPlayer.setAudioSource(
            any(),
            initialPosition: const Duration(seconds: 42),
          ),
        );
      });
    });

    test('guest toggleFavorite triggers login prompt', () async {
      final container = ProviderContainer(
        overrides: [
          authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(const AuthInitial())),
        ],
      );
      addTearDown(container.dispose);

      final notifierWithRef = PlayerNotifier(
        mockAudioPlayer,
        mockTrackDetailRepo,
        mockAppAudioHandler,
        ref: container.read(testRefProvider),
      );

      notifierWithRef.state = AsyncData(
        notifierWithRef.state.value!.copyWith(currentTrackId: '1', isPreview: true),
      );

      await notifierWithRef.toggleFavorite();

      expect(notifierWithRef.state.value!.showLoginPrompt, isTrue);
    });
  });
}
