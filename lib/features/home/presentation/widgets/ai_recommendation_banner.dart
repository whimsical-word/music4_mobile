import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/home_track_item.dart';
import '../controllers/home_feed_controller.dart';
import '../../../player/presentation/providers/player_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../player/domain/models/player_state_data.dart';

class AiRecommendationBanner extends ConsumerWidget {
  final HomeTrackItem? track;
  final List<HomeTrackItem> playlist;

  const AiRecommendationBanner({
    super.key,
    this.track,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (track == null) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HapticFeedback.lightImpact();
            
            final queue = playlist.map((t) => TrackQueueItem(
              id: t.id,
              title: t.title,
              artist: t.artist,
              coverUrl: t.coverUrl,
              duration: Duration(seconds: t.durationSeconds),
            )).toList();
            
            final initialIndex = queue.indexWhere((t) => t.id == track!.id);
            if (initialIndex != -1) {
              ref.read(playerNotifierProvider.notifier).playPlaylist(queue, initialIndex);
            }
            
            ref.read(homeFeedControllerProvider.notifier).trackPlay(track!.id);
            context.push(RouteNames.player);
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: track!.coverUrl != null && track!.coverUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: track!.coverUrl!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.surface,
                              child: const Center(
                                child: Icon(Icons.album, color: AppColors.textSecondary, size: 28),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.surface,
                              child: const Center(
                                child: Icon(Icons.album, color: AppColors.textSecondary, size: 28),
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.album, color: AppColors.textSecondary, size: 28),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        track!.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        track!.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.surface,
                  child: const Icon(
                    Icons.play_arrow,
                    color: AppColors.textPrimary,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
