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

class AiRecommendationCard extends ConsumerWidget {
  final HomeTrackItem track;

  const AiRecommendationCard({super.key, required this.track});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          HapticFeedback.lightImpact();
          
          final homeState = ref.read(homeFeedControllerProvider).value;
          if (homeState != null) {
            final playlist = homeState.aiRecommendations.map((t) => TrackQueueItem(
              id: t.id,
              title: t.title,
              artist: t.artist,
              coverUrl: t.coverUrl,
              duration: Duration(seconds: t.durationSeconds),
            )).toList();
            
            final initialIndex = playlist.indexWhere((t) => t.id == track.id);
            if (initialIndex != -1) {
              ref.read(playerNotifierProvider.notifier).playPlaylist(playlist, initialIndex);
            }
          }
          
          ref.read(homeFeedControllerProvider.notifier).trackPlay(track.id);
          context.push(RouteNames.player);
        },
        child: Container(
          width: 136,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 110,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: track.coverUrl != null && track.coverUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: CachedNetworkImage(
                          imageUrl: track.coverUrl!,
                          width: double.infinity,
                          height: 110,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.surface,
                            child: const Center(
                              child: Icon(Icons.music_note, color: AppColors.primary, size: 40),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.surface,
                            child: const Center(
                              child: Icon(Icons.music_note, color: AppColors.primary, size: 40),
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.music_note, color: AppColors.primary, size: 40),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      track.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
