import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class TrackActionBar extends StatelessWidget {
  final bool isLiked;
  final int rating;
  final VoidCallback onLikeToggle;
  final VoidCallback onAddToPlaylist;
  final VoidCallback onShare;
  final ValueChanged<int> onRatingChanged;

  const TrackActionBar({
    super.key,
    required this.isLiked,
    required this.rating,
    required this.onLikeToggle,
    required this.onAddToPlaylist,
    required this.onShare,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? AppColors.error : AppColors.textPrimary,
                size: 28,
              ),
              tooltip: isLiked ? 'Bỏ thích' : 'Yêu thích',
              onPressed: () {
                HapticFeedback.lightImpact();
                onLikeToggle();
              },
            ),
            IconButton(
              icon: const Icon(Icons.playlist_add, color: AppColors.textPrimary, size: 28),
              tooltip: 'Thêm vào playlist',
              onPressed: () {
                HapticFeedback.lightImpact();
                onAddToPlaylist();
              },
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary, size: 26),
              tooltip: 'Chia sẻ',
              onPressed: () {
                HapticFeedback.lightImpact();
                onShare();
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Đánh giá: ', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ...List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onRatingChanged(index + 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Icon(
                    index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: index < rating ? AppColors.warning : AppColors.textMuted,
                    size: 24,
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
