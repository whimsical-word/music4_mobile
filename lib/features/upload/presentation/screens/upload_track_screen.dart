import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class UploadTrackScreen extends StatelessWidget {
  const UploadTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artist Studio - Upload Nhạc')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.card,
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.audio_file, size: 48, color: AppColors.primary),
                    SizedBox(height: 8),
                    Text('Chọn file âm thanh (MP3/WAV)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Tên bài hát',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Thể loại (Category)',
                prefixIcon: Icon(Icons.category),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Tải lên & Xuất bản'),
            ),
          ],
        ),
      ),
    );
  }
}
