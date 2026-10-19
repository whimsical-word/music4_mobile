import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/user_profile.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/account_section.dart';
import '../widgets/edit_profile_button.dart';
import '../../../../core/shared/widgets/settings_bottom_sheet.dart';
import '../widgets/profile_error_view.dart';
import '../widgets/user_profile_header.dart';
import '../widgets/user_profile_shimmer.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with RouteAware {
  ModalRoute<dynamic>? _subscribedRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route != _subscribedRoute) {
      if (_subscribedRoute != null) {
        appRouteObserver.unsubscribe(this);
      }
      _subscribedRoute = route;
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _refreshProfile();
  }

  @override
  void didPopNext() {
    _refreshProfile();
  }

  void _refreshProfile() {
    if (!mounted) return;
    unawaited(ref.read(userProfileProvider.notifier).refresh());
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Hồ sơ cá nhân'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Cài đặt',
          onPressed: () {
            showSettingsBottomSheet(context);
          },
        ),
      ],
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  final UserProfile profile;

  const _ProfileBody({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(userProfileProvider.notifier).refresh(),
      color: AppColors.primary,
      backgroundColor: AppColors.card,
      child: CustomScrollView(
        // Bắt buộc có dòng này để màn hình luôn kéo vuốt được ngay cả khi nội dung ngắn hơn chiều cao màn hình:
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: UserProfileHeader(profile: profile)),
          SliverToBoxAdapter(child: EditProfileButton(profile: profile)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.divider, thickness: 1),
            ),
          ),
          SliverToBoxAdapter(child: AccountSection(profile: profile)),

          // Tạo khoảng đệm thoáng đáy màn hình
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
