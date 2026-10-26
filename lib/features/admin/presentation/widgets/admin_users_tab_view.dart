import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../data/models/admin_user_model.dart';
import '../providers/admin_users_provider.dart';
import 'admin_empty_state.dart';
import 'admin_shimmer_skeleton.dart';
import 'admin_user_tile.dart';

class AdminUsersTabView extends ConsumerStatefulWidget {
  const AdminUsersTabView({super.key});

  @override
  ConsumerState<AdminUsersTabView> createState() => _AdminUsersTabViewState();
}

class _AdminUsersTabViewState extends ConsumerState<AdminUsersTabView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId =
        authState is AuthAuthenticated ? authState.user.id : null;

    return usersAsync.when(
      loading: () => const AdminShimmerSkeleton(),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () => ref.read(adminUsersProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh, color: Colors.black),
                label: const Text('Thử lại', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
      data: (allUsers) {
        final users = _searchQuery.isEmpty
            ? allUsers
            : allUsers.where((u) {
                final query = _searchQuery.toLowerCase();
                return u.name.toLowerCase().contains(query) ||
                    u.email.toLowerCase().contains(query) ||
                    u.username.toLowerCase().contains(query);
              }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Tìm người dùng theo tên, email...',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                  filled: true,
                  fillColor: AppColors.card,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              ),
            ),
            Expanded(
              child: users.isEmpty
                  ? const AdminEmptyState(
                      title: 'Không tìm thấy người dùng',
                      message: 'Thử tìm với từ khóa khác.',
                      icon: Icons.person_search_outlined,
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.card,
                      onRefresh: () => ref.read(adminUsersProvider.notifier).refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final isSelf = currentUserId != null && currentUserId == user.id;

                          return AdminUserTile(
                            user: user,
                            isSelf: isSelf,
                            onToggleStatus: () =>
                                _confirmToggleStatus(context, ref, user, isSelf),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  void _confirmToggleStatus(
    BuildContext context,
    WidgetRef ref,
    AdminUserModel user,
    bool isSelf,
  ) {
    if (isSelf) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bảo mật: Không thể tự khóa tài khoản của chính mình!')),
      );
      return;
    }

    final isLocked = user.isDeleted;
    final action = isLocked ? 'kích hoạt lại' : 'vô hiệu hóa';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Xác nhận $action tài khoản',
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có chắc chắn muốn $action tài khoản "${user.name.isNotEmpty ? user.name : user.username}" (${user.email})?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: isLocked ? AppColors.primary : AppColors.error,
              foregroundColor: isLocked ? Colors.black : Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final notifier = ref.read(adminUsersProvider.notifier);
              final success = isLocked
                  ? await notifier.reactivateUser(user.id)
                  : await notifier.deleteUser(user.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Đã $action tài khoản thành công.'
                          : 'Thao tác $action thất bại. Vui lòng thử lại.',
                    ),
                  ),
                );
              }
            },
            child: Text(isLocked ? 'Kích hoạt' : 'Khóa tài khoản'),
          ),
        ],
      ),
    );
  }
}
