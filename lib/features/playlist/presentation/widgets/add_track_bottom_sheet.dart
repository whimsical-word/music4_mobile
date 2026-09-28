import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class AddTrackBottomSheet extends StatelessWidget {
  final ValueChanged<Map<String, String>> onTrackAdded;

  const AddTrackBottomSheet({super.key, required this.onTrackAdded});

  static void show(BuildContext context, ValueChanged<Map<String, String>> onAdded) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => AddTrackBottomSheet(onTrackAdded: onAdded),
    );
  }

  static const _availableTracks = [
    {'title': 'Chạy Ngay Đi', 'artist': 'Sơn Tùng M-TP', 'duration': '04:07'},
    {'title': 'Waiting For You', 'artist': 'MONO', 'duration': '04:25'},
    {'title': 'See Tình', 'artist': 'Hoàng Thùy Linh', 'duration': '03:05'},
    {'title': 'Cắt Đôi Nỗi Sầu', 'artist': 'Tăng Duy Tân', 'duration': '03:13'},
    {'title': 'Ánh Sao Và Bầu Trời', 'artist': 'T.R.I', 'duration': '04:18'},
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
                const Text('Thêm bài hát gợi ý', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Divider(color: AppColors.divider),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _availableTracks.length,
              itemBuilder: (context, index) {
                final track = _availableTracks[index];
                return ListTile(
                  leading: const Icon(Icons.music_note, color: AppColors.primary),
                  title: Text(track['title']!, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${track['artist']} • ${track['duration']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primary),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onTrackAdded(track);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
