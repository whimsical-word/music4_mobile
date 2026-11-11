import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/notification_provider.dart';
import '../utils/notification_actions.dart';
import '../widgets/notification_error_view.dart';
import '../widgets/notification_list_view.dart';
import '../widgets/notification_shimmer.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  Future<void> _markAllRead(BuildContext context, WidgetRef ref) async {
    final ok = await ref.read(notificationProvider.notifier).markAllAsRead();
    if (!ok && context.mounted) {
      showNotificationSnackBar(context, 'Một số thông báo chưa được cập nhật.');
    }
  }

  Future<void> _clearAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa tất cả thông báo?'),
        content: const Text('Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa hết'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final ok = await ref.read(notificationProvider.notifier).clearAll();
    if (!ok && context.mounted) {
      showNotificationSnackBar(context, 'Không thể xóa thông báo.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Đánh dấu tất cả đã đọc',
            onPressed: () => _markAllRead(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Xóa tất cả',
            onPressed: () => _clearAll(context, ref),
          ),
        ],
      ),
      body: notificationState.when(
        loading: () => const NotificationShimmer(),
        error: (error, _) => NotificationErrorView(
          errorMessage: error.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref.read(notificationProvider.notifier).retry(),
        ),
        data: (notifications) => notifications.isEmpty
            ? const _EmptyNotifications()
            : NotificationListView(notifications: notifications),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Bạn chưa có thông báo nào.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
