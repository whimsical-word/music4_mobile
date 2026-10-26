import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/theme/app_theme.dart';
import 'package:music4_mobile/features/album/data/models/album_model.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_with_google_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/state/auth_state.dart';
import 'package:music4_mobile/features/home/data/sources/home_mock_data.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_controller.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_state.dart';
import 'package:music4_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_album_section.dart';
import 'package:music4_mobile/features/notifications/presentation/providers/notification_provider.dart';
import 'package:music4_mobile/features/player/data/services/app_audio_handler.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockLogoutUseCase extends Mock implements LogoutUseCase {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockTokenStorage extends Mock implements TokenStorage {}

class _MockLoginWithGoogleUseCase extends Mock implements LoginWithGoogleUseCase {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockTrackDetailRepo extends Mock implements TrackDetailRepository {}

class _MockAppAudioHandler extends Mock implements AppAudioHandler {}

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(AuthState initial)
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

class _FakeHomeFeedController extends HomeFeedController {
  @override
  Future<HomeFeedState> build() async {
    return const HomeFeedState(
      featuredAiTrack: HomeMockData.featuredAiTrack,
      aiRecommendations: HomeMockData.aiRecommendations,
      trendingTracks: HomeMockData.topTrendingTracks,
    );
  }
}

AudioPlayer _createMockAudioPlayer() {
  final mock = _MockAudioPlayer();
  when(() => mock.playerStateStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.positionStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.bufferedPositionStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.durationStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.playbackEventStream).thenAnswer((_) => const Stream.empty());
  return mock;
}

class _MockPlayerNotifier extends PlayerNotifier {
  _MockPlayerNotifier()
      : super(_createMockAudioPlayer(), _MockTrackDetailRepo(), _MockAppAudioHandler());
}

void main() {
  const listener = UserEntity(id: 1, displayName: 'Listener', username: 'listener', isArtist: false);
  const artist = UserEntity(id: 2, displayName: 'Artist', username: 'artist', isArtist: true);
  const admin = UserEntity(id: 3, displayName: 'Admin', username: 'admin', isArtist: false, isAdmin: true);

  Widget buildHome(AuthState auth) {
    return ProviderScope(
      overrides: [
        authNotifierProvider.overrideWith((ref) => _FakeAuthNotifier(auth)),
        homeFeedControllerProvider.overrideWith(() => _FakeHomeFeedController()),
        playerNotifierProvider.overrideWith((ref) => _MockPlayerNotifier()),
        // The album section would call the real API.
        homeAlbumListProvider.overrideWith((ref) async => <AlbumModel>[]),
        // For a signed-in user the notification bell loads the notifications and
        // opens the SSE stream (real network, so timers stay pending).
        unreadNotificationCountProvider.overrideWithValue(0),
      ],
      child: MaterialApp(theme: AppTheme.darkTheme, home: const HomeScreen()),
    );
  }

  group('[CE190284] Home - admin shortcut', () {
    testWidgets('an admin sees the admin button in the app bar', (tester) async {
      await tester.pumpWidget(buildHome(const AuthAuthenticated(admin)));
      await tester.pump();

      expect(find.byKey(const Key('home_appbar_admin_btn')), findsOneWidget);
      // An admin is not an artist: no artist buttons.
      expect(find.byKey(const Key('home_appbar_upload_btn')), findsNothing);
    });

    testWidgets('a listener does not see it', (tester) async {
      await tester.pumpWidget(buildHome(const AuthAuthenticated(listener)));
      await tester.pump();

      expect(find.byKey(const Key('home_appbar_admin_btn')), findsNothing);
    });

    testWidgets('an artist does not see it', (tester) async {
      await tester.pumpWidget(buildHome(const AuthAuthenticated(artist)));
      await tester.pump();

      expect(find.byKey(const Key('home_appbar_admin_btn')), findsNothing);
    });

    testWidgets('a guest does not see it', (tester) async {
      await tester.pumpWidget(buildHome(const AuthInitial()));
      await tester.pump();

      expect(find.byKey(const Key('home_appbar_admin_btn')), findsNothing);
    });
  });
}
