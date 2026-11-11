import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/shared/widgets/change_password_action.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_menu_item.dart';
import 'section_label.dart';

class SettingsSection extends ConsumerWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const SectionLabel(label: 'Cài đặt'),
        ProfileMenuItem(
          icon: Icons.lock_outline,
          iconColor: AppColors.textSecondary,
          title: 'Đổi mật khẩu',
          subtitle: 'Cập nhật mật khẩu của bạn',
          onTap: () => handleOpenChangePassword(context, ref),
        ),
        ProfileMenuItem(
          icon: Icons.notifications_outlined,
          iconColor: AppColors.warning,
          title: 'Thông báo',
          subtitle: 'Quản lý thông báo',
          onTap: () => context.push(RouteNames.notifications),
        ),
        ProfileMenuItem(
          icon: Icons.help_outline,
          iconColor: AppColors.textSecondary,
          title: 'Trợ giúp & Phản hồi',
          subtitle: 'Báo cáo vấn đề hoặc gửi góp ý',
          onTap: () {
            // TODO: Open help page
          },
        ),
      ],
    );
  }
}
