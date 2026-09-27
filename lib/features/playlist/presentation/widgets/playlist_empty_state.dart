import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class PlaylistEmptyState extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const PlaylistEmptyState({super.key, required this.onCreatePressed});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.card,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider, width: 1.5),
              ),
              child: const Icon(
                Icons.queue_music_rounded,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Chưa có playlist nào',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tạo danh sách phát đầu tiên để lưu lại những bản nhạc bạn yêu thích.',
              style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                onCreatePressed();
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Tạo Playlist'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
