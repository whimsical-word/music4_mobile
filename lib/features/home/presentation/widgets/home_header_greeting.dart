import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/home_filter.dart';

class HomeHeaderGreeting extends ConsumerWidget {
  const HomeHeaderGreeting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final selected = ref.watch(homeFilterProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chào bạn,',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hôm nay bạn muốn nghe gì?',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  context,
                  ref,
                  'Tất cả',
                  filter: HomeFilter.all,
                  selected: selected,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  ref,
                  'Gợi ý',
                  filter: HomeFilter.recommended,
                  selected: selected,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  ref,
                  'Thịnh hành',
                  filter: HomeFilter.trending,
                  selected: selected,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  context,
                  ref,
                  'Album nổi bật',
                  filter: HomeFilter.albums,
                  selected: selected,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref,
    String label, {
    required HomeFilter filter,
    required HomeFilter selected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = filter == selected;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(homeFilterProvider.notifier).state = filter;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
