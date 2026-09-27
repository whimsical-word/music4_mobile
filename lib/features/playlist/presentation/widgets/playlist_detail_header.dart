import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class PlaylistDetailHeader extends StatelessWidget {
  final String title;
  final int trackCount;
  final VoidCallback onPlayAll;
  final VoidCallback onShuffle;
  final VoidCallback onAddTrack;
  final VoidCallback onShare;

  const PlaylistDetailHeader({
    super.key,
    required this.title,
    required this.trackCount,
    required this.onPlayAll,
    required this.onShuffle,
    required this.onAddTrack,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 8)),
              ],
            ),
            child: const Center(
              child: Icon(Icons.queue_music_rounded, size: 72, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'Danh sách phát • Bạn • $trackCount bài hát',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onPlayAll();
                },
                icon: const Icon(Icons.play_arrow, color: Colors.black),
                label: const Text('Phát', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onShuffle();
                },
                icon: const Icon(Icons.shuffle, size: 18),
                label: const Text('Trộn bài'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                icon: const Icon(Icons.add, size: 20),
                tooltip: 'Thêm bài hát',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onAddTrack();
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 20),
                tooltip: 'Chia sẻ',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onShare();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
