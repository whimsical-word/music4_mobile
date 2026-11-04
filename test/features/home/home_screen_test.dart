import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';


import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/core/theme/app_theme.dart';

import 'package:music4_mobile/features/home/data/models/track_detail_model.dart';
import 'package:music4_mobile/features/home/data/models/track_suggest_model.dart';
import 'package:music4_mobile/features/home/data/sources/home_mock_data.dart';
import 'package:music4_mobile/features/home/data/sources/home_repository.dart';
import 'package:music4_mobile/features/player/data/services/app_audio_handler.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';

import 'package:music4_mobile/features/home/presentation/controllers/home_feed_controller.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_state.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_filter.dart';
import 'package:music4_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:music4_mobile/features/home/presentation/widgets/ai_recommendation_banner.dart';
import 'package:music4_mobile/features/home/presentation/widgets/ai_recommendation_section.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_empty_state.dart';
import 'package:music4_mobile/features/album/data/models/album_model.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_album_list_tile.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_album_section.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_track_list_section.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_error_state.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_header_greeting.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_shimmer_skeleton.dart';
import 'package:music4_mobile/features/home/presentation/widgets/trending_section.dart';



class MockAudioPlayer extends Mock implements AudioPlayer {}

class MockAppAudioHandler extends Mock implements AppAudioHandler {}

AudioPlayer createMockAudioPlayer() {
  final mock = MockAudioPlayer();
  when(() => mock.playerStateStream).thenAnswer((_) => Stream.empty());
  when(() => mock.positionStream).thenAnswer((_) => Stream.empty());
  when(() => mock.bufferedPositionStream).thenAnswer((_) => Stream.empty());
  when(() => mock.durationStream).thenAnswer((_) => Stream.empty());
  when(() => mock.playbackEventStream).thenAnswer((_) => Stream.empty());
  return mock;
}


class MockPlayerNotifier extends PlayerNotifier {
  MockPlayerNotifier() : super(createMockAudioPlayer(), MockTrackDetailRepo(), MockAppAudioHandler());
}
class MockTrackDetailRepo extends Mock implements TrackDetailRepository {}

class MockHomeRepository extends HomeRepository {
  MockHomeRepository() : super(DioClient());
}

class MockHomeFeedController extends HomeFeedController {
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

/// Serves album pages from memory and records which pages were requested.
class FakeAlbumsRepository extends HomeRepository {
  final List<List<AlbumModel>> pages;
  final List<int> requestedPages = [];
  int failures;

  FakeAlbumsRepository(this.pages, {this.failures = 0}) : super(DioClient());

  @override
  Future<List<AlbumModel>> getAlbumsPage({int page = 0, int size = 10}) async {
    requestedPages.add(page);
    if (failures > 0) {
      failures--;
      throw const HomeException('Mạng quá yếu, thử lại sau');
    }
    return page < pages.length ? pages[page] : [];
  }
}

AlbumModel albumNamed(int i) => AlbumModel(
  id: '$i',
  title: 'Album $i',
  artistId: '1',
  artistName: 'Artist',
  releaseDate: DateTime(2026, 1, 1),
  trackCount: 3,
);

/// Feed with recommendations but no trending tracks.
class NoTrendingHomeFeedController extends HomeFeedController {
  @override
  Future<HomeFeedState> build() async {
    return const HomeFeedState(
      featuredAiTrack: HomeMockData.featuredAiTrack,
      aiRecommendations: HomeMockData.aiRecommendations,
      trendingTracks: [],
    );
  }
}

class FakeHomeRepository extends HomeRepository {
  FakeHomeRepository() : super(DioClient());

  int recommendationsCalls = 0;
  int trendingCalls = 0;

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
      homeRepositoryProvider.overrideWithValue(MockHomeRepository()),
      audioHandlerProvider.overrideWithValue(MockAppAudioHandler()),
      playerNotifierProvider.overrideWith((ref) => MockPlayerNotifier()),
      homeFeedControllerProvider.overrideWith(MockHomeFeedController.new),
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

        // Allow the AsyncNotifier build future to complete.
        await tester.pump();

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

        expect(find.text('Thịnh hành'), findsWidgets);
      },
    );

    testWidgets('renders Loading Shimmer Skeleton when in loading state', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          homeRepositoryProvider.overrideWithValue(MockHomeRepository()),
      audioHandlerProvider.overrideWithValue(MockAppAudioHandler()),
      playerNotifierProvider.overrideWith((ref) => MockPlayerNotifier()),
          homeFeedControllerProvider.overrideWith(MockHomeFeedController.new),
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
          homeRepositoryProvider.overrideWithValue(MockHomeRepository()),
      audioHandlerProvider.overrideWithValue(MockAppAudioHandler()),
      playerNotifierProvider.overrideWith((ref) => MockPlayerNotifier()),
          homeFeedControllerProvider.overrideWith(MockHomeFeedController.new),
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
          homeRepositoryProvider.overrideWithValue(MockHomeRepository()),
      audioHandlerProvider.overrideWithValue(MockAppAudioHandler()),
      playerNotifierProvider.overrideWith((ref) => MockPlayerNotifier()),
          homeFeedControllerProvider.overrideWith(MockHomeFeedController.new),
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
      'silentRefresh reloads the feed without setting loading state',
      (tester) async {
        final fakeRepository = FakeHomeRepository();

        final container = ProviderContainer(
          overrides: [
            homeRepositoryProvider.overrideWithValue(MockHomeRepository()),
      audioHandlerProvider.overrideWithValue(MockAppAudioHandler()),
      playerNotifierProvider.overrideWith((ref) => MockPlayerNotifier()),
            homeFeedControllerProvider.overrideWith(MockHomeFeedController.new),
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

        // Start the background refresh without awaiting immediately.
        final future = controller.silentRefresh();

        // While the refresh is running, the UI must NOT
        // enter loading state.
        final stateDuringRefresh = container.read(homeFeedControllerProvider);

        expect(stateDuringRefresh.hasValue, isTrue);

        expect(stateDuringRefresh.isLoading, isFalse);

        // Wait for the silent refresh to complete.
        await future;

        final finalState = container.read(homeFeedControllerProvider);

        // Verify silent refresh fetched both Home sections.
        expect(fakeRepository.recommendationsCalls, 1);

        expect(fakeRepository.trendingCalls, 1);

        // Final state must remain AsyncData.
        expect(finalState.hasValue, isTrue);

        expect(finalState.isLoading, isFalse);
      },
    );

    group('filter chips and section headers', () {
      /// The album section would call the real album API (and fall back to
      /// hard-coded albums), so it is replaced by an empty list here.
      Widget createFilterTestWidget({List<Override> overrides = const []}) {
        return createTestWidget(
          overrides: [
            homeAlbumListProvider.overrideWith((ref) async => <AlbumModel>[]),
            ...overrides,
          ],
        );
      }

      Finder chip(String label) => find.descendant(
        of: find.byType(HomeHeaderGreeting),
        matching: find.text(label),
      );

      HomeFilter selectedFilter(WidgetTester tester) {
        final container = ProviderScope.containerOf(
          tester.element(find.byType(HomeScreen)),
        );
        return container.read(homeFilterProvider);
      }

      testWidgets('starts on Tất cả with every section visible', (tester) async {
        await tester.pumpWidget(createFilterTestWidget());
        await tester.pump();

        expect(selectedFilter(tester), HomeFilter.all);
        expect(find.byType(AiRecommendationBanner), findsOneWidget);
        expect(find.byType(AiRecommendationSection), findsOneWidget);
        expect(find.byType(TrendingSection, skipOffstage: false), findsOneWidget);

        // The album section is the last child of a lazy list: scroll to it.
        await tester.drag(find.byType(ListView).first, const Offset(0, -3000));
        await tester.pump();
        expect(find.byType(HomeAlbumSection), findsOneWidget);
      });

      testWidgets('Thịnh hành shows only the trending section', (tester) async {
        await tester.pumpWidget(createFilterTestWidget());
        await tester.pump();

        await tester.tap(chip('Thịnh hành'));
        await tester.pump();

        expect(selectedFilter(tester), HomeFilter.trending);
        expect(find.byType(TrendingSection, skipOffstage: false), findsOneWidget);
        expect(find.byType(AiRecommendationSection), findsNothing);
        expect(find.byType(AiRecommendationBanner), findsNothing);
        expect(find.byType(HomeAlbumSection), findsNothing);
      });

      testWidgets('Gợi ý shows the full vertical recommendation list only', (tester) async {
        await tester.pumpWidget(createFilterTestWidget());
        await tester.pump();

        await tester.tap(chip('Gợi ý'));
        await tester.pump();

        expect(selectedFilter(tester), HomeFilter.recommended);
        // One vertical list with the featured track first.
        expect(find.byType(HomeTrackListSection), findsOneWidget);
        expect(find.byType(AiRecommendationBanner), findsNothing);
        expect(find.byType(AiRecommendationSection), findsNothing);
        expect(find.byType(TrendingSection, skipOffstage: false), findsNothing);
        expect(find.byType(HomeAlbumSection), findsNothing);
      });

      testWidgets('Tất cả brings every section back', (tester) async {
        await tester.pumpWidget(createFilterTestWidget());
        await tester.pump();

        await tester.tap(chip('Thịnh hành'));
        await tester.pump();
        await tester.tap(chip('Tất cả'));
        await tester.pump();

        expect(selectedFilter(tester), HomeFilter.all);
        expect(find.byType(AiRecommendationSection), findsOneWidget);
        expect(find.byType(TrendingSection, skipOffstage: false), findsOneWidget);
      });

      testWidgets('the ">" on a header opens just that section', (tester) async {
        await tester.pumpWidget(createFilterTestWidget());
        await tester.pump();

        // Unfiltered feed: both headers have a ">".
        expect(find.byIcon(Icons.chevron_right), findsNWidgets(2));

        await tester.tap(find.text('Gợi ý cho bạn'));
        await tester.pump();

        expect(selectedFilter(tester), HomeFilter.recommended);
        expect(find.byType(TrendingSection, skipOffstage: false), findsNothing);
        // Already filtered: the ">" is gone.
        expect(find.byIcon(Icons.chevron_right), findsNothing);
      });

      testWidgets('an empty selected section shows a message', (tester) async {
        await tester.pumpWidget(
          createFilterTestWidget(
            overrides: [
              homeFeedControllerProvider.overrideWith(
                NoTrendingHomeFeedController.new,
              ),
            ],
          ),
        );
        await tester.pump();

        await tester.tap(chip('Thịnh hành'));
        await tester.pump();

        expect(find.text('Chưa có bài hát thịnh hành.'), findsOneWidget);
      });

      group('Album nổi bật tab', () {
        Future<FakeAlbumsRepository> openAlbumsTab(
          WidgetTester tester,
          List<List<AlbumModel>> pages, {
          int failures = 0,
        }) async {
          final fake = FakeAlbumsRepository(pages, failures: failures);
          await tester.pumpWidget(
            createFilterTestWidget(
              overrides: [homeRepositoryProvider.overrideWithValue(fake)],
            ),
          );
          await tester.pump();

          await tester.tap(chip('Album nổi bật'));
          await tester.pump();
          await tester.pump();
          return fake;
        }

        List<AlbumModel> albums(int count, {int start = 0}) => [
          for (var i = 0; i < count; i++) albumNamed(start + i),
        ];

        testWidgets('has its own chip and shows only the albums', (tester) async {
          await openAlbumsTab(tester, [albums(3)]);

          expect(selectedFilter(tester), HomeFilter.albums);
          expect(find.text('Album 0'), findsOneWidget);
          expect(find.text('Album 2'), findsOneWidget);
          expect(find.byType(HomeAlbumListTile), findsNWidgets(3));
          expect(find.byType(AiRecommendationSection), findsNothing);
          expect(find.byType(TrendingSection, skipOffstage: false), findsNothing);
        });

        testWidgets('scrolling to the bottom loads the next page (infinite scroll)', (tester) async {
          final fake = await openAlbumsTab(tester, [albums(10), albums(3, start: 10)]);

          expect(fake.requestedPages, [0]);

          await tester.drag(find.byType(ListView).first, const Offset(0, -3000));
          await tester.pump();
          await tester.pump();

          expect(fake.requestedPages, [0, 1]);

          // The last page was short: scrolling further asks for nothing more.
          await tester.drag(find.byType(ListView).first, const Offset(0, -3000));
          await tester.pump();
          await tester.pump();

          expect(fake.requestedPages, [0, 1]);
          expect(find.text('Album 12'), findsOneWidget);
        });

        testWidgets('an empty list shows a message', (tester) async {
          await openAlbumsTab(tester, [<AlbumModel>[]]);

          expect(find.text('Chưa có album nào.'), findsOneWidget);
        });

        testWidgets('an error shows the message and Thử lại loads again', (tester) async {
          final fake = await openAlbumsTab(tester, [albums(2)], failures: 1);

          expect(find.text('Mạng quá yếu, thử lại sau'), findsOneWidget);

          await tester.tap(find.text('Thử lại'));
          await tester.pump();
          await tester.pump();

          expect(fake.requestedPages, [0, 0]);
          expect(find.text('Album 0'), findsOneWidget);
        });
      });
    });
  });
}
