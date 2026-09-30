import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class UploadProgressWidget extends StatelessWidget {
  final double progress;
  const UploadProgressWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Đang đẩy 2 files lên AWS S3...', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress, 
          backgroundColor: AppColors.divider, 
          color: AppColors.primary, 
          minHeight: 8, 
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        Text(
          '${(progress * 100).toInt()}%', 
          textAlign: TextAlign.right, 
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
