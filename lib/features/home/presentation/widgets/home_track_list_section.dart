import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/home_track_item.dart';
import 'trending_track_tile.dart';

/// A titled, full-width vertical list of tracks (used by the "Gợi ý" tab). The
/// whole list is queued in the Player, starting at the tapped track.
class HomeTrackListSection extends StatelessWidget {
  final String title;
  final List<HomeTrackItem> tracks;

  const HomeTrackListSection({
    super.key,
    required this.title,
    required this.tracks,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        for (var i = 0; i < tracks.length; i++)
          TrendingTrackTile(
            rank: i + 1,
            track: tracks[i],
            playlist: tracks,
            initialIndex: i,
          ),
      ],
    );
  }
}
