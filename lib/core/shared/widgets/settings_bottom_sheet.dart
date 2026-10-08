import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../router/route_names.dart';
import '../../theme/app_colors.dart';
import 'logout_dialog.dart';

void showSettingsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const _SettingsBottomSheetContent(),
  );
}

class _SettingsBottomSheetContent extends ConsumerWidget {
  const _SettingsBottomSheetContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Cài đặt',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
            title: const Text('Đổi mật khẩu', style: TextStyle(color: AppColors.textPrimary)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to ChangePasswordScreen
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined, color: AppColors.warning),
            title: const Text('Thông báo', style: TextStyle(color: AppColors.textPrimary)),
            onTap: () {
              Navigator.pop(context);
              context.push(RouteNames.notifications);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: AppColors.textSecondary),
            title: const Text('Trợ giúp & Phản hồi', style: TextStyle(color: AppColors.textPrimary)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Open help page
            },
          ),
          const Divider(color: AppColors.divider),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Đăng xuất', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context); // Close bottom sheet
              showLogoutDialog(context); // Show confirmation dialog
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
