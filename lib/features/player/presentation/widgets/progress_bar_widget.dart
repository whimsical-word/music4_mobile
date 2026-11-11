import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProgressBarWidget extends StatefulWidget {
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
  State<ProgressBarWidget> createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    // Đảm bảo maxValue luôn hợp lệ
    final safeMax = widget.maxValue > 0 ? widget.maxValue : 1.0;
    
    // Nếu đang kéo (_dragValue != null) thì dùng giá trị kéo, ngược lại dùng giá trị từ Stream
    double displayValue = _dragValue ?? widget.currentValue;
    final safeCurrent = displayValue.clamp(0.0, safeMax);

    // Tính toán lại text hiển thị thời gian khi đang kéo để UI cập nhật tức thì
    String displayPositionText = widget.positionText;
    if (_dragValue != null) {
      final positionDuration = Duration(seconds: _dragValue!.toInt());
      final min = positionDuration.inMinutes;
      final sec = (positionDuration.inSeconds % 60).toString().padLeft(2, '0');
      displayPositionText = '$min:$sec';
    }

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
            onChanged: (val) {
              // Cập nhật giao diện nội bộ khi đang kéo Slider
              setState(() {
                _dragValue = val;
              });
            },
            onChangeEnd: (val) {
              // Chỉ gọi hàm seek thật (Gửi xuống Riverpod) khi người dùng thả tay
              widget.onChanged(val);
              setState(() {
                _dragValue = null;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayPositionText,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              Text(
                widget.durationText,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
