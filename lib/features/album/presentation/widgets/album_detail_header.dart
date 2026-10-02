import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class AlbumDetailHeader extends StatelessWidget {
  final String title, artist, metadata, imageUrl;
  final bool isFavorite;
  final VoidCallback onPlay, onShuffle, onToggleFavorite, onShare;

  const AlbumDetailHeader({
    super.key, required this.title, required this.artist, required this.metadata,
    required this.imageUrl, required this.isFavorite, required this.onPlay,
    required this.onShuffle, required this.onToggleFavorite, required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 8))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.surface,
                child: const Icon(Icons.album, size: 80, color: AppColors.primary),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Text(artist, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary), textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text(metadata, style: const TextStyle(fontSize: 13, color: AppColors.textMuted), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: () { HapticFeedback.lightImpact(); onPlay(); },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Phát'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black, shape: const StadiumBorder()),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () { HapticFeedback.lightImpact(); onShuffle(); },
              icon: const Icon(Icons.shuffle, size: 18),
              label: const Text('Trộn'),
              style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: () { HapticFeedback.lightImpact(); onToggleFavorite(); },
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.redAccent : AppColors.textPrimary),
              tooltip: 'Yêu thích album',
            ),
            IconButton(
              onPressed: () { HapticFeedback.lightImpact(); onShare(); },
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Chia sẻ album',
            ),
          ],
        ),
      ],
    );
  }
}
