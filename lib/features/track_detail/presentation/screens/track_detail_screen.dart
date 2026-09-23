import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TrackDetailScreen extends StatelessWidget {
  final String? trackId;
  const TrackDetailScreen({super.key, this.trackId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết bài hát #${trackId ?? "1"}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Icon(Icons.music_note, size: 80, color: AppColors.primary)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.favorite_border, color: AppColors.error), onPressed: () {}),
                IconButton(icon: const Icon(Icons.playlist_add), onPressed: () {}),
                IconButton(icon: const Icon(Icons.share), onPressed: () {}),
              ],
            ),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Bình luận (Comments)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text('User ${index + 1}'),
                    subtitle: const Text('Bài hát này nghe hay tuyệt vời!'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
