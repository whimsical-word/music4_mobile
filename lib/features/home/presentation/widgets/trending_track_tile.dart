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

class TrendingTrackTile extends ConsumerWidget {
  final int rank;
  final HomeTrackItem track;

  const TrendingTrackTile({
    super.key,
    required this.rank,
    required this.track,
  });

  void _onPlay(BuildContext context, WidgetRef ref) {
    HapticFeedback.lightImpact();
    ref.read(playerNotifierProvider.notifier).playTrack(
      trackId: track.id,
      title: track.title,
      artist: track.artist,
      coverUrl: track.coverUrl,
    );
    ref.read(homeFeedControllerProvider.notifier).trackPlay(track.id);
    context.push(RouteNames.player);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final isTop3 = rank <= 3;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _onPlay(context, ref),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isTop3 ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: track.coverUrl != null && track.coverUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: track.coverUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.surface,
                            child: const Center(
                              child: Icon(Icons.music_note, color: AppColors.primary, size: 24),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.surface,
                            child: const Center(
                              child: Icon(Icons.music_note, color: AppColors.primary, size: 24),
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.music_note, color: AppColors.primary, size: 24),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      track.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${track.artist}${track.playsCount != null ? ' • ${track.playsCount} lượt nghe' : ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 28),
                onPressed: () => _onPlay(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
