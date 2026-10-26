import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';

class AdminShimmerSkeleton extends StatelessWidget {
  const AdminShimmerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 8,
      separatorBuilder: (_, index) => const SizedBox(height: 10),
      itemBuilder: (_, index) => Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.card,
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
