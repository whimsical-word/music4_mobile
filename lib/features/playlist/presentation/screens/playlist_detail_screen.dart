import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../data/models/playlist_model.dart';
import '../../data/models/playlist_track_model.dart';
import '../controllers/playlist_controller.dart';
import '../controllers/playlist_detail_controller.dart';
import '../widgets/add_track_bottom_sheet.dart';
import '../widgets/edit_playlist_dialog.dart';
import '../widgets/playlist_detail_header.dart';
import '../widgets/playlist_error_state.dart';
import '../widgets/playlist_shimmer_skeleton.dart';
import '../widgets/playlist_track_tile.dart';

class PlaylistDetailScreen extends ConsumerStatefulWidget {
  final String? playlistId;

  const PlaylistDetailScreen({super.key, this.playlistId});

  @override
  ConsumerState<PlaylistDetailScreen> createState() =>
      _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends ConsumerState<PlaylistDetailScreen> {
  int get _id => int.tryParse(widget.playlistId ?? '1') ?? 1;

  void _removeTrack(int trackId, String title) async {
    try {
      await ref
          .read(playlistDetailControllerProvider(_id).notifier)
          .removeTrack(trackId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa "$title" khỏi playlist'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể xóa: ${e.toString().replaceAll("Exception: ", "")}',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAddTrackSheet(List<PlaylistTrackModel> availableTracks) {
    AddTrackBottomSheet.show(
      context,
      tracks: availableTracks,
      onAdded: (track) async {
        try {
          await ref
              .read(playlistDetailControllerProvider(_id).notifier)
              .addTrack(track.id);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã thêm "${track.name}" vào playlist'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Thêm thất bại: ${e.toString().replaceAll("Exception: ", "")}',
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  void _showEditDialog(PlaylistModel playlist) async {
    final result = await EditPlaylistDialog.show(
      context,
      initialName: playlist.name,
      initialDescription: playlist.description,
      initialCoverUrl: playlist.coverUrl,
    );
    if (result != null) {
      try {
        await ref
            .read(playlistDetailControllerProvider(_id).notifier)
            .updatePlaylist(
              name: result.name,
              description: result.description,
              coverFilePath: result.coverFilePath,
            );
        // Đồng bộ danh sách playlist ngoài màn hình chính
        ref.read(playlistControllerProvider.notifier).loadPlaylists();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã cập nhật playlist "${result.name}"'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cập nhật thất bại: ${e.toString().replaceAll("Exception: ", "")}',
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(playlistDetailControllerProvider(_id));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Chỉnh sửa playlist',
            onPressed: () {
              final playlist = detailState.value?.playlist;
              if (playlist != null) {
                _showEditDialog(playlist);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Đã sao chép link chia sẻ: music4://playlist/$_id',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: detailState.when(
        loading: () => const PlaylistShimmerSkeleton(),
        error: (error, _) => PlaylistErrorState(
          message: error.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref
              .read(playlistDetailControllerProvider(_id).notifier)
              .refresh(),
        ),
        data: (state) {
          final playlist = state.playlist;
          final tracks = state.tracks;

          return RefreshIndicator(
            onRefresh: () => ref
                .read(playlistDetailControllerProvider(_id).notifier)
                .refresh(),
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              children: [
                PlaylistDetailHeader(
                  title: playlist.name,
                  description: playlist.description,
                  coverUrl: playlist.coverUrl,
                  trackCount: tracks.length,
                  onPlayAll: () => context.push(RouteNames.player),
                  onShuffle: () => context.push(RouteNames.player),
                  onAddTrack: () => _showAddTrackSheet(state.availableTracks),
                  onEdit: () => _showEditDialog(playlist),
                  onShare: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã sao chép link chia sẻ: music4://playlist/$_id'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bài hát (${tracks.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showAddTrackSheet(state.availableTracks),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Thêm bài hát'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (tracks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.music_off_outlined,
                            size: 48,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Chưa có bài hát nào trong playlist này',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () => _showAddTrackSheet(state.availableTracks),
                            icon: const Icon(Icons.add),
                            label: const Text('Thêm bài hát ngay'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...tracks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final track = entry.value;
                    return PlaylistTrackTile(
                      index: index + 1,
                      title: track.name,
                      artist: track.artistNames,
                      duration: track.formattedDuration,
                      imageUrl: ImageUrlHelper.resolve(track.img),
                      onTap: () => context.push(RouteNames.player),
                      onRemove: () => _removeTrack(track.id, track.name),
                    );
                  }),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
