import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../controllers/home_feed_controller.dart';
import '../widgets/ai_recommendation_banner.dart';
import '../widgets/ai_recommendation_section.dart';
import '../widgets/home_empty_state.dart';
import '../widgets/home_error_state.dart';
import '../widgets/home_header_greeting.dart';
import '../widgets/home_shimmer_skeleton.dart';
import '../widgets/trending_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeFeedAsync = ref.watch(homeFeedControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Music4',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.push(RouteNames.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(RouteNames.profile),
          ),
        ],
      ),
      body: homeFeedAsync.when(
        loading: () => const HomeShimmerSkeleton(),
        error: (error, _) => HomeErrorState(
          message: error.toString(),
          onRetry: () => ref.read(homeFeedControllerProvider.notifier).refresh(),
        ),
        data: (state) {
          if (state.isEmpty) {
            return HomeEmptyState(
              onRefresh: () =>
                  ref.read(homeFeedControllerProvider.notifier).refresh(),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(homeFeedControllerProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24.0),
              children: [
                const HomeHeaderGreeting(),
                const SizedBox(height: 8),
                AiRecommendationBanner(track: state.featuredAiTrack),
                const SizedBox(height: 16),
                AiRecommendationSection(tracks: state.aiRecommendations),
                const SizedBox(height: 16),
                TrendingSection(tracks: state.trendingTracks),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(icon: Icon(Icons.queue_music), label: 'Thư viện'),
        ],
        onTap: (index) {
          if (index == 1) context.push(RouteNames.search);
          if (index == 2) context.push(RouteNames.playlist);
        },
      ),
    );
  }
}
