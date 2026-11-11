import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';

class PlaylistDetailHeader extends StatelessWidget {
  final String title;
  final String? description;
  final String? coverUrl;
  final int trackCount;
  final VoidCallback onPlayAll, onShuffle, onAddTrack, onShare;
  final VoidCallback? onEdit;

  const PlaylistDetailHeader({
    super.key,
    required this.title,
    this.description,
    this.coverUrl,
    required this.trackCount,
    required this.onPlayAll,
    required this.onShuffle,
    required this.onAddTrack,
    required this.onShare,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedCover = ImageUrlHelper.resolve(coverUrl);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: onEdit != null
                    ? () {
                        HapticFeedback.lightImpact();
                        onEdit!();
                      }
                    : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: resolvedCover != null && resolvedCover.isNotEmpty
                        ? Image.network(
                            resolvedCover,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(
                                Icons.queue_music_rounded,
                                size: 72,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.queue_music_rounded,
                              size: 72,
                              color: AppColors.primary,
                            ),
                          ),
                  ),
                ),
              ),
              if (onEdit != null)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onEdit!();
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          if (description != null && description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              description!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
            ),
          ],
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
                onPressed: () { HapticFeedback.lightImpact(); onPlayAll(); },
                icon: const Icon(Icons.play_arrow, color: Colors.black),
                label: const Text('Phát', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), shape: const StadiumBorder()),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () { HapticFeedback.lightImpact(); onShuffle(); },
                icon: const Icon(Icons.shuffle, size: 18),
                label: const Text('Trộn bài'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.textPrimary, side: const BorderSide(color: AppColors.divider), shape: const StadiumBorder()),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                icon: const Icon(Icons.add, size: 20),
                tooltip: 'Thêm bài hát',
                onPressed: () { HapticFeedback.lightImpact(); onAddTrack(); },
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 20),
                tooltip: 'Chia sẻ',
                onPressed: () { HapticFeedback.lightImpact(); onShare(); },
              ),
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Chỉnh sửa playlist',
                  onPressed: () { HapticFeedback.lightImpact(); onEdit!(); },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
