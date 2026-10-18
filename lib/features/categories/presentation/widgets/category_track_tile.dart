import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/category_detail_model.dart';

class CategoryTrackTile extends StatelessWidget {
  final CategoryTrackModel track;
  final int index;
  final VoidCallback onTap;
  final VoidCallback? onMorePressed;

  const CategoryTrackTile({
    super.key,
    required this.track,
    required this.index,
    required this.onTap,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    final artistNames = track.artists.isNotEmpty
        ? track.artists.map((a) => a.name).join(', ')
        : 'Nhiều nghệ sĩ';

    final durationSec = track.duration ?? 0;
    final minutes = durationSec ~/ 60;
    final seconds = (durationSec % 60).toString().padLeft(2, '0');
    final formattedDuration = '$minutes:$seconds';

    final imgUrl = ApiEndpoints.buildImageUrl(track.img);

    return ListTile(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: SizedBox(
        width: 60,
        child: Row(
          children: [
            SizedBox(
              width: 18,
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 34,
                height: 34,
                child: imgUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
          ],
        ),
      ),
      title: Text(
        track.name,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '$artistNames • $formattedDuration',
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: onMorePressed != null
          ? IconButton(
              icon: const Icon(Icons.more_vert, color: AppColors.textMuted, size: 20),
              onPressed: () {
                HapticFeedback.lightImpact();
                onMorePressed!();
              },
            )
          : null,
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.card,
      child: const Icon(Icons.music_note, color: AppColors.primary, size: 20),
    );
  }
}
