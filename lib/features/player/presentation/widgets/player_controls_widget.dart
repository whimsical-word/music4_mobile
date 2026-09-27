import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class PlayerControlsWidget extends StatelessWidget {
  final bool isPlaying;
  final bool isShuffle;
  final bool isRepeat;
  final VoidCallback onPlayPause;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;

  const PlayerControlsWidget({
    super.key,
    required this.isPlaying,
    required this.isShuffle,
    required this.isRepeat,
    required this.onPlayPause,
    required this.onShuffle,
    required this.onRepeat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.shuffle, color: isShuffle ? AppColors.primary : Colors.white),
          onPressed: onShuffle,
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous, size: 36),
          onPressed: () {
            HapticFeedback.lightImpact();
          },
        ),
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.primary,
          child: IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 36, color: Colors.black),
            onPressed: onPlayPause,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.skip_next, size: 36),
          onPressed: () {
            HapticFeedback.lightImpact();
          },
        ),
        IconButton(
          icon: Icon(Icons.repeat, color: isRepeat ? AppColors.primary : Colors.white),
          onPressed: onRepeat,
        ),
      ],
    );
  }
}
