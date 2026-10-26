import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../notifications/presentation/widgets/notification_bell_button.dart';
import '../../../player/presentation/widgets/mini_player_widget.dart';
import '../controllers/home_albums_controller.dart';
import '../controllers/home_feed_controller.dart';
import '../controllers/home_feed_state.dart';
import '../controllers/home_filter.dart';
import '../utils/profile_destination.dart';
import '../widgets/ai_recommendation_banner.dart';
import '../widgets/ai_recommendation_section.dart';
import '../widgets/home_empty_state.dart';
import '../widgets/home_error_state.dart';
import '../widgets/home_header_greeting.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../widgets/artist_studio_quick_banner.dart';
import '../widgets/home_shimmer_skeleton.dart';
import '../widgets/home_album_section.dart';
import '../widgets/home_artist_section.dart';
import '../widgets/home_albums_full_list.dart';
import '../widgets/home_track_list_section.dart';
import '../widgets/trending_section.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../../player/domain/models/player_state_data.dart';
import '../../../player/presentation/dialogs/preview_ended_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<PlayerStateData>>(playerNotifierProvider, (
      previous,
      next,
    ) {
      if (next is AsyncData &&
          next.value!.showLoginPrompt &&
          !(previous?.value?.showLoginPrompt ?? false)) {
        showPreviewEndedDialog(context, ref);
      }
    });

    final homeFeedAsync = ref.watch(homeFeedControllerProvider);
    final filter = ref.watch(homeFilterProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState is AuthAuthenticated ? authState.user : null;
    final isArtist = user?.isArtist ?? false;
    final isAdmin = user?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Music4',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          if (isAdmin)
            IconButton(
              key: const Key('home_appbar_admin_btn'),
              icon: const Icon(Icons.admin_panel_settings_outlined),
              tooltip: 'Quản trị hệ thống',
              onPressed: () => context.push(RouteNames.admin),
            ),
          if (isArtist) ...[
            IconButton(
              key: const Key('home_appbar_upload_btn'),
              icon: const Icon(Icons.cloud_upload_outlined),
              tooltip: 'Tải lên nhạc',
              onPressed: () => context.push(RouteNames.upload),
            ),
            IconButton(
              key: const Key('home_appbar_track_btn'),
              icon: const Icon(Icons.library_music_outlined),
              tooltip: 'Quản lý Bài hát',
              onPressed: () => context.push(RouteNames.trackManagement),
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
            onPressed: () =>
                context.push(profileRouteFor(ref.read(authNotifierProvider))),
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
                  // The albums tab pages its own data: refresh just that.
                  onRefresh: () => filter == HomeFilter.albums
                      ? ref.read(homeAlbumsProvider.notifier).fetch()
                      : ref.read(homeFeedControllerProvider.notifier).refresh(),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      // Infinite scroll of the albums tab.
                      if (filter == HomeFilter.albums &&
                          notification.metrics.axis == Axis.vertical &&
                          notification.metrics.extentAfter < 300) {
                        ref.read(homeAlbumsProvider.notifier).loadMore();
                      }
                      return false;
                    },
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      children: [
                        const HomeHeaderGreeting(),
                        if (isArtist && filter == HomeFilter.all) ...[
                          const SizedBox(height: 12),
                          const ArtistStudioQuickBanner(),
                        ],
                        const SizedBox(height: 8),
                        ..._buildSections(ref, state, filter),
                      ],
                    ),
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

  /// The sections for the selected chip.
  List<Widget> _buildSections(
    WidgetRef ref,
    HomeFeedState state,
    HomeFilter filter,
  ) {
    void select(HomeFilter next) =>
        ref.read(homeFilterProvider.notifier).state = next;

    switch (filter) {
      case HomeFilter.all:
        return [
          AiRecommendationBanner(
            track: state.featuredAiTrack,
            playlist: state.aiRecommendations,
          ),
          const SizedBox(height: 16),
          AiRecommendationSection(
            tracks: state.aiRecommendations,
            onSeeAll: () => select(HomeFilter.recommended),
          ),
          const SizedBox(height: 16),
          TrendingSection(
            tracks: state.trendingTracks,
            onSeeAll: () => select(HomeFilter.trending),
          ),
          const SizedBox(height: 16),
          HomeAlbumSection(onSeeAll: () => select(HomeFilter.albums)),
          const SizedBox(height: 16),
          const HomeArtistSection(),
        ];

      case HomeFilter.recommended:
        // The banner's track is the best match: it leads the full list.
        final all = [
          if (state.featuredAiTrack != null) state.featuredAiTrack!,
          ...state.aiRecommendations,
        ];
        if (all.isEmpty) {
          return const [_FilterEmptyMessage('Chưa có gợi ý nào.')];
        }
        return [HomeTrackListSection(title: 'Gợi ý cho bạn', tracks: all)];

      case HomeFilter.trending:
        if (state.trendingTracks.isEmpty) {
          return const [_FilterEmptyMessage('Chưa có bài hát thịnh hành.')];
        }
        return [TrendingSection(tracks: state.trendingTracks)];

      case HomeFilter.albums:
        return const [HomeAlbumsFullList()];
    }
  }
}

/// Shown when the selected chip has nothing to display.
class _FilterEmptyMessage extends StatelessWidget {
  final String message;

  const _FilterEmptyMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
