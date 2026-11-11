import 'package:flutter/material.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/admin_artist_model.dart';

class AdminArtistTile extends StatelessWidget {
  final AdminArtistModel artist;
  final bool isSelf;
  final VoidCallback onToggleStatus;

  const AdminArtistTile({
    super.key,
    required this.artist,
    required this.isSelf,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = artist.isDeleted;
    final avatarUrl = ApiEndpoints.buildImageUrl(artist.img);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: AppColors.surface,
          backgroundImage:
              avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
          child: avatarUrl.isEmpty
              ? Text(
                  artist.name.isNotEmpty
                      ? artist.name[0].toUpperCase()
                      : (artist.userName?.isNotEmpty == true
                          ? artist.userName![0].toUpperCase()
                          : 'A'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                )
              : null,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                artist.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: isLocked ? AppColors.textMuted : AppColors.textPrimary,
                  decoration: isLocked ? TextDecoration.lineThrough : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            if (isSelf) _buildPill('(Bạn)', AppColors.primary),
            const SizedBox(width: 4),
            _buildPill('ARTIST', AppColors.primary),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      artist.email ?? artist.userName ?? '@${artist.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusIndicator(isLocked),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${artist.trackTotal} bài hát • ${artist.albumTotal} album',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        trailing: isSelf
            ? const Tooltip(
                message: 'Tài khoản của bạn',
                child: Icon(Icons.verified_user, color: AppColors.primary, size: 22),
              )
            : IconButton(
                icon: Icon(
                  isLocked ? Icons.lock_open_outlined : Icons.lock_outline,
                  color: isLocked ? AppColors.primary : AppColors.error,
                  size: 22,
                ),
                tooltip:
                    isLocked ? 'Mở khóa nghệ sĩ' : 'Vô hiệu hóa nghệ sĩ',
                onPressed: onToggleStatus,
              ),
      ),
    );
  }

  Widget _buildPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildStatusIndicator(bool isLocked) {
    final color = isLocked ? AppColors.error : AppColors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          isLocked ? 'Đã khóa' : 'Hoạt động',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
