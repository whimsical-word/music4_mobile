import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../domain/models/user_profile.dart';
import 'profile_menu_item.dart';
import 'section_label.dart';

class AccountSection extends ConsumerWidget {
  final UserProfile profile;

  const AccountSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isAdmin = authState is AuthAuthenticated && authState.user.isAdmin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(label: 'Tài khoản'),
        if (isAdmin)
          ProfileMenuItem(
            icon: Icons.admin_panel_settings_outlined,
            iconColor: Colors.amber,
            title: 'Quản trị hệ thống (Admin)',
            subtitle: 'Quản lý người dùng và thể loại nhạc',
            onTap: () => context.push(RouteNames.admin),
          ),
        ProfileMenuItem(
          icon: Icons.favorite_outline,
          iconColor: const Color(0xFFE91E63),
          title: 'Bài hát yêu thích',
          subtitle: '${profile.likedTracksCount} bài hát',
          onTap: () => context.push(RouteNames.favorites),
        ),
        ProfileMenuItem(
          icon: Icons.queue_music_outlined,
          iconColor: AppColors.primary,
          title: 'Playlist của tôi',
          subtitle: '${profile.playlistCount} playlist',
          onTap: () => context.push(RouteNames.playlist),
        ),
        ProfileMenuItem(
          icon: Icons.history_outlined,
          iconColor: AppColors.secondary,
          title: 'Lịch sử nghe nhạc',
          subtitle: 'Xem các bài hát đã nghe gần đây',
          onTap: () => context.push(RouteNames.history),
        ),
      ],
    );
  }
}
