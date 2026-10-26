import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import 'existing_tracks_picker_bottom_sheet.dart';

Future<void> showAddTrackOptionsBottomSheet(
  BuildContext context, {
  required int albumId,
  required String albumTitle,
  required int artistId,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (modalContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Thêm bài hát vào "$albumTitle"',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.playlist_add_check_rounded, color: AppColors.primary),
              ),
              title: const Text(
                'Chọn từ bài hát có sẵn của tôi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Gán các bài Single bạn đã phát hành vào Album này',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
              onTap: () {
                Navigator.pop(modalContext);
                showExistingTracksPickerBottomSheet(
                  context,
                  albumId: albumId,
                  albumTitle: albumTitle,
                  artistId: artistId,
                );
              },
            ),
            const Divider(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_upload_outlined, color: Colors.blueAccent),
              ),
              title: const Text(
                'Tải lên bài hát mới',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Upload file nhạc mới từ thiết bị và thêm vào Album này',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
              onTap: () {
                Navigator.pop(modalContext);
                context.push('${RouteNames.upload}?albumId=$albumId');
              },
            ),
          ],
        ),
      ),
    ),
  );
}
