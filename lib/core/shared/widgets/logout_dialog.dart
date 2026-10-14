import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music4_mobile/core/router/app_router.dart';

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                final authNotifier = ref.read(authNotifierProvider.notifier);
                final playerNotifier = ref.read(
                  playerNotifierProvider.notifier,
                );

                Navigator.pop(ctx);

                await playerNotifier.onUserLoggedOut();
                await authNotifier.logout();
                await TokenStorage.instance.clearSession();
                final navContext = rootNavigatorKey.currentContext;
                if (navContext != null && navContext.mounted) {
                  navContext.go(RouteNames.login);
                }
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    ),
  );
}
