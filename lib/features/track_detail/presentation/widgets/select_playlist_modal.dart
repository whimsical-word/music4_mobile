import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class SelectPlaylistModal extends StatelessWidget {
  final ValueChanged<String> onPlaylistSelected;

  const SelectPlaylistModal({super.key, required this.onPlaylistSelected});

  static void show(BuildContext context, ValueChanged<String> onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SelectPlaylistModal(onPlaylistSelected: onSelected),
    );
  }

  static const _playlists = [
    'Nhạc Chill Đêm Khuya',
    'Workout Motivation',
    'Acoustic Coffee Time',
    'Top V-Pop Hits',
    'Coding Focus Lofi',
  ];

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
                const Text('Thêm vào Playlist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Divider(color: AppColors.divider),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _playlists.length,
              itemBuilder: (context, index) {
                final name = _playlists[index];
                return ListTile(
                  leading: const Icon(Icons.queue_music, color: AppColors.primary),
                  title: Text(name),
                  trailing: const Icon(Icons.add_circle_outline, color: AppColors.textSecondary),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onPlaylistSelected(name);
                    Navigator.pop(context);
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
