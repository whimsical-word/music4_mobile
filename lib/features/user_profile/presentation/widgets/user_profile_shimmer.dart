import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';

class UserProfileShimmer extends StatelessWidget {
  const UserProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.card,
      highlightColor: AppColors.surface,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Header gradient placeholder
            Container(height: 160, width: double.infinity, color: Colors.white),
            // Avatar
            Transform.translate(
              offset: const Offset(0, -50),
              child: CircleAvatar(
                radius: 52,
                backgroundColor: AppColors.background,
                child: CircleAvatar(radius: 48, backgroundColor: Colors.white),
              ),
            ),
            // Name & email
            const SizedBox(height: 0),
            Container(height: 22, width: 160, color: Colors.white),
            const SizedBox(height: 8),
            Container(height: 14, width: 200, color: Colors.white),
            const SizedBox(height: 12),
            Container(height: 14, width: 240, color: Colors.white),
            const SizedBox(height: 24),
            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  3,
                  (_) => Column(
                    children: [
                      Container(height: 22, width: 48, color: Colors.white),
                      const SizedBox(height: 4),
                      Container(height: 12, width: 64, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // List tiles
            ...List.generate(
              4,
              (_) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 16, color: Colors.white),
                          const SizedBox(height: 6),
                          Container(
                            height: 12,
                            width: 120,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
