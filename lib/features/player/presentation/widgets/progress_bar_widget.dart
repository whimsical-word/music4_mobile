import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProgressBarWidget extends StatelessWidget {
  final double currentValue;
  final ValueChanged<double> onChanged;

  const ProgressBarWidget({
    super.key,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: currentValue,
            max: 200,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.divider,
            onChanged: onChanged,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0:30', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              Text('3:20', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
