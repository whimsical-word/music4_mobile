import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class HomeEmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const HomeEmptyState({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.music_off_outlined,
                color: AppColors.textMuted,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có bài hát nào',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy thử làm mới hoặc khám phá thêm bài hát trong danh mục.',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                onRefresh();
              },
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Làm mới'),
            ),
          ],
        ),
      ),
    );
  }
}
