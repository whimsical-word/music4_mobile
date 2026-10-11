import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../../player/domain/models/player_state_data.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../domain/models/favorite_track.dart';
import '../../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  /// Plays the favorites through the existing Player flow, starting at the
  /// tapped track. The backend does not return durations, so the Player takes
  /// the real duration from the audio stream.
  void _playTrack(
    BuildContext context,
    WidgetRef ref,
    List<FavoriteTrack> tracks,
    int index,
  ) {
    final queue = tracks
        .map(
          (t) => TrackQueueItem(
            id: t.id,
            title: t.title,
            artist: t.artist,
            coverUrl: t.coverUrl,
            duration: Duration.zero,
          ),
        )
        .toList();

    ref.read(playerNotifierProvider.notifier).playPlaylist(queue, index);
    context.push(RouteNames.player);
  }

  Future<void> _removeFavorite(
    BuildContext context,
    WidgetRef ref,
    FavoriteTrack track,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref
        .read(favoritesProvider.notifier)
        .removeFavorite(track.id);

    switch (result) {
      case FavoriteRemoveResult.removed:
      case FavoriteRemoveResult.inProgress:
        break;
      case FavoriteRemoveResult.stillFavorite:
        messenger.showSnackBar(
          const SnackBar(content: Text('Bài hát vẫn nằm trong danh sách yêu thích.')),
        );
      case FavoriteRemoveResult.failed:
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Không thể bỏ yêu thích. Vui lòng thử lại.'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    // Favorites are per user: never request them for a guest.
    if (authState is! AuthAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bài hát yêu thích', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: authState is AuthInitial || authState is AuthLoading
            ? const _LoadingState()
            : const _GuestState(),
      );
    }

    final favoritesState = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài hát yêu thích', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: favoritesState.when(
        data: (tracks) {
          if (tracks.isEmpty) {
            return const _EmptyState();
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(favoritesProvider.notifier).refresh(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: track.coverUrl == null
                          ? const Icon(Icons.music_note, color: AppColors.primary)
                          : Image.network(
                              track.coverUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.music_note,
                                color: AppColors.primary,
                              ),
                            ),
                    ),
                    title: Text(
                      track.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      track.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite, color: AppColors.primary),
                          onPressed: () => _removeFavorite(context, ref, track),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                          onPressed: () {
                            // More actions
                          },
                        ),
                      ],
                    ),
                    onTap: () => _playTrack(context, ref, tracks, index),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const _LoadingState(),
        error: (error, stack) => _ErrorState(
          message: error is FavoritesException ? error.message : null,
          onRetry: () => ref.read(favoritesProvider.notifier).retry(),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: AppColors.textMuted.withAlpha(128)),
          const SizedBox(height: 16),
          const Text(
            'Chưa có bài hát yêu thích',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hãy thả tim cho những bài hát bạn thích nhé',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _GuestState extends StatelessWidget {
  const _GuestState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: AppColors.textMuted.withAlpha(128)),
            const SizedBox(height: 16),
            const Text(
              'Đăng nhập để xem yêu thích',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Danh sách yêu thích chỉ dành cho tài khoản đã đăng nhập.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push(RouteNames.login),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.card,
                highlightColor: AppColors.surface,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.card,
                      highlightColor: AppColors.surface,
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: AppColors.card,
                      highlightColor: AppColors.surface,
                      child: Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Shimmer.fromColors(
                baseColor: AppColors.card,
                highlightColor: AppColors.surface,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  /// Friendly message from the repository; the default text is used if null.
  final String? message;
  final VoidCallback onRetry;

  const _ErrorState({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          const Text(
            'Đã xảy ra lỗi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              message ?? 'Không thể tải danh sách yêu thích',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
