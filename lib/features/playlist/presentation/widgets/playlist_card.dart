import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

class PlaylistCard extends StatelessWidget {
  final String id;
  final String title;
  final int trackCount;
  final String? coverUrl;
  final IconData icon;
  final bool isGrid;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const PlaylistCard({
    super.key,
    required this.id,
    required this.title,
    required this.trackCount,
    this.coverUrl,
    this.icon = Icons.queue_music_rounded,
    this.isGrid = false,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return _buildGridItem(context);
    }
    return _buildListItem(context);
  }

  /// YouTube Music style List Tile (Gọn gàng, thanh lịch)
  Widget _buildListItem(BuildContext context) {
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
              // Thumbnail 52x52 vuông bo góc kiểu YouTube Music
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.divider.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Center(
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),
              ),
              const SizedBox(width: 14),
              // Thông tin playlist
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
                    const SizedBox(height: 3),
                    Text(
                      trackCount > 0
                          ? 'Danh sách phát • Bạn • $trackCount bài hát'
                          : 'Danh sách phát • Bạn',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Nút 3 chấm tùy chọn
              _buildMoreMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  /// YouTube Music style Compact Grid Item (Lưới 2 cột cân đối)
  Widget _buildGridItem(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh vuông 1:1
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.divider.withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Center(
                  child: Icon(icon, color: AppColors.primary, size: 36),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        trackCount > 0
                            ? 'Playlist • $trackCount bài'
                            : 'Playlist • Bạn',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildMoreMenu(context, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreMenu(BuildContext context, {double size = 20}) {
    if (onDelete == null) return const SizedBox.shrink();

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, size: size, color: AppColors.textSecondary),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) {
        HapticFeedback.lightImpact();
        if (value == 'delete') onDelete?.call();
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: AppColors.error, size: 18),
              SizedBox(width: 8),
              Text(
                'Xóa',
                style: TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
