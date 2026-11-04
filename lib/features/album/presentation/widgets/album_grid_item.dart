import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../data/models/album_model.dart';
import '../providers/album_provider.dart';
import '../../../track_management/presentation/providers/artist_tracks_provider.dart';
import 'add_track_options_bottom_sheet.dart';

class AlbumGridItem extends ConsumerWidget {
  final AlbumModel album;

  const AlbumGridItem({super.key, required this.album});

  void _handleDeleteAlbum(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xóa Album', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn có chắc chắn muốn xóa "${album.title}"?'),
            const SizedBox(height: 8),
            const Text(
              'Lưu ý: Các bài hát trong album sẽ không bị xóa mà sẽ trở thành bài hát đơn lẻ (Single).',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('HỦY', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(albumNotifierProvider.notifier).deleteAlbum(album.id);
                final authState = ref.read(authNotifierProvider);
                if (authState is AuthAuthenticated) {
                  ref.read(artistTracksNotifierProvider.notifier).refresh(authState.user.id);
                } else {
                  ref.read(artistTracksNotifierProvider.notifier).refresh();
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa album "${album.title}" thành công!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  final cleanMsg = e.toString().replaceFirst('Exception: ', '');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi khi xóa album: $cleanMsg'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('XÓA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.album_rounded, size: 48, color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvedCover = ImageUrlHelper.resolve(album.coverUrl);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push('/album/${album.id}');
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: resolvedCover != null
                            ? Image.network(
                                resolvedCover,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${album.trackCount} bài hát',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            key: Key('album_item_add_track_btn_${album.id}'),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              final authState = ref.read(authNotifierProvider);
                              final artistId = (authState is AuthAuthenticated)
                                  ? authState.user.id
                                  : (int.tryParse(album.artistId) ?? 0);
                              showAddTrackOptionsBottomSheet(
                                context,
                                albumId: int.tryParse(album.id) ?? 0,
                                albumTitle: album.title,
                                artistId: artistId,
                              );
                            },
                            icon: const Icon(Icons.add, size: 14, color: AppColors.primary),
                            label: const Text(
                              'Thêm bài hát',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.6), width: 1),
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              minimumSize: const Size(0, 30),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _handleDeleteAlbum(context, ref),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
