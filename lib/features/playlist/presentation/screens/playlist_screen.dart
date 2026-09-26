import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/create_playlist_dialog.dart';
import '../widgets/playlist_card.dart';
import '../widgets/playlist_empty_state.dart';

class _MockPlaylist {
  final String id;
  final String title;
  final int trackCount;
  final IconData icon;

  const _MockPlaylist({
    required this.id,
    required this.title,
    required this.trackCount,
    this.icon = Icons.queue_music_rounded,
  });
}

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final List<_MockPlaylist> _playlists = [
    const _MockPlaylist(
      id: '1',
      title: 'Nhạc Chill Đêm Khuya',
      trackCount: 18,
      icon: Icons.nightlight_round,
    ),
    const _MockPlaylist(
      id: '2',
      title: 'Workout Motivation',
      trackCount: 24,
      icon: Icons.fitness_center_rounded,
    ),
    const _MockPlaylist(
      id: '3',
      title: 'Acoustic Coffee Time',
      trackCount: 15,
      icon: Icons.coffee_rounded,
    ),
    const _MockPlaylist(
      id: '4',
      title: 'Top V-Pop Hits',
      trackCount: 30,
      icon: Icons.trending_up_rounded,
    ),
    const _MockPlaylist(
      id: '5',
      title: 'Coding Focus Lofi',
      trackCount: 42,
      icon: Icons.headphones_rounded,
    ),
    const _MockPlaylist(
      id: '6',
      title: 'Giai điệu Mùa Thu',
      trackCount: 12,
      icon: Icons.park_rounded,
    ),
  ];

  String _searchQuery = '';
  bool _isSearching = false;

  void _showCreateDialog() async {
    final result = await CreatePlaylistDialog.show(context);
    if (result != null && result.isNotEmpty) {
      setState(() {
        _playlists.insert(
          0,
          _MockPlaylist(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: result,
            trackCount: 0,
            icon: Icons.queue_music_rounded,
          ),
        );
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã tạo playlist "$result"'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _deletePlaylist(int index) {
    final removed = _playlists[index];
    setState(() => _playlists.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${removed.title}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlaylists = _playlists
        .where(
          (p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

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
      body: filteredPlaylists.isEmpty
          ? PlaylistEmptyState(onCreatePressed: _showCreateDialog)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    '${filteredPlaylists.length} danh sách phát',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: filteredPlaylists.length,
                    itemBuilder: (context, index) {
                      final item = filteredPlaylists[index];
                      return PlaylistCard(
                        id: item.id,
                        title: item.title,
                        trackCount: item.trackCount,
                        icon: item.icon,
                        onTap: () => context.push('/playlist/${item.id}'),
                        onDelete: () => _deletePlaylist(index),
                      );
                    },
                  ),
                ),
              ],
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
