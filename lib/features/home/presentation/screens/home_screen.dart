import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../notifications/presentation/widgets/notification_bell_button.dart';
import '../../../player/presentation/widgets/mini_player_widget.dart';
import '../controllers/home_feed_controller.dart';
import '../utils/profile_destination.dart';
import '../widgets/ai_recommendation_banner.dart';
import '../widgets/ai_recommendation_section.dart';
import '../widgets/home_empty_state.dart';
import '../widgets/home_error_state.dart';
import '../widgets/home_header_greeting.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../widgets/artist_studio_quick_banner.dart';
import '../widgets/home_shimmer_skeleton.dart';
import '../widgets/home_album_section.dart';
import '../widgets/trending_section.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../../player/domain/models/player_state_data.dart';
import '../../../player/presentation/dialogs/preview_ended_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<PlayerStateData>>(playerNotifierProvider, (previous, next) {
      if (next is AsyncData &&
          next.value!.showLoginPrompt &&
          !(previous?.value?.showLoginPrompt ?? false)) {
        showPreviewEndedDialog(context, ref);
      }
    });

    final homeFeedAsync = ref.watch(homeFeedControllerProvider);
    final authState = ref.watch(authNotifierProvider);
    final isArtist = authState is AuthAuthenticated && authState.user.isArtist;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Music4',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          if (isArtist) ...[
            IconButton(
              key: const Key('home_appbar_upload_btn'),
              icon: const Icon(Icons.cloud_upload_outlined),
              tooltip: 'Tải lên & Quản lý nhạc',
              onPressed: () => context.push(RouteNames.upload),
            ),
            IconButton(
              key: const Key('home_appbar_album_btn'),
              icon: const Icon(Icons.album_outlined),
              tooltip: 'Quản lý Album',
              onPressed: () => context.push(RouteNames.albumManagement),
            ),
          ],
          const NotificationBellButton(),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(
              profileRouteFor(ref.read(authNotifierProvider)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: homeFeedAsync.when(
              loading: () => const HomeShimmerSkeleton(),
              error: (error, _) => HomeErrorState(
                message: error.toString(),
                onRetry: () =>
                    ref.read(homeFeedControllerProvider.notifier).refresh(),
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
                      if (isArtist) ...[
                        const SizedBox(height: 12),
                        const ArtistStudioQuickBanner(),
                      ],
                      const SizedBox(height: 8),
                      AiRecommendationBanner(
                        track: state.featuredAiTrack,
                        playlist: state.aiRecommendations,
                      ),
                      const SizedBox(height: 16),
                      AiRecommendationSection(tracks: state.aiRecommendations),
                      const SizedBox(height: 16),
                      TrendingSection(tracks: state.trendingTracks),
                      const SizedBox(height: 16),
                      const HomeAlbumSection(),
                    ],
                  ),
                );
              },
            ),
          ),
          const MiniPlayerWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music),
            label: 'Thư viện',
          ),
        ],
        onTap: (index) {
          if (index == 1) context.push(RouteNames.search);
          if (index == 2) context.push(RouteNames.playlist);
        },
      ),
    );
  }
}
