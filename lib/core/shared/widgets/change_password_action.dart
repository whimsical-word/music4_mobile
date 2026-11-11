import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music4_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';

import '../../router/route_names.dart';
import '../../theme/app_colors.dart';

void showGoogleAccountNoticeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.primary),
          SizedBox(width: 8),
          Text(
            'Tài khoản Google',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
          ),
        ],
      ),
      content: const Text(
        'Tài khoản của bạn được liên kết qua Google và không sử dụng mật khẩu riêng. Vui lòng quản lý bảo mật thông qua tài khoản Google của bạn.',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text(
            'Đã hiểu',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> handleOpenChangePassword(
  BuildContext context,
  WidgetRef ref,
) async {
  final authRepo = ref.read(authRepositoryProvider);
  final result = await authRepo.checkCanChangePassword();

  if (!context.mounted) return;

  final canChange = switch (result) {
    Success(:final data) => data,
    _ => true,
  };

  if (!canChange) {
    showGoogleAccountNoticeDialog(context);
  } else {
    context.push(RouteNames.changePassword);
  }
}
