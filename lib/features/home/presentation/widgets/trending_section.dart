import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/home_track_item.dart';
import 'trending_track_tile.dart';

class TrendingSection extends StatelessWidget {
  final List<HomeTrackItem> tracks;

  const TrendingSection({super.key, required this.tracks});

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Thịnh hành',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            return TrendingTrackTile(
              rank: index + 1,
              track: tracks[index],
            );
          },
        ),
      ],
    );
  }
}
