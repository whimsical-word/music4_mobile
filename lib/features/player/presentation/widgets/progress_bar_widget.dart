import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProgressBarWidget extends StatelessWidget {
  final double currentValue;
  final double maxValue;
  final String positionText;
  final String durationText;
  final ValueChanged<double> onChanged;

  const ProgressBarWidget({
    super.key,
    required this.currentValue,
    required this.maxValue,
    required this.positionText,
    required this.durationText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure currentValue is not greater than maxValue and maxValue > 0
    final safeMax = maxValue > 0 ? maxValue : 1.0;
    final safeCurrent = currentValue.clamp(0.0, safeMax);

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: safeCurrent,
            max: safeMax,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.divider,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                positionText,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              Text(
                durationText,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
