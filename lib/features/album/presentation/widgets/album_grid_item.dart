import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/album_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/album_provider.dart';

class AlbumGridItem extends ConsumerWidget {
  final AlbumModel album;

  const AlbumGridItem({super.key, required this.album});

  void _handleDeleteAlbum(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Xóa Album'),
        content: Text('Bạn có chắc chắn muốn xóa "${album.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('HỦY', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(albumNotifierProvider.notifier).deleteAlbum(album.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('XÓA', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // Navigate to details
      },
      child: Container(
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      image: DecorationImage(
                        image: NetworkImage(album.coverUrl ?? 'https://picsum.photos/300'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(album.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('${album.trackCount} bài hát', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8, right: 8,
              child: GestureDetector(
                onTap: () => _handleDeleteAlbum(context, ref),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), shape: BoxShape.circle),
                  child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
