import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/home_track_item.dart';
import 'trending_track_tile.dart';

class TrendingSection extends StatelessWidget {
  final List<HomeTrackItem> tracks;

  /// Tapping the header (with its ">") opens just this section. Null hides the
  /// ">" (the feed is already filtered to this section).
  final VoidCallback? onSeeAll;

  const TrendingSection({super.key, required this.tracks, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) return const SizedBox.shrink();

    final topTracks = tracks.length > 5 ? tracks.take(5).toList() : tracks;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onSeeAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Thịnh hành',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: 13,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 2),
                            Text(
                              'Top 5',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (onSeeAll != null) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topTracks.length,
          itemBuilder: (context, index) {
            return TrendingTrackTile(
              rank: index + 1,
              track: topTracks[index],
              playlist: topTracks,
              initialIndex: index,
            );
          },
        ),
      ],
    );
  }
}
