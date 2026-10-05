import '../../domain/models/player_state_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class PlayerControlsWidget extends StatelessWidget {
  final bool isPlaying;
  final bool isShuffle;
  final RepeatState repeatMode;
  final bool hasNext;
  final bool hasPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const PlayerControlsWidget({
    super.key,
    required this.isPlaying,
    required this.isShuffle,
    required this.repeatMode,
    required this.hasNext,
    required this.hasPrevious,
    required this.onPlayPause,
    required this.onShuffle,
    required this.onRepeat,
    required this.onNext,
    required this.onPrevious,
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
          icon: Icon(Icons.skip_previous, size: 36, color: hasPrevious ? Colors.white : AppColors.textMuted),
          onPressed: () {
            HapticFeedback.lightImpact();
            onPrevious();
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
          icon: Icon(Icons.skip_next, size: 36, color: hasNext ? Colors.white : AppColors.textMuted),
          onPressed: () {
            HapticFeedback.lightImpact();
            if (hasNext) onNext();
          },
        ),
        IconButton(
          icon: Icon(
            repeatMode == RepeatState.one ? Icons.repeat_one : Icons.repeat,
            color: repeatMode != RepeatState.off ? AppColors.primary : Colors.white,
          ),
          onPressed: onRepeat,
        ),
      ],
    );
  }
}

