import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/features/user_profile/presentation/widgets/settings_section.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/user_profile.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/account_section.dart';
import '../widgets/edit_profile_button.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_error_view.dart';
import '../widgets/user_profile_header.dart';
import '../widgets/user_profile_shimmer.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: profileAsync.when(
        loading: () => const UserProfileShimmer(),
        error: (error, _) => ProfileErrorView(
          message: error.toString(),
          onRetry: () => ref.read(userProfileProvider.notifier).retry(),
        ),
        data: (state) {
          final profile = state.profile;
          if (profile == null) return const SizedBox.shrink();

          return _ProfileBody(profile: profile);
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Hồ sơ cá nhân'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Cài đặt',
          onPressed: () {
            // TODO: navigate to Settings
          },
        ),
      ],
    );
  }
}

// ── Body (data state) ──────────────────────────────────────────────────────

class _ProfileBody extends StatelessWidget {
  final UserProfile profile;

  const _ProfileBody({required this.profile});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: UserProfileHeader(profile: profile)),
        const SliverToBoxAdapter(child: EditProfileButton()),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.divider, thickness: 1),
          ),
        ),
        SliverToBoxAdapter(child: AccountSection(profile: profile)),
        // const SliverToBoxAdapter(child: SettingsSection()),
        const SliverToBoxAdapter(child: LogoutButton()),
      ],
    );
  }
}
