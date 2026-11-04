import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/notification_provider.dart';

/// Widget hiển thị Badge Material 3 chuẩn trên icon thông báo.
/// - unreadCount == 0: Ẩn hoàn toàn (isLabelVisible: false).
/// - unreadCount == 1: Chấm tròn nhỏ góc icon (smallSize: 8, label: null).
/// - unreadCount > 1: Con số cụ thể (hoặc '99+').
class NotificationBadge extends ConsumerWidget {
  final Widget child;

  const NotificationBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Badge(
      isLabelVisible: unreadCount > 0,
      backgroundColor: AppColors.primary,
      smallSize: 8,
      label: unreadCount > 1
          ? Text(
              unreadCount > 99 ? '99+' : '$unreadCount',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          : null,
      child: child,
    );
  }
}

/// Nút chuông thông báo tiện dụng cho AppBar với Badge chưa đọc.
class NotificationBellButton extends StatelessWidget {
  const NotificationBellButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Thông báo',
      icon: const NotificationBadge(
        child: Icon(Icons.notifications_none),
      ),
      onPressed: () => context.push(RouteNames.notifications),
    );
  }
}
