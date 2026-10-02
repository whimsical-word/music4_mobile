import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../playlist/data/models/playlist_model.dart';

class SelectPlaylistModal extends StatelessWidget {
  final List<PlaylistModel> playlists;
  final ValueChanged<PlaylistModel> onPlaylistSelected;

  const SelectPlaylistModal({
    super.key,
    required this.playlists,
    required this.onPlaylistSelected,
  });

  static void show(
    BuildContext context, {
    required List<PlaylistModel> playlists,
    required ValueChanged<PlaylistModel> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SelectPlaylistModal(
        playlists: playlists,
        onPlaylistSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Thêm vào Playlist',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.divider),
          if (playlists.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
              child: Center(
                child: Text(
                  'Bạn chưa có playlist nào.\nHãy tạo playlist ở trang cá nhân trước nhé!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  final resolvedCover = ImageUrlHelper.resolve(playlist.coverUrl);

                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 44,
                        height: 44,
                        color: AppColors.card,
                        child: resolvedCover != null && resolvedCover.isNotEmpty
                            ? Image.network(
                                resolvedCover,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.queue_music,
                                  color: AppColors.primary,
                                ),
                              )
                            : const Icon(
                                Icons.queue_music,
                                color: AppColors.primary,
                              ),
                      ),
                    ),
                    title: Text(
                      playlist.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${playlist.trackCount} bài hát',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primary,
                    ),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                      onPlaylistSelected(playlist);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
