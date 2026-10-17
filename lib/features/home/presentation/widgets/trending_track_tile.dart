import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/home_track_item.dart';
import '../../../player/presentation/providers/player_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../artist_profile/presentation/widgets/artist_name_link.dart';
import '../../../player/domain/models/player_state_data.dart';

class TrendingTrackTile extends ConsumerWidget {
  final int rank;
  final HomeTrackItem track;
  final List<HomeTrackItem> playlist;
  final int initialIndex;

  const TrendingTrackTile({
    super.key,
    required this.rank,
    required this.track,
    required this.playlist,
    required this.initialIndex,
  });

  void _onPlay(BuildContext context, WidgetRef ref) {
    HapticFeedback.lightImpact();
    
    final queue = playlist.map((t) => TrackQueueItem(
      id: t.id,
      title: t.title,
      artist: t.artist,
      coverUrl: t.coverUrl,
      duration: Duration(seconds: t.durationSeconds),
    )).toList();
    
    ref.read(playerNotifierProvider.notifier).playPlaylist(queue, initialIndex);
    
    context.push(RouteNames.player);
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Vàng Gold
      case 2:
        return const Color(0xFFC0C0C0); // Bạc Silver
      case 3:
        return const Color(0xFFCD7F32); // Đồng Bronze
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

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
                    color: _rankColor(rank),
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
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ArtistNameLink(
                          text: track.artist,
                          artistId: track.artistId,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        if (track.playsCount != null) ...[
                          Text(
                            ' • ${track.playsCount} lượt nghe',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.play_circle_fill, color: AppColors.primary, size: 28),
                    tooltip: 'Phát bài hát',
                    onPressed: () => _onPlay(context, ref),
                  ),
                  PopupMenuButton<String>(
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    tooltip: 'Tùy chọn',
                    onSelected: (action) {
                      if (action == 'detail') {
                        context.push('/track/${track.id}');
                      } else if (action == 'artist' && track.artistId != null) {
                        context.push('/artist/${track.artistId}');
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'detail',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline, size: 18, color: AppColors.primary),
                            SizedBox(width: 8),
                            Flexible(child: Text('Chi tiết bài hát')),
                          ],
                        ),
                      ),
                      if (track.artistId != null)
                        const PopupMenuItem(
                          value: 'artist',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person_outline, size: 18, color: AppColors.secondary),
                              SizedBox(width: 8),
                              Flexible(child: Text('Trang nghệ sĩ')),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
