import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/artist_album.dart';

class ArtistAlbumItem extends StatelessWidget {
  final ArtistAlbum album;
  final VoidCallback onTap;

  const ArtistAlbumItem({super.key, required this.album, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Container(
          width: 48,
          height: 48,
          color: AppColors.surface,
          child: album.coverUrl == null
              ? const Icon(Icons.album, color: AppColors.textMuted)
              : Image.network(
                  album.coverUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.album,
                    color: AppColors.textMuted,
                  ),
                ),
        ),
      ),
      title: Text(
        album.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${album.trackCount} bài hát',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
    );
  }
}
