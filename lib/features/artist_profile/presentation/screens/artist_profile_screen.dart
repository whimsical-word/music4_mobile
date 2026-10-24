import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/shared/widgets/settings_bottom_sheet.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/state/auth_state.dart';
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

class ArtistProfileScreen extends ConsumerStatefulWidget {
  final String? artistId;
  final ArtistProfileMode mode;

  const ArtistProfileScreen({
    super.key,
    this.artistId,
    this.mode = ArtistProfileMode.listener, // Default to listener
  });

  @override
  ConsumerState<ArtistProfileScreen> createState() =>
      _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends ConsumerState<ArtistProfileScreen> {
  /// Tracks and albums show this many items; "Xem tất cả" reveals the rest.
  static const int _previewCount = 5;

  bool _showAllTracks = false;
  bool _showAllAlbums = false;

  /// Plays the artist's tracks through the existing Player flow, starting at
  /// the tapped track.
  void _playTrack(
    BuildContext context,
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
      case FollowResult.notSupported:
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Tài khoản nghệ sĩ không thể theo dõi nghệ sĩ khác.'),
          ),
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
  Widget build(BuildContext context) {
    // An artist opening their OWN profile is the owner: they get the
    // dashboard and the settings (logout), and no Follow button.
    final authState = ref.watch(authNotifierProvider);
    final isOwnProfile = authState is AuthAuthenticated &&
        authState.user.isArtist &&
        authState.user.id.toString() == widget.artistId;
    final isOwnerMode = widget.mode == ArtistProfileMode.owner || isOwnProfile;

    final params = ArtistProfileParams(
      artistId: widget.artistId,
      isOwner: isOwnerMode,
    );
    final profileState = ref.watch(artistProfileProvider(params));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ Nghệ sĩ'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (isOwnerMode) ...[
            IconButton(
              key: const Key('artist_profile_appbar_upload_btn'),
              icon: const Icon(Icons.cloud_upload_outlined),
              tooltip: 'Tải lên & Quản lý nhạc',
              onPressed: () => context.push(RouteNames.upload),
            ),
            IconButton(
              key: const Key('artist_profile_appbar_album_btn'),
              icon: const Icon(Icons.album_outlined),
              tooltip: 'Quản lý Album',
              onPressed: () => context.push(RouteNames.albumManagement),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Cài đặt',
              onPressed: () => showSettingsBottomSheet(context),
            ),
          ],
        ],
      ),
      extendBodyBehindAppBar: true,
      body: profileState.when(
        data: (data) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ArtistHeader(
                  artist: data.artist,
                  isFollowing: data.isFollowing,
                  showFollowButton: !isOwnerMode,
                  onToggleFollow: () => _toggleFollow(context, params),
                ),
              ),
              if (isOwnerMode)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                key: const Key('artist_profile_upload_btn'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.cloud_upload_outlined, size: 20),
                                label: const Text(
                                  'Upload Nhạc Mới',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () => context.push(RouteNames.upload),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                key: const Key('artist_profile_track_btn'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textPrimary,
                                  side: const BorderSide(color: AppColors.divider),
                                  backgroundColor: AppColors.surface,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.library_music_outlined,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                label: const Text(
                                  'Quản lý Bài hát',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () =>
                                    context.push(RouteNames.trackManagement),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                key: const Key('artist_profile_album_btn'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textPrimary,
                                  side: const BorderSide(color: AppColors.divider),
                                  backgroundColor: AppColors.surface,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.album_outlined,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                label: const Text(
                                  'Quản lý Album',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () =>
                                    context.push(RouteNames.albumManagement),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
              else ...[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final track = data.popularTracks[index];
                      // The queue is the whole list, so playback continues
                      // past the visible items.
                      return TrackListItem(
                        track: track,
                        onTap: () => _playTrack(context, data, index),
                      );
                    },
                    childCount: _showAllTracks
                        ? data.popularTracks.length
                        : math.min(data.popularTracks.length, _previewCount),
                  ),
                ),
                if (data.popularTracks.length > _previewCount)
                  SliverToBoxAdapter(
                    child: _ShowAllButton(
                      total: data.popularTracks.length,
                      expanded: _showAllTracks,
                      onPressed: () =>
                          setState(() => _showAllTracks = !_showAllTracks),
                    ),
                  ),
              ],

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
                    childCount: _showAllAlbums
                        ? data.albums.length
                        : math.min(data.albums.length, _previewCount),
                  ),
                ),
                if (data.albums.length > _previewCount)
                  SliverToBoxAdapter(
                    child: _ShowAllButton(
                      total: data.albums.length,
                      expanded: _showAllAlbums,
                      onPressed: () =>
                          setState(() => _showAllAlbums = !_showAllAlbums),
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

/// "Xem tất cả (N)" / "Thu gọn": reveals or hides the items after the first 5.
class _ShowAllButton extends StatelessWidget {
  final int total;
  final bool expanded;
  final VoidCallback onPressed;

  const _ShowAllButton({
    required this.total,
    required this.expanded,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextButton(
          onPressed: onPressed,
          child: Text(expanded ? 'Thu gọn' : 'Xem tất cả ($total)'),
        ),
      ),
    );
  }
}
