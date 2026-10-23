import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music4_mobile/core/theme/app_theme.dart';
import 'package:music4_mobile/features/album/presentation/screens/album_management_screen.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:music4_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:music4_mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:music4_mobile/features/auth/data/datasources/token_storage.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/state/auth_state.dart';
import 'package:music4_mobile/features/home/data/sources/home_mock_data.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_controller.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_state.dart';
import 'package:music4_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:music4_mobile/features/home/presentation/widgets/artist_studio_quick_banner.dart';
import 'package:music4_mobile/features/player/data/services/app_audio_handler.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';
import 'package:music4_mobile/features/upload/presentation/screens/upload_track_screen.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}
class _MockLogoutUseCase extends Mock implements LogoutUseCase {}
class _MockAuthRepository extends Mock implements AuthRepository {}
class _MockTokenStorage extends Mock implements TokenStorage {}
class _MockAudioPlayer extends Mock implements AudioPlayer {}
class _MockTrackDetailRepo extends Mock implements TrackDetailRepository {}
class _MockAppAudioHandler extends Mock implements AppAudioHandler {}

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(AuthState initial)
      : super(
          loginUseCase: _MockLoginUseCase(),
          logoutUseCase: _MockLogoutUseCase(),
          repository: _MockAuthRepository(),
          tokenStorage: _MockTokenStorage(),
        ) {
    state = initial;
  }
}

class FakeHomeFeedController extends HomeFeedController {
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

class MockPlayerNotifier extends PlayerNotifier {
  MockPlayerNotifier()
      : super(_createMockAudioPlayer(), _MockTrackDetailRepo(), _MockAppAudioHandler());
}

void main() {
  final listenerUser = AuthAuthenticated(
    const UserEntity(
      id: 1,
      displayName: 'Normal Listener',
      username: 'listener1',
      isArtist: false,
    ),
  );

  final artistUser = AuthAuthenticated(
    const UserEntity(
      id: 99,
      displayName: 'Ariana Grande',
      username: 'ariana',
      isArtist: true,
    ),
  );

  Widget createWidget({
    required Widget child,
    required AuthState authState,
  }) {
    return ProviderScope(
      overrides: [
        authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(authState)),
        homeFeedControllerProvider.overrideWith(() => FakeHomeFeedController()),
        playerNotifierProvider.overrideWith((ref) => MockPlayerNotifier()),
      ],
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: child,
      ),
    );
  }

  group('[CE190036] Artist Studio Navigation & RBAC Tests UC46', () {
    testWidgets('Listener on HomeScreen cannot see upload & album buttons or banner',
        (tester) async {
      await tester.pumpWidget(
        createWidget(
          child: const HomeScreen(),
          authState: listenerUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_appbar_upload_btn')), findsNothing);
      expect(find.byKey(const Key('home_appbar_album_btn')), findsNothing);
      expect(find.byType(ArtistStudioQuickBanner), findsNothing);
    });

    testWidgets('Artist on HomeScreen sees upload & album buttons in AppBar and Banner',
        (tester) async {
      await tester.pumpWidget(
        createWidget(
          child: const HomeScreen(),
          authState: artistUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_appbar_upload_btn')), findsOneWidget);
      expect(find.byKey(const Key('home_appbar_album_btn')), findsOneWidget);
      expect(find.byType(ArtistStudioQuickBanner), findsOneWidget);
      expect(find.byKey(const Key('artist_studio_upload_btn')), findsOneWidget);
      expect(find.byKey(const Key('artist_studio_album_btn')), findsOneWidget);
    });

    testWidgets('UploadTrackScreen blocks non-artist with access denied screen',
        (tester) async {
      await tester.pumpWidget(
        createWidget(
          child: const UploadTrackScreen(),
          authState: listenerUser,
        ),
      );
      await tester.pump();

      expect(find.text('Chỉ dành cho Nghệ sĩ'), findsOneWidget);
      expect(find.text('Quay lại'), findsOneWidget);
      expect(find.text('Artist Studio - Upload Nhạc'), findsOneWidget);
    });

    testWidgets('AlbumManagementScreen blocks non-artist with access denied screen',
        (tester) async {
      await tester.pumpWidget(
        createWidget(
          child: const AlbumManagementScreen(),
          authState: listenerUser,
        ),
      );
      await tester.pump();

      expect(find.text('Chỉ dành cho Nghệ sĩ'), findsOneWidget);
      expect(find.text('Quay lại'), findsOneWidget);
      expect(find.text('Quản lý Album'), findsOneWidget);
    });
  });
}
