import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../providers/album_provider.dart';
import '../../data/models/album_model.dart';
import '../widgets/album_creation_form.dart';
import '../widgets/album_grid_item.dart';
import '../widgets/add_track_options_bottom_sheet.dart';

class AlbumManagementScreen extends ConsumerStatefulWidget {
  const AlbumManagementScreen({super.key});

  @override
  ConsumerState<AlbumManagementScreen> createState() => _AlbumManagementScreenState();
}

class _AlbumManagementScreenState extends ConsumerState<AlbumManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authNotifierProvider);
      if (authState is AuthAuthenticated && authState.user.isArtist) {
        ref.read(albumNotifierProvider.notifier).fetchMyAlbums(
          authState.user.id,
          artistName: authState.user.displayName,
        );
      }
    });
  }

  Future<void> _showCreateAlbumPopup(BuildContext context) async {
    final newAlbum = await showModalBottomSheet<AlbumModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => const AlbumCreationForm(),
    );

    if (newAlbum != null && mounted) {
      _showAddTrackPromptDialog(this.context, newAlbum);
    }
  }

  void _showAddTrackPromptDialog(BuildContext context, AlbumModel album) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 48),
        title: const Text(
          'Tạo Album thành công!',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Bạn vừa tạo thành công album "${album.title}". Bạn có muốn thêm bài hát vào album này ngay bây giờ không?',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Để sau', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              final authState = ref.read(authNotifierProvider);
              final artistId = int.tryParse(album.artistId) ??
                  (authState is AuthAuthenticated ? authState.user.id : 0);
              showAddTrackOptionsBottomSheet(
                context,
                albumId: int.tryParse(album.id) ?? 0,
                albumTitle: album.title,
                artistId: artistId,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: const Icon(Icons.playlist_add_rounded, size: 18),
            label: const Text('Thêm bài hát ngay', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isArtist = authState is AuthAuthenticated && authState.user.isArtist;

    if (!isArtist) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quản lý Album'), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chỉ dành cho Nghệ sĩ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Trang Quản lý Album chỉ dành riêng cho tài khoản Nghệ sĩ (Artist). Vui lòng đăng nhập bằng tài khoản Nghệ sĩ để truy cập.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final user = authState.user;
    final albumState = ref.watch(albumNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Studio - Quản lý Album'),
        centerTitle: true,
        actions: [
          IconButton(
            key: const Key('album_mgmt_appbar_add_btn'),
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 26),
            tooltip: 'Tạo Album Mới',
            onPressed: () => _showCreateAlbumPopup(context),
          ),
        ],
      ),
      body: albumState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(err.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(albumNotifierProvider.notifier).fetchMyAlbums(user.id, artistName: user.displayName),
                  child: const Text('Thử Lại'),
                ),
              ],
            ),
          ),
        ),
        data: (albums) {
          if (albums.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.album_outlined, size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    const Text(
                      'Bạn chưa có album nào',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Bấm nút "Tạo Album" bên dưới để phát hành đĩa nhạc đầu tiên của bạn!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      key: const Key('album_empty_create_btn'),
                      onPressed: () => _showCreateAlbumPopup(context),
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text(
                        'Tạo Album Đầu Tiên',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(albumNotifierProvider.notifier).fetchMyAlbums(user.id, artistName: user.displayName),
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemCount: albums.length,
              itemBuilder: (context, index) => AlbumGridItem(album: albums[index]),
            ),
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
