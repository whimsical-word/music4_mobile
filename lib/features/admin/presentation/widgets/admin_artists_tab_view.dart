import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../data/models/admin_artist_model.dart';
import '../providers/admin_artists_provider.dart';
import 'admin_artist_tile.dart';
import 'admin_empty_state.dart';
import 'admin_shimmer_skeleton.dart';

class AdminArtistsTabView extends ConsumerStatefulWidget {
  const AdminArtistsTabView({super.key});

  @override
  ConsumerState<AdminArtistsTabView> createState() =>
      _AdminArtistsTabViewState();
}

class _AdminArtistsTabViewState extends ConsumerState<AdminArtistsTabView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final artistsAsync = ref.watch(adminArtistsProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId =
        authState is AuthAuthenticated ? authState.user.id : null;

    return artistsAsync.when(
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
                onPressed: () =>
                    ref.read(adminArtistsProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh, color: Colors.black),
                label: const Text('Thử lại', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
      data: (allArtists) {
        final artists = _searchQuery.isEmpty
            ? allArtists
            : allArtists.where((a) {
                final query = _searchQuery.toLowerCase();
                final nameMatch = a.name.toLowerCase().contains(query);
                final emailMatch =
                    a.email?.toLowerCase().contains(query) ?? false;
                final usernameMatch =
                    a.userName?.toLowerCase().contains(query) ?? false;
                return nameMatch || emailMatch || usernameMatch;
              }).toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Tìm nghệ sĩ theo tên, email...',
                  hintStyle:
                      const TextStyle(color: AppColors.textMuted, fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: AppColors.card,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
              child: artists.isEmpty
                  ? const AdminEmptyState(
                      title: 'Không tìm thấy nghệ sĩ',
                      message: 'Thử tìm với từ khóa khác.',
                      icon: Icons.person_search_outlined,
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.card,
                      onRefresh: () =>
                          ref.read(adminArtistsProvider.notifier).refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: artists.length,
                        itemBuilder: (context, index) {
                          final artist = artists[index];
                          final isSelf =
                              currentUserId != null && currentUserId == artist.id;

                          return AdminArtistTile(
                            artist: artist,
                            isSelf: isSelf,
                            onToggleStatus: () =>
                                _confirmToggleStatus(context, ref, artist, isSelf),
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
    AdminArtistModel artist,
    bool isSelf,
  ) {
    if (isSelf) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bảo mật: Không thể tự khóa tài khoản của chính mình!'),
        ),
      );
      return;
    }

    final isLocked = artist.isDeleted;
    final action = isLocked ? 'kích hoạt lại' : 'vô hiệu hóa';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Xác nhận $action nghệ sĩ',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          isLocked
              ? 'Bạn có chắc chắn muốn kích hoạt lại nghệ sĩ "${artist.name}"?'
              : 'Bạn có chắc chắn muốn vô hiệu hóa nghệ sĩ "${artist.name}"? '
                  'Các bài hát và album của nghệ sĩ này sẽ bị tạm ẩn khỏi ứng dụng.',
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
              final notifier = ref.read(adminArtistsProvider.notifier);
              final success = isLocked
                  ? await notifier.reactivateArtist(artist.id)
                  : await notifier.deleteArtist(artist.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Đã $action nghệ sĩ thành công.'
                          : 'Thao tác $action thất bại. Vui lòng thử lại.',
                    ),
                  ),
                );
              }
            },
            child: Text(isLocked ? 'Kích hoạt' : 'Vô hiệu hóa'),
          ),
        ],
      ),
    );
  }
}
