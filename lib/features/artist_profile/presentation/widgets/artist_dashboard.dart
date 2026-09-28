import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/artist_profile_data.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArtistDashboard extends StatelessWidget {
  final ArtistDashboardStats stats;

  const ArtistDashboard({super.key, required this.stats});

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.lightBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tổng quan dữ liệu của bạn',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Theo dõi hiệu suất các sản phẩm của bạn trên hệ thống.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: 16),
          
          // KPIs Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8, // Adjust for 360dp fitting
            children: [
              DashboardStatCard(
                title: 'Lượt nghe',
                value: _formatNumber(stats.totalViews),
                icon: Icons.headphones,
                color: Colors.lightBlue,
              ),
              DashboardStatCard(
                title: 'Lượt thích',
                value: _formatNumber(stats.totalLikes),
                icon: Icons.favorite,
                color: Colors.pinkAccent,
              ),
              DashboardStatCard(
                title: 'Người theo dõi',
                value: _formatNumber(stats.totalFollowers),
                icon: Icons.people,
                color: Colors.amber,
              ),
              DashboardStatCard(
                title: 'Bình luận',
                value: _formatNumber(stats.totalComments),
                icon: Icons.comment,
                color: Colors.greenAccent,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Chart Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lượt tương tác',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '7 ngày gần nhất',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textMuted,
                              ),
                        ),
                      ],
                    ),
                    // Mock Period Selector
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPeriodTab('7N', true),
                        const SizedBox(width: 4),
                        _buildPeriodTab('14N', false),
                        const SizedBox(width: 4),
                        _buildPeriodTab('30N', false),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                
                // Mock Chart representation (Bar Chart via Containers)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(stats.chartViews.length, (index) {
                    final maxValue = stats.chartViews.reduce((curr, next) => curr > next ? curr : next);
                    final value = stats.chartViews[index];
                    final heightRatio = value / (maxValue > 0 ? maxValue : 1);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 24,
                          height: 120 * heightRatio, // Max height 120
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.withValues(alpha: 0.8),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'T${index + 2}', // Mock labels T2, T3...
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                        )
                      ],
                    );
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPeriodTab(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.lightBlue.withValues(alpha: 0.15) : Colors.transparent,
        border: Border.all(
          color: isSelected ? Colors.lightBlue.withValues(alpha: 0.3) : AppColors.textMuted.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: isSelected ? Colors.lightBlue : AppColors.textMuted,
        ),
      ),
    );
  }
}
