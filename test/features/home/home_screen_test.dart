import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/core/theme/app_theme.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_controller.dart';
import 'package:music4_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:music4_mobile/features/home/presentation/widgets/ai_recommendation_banner.dart';
import 'package:music4_mobile/features/home/presentation/widgets/ai_recommendation_section.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_empty_state.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_error_state.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_shimmer_skeleton.dart';
import 'package:music4_mobile/features/home/presentation/widgets/trending_section.dart';

Widget createTestWidget({List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    ),
  );
}

void main() {
  group('[CE190284] HomeScreen & Home Feed Widget Tests', () {
    testWidgets('renders loaded Home feed with AI recommendation and Top Trending',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify App Bar
      expect(find.text('Music4'), findsOneWidget);

      // Verify AI recommendation banner and sections
      expect(find.byType(AiRecommendationBanner), findsOneWidget);
      expect(find.byType(AiRecommendationSection), findsOneWidget);
      expect(find.byType(TrendingSection), findsOneWidget);

      // Verify specific data items from HomeMockData
      expect(find.text('Gió Cuốn Hoa Rơi'), findsOneWidget);
      expect(find.text('Gợi ý cho bạn'), findsOneWidget);
      expect(find.text('Thịnh hành'), findsWidgets);
    });

    testWidgets('renders Loading Shimmer Skeleton when in loading state',
        (tester) async {
      final container = ProviderContainer();
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

      // Transition to loading
      container
          .read(homeFeedControllerProvider.notifier)
          .setLoadingForTesting();
      await tester.pump();

      expect(find.byType(HomeShimmerSkeleton), findsOneWidget);
    });

    testWidgets('renders Error State and allows retry', (tester) async {
      final container = ProviderContainer();
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

      // Trigger error state
      container
          .read(homeFeedControllerProvider.notifier)
          .setErrorForTesting('Không thể kết nối đến máy chủ');
      await tester.pump();

      expect(find.byType(HomeErrorState), findsOneWidget);
      expect(find.text('Không thể tải dữ liệu'), findsOneWidget);
      expect(find.text('Không thể kết nối đến máy chủ'), findsOneWidget);

      // Tap retry button
      await tester.tap(find.text('Thử lại'));
      await tester.pump();

      // State restored
      expect(find.byType(HomeErrorState), findsNothing);
      expect(find.byType(TrendingSection), findsOneWidget);
    });

    testWidgets('renders Empty State when data has no tracks', (tester) async {
      final container = ProviderContainer();
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

      // Trigger empty state
      container.read(homeFeedControllerProvider.notifier).setEmptyForTesting();
      await tester.pump();

      expect(find.byType(HomeEmptyState), findsOneWidget);
      expect(find.text('Chưa có bài hát nào'), findsOneWidget);

      // Tap refresh
      await tester.tap(find.text('Làm mới'));
      await tester.pump();

      expect(find.byType(HomeEmptyState), findsNothing);
      expect(find.byType(TrendingSection), findsOneWidget);
    });

    testWidgets('responsive layout renders on 360dp width without overflow',
        (tester) async {
      // Set surface to 360dp width
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Verify that no RenderFlex overflow error is thrown
      expect(tester.takeException(), isNull);
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
