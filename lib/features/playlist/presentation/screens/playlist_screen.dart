import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/playlist_controller.dart';
import '../widgets/create_playlist_dialog.dart';
import '../widgets/playlist_card.dart';
import '../widgets/playlist_empty_state.dart';
import '../widgets/playlist_error_state.dart';
import '../widgets/playlist_shimmer_skeleton.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  const PlaylistScreen({super.key});

  @override
  ConsumerState<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  String _searchQuery = '';
  bool _isSearching = false;
  bool _isGrid = false;

  void _showCreateDialog() async {
    final result = await CreatePlaylistDialog.show(context);
    if (result != null && result.isNotEmpty) {
      try {
        await ref
            .read(playlistControllerProvider.notifier)
            .createPlaylist(result);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã tạo playlist "$result"'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tạo thất bại: ${e.toString().replaceAll("Exception: ", "")}',
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _deletePlaylist(int id, String title) async {
    try {
      await ref.read(playlistControllerProvider.notifier).deletePlaylist(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa "$title"'),
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

  @override
  Widget build(BuildContext context) {
    final playlistState = ref.watch(playlistControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm playlist...',
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              )
            : const Text('Thư viện Playlist'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              HapticFeedback.lightImpact();
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchQuery = '';
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tạo playlist',
            onPressed: _showCreateDialog,
          ),
        ],
      ),
      body: playlistState.when(
        loading: () => PlaylistShimmerSkeleton(isGrid: _isGrid),
        error: (error, _) => PlaylistErrorState(
          message: error.toString().replaceAll('Exception: ', ''),
          onRetry: () =>
              ref.read(playlistControllerProvider.notifier).refresh(),
        ),
        data: (playlists) {
          final filtered = playlists
              .where(
                (p) =>
                    p.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

          if (filtered.isEmpty) {
            return PlaylistEmptyState(onCreatePressed: _showCreateDialog);
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(playlistControllerProvider.notifier).refresh(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filtered.length} danh sách phát',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isGrid
                              ? Icons.format_list_bulleted
                              : Icons.grid_view_outlined,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        tooltip: _isGrid ? 'Xem dạng danh sách' : 'Xem dạng lưới',
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() => _isGrid = !_isGrid);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isGrid
                      ? GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.78,
                              ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return PlaylistCard(
                              id: item.id.toString(),
                              title: item.name,
                              trackCount: item.trackCount,
                              isGrid: true,
                              onTap: () => context.push('/playlist/${item.id}'),
                              onDelete: () =>
                                  _deletePlaylist(item.id, item.name),
                            );
                          },
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return PlaylistCard(
                              id: item.id.toString(),
                              title: item.name,
                              trackCount: item.trackCount,
                              isGrid: false,
                              onTap: () => context.push('/playlist/${item.id}'),
                              onDelete: () =>
                                  _deletePlaylist(item.id, item.name),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text(
          'Tạo Playlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
