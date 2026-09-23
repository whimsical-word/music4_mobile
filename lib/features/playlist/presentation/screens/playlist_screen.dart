import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư viện Playlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Dialog tạo playlist mới
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Tạo Playlist mới'),
                  content: const TextField(decoration: InputDecoration(hintText: 'Tên Playlist')),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
                    ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tạo')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.queue_music, color: AppColors.primary),
            ),
            title: Text('Danh sách phát #${index + 1}'),
            subtitle: const Text('12 bài hát'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/playlist/${index + 1}'),
          );
        },
      ),
    );
  }
}
