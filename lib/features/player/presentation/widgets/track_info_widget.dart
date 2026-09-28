import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class TrackInfoWidget extends StatelessWidget {
  const TrackInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tên bài hát mẫu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), maxLines: 1),
              SizedBox(height: 8),
              Text('Tên Ca Sĩ / Nghệ sĩ', style: TextStyle(fontSize: 16, color: AppColors.textSecondary), maxLines: 1),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          color: AppColors.primary,
          onPressed: () => HapticFeedback.lightImpact(),
        ),
      ],
    );
  }
}
