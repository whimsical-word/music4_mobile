import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String? playlistId;
  const PlaylistDetailScreen({super.key, this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Playlist #${playlistId ?? "1"}')),
      body: ListView(
        children: [
          Container(
            height: 180,
            color: AppColors.card,
            child: const Center(
              child: Icon(Icons.queue_music, size: 80, color: AppColors.primary),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Danh sách bài hát', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text('${index + 1}'),
                title: Text('Bài hát trong playlist #${index + 1}'),
                subtitle: const Text('Ca sĩ'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                  onPressed: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
