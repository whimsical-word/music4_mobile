import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class TrackInfoWidget extends StatelessWidget {
  final String title;
  final String artist;
  final bool isLiked;
  final VoidCallback onFavoriteTap;

  const TrackInfoWidget({
    super.key,
    required this.title,
    required this.artist,
    required this.isLiked,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), maxLines: 1),
              const SizedBox(height: 8),
              Text(artist, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary), maxLines: 1),
            ],
          ),
        ),
        IconButton(
          icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
          color: isLiked ? AppColors.primary : Colors.white,
          onPressed: () {
            HapticFeedback.lightImpact();
            onFavoriteTap();
          },
        ),
      ],
    );
  }
}
