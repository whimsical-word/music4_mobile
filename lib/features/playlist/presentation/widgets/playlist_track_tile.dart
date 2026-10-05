import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class PlaylistTrackTile extends StatelessWidget {
  final int index;
  final String title;
  final String artist;
  final String duration;
  final String? imageUrl;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const PlaylistTrackTile({
    super.key,
    required this.index,
    required this.title,
    required this.artist,
    required this.duration,
    this.imageUrl,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: 48,
                  height: 48,
                  color: AppColors.surface,
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(
                              Icons.music_note,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.music_note,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$artist • $duration',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: AppColors.textMuted, size: 20),
                tooltip: 'Xóa khỏi playlist',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onRemove();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
