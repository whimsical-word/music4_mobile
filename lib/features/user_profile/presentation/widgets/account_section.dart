import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/user_profile.dart';
import 'profile_menu_item.dart';
import 'section_label.dart';

class AccountSection extends StatelessWidget {
  final UserProfile profile;

  const AccountSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(label: 'Tài khoản'),
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
