import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../router/route_names.dart';
import '../../theme/app_colors.dart';
import '../../../features/auth/presentation/notifiers/auth_notifier.dart';

Future<void> showLogoutDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => Consumer(
      builder: (context, ref, child) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Đăng xuất',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: const Text(
            'Bạn có chắc muốn đăng xuất không?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Huỷ',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                // Đọc notifier TRƯỚC KHI đóng dialog (trước khi ref bị dispose)
                final authNotifier = ref.read(authNotifierProvider.notifier);
                
                Navigator.pop(ctx); // Đóng dialog
                
                await authNotifier.logout();
                if (context.mounted) context.go(RouteNames.login);
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    ),
  );
}
