import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/notification_model.dart';

/// Dialog xem chi tiết cho thông báo hệ thống (không có trang đích).
Future<void> showNotificationDetailDialog(
  BuildContext context,
  NotificationModel notification,
) {
  final time = DateFormat('dd/MM/yyyy HH:mm').format(notification.createdAt);
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(notification.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.content),
          const SizedBox(height: 12),
          Text(time, style: Theme.of(ctx).textTheme.bodySmall),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Đóng'),
        ),
      ],
    ),
  );
}
