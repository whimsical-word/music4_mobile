import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài hát yêu thích')),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.favorite, color: AppColors.error),
            title: Text('Bài hát đã thích #${index + 1}'),
            subtitle: const Text('Ca sĩ'),
            trailing: const Icon(Icons.play_arrow),
          );
        },
      ),
    );
  }
}
