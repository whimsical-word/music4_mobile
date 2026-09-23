import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AlbumDetailScreen extends StatelessWidget {
  final String? albumId;
  const AlbumDetailScreen({super.key, this.albumId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Album #${albumId ?? "1"}')),
      body: ListView(
        children: [
          // Album Header
          Container(
            height: 220,
            color: AppColors.card,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 16, offset: Offset(0, 8))],
                  ),
                  child: const Icon(Icons.album, size: 80, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                const Text('Tên Album', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Nghệ sĩ thực hiện', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          // Track list in album
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Danh sách bài hát trong album', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text('${index + 1}', style: const TextStyle(color: AppColors.textMuted, fontSize: 16)),
                title: Text('Track #${index + 1} trong album'),
                subtitle: const Text('3:24'),
                trailing: const Icon(Icons.more_vert, color: AppColors.textMuted),
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
