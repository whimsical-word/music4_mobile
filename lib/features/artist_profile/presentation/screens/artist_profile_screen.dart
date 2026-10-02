import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/artist_profile_provider.dart';
import '../widgets/artist_header.dart';
import '../widgets/artist_profile_shimmer.dart';
import '../widgets/track_list_item.dart';
import '../widgets/artist_dashboard.dart';

enum ArtistProfileMode {
  listener,
  owner,
}

class ArtistProfileScreen extends ConsumerWidget {
  final String? artistId;
  final ArtistProfileMode mode;

  const ArtistProfileScreen({
    super.key,
    this.artistId,
    this.mode = ArtistProfileMode.listener, // Default to listener
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(artistProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ Nghệ sĩ'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: profileState.when(
        data: (data) {
          final isOwnerMode = mode == ArtistProfileMode.owner;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ArtistHeader(
                  artist: data.artist,
                  isFollowing: data.isFollowing,
                  showFollowButton: !isOwnerMode,
                  onToggleFollow: () {
                    ref.read(artistProfileProvider.notifier).toggleFollow();
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Bài hát phổ biến',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              if (data.popularTracks.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'Chưa có bài hát nào.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final track = data.popularTracks[index];
                      return TrackListItem(
                        track: track,
                        onTap: () {
                          // Handle track tap, e.g. navigate to player
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đang phát: ${track.title}')),
                          );
                        },
                      );
                    },
                    childCount: data.popularTracks.length,
                  ),
                ),
              
              // Artist Dashboard (Owner Only)
              if (isOwnerMode && data.dashboardStats != null)
                SliverToBoxAdapter(
                  child: ArtistDashboard(stats: data.dashboardStats!),
                ),

              // Padding for bottom nav bar if needed
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
        loading: () => const ArtistProfileShimmer(),
        error: (error, stack) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: 16),
                const Text(
                  'Đã xảy ra lỗi khi tải dữ liệu',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(artistProfileProvider.notifier).retry();
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
