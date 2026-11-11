import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/notification_model.dart';
import '../providers/notification_provider.dart';
import '../utils/notification_actions.dart';
import 'notification_tile.dart';

/// Danh sách thông báo: pull-to-refresh, vuốt trái để xóa, chạm để mở.
class NotificationListView extends ConsumerWidget {
  final List<NotificationModel> notifications;

  const NotificationListView({super.key, required this.notifications});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(notificationProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: notifications.length,
        separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Dismissible(
            key: ValueKey(notification.id),
            direction: DismissDirection.endToStart,
            background: _DeleteBackground(
              color: Theme.of(context).colorScheme.error,
            ),
            onDismissed: (_) async {
              final ok = await notifier.delete(notification.id);
              if (!ok && context.mounted) {
                showNotificationSnackBar(
                  context,
                  'Không thể xóa thông báo. Đã khôi phục.',
                );
              }
            },
            child: NotificationTile(
              notification: notification,
              onTap: () => openNotification(context, ref, notification),
            ),
          );
        },
      ),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  final Color color;

  const _DeleteBackground({required this.color});

  @override
  Widget build(BuildContext context) => Container(
    color: color,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 24),
    child: const Icon(Icons.delete_outline, color: Colors.white),
  );
}
