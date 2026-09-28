import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/add_track_bottom_sheet.dart';
import '../widgets/playlist_detail_header.dart';
import '../widgets/playlist_track_tile.dart';

class _PlaylistTrackItem {
  final String title;
  final String artist;
  final String duration;

  const _PlaylistTrackItem({
    required this.title,
    required this.artist,
    required this.duration,
  });
}

class PlaylistDetailScreen extends StatefulWidget {
  final String? playlistId;

  const PlaylistDetailScreen({super.key, this.playlistId});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  late final List<_PlaylistTrackItem> _tracks;

  @override
  void initState() {
    super.initState();
    _tracks = [
      const _PlaylistTrackItem(title: 'Chúng Ta Của Hiện Tại', artist: 'Sơn Tùng M-TP', duration: '05:01'),
      const _PlaylistTrackItem(title: 'Bên Trên Tầng Lầu', artist: 'Tăng Duy Tân', duration: '03:15'),
      const _PlaylistTrackItem(title: 'Nấu Ăn Cho Em', artist: 'Đen Vâu ft. PiaLinh', duration: '04:12'),
      const _PlaylistTrackItem(title: 'Dự Báo Thời Tiết Hôm Nay Mưa', artist: 'GREY D', duration: '04:32'),
      const _PlaylistTrackItem(title: 'Ngày Mai Người Ta Lấy Chồng', artist: 'Thành Đạt', duration: '05:10'),
      const _PlaylistTrackItem(title: 'Từng Quen', artist: 'Wren Evans', duration: '02:56'),
    ];
  }

  void _removeTrack(int index) {
    final removed = _tracks[index];
    setState(() => _tracks.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa "${removed.title}" khỏi playlist'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addTrack(Map<String, String> track) {
    setState(() {
      _tracks.add(
        _PlaylistTrackItem(
          title: track['title']!,
          artist: track['artist']!,
          duration: track['duration']!,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã thêm "${track['title']}" vào playlist'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sharePlaylist() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔗 Đã sao chép liên kết chia sẻ playlist (music4://playlist)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playlistTitle = 'Playlist #${widget.playlistId ?? "1"}';

    return Scaffold(
      appBar: AppBar(
        title: Text(playlistTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Chia sẻ',
            onPressed: () {
              HapticFeedback.lightImpact();
              _sharePlaylist();
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            color: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (val) {
              HapticFeedback.lightImpact();
              if (val == 'clear') {
                setState(() => _tracks.clear());
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('Xóa tất cả bài hát', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          PlaylistDetailHeader(
            title: playlistTitle,
            trackCount: _tracks.length,
            onPlayAll: () => context.push(RouteNames.player),
            onShuffle: () => context.push(RouteNames.player),
            onAddTrack: () => AddTrackBottomSheet.show(context, _addTrack),
            onShare: _sharePlaylist,
          ),
          const Divider(color: AppColors.divider, height: 1),
          if (_tracks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
              child: Column(
                children: [
                  const Icon(Icons.music_off_outlined, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  const Text(
                    'Chưa có bài hát nào trong playlist này',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => AddTrackBottomSheet.show(context, _addTrack),
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text('Thêm bài hát ngay', style: TextStyle(color: Colors.black)),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tracks.length,
              itemBuilder: (context, index) {
                final track = _tracks[index];
                return PlaylistTrackTile(
                  index: index,
                  title: track.title,
                  artist: track.artist,
                  duration: track.duration,
                  onTap: () => context.push('/track/${index + 1}'),
                  onRemove: () => _removeTrack(index),
                );
              },
            ),
        ],
      ),
    );
  }
}
