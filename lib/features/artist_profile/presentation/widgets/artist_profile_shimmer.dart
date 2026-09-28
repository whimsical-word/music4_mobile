import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';

class ArtistProfileShimmer extends StatelessWidget {
  const ArtistProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.card,
      highlightColor: AppColors.surface,
      child: Column(
        children: [
          // Cover & Avatar Placeholder
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 160,
                width: double.infinity,
                color: Colors.white,
              ),
              Positioned(
                bottom: -50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.background,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          
          // Info Placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(height: 24, width: 150, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 16, width: 100, color: Colors.white),
                const SizedBox(height: 16),
                Container(height: 14, width: double.infinity, color: Colors.white),
                const SizedBox(height: 4),
                Container(height: 14, width: 200, color: Colors.white),
                const SizedBox(height: 24),
                Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          // Tracks Placeholder
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  title: Container(height: 16, width: double.infinity, color: Colors.white),
                  subtitle: Container(height: 14, width: 150, color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
