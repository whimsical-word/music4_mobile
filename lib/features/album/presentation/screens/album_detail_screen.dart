import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/album_detail_header.dart';
import '../widgets/album_detail_track_tile.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String? albumId;
  const AlbumDetailScreen({super.key, this.albumId});

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  bool _isFavorite = false;

  final List<Map<String, String>> _tracks = const [
    {'title': 'Chúng Ta Của Tương Lai', 'artist': 'Sơn Tùng M-TP', 'duration': '4:11'},
    {'title': 'Đừng Làm Trái Tim Anh Đau', 'artist': 'Sơn Tùng M-TP', 'duration': '3:33'},
    {'title': 'Có Chắc Yêu Là Đây', 'artist': 'Sơn Tùng M-TP', 'duration': '3:22'},
    {'title': 'Nơi Này Có Anh', 'artist': 'Sơn Tùng M-TP', 'duration': '4:20'},
    {'title': 'Lạc Trôi', 'artist': 'Sơn Tùng M-TP', 'duration': '3:52'},
    {'title': 'Muộn Rồi Mà Sao Còn', 'artist': 'Sơn Tùng M-TP', 'duration': '4:35'},
    {'title': 'Hãy Trao Cho Anh', 'artist': 'Sơn Tùng M-TP ft. Snoop Dogg', 'duration': '4:05'},
    {'title': 'Cơn Mưa Ngang Qua', 'artist': 'Sơn Tùng M-TP', 'duration': '3:50'},
  ];

  void _showNotification(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showTrackOptions(Map<String, String> track) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(track['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(track['artist']!),
                trailing: const Icon(Icons.music_note, color: AppColors.primary),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: const Text('Phát bài này'),
                onTap: () {
                  modalContext.pop();
                  context.push('/player');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Xem chi tiết bài hát'),
                onTap: () {
                  modalContext.pop();
                  context.push('/track/1');
                },
              ),
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Thêm vào danh sách phát'),
                onTap: () {
                  modalContext.pop();
                  _showNotification('Đã thêm "${track['title']}" vào danh sách phát');
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Chia sẻ bài hát'),
                onTap: () {
                  modalContext.pop();
                  _showNotification('Đã sao chép liên kết bài hát');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Chi tiết Album'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Chia sẻ album',
            onPressed: () => _showNotification('Đã sao chép liên kết chia sẻ album'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          AlbumDetailHeader(
            title: 'Tuyển Tập Sơn Tùng M-TP 2024',
            artist: 'Sơn Tùng M-TP',
            metadata: 'Album • 2024 • ${_tracks.length} bài hát • 31 phút',
            imageUrl: 'https://picsum.photos/400/400',
            isFavorite: _isFavorite,
            onPlay: () {
              _showNotification('Đang phát toàn bộ album...');
              context.push('/player');
            },
            onShuffle: () {
              _showNotification('Đang phát ngẫu nhiên album...');
              context.push('/player');
            },
            onToggleFavorite: () {
              setState(() => _isFavorite = !_isFavorite);
              _showNotification(
                _isFavorite ? 'Đã lưu album vào Thư viện yêu thích' : 'Đã xóa album khỏi Thư viện',
              );
            },
            onShare: () => _showNotification('Đã sao chép liên kết album: music4://album/${widget.albumId ?? "1"}'),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Danh sách bài hát (${_tracks.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._tracks.asMap().entries.map(
            (entry) => AlbumDetailTrackTile(
              trackNumber: entry.key + 1,
              title: entry.value['title']!,
              artist: entry.value['artist']!,
              duration: entry.value['duration']!,
              onTap: () => context.push('/player'),
              onMorePressed: () => _showTrackOptions(entry.value),
            ),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Column(
              children: [
                Text(
                  '© 2024 M-TP Entertainment',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'Phát hành trên nền tảng Music4 Streaming',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
