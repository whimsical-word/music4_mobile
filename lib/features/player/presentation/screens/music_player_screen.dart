import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đang phát'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Artwork
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.card,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.music_note, size: 100, color: AppColors.primary),
            ),
            // Track Info
            const Column(
              children: [
                Text(
                  'Tên bài hát mẫu',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Tên Ca Sĩ / Nghệ sĩ',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                ),
              ],
            ),
            // Progress Bar
            Column(
              children: [
                Slider(
                  value: 30,
                  max: 200,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.divider,
                  onChanged: (val) {},
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
            ),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 36),
                  onPressed: () {},
                ),
                const SizedBox(width: 24),
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow, size: 36, color: Colors.black),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 36),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
