import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../player/domain/models/player_state_data.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../data/repositories/artist_profile_repository.dart';
import '../../domain/models/artist_profile_data.dart';
import '../providers/artist_profile_provider.dart';
import '../widgets/artist_album_item.dart';
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

  /// Plays the artist's tracks through the existing Player flow, starting at
  /// the tapped track.
  void _playTrack(
    BuildContext context,
    WidgetRef ref,
    ArtistProfileData data,
    int index,
  ) {
    final queue = data.popularTracks
        .map(
          (t) => TrackQueueItem(
            id: t.id,
            title: t.title,
            artist: t.artistName,
            coverUrl: t.artworkUrl,
            duration: Duration(seconds: t.durationSeconds),
          ),
        )
        .toList();

    ref.read(playerNotifierProvider.notifier).playPlaylist(queue, index);
    context.push(RouteNames.player);
  }

  Future<void> _toggleFollow(
    BuildContext context,
    WidgetRef ref,
    ArtistProfileParams params,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref
        .read(artistProfileProvider(params).notifier)
        .toggleFollow();

    switch (result) {
      case FollowResult.success:
        break;
      case FollowResult.needsLogin:
        messenger.showSnackBar(
          const SnackBar(content: Text('Vui lòng đăng nhập để theo dõi nghệ sĩ.')),
        );
      case FollowResult.failed:
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Không thể cập nhật theo dõi. Vui lòng thử lại.'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = ArtistProfileParams(
      artistId: artistId,
      isOwner: mode == ArtistProfileMode.owner,
    );
    final profileState = ref.watch(artistProfileProvider(params));

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
                  onToggleFollow: () => _toggleFollow(context, ref, params),
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
                        onTap: () => _playTrack(context, ref, data, index),
                      );
                    },
                    childCount: data.popularTracks.length,
                  ),
                ),

              // Albums (only when the artist has some)
              if (data.albums.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                    child: Text(
                      'Album',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final album = data.albums[index];
                      return ArtistAlbumItem(
                        album: album,
                        onTap: () => context.push('/album/${album.id}'),
                      );
                    },
                    childCount: data.albums.length,
                  ),
                ),
              ],

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  const Text(
                    'Đã xảy ra lỗi khi tải dữ liệu',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  // Friendly message from the repository (not a raw exception).
                  if (error is ArtistProfileException) ...[
                    const SizedBox(height: 8),
                    Text(
                      error.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(artistProfileProvider(params).notifier).retry();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
