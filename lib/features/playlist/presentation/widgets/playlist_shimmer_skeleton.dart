import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';

class PlaylistShimmerSkeleton extends StatelessWidget {
  const PlaylistShimmerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF282828),
      highlightColor: const Color(0xFF3E3E3E),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
