import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class AlbumDetailTrackTile extends StatelessWidget {
  final int trackNumber;
  final String title;
  final String artist;
  final String duration;
  final VoidCallback onTap;
  final VoidCallback onMorePressed;

  const AlbumDetailTrackTile({
    super.key,
    required this.trackNumber,
    required this.title,
    required this.artist,
    required this.duration,
    required this.onTap,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      leading: SizedBox(
        width: 32,
        child: Center(
          child: Text(
            '$trackNumber',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        '$artist • $duration',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
        onPressed: () {
          HapticFeedback.lightImpact();
          onMorePressed();
        },
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }
}
