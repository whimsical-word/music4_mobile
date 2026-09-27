import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class TrackHeaderInfo extends StatelessWidget {
  final String title;
  final String artist;
  final String genre;
  final String duration;
  final String views;
  final VoidCallback onPlay;

  const TrackHeaderInfo({
    super.key,
    required this.title,
    required this.artist,
    required this.genre,
    required this.duration,
    required this.views,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 10)),
            ],
          ),
          child: const Center(
            child: Icon(Icons.music_note_rounded, size: 88, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          artist,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Text(
          '$genre • $duration • $views',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            onPlay();
          },
          icon: const Icon(Icons.play_arrow, color: Colors.black),
          label: const Text('Phát bài hát', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
        ),
      ],
    );
  }
}
