import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/album_provider.dart';
import '../widgets/album_creation_form.dart';
import '../widgets/album_grid_item.dart';

class AlbumManagementScreen extends ConsumerWidget {
  const AlbumManagementScreen({super.key});

  void _showCreateAlbumPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => const AlbumCreationForm(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumState = ref.watch(albumNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Album'), centerTitle: true),
      body: albumState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(err.toString(), textAlign: TextAlign.center),
              ElevatedButton(onPressed: () => ref.read(albumNotifierProvider.notifier).fetchAlbums(), child: const Text('Thử Lại')),
            ],
          ),
        ),
        data: (albums) {
          if (albums.isEmpty) return const Center(child: Text('Bạn chưa có album nào.'));
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8,
            ),
            itemCount: albums.length,
            itemBuilder: (context, index) => AlbumGridItem(album: albums[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateAlbumPopup(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('Tạo Album', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(icon: Icon(Icons.queue_music), label: 'Thư viện'),
        ],
        onTap: (index) {
          if (index == 0) context.push(RouteNames.home);
          if (index == 1) context.push(RouteNames.search);
          if (index == 2) context.push(RouteNames.playlist);
        },
      ),
    );
  }
}
