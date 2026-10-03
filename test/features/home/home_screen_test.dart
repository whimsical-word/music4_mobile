import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/core/theme/app_theme.dart';

import 'package:music4_mobile/features/home/data/models/track_detail_model.dart';
import 'package:music4_mobile/features/home/data/models/track_suggest_model.dart';
import 'package:music4_mobile/features/home/data/sources/home_mock_data.dart';
import 'package:music4_mobile/features/home/data/sources/home_repository.dart';

import 'package:music4_mobile/features/home/presentation/controllers/home_feed_controller.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_state.dart';
import 'package:music4_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:music4_mobile/features/home/presentation/widgets/ai_recommendation_banner.dart';
import 'package:music4_mobile/features/home/presentation/widgets/ai_recommendation_section.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_empty_state.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_error_state.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_shimmer_skeleton.dart';
import 'package:music4_mobile/features/home/presentation/widgets/trending_section.dart';

class MockHomeRepository extends HomeRepository { MockHomeRepository() : super(DioClient()); @override Future<void> trackHistory(String trackId) async { return Future.value(); } } class MockHomeFeedController extends HomeFeedController {
  @override
  Future<HomeFeedState> build() async {
    return _mockHomeFeed();
  }

  Future<HomeFeedState> _mockHomeFeed() async {
    return const HomeFeedState(
      featuredAiTrack: HomeMockData.featuredAiTrack,
      aiRecommendations: HomeMockData.aiRecommendations,
      trendingTracks: HomeMockData.topTrendingTracks,
    );
  }

  @override
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(_mockHomeFeed);
  }
}

class FakeHomeRepository extends HomeRepository {
  FakeHomeRepository() : super(DioClient());

  int trackHistoryCalls = 0;
  int recommendationsCalls = 0;
  int trendingCalls = 0;

  @override
  Future<void> trackHistory(String trackId) async {
    trackHistoryCalls++;
  }

  @override
  Future<List<TrackSuggestModel>> getRecommendations() async {
    recommendationsCalls++;
    return [];
  }

  @override
  Future<List<TrackDetailModel>> getTopTrending() async {
    trendingCalls++;
    return [];
  }
}

Widget createTestWidget({List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: [
      homeRepositoryProvider.overrideWithValue(MockHomeRepository()), homeFeedControllerProvider.overrideWith(MockHomeFeedController.new),
      ...overrides,
    ],
    child: MaterialApp(theme: AppTheme.darkTheme, home: const HomeScreen()),
  );
}

void main() {
  group('[CE190284] HomeScreen & Home Feed Widget Tests', () {
    testWidgets(
      'renders loaded Home feed with AI recommendation and Top Trending',
      (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.pumpAndSettle();

        // Verify App Bar.
        expect(find.text('Music4'), findsOneWidget);

        // Verify AI recommendation banner and sections.
        expect(find.byType(AiRecommendationBanner), findsOneWidget);

        expect(find.byType(AiRecommendationSection), findsOneWidget);

        expect(
          find.byType(TrendingSection, skipOffstage: false),
          findsOneWidget,
        );

        // Verify specific data items from HomeMockData.
        expect(find.text('Gió Cuốn Hoa Rơi'), findsOneWidget);

        expect(find.text('Gợi ý cho bạn'), findsOneWidget);

        expect(find.text('Thịnh hành'), findsOneWidget);
      },
    );

    testWidgets('renders Loading Shimmer Skeleton when in loading state', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(MockHomeRepository()), homeFeedControllerProvider.overrideWith(MockHomeFeedController.new),
        ],
      );

      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      // Transition to loading state.
      container
          .read(homeFeedControllerProvider.notifier)
          .setLoadingForTesting();

      await tester.pump();

      expect(find.byType(HomeShimmerSkeleton), findsOneWidget);
    });

    testWidgets('renders Error State and allows retry', (tester) async {
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(MockHomeRepository()), homeFeedControllerProvider.overrideWith(MockHomeFeedController.new),
        ],
      );

      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      // Trigger error state.
      container
          .read(homeFeedControllerProvider.notifier)
          .setErrorForTesting('Không thể kết nối đến máy chủ');

      await tester.pump();

      expect(find.byType(HomeErrorState), findsOneWidget);

      expect(find.text('Không thể tải dữ liệu'), findsOneWidget);

      expect(find.text('Không thể kết nối đến máy chủ'), findsOneWidget);

      // Tap retry button.
      await tester.tap(find.text('Thử lại'));

      await tester.pumpAndSettle();

      // State restored.
      expect(find.byType(HomeErrorState), findsNothing);

      expect(find.byType(TrendingSection, skipOffstage: false), findsOneWidget);
    });

    testWidgets('renders Empty State when data has no tracks', (tester) async {
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(MockHomeRepository()), homeFeedControllerProvider.overrideWith(MockHomeFeedController.new),
        ],
      );

      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      // Trigger empty state.
      container.read(homeFeedControllerProvider.notifier).setEmptyForTesting();

      await tester.pump();

      expect(find.byType(HomeEmptyState), findsOneWidget);

      expect(find.text('Chưa có bài hát nào'), findsOneWidget);

      // Tap refresh.
      await tester.tap(find.text('Làm mới'));

      await tester.pumpAndSettle();

      expect(find.byType(HomeEmptyState), findsNothing);

      expect(find.byType(TrendingSection, skipOffstage: false), findsOneWidget);
    });

    testWidgets('responsive layout renders on 360dp width without overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);

      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());

      await tester.pumpAndSettle();

      // Verify that no RenderFlex overflow error is thrown.
      expect(tester.takeException(), isNull);

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets(
      'trackPlay performs silent refresh without setting loading state',
      (tester) async {
        final fakeRepository = FakeHomeRepository();

        final container = ProviderContainer(
          overrides: [
            homeRepositoryProvider.overrideWithValue(MockHomeRepository()), homeFeedControllerProvider.overrideWith(MockHomeFeedController.new),
            homeRepositoryProvider.overrideWithValue(fakeRepository),
          ],
        );

        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: const HomeScreen(),
            ),
          ),
        );

        // Wait only for the initial widget build.
        // Do not use pumpAndSettle() here because this test
        // specifically verifies silent/background state changes.
        await tester.pump();

        final controller = container.read(homeFeedControllerProvider.notifier);

        final initialState = container.read(homeFeedControllerProvider);

        // Initial state must already be loaded.
        expect(initialState.hasValue, isTrue);

        expect(initialState.isLoading, isFalse);

        // Start tracking without awaiting immediately.
        final future = controller.trackPlay('123');

        // While tracking/refresh is running, the UI must NOT
        // enter loading state.
        final stateDuringRefresh = container.read(homeFeedControllerProvider);

        expect(stateDuringRefresh.hasValue, isTrue);

        expect(stateDuringRefresh.isLoading, isFalse);

        // Wait for tracking + silent refresh to complete.
        await future;

        final finalState = container.read(homeFeedControllerProvider);

        // Verify tracking API was called.
        expect(fakeRepository.trackHistoryCalls, 1);

        // Verify silent refresh fetched both Home sections.
        expect(fakeRepository.recommendationsCalls, 1);

        expect(fakeRepository.trendingCalls, 1);

        // Final state must remain AsyncData.
        expect(finalState.hasValue, isTrue);

        expect(finalState.isLoading, isFalse);
      },
    );
  });
}
