import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../router/route_names.dart';
import '../../theme/app_colors.dart';
import '../../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../../features/player/presentation/providers/player_provider.dart';
import '../../../features/auth/data/datasources/token_storage.dart';

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
                // Đọc notifiers TRƯỚC KHI đóng dialog (trước khi ref bị dispose)
                final authNotifier = ref.read(authNotifierProvider.notifier);
                final playerNotifier = ref.read(playerNotifierProvider.notifier);
                
                Navigator.pop(ctx); // Đóng dialog
                
                // Dừng nhạc và reset trạng thái phát ngay lập tức khi đăng xuất
                await playerNotifier.onUserLoggedOut();
                await authNotifier.logout();
                await TokenStorage.instance.clearSession();
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
