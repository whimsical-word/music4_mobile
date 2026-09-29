import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/notification_provider.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notification_shimmer.dart';
import '../widgets/notification_error_view.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              // TODO: Tích hợp hàm đánh dấu đã đọc tất cả ở Tuần 4
            },
            tooltip: 'Đánh dấu đã đọc',
          ),
        ],
      ),
      body: notificationState.when(
        loading: () => const NotificationShimmer(),

        error: (error, stack) => NotificationErrorView(
          errorMessage: error.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref.read(notificationProvider.notifier).refresh(),
        ),

        data: (notifications) {
          if (notifications.isEmpty) {
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

          return RefreshIndicator(
            onRefresh: () => ref.read(notificationProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () {
                    // TODO: Điều hướng đến trang tương ứng (Ví dụ: Chi tiết bài hát)
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
