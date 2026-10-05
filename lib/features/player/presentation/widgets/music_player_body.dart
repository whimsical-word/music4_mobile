import 'package:flutter/material.dart';
import '../../domain/models/player_state_data.dart';
import 'player_controls_widget.dart';
import 'progress_bar_widget.dart';
import 'track_info_widget.dart';
import 'vinyl_disc_widget.dart';

class MusicPlayerBody extends StatelessWidget {
  final PlayerStateData state;
  final AnimationController spinController;
  final bool isShuffle;
  final RepeatState repeatMode;
  final VoidCallback onPlayPause;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final ValueChanged<double> onSeek;

  const MusicPlayerBody({
    super.key,
    required this.state,
    required this.spinController,
    required this.isShuffle,
    required this.repeatMode,
    required this.onPlayPause,
    required this.onShuffle,
    required this.onRepeat,
    required this.onNext,
    required this.onPrevious,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          VinylDiscWidget(
            animation: spinController,
            imageUrl: state.coverUrl ?? 'https://picsum.photos/300',
          ),
          const SizedBox(height: 16),
          TrackInfoWidget(
            title: state.title,
            artist: state.artist,
          ),
          ProgressBarWidget(
            currentValue: state.position.inSeconds.toDouble(),
            maxValue: state.duration.inSeconds.toDouble(),
            positionText: state.positionText,
            durationText: state.durationText,
            onChanged: onSeek,
          ),
          PlayerControlsWidget(
            isPlaying: state.isPlaying,
            isShuffle: isShuffle,
            repeatMode: repeatMode,
            hasNext: state.hasNext,
            hasPrevious: state.hasPrevious,
            onPlayPause: onPlayPause,
            onShuffle: onShuffle,
            onRepeat: onRepeat,
            onNext: onNext,
            onPrevious: onPrevious,
          ),
        ],
      ),
    );
  }
}

