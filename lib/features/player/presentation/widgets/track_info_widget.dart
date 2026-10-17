import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class TrackInfoWidget extends StatelessWidget {
  final String title;
  final String artist;
  final bool isLiked;
  final bool isOfflineCached;
  final bool isPreview;
  final VoidCallback onFavoriteTap;

  const TrackInfoWidget({
    super.key,
    required this.title,
    required this.artist,
    required this.isLiked,
    this.isOfflineCached = false,
    this.isPreview = false,
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
              Row(
                children: [
                  Flexible(
                    child: Text(
                      artist,
                      style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isPreview) ...[
                    const SizedBox(width: 8),
                    Container(
                      key: const Key('preview_30s_badge'),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.amber, width: 0.8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer_outlined, size: 12, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            'Preview 30s',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (isOfflineCached) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.primary, width: 0.8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi_off_rounded, size: 12, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text(
                            'Offline',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
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
