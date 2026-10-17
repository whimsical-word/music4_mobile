import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/router/route_names.dart';
import '../../../player/domain/models/player_state_data.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../../track_detail/data/repositories/track_detail_repository.dart';
import '../../data/models/notification_model.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_detail_dialog.dart';

/// Đường dẫn GoRouter tương ứng với loại thông báo (null = thông báo hệ thống).
String? notificationRoutePath(NotificationModel n) => switch (n.type) {
  NotificationType.newTrack => RouteNames.player,
  NotificationType.newAlbum => RouteNames.albumDetail.replaceFirst(
    ':id',
    '${n.albumId}',
  ),
  NotificationType.system => null,
};

void showNotificationSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
}

/// Click 1 thông báo: đánh dấu đã đọc (optimistic) rồi điều hướng thông minh.
/// - Bài hát mới: Tự động nạp track vào player và chuyển thẳng sang màn hình nghe nhạc.
/// - Album mới: Chuyển sang AlbumDetail.
/// - Hệ thống: Mở Dialog chi tiết.
void openNotification(
  BuildContext context,
  WidgetRef ref,
  NotificationModel notification,
) {
  if (!notification.isRead) {
    final messenger = ScaffoldMessenger.of(context);
    unawaited(
      ref.read(notificationProvider.notifier).markAsRead(notification.id).then((
        ok,
      ) {
        if (!ok) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Không thể đánh dấu đã đọc. Vui lòng thử lại.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }),
    );
  }

  if (notification.type == NotificationType.newTrack &&
      notification.trackId != null) {
    unawaited(_playAndOpenPlayer(context, ref, notification));
    return;
  }

  final path = notificationRoutePath(notification);
  if (path != null) {
    context.push(path);
  } else {
    showNotificationDetailDialog(context, notification);
  }
}

Future<void> _playAndOpenPlayer(
  BuildContext context,
  WidgetRef ref,
  NotificationModel notification,
) async {
  final trackId = notification.trackId!;

  String title = notification.trackName?.trim().isNotEmpty == true
      ? notification.trackName!
      : 'Bài hát mới';
  String artist = notification.artistName?.trim().isNotEmpty == true
      ? notification.artistName!
      : 'Nghệ sĩ';
  String? coverUrl;
  Duration duration = Duration.zero;

  try {
    final detail = await ref
        .read(trackDetailRepositoryProvider)
        .getTrackDetail(trackId)
        .timeout(const Duration(milliseconds: 1000));
    if (detail.name.isNotEmpty) title = detail.name;
    if (detail.artists.isNotEmpty) {
      artist = detail.artists.map((a) => a.name).join(', ');
    }
    final img = detail.img;
    if (img != null && img.isNotEmpty) {
      coverUrl = ApiEndpoints.buildImageUrl(img);
    }
    final dur = detail.duration;
    if (dur != null && dur > 0) {
      duration = Duration(seconds: dur);
    }
  } catch (e) {
    final errStr = e.toString().toLowerCase();
    // Nếu bài hát không tồn tại trên server (404 Not Found do đã bị xóa)
    if (errStr.contains('không tìm thấy') ||
        errStr.contains('404') ||
        errStr.contains('not found')) {
      // Tự động gỡ thông báo lỗi này khỏi danh sách
      ref.read(notificationProvider.notifier).delete(notification.id);
      if (context.mounted) {
        showNotificationSnackBar(
          context,
          'Bài hát này đã bị xóa hoặc không còn tồn tại!',
        );
      }
      return; // Dừng lại, không mở Player!
    }
    // Lỗi mạng hoặc timeout: tiếp tục phát với dữ liệu sẵn có từ notification
  }

  final queueItem = TrackQueueItem(
    id: '$trackId',
    title: title,
    artist: artist,
    coverUrl: coverUrl,
    duration: duration,
  );

  ref.read(playerNotifierProvider.notifier).playPlaylist([queueItem], 0);

  if (context.mounted) {
    context.push(RouteNames.player);
  }
}
