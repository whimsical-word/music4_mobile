import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/artist_profile_data.dart';
import '../../domain/models/dashboard_period.dart';
import '../utils/count_format.dart';

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

class ArtistDashboard extends StatefulWidget {
  final ArtistDashboardStats stats;

  /// The last day of the chart window; defaults to the device date.
  final DateTime? today;

  const ArtistDashboard({super.key, required this.stats, this.today});

  @override
  State<ArtistDashboard> createState() => _ArtistDashboardState();
}

class _ArtistDashboardState extends State<ArtistDashboard> {
  static const double _chartHeight = 120;

  DashboardPeriod _period = DashboardPeriod.week;

  @override
  Widget build(BuildContext context) {
    final stats = widget.stats;
    final view = buildPeriodView(
      stats.daily,
      _period,
      today: widget.today ?? DateTime.now(),
    );

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

          // KPIs grid. padding: zero, otherwise the grid adds the status-bar /
          // app-bar inset above itself and leaves a blank gap.
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8, // Adjust for 360dp fitting
            children: [
              DashboardStatCard(
                title: 'Lượt nghe',
                value: formatCount(stats.totalViews),
                icon: Icons.headphones,
                color: Colors.lightBlue,
              ),
              DashboardStatCard(
                title: 'Lượt thích',
                value: formatCount(stats.totalLikes),
                icon: Icons.favorite,
                color: Colors.pinkAccent,
              ),
              DashboardStatCard(
                title: 'Người theo dõi',
                value: formatCount(stats.totalFollowers),
                icon: Icons.people,
                color: Colors.amber,
              ),
              DashboardStatCard(
                title: 'Bình luận',
                value: formatCount(stats.totalComments),
                icon: Icons.comment,
                color: Colors.greenAccent,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Chart section
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
                          'Lượt nghe',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_period.days} ngày gần nhất',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textMuted,
                              ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final period in DashboardPeriod.values) ...[
                          if (period != DashboardPeriod.values.first)
                            const SizedBox(width: 4),
                          _buildPeriodTab(period),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSummary(context, view),
                const SizedBox(height: 16),
                if (view.hasActivity)
                  _buildBars(view)
                else
                  SizedBox(
                    height: _chartHeight,
                    child: Center(
                      child: Text(
                        'Chưa có lượt nghe trong ${_period.days} ngày qua.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// "420 lượt nghe" plus how it compares with the previous window.
  Widget _buildSummary(BuildContext context, DashboardPeriodView view) {
    final textTheme = Theme.of(context).textTheme;
    final chip = _buildGrowthChip(view);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        Text(
          '${formatCount(view.totalViews)} lượt nghe',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (chip != null) ...[
          chip,
          Text(
            'so với ${view.period.days} ngày trước',
            style: textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ],
    );
  }

  /// ▲ 25% / ▼ 10% / "Mới". Null when there is nothing to compare with
  /// (30N has no earlier 30-day window in the data the backend returns).
  Widget? _buildGrowthChip(DashboardPeriodView view) {
    if (view.isNewActivity) {
      return _chip(Icons.arrow_upward, 'Mới', Colors.greenAccent);
    }

    final growth = view.growthPercent;
    if (growth == null) return null;

    final percent = '${growth.abs().toStringAsFixed(0)}%';
    if (growth > 0) return _chip(Icons.arrow_upward, percent, Colors.greenAccent);
    if (growth < 0) return _chip(Icons.arrow_downward, percent, Colors.redAccent);
    return _chip(Icons.remove, percent, AppColors.textMuted);
  }

  Widget _chip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBars(DashboardPeriodView view) {
    final maxViews = view.points.fold<int>(0, (m, p) => math.max(m, p.views));
    final count = view.points.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < count; i++)
          // Expanded: every day gets an equal slot, so 7, 14 or 30 columns
          // always fit the width (also at 360dp / large text scale).
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Container(
                    height: view.points[i].views == 0
                        ? 2
                        : math.max(4, _chartHeight * view.points[i].views / maxViews),
                    decoration: BoxDecoration(
                      color: view.points[i].views == 0
                          ? AppColors.textMuted.withValues(alpha: 0.3)
                          : Colors.lightBlue.withValues(alpha: 0.8),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 14,
                  child: _showLabel(i, count)
                      ? OverflowBox(
                          maxWidth: 48,
                          child: Text(
                            _dayLabel(view.points[i].date),
                            maxLines: 1,
                            softWrap: false,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Counted from the newest day, so today is always labelled and a long
  /// range does not print 30 labels.
  bool _showLabel(int index, int count) {
    if (count <= 7) return true;
    final step = count <= 14 ? 2 : 5;
    return (count - 1 - index) % step == 0;
  }

  String _dayLabel(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}';
  }

  Widget _buildPeriodTab(DashboardPeriod period) {
    final isSelected = period == _period;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => _period = period),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlue.withValues(alpha: 0.15) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.lightBlue.withValues(alpha: 0.3) : AppColors.textMuted.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          period.label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.lightBlue : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
