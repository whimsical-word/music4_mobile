import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music4_mobile/features/user_profile/presentation/providers/user_profile_provider.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/jwt_helper.dart';
import '../../../auth/data/datasources/token_storage.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../../playlist/data/models/playlist_model.dart';
import '../controllers/track_detail_controller.dart';
import '../widgets/select_playlist_modal.dart';
import '../widgets/track_action_bar.dart';
import '../widgets/track_comment_section.dart';
import '../widgets/track_detail_shimmer.dart';
import '../widgets/track_header_info.dart';
import '../../../../core/utils/image_url_helper.dart';

import 'package:music4_mobile/features/track_management/data/repositories/track_management_repository.dart';
import 'package:music4_mobile/features/track_management/presentation/widgets/edit_track_modal.dart';

class TrackDetailScreen extends ConsumerStatefulWidget {
  final String? trackId;

  const TrackDetailScreen({super.key, this.trackId});

  @override
  ConsumerState<TrackDetailScreen> createState() => _TrackDetailScreenState();
}

class _TrackDetailScreenState extends ConsumerState<TrackDetailScreen> {
  int get _id => int.tryParse(widget.trackId ?? '1') ?? 1;

  int? _storedUserId;
  String? _storedDisplayName;
  String? _storedUsername;

  @override
  void initState() {
    super.initState();
    _loadUserFromToken();
  }

  Future<void> _loadUserFromToken() async {
    try {
      final token = await TokenStorage.instance.getAccessToken();
      debugPrint(
        '[AUTH DEBUG] Stored access_token: ${token != null ? "FOUND (${token.length} chars)" : "NULL"}',
      );
      if (token != null && mounted) {
        final uid = JwtHelper.getUserId(token);
        final dName = JwtHelper.getUserName(token);
        final uName = JwtHelper.getUsername(token);
        debugPrint(
          '[AUTH DEBUG] Decoded from JWT -> ID: $uid, Name: "$dName", Username: "$uName"',
        );
        setState(() {
          _storedUserId = uid;
          _storedDisplayName = dName;
          _storedUsername = uName;
        });
      } else {
        debugPrint('[AUTH DEBUG] No token found in TokenStorage!');
      }
    } catch (e) {
      debugPrint('[AUTH DEBUG] Error in _loadUserFromToken: $e');
    }
  }

  void _toggleLike() async {
    try {
      await ref
          .read(trackDetailControllerProvider(_id).notifier)
          .toggleFavorite();
      if (!mounted) return;
      final isLikedNow =
          ref.read(trackDetailControllerProvider(_id)).value?.isLiked ?? false;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isLikedNow ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isLikedNow ? AppColors.error : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isLikedNow
                    ? 'Đã thêm vào bài hát yêu thích'
                    : 'Đã xóa khỏi bài hát yêu thích',
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      ref.invalidate(userProfileProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể cập nhật: ${e.toString().replaceAll("Exception: ", "")}',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _addToPlaylist(
    List<PlaylistModel> playlists,
    Set<int> playlistsContainingTrack,
  ) {
    SelectPlaylistModal.show(
      context,
      playlists: playlists,
      playlistsContainingTrack: playlistsContainingTrack,
      onSelected: (playlist) async {
        try {
          await ref
              .read(trackDetailControllerProvider(_id).notifier)
              .addTrackToPlaylist(playlist.id);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Đã thêm bài hát vào "${playlist.name}"'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          ref.invalidate(userProfileProvider);
        } catch (e) {
          if (!mounted) return;
          final errorText = e.toString();
          final message = errorText.contains('đã tồn tại') ||
                  errorText.contains('Duplicate')
              ? 'Bài hát này đã có trong "${playlist.name}" rồi.'
              : 'Thêm vào playlist thất bại: ${errorText.replaceAll("Exception: ", "")}';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  void _shareTrack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🔗 Đã sao chép link chia sẻ bài hát (music4://track/$_id)',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleDeleteTrack(String trackName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xác nhận xóa bài hát',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn có chắc chắn muốn xóa bài hát "$trackName"?'),
            const SizedBox(height: 8),
            const Text(
              'Hành động này sẽ xóa bài hát vĩnh viễn khỏi hệ thống và các playlist của người nghe.',
              style: TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ],
        ),
        actionsOverflowButtonSpacing: 8,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            key: const Key('confirm_delete_track_btn'),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text(
              'Xác nhận xóa',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await ref.read(trackManagementRepositoryProvider).deleteTrack(_id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã xóa bài hát "$trackName" thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          final cleanMsg = e.toString().replaceFirst('Exception: ', '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi xóa bài hát: $cleanMsg'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  void _addComment(String text) async {
    try {
      final authState = ref.read(authNotifierProvider);
      final userId = authState is AuthAuthenticated
          ? authState.user.id
          : _storedUserId;

      await ref
          .read(trackDetailControllerProvider(_id).notifier)
          .addComment(text, userId: userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã đăng bình luận thành công!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể gửi bình luận: ${e.toString().replaceAll("Exception: ", "")}',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _editComment(int commentId, String newContent) async {
    try {
      await ref
          .read(trackDetailControllerProvider(_id).notifier)
          .updateComment(commentId: commentId, content: newContent);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật bình luận thành công!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể cập nhật bình luận: ${e.toString().replaceAll("Exception: ", "")}',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _deleteComment(int commentId) async {
    try {
      await ref
          .read(trackDetailControllerProvider(_id).notifier)
          .deleteComment(commentId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa bình luận thành công!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Không thể xóa bình luận: ${e.toString().replaceAll("Exception: ", "")}',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) return '03:45';
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M lượt nghe';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K lượt nghe';
    }
    return '$views lượt nghe';
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(trackDetailControllerProvider(_id));
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState is AuthAuthenticated
        ? authState.user.id
        : _storedUserId;
    final currentDisplayName = authState is AuthAuthenticated
        ? authState.user.displayName
        : _storedDisplayName;
    final currentUsername = authState is AuthAuthenticated
        ? authState.user.username
        : _storedUsername;

    debugPrint(
      '🎯 [TRACK_DETAIL BUILD] authState: ${authState.runtimeType} | '
      'currentUserId: $currentUserId | '
      'currentDisplayName: "$currentDisplayName" | '
      'currentUsername: "$currentUsername"',
    );

    final isArtist = authState is AuthAuthenticated && authState.user.isArtist;
    final trackData = detailAsync.value?.track;
    final isOwner =
        isArtist &&
        trackData != null &&
        ((authState.user.id == trackData.album?.artistId) ||
            trackData.artists.any(
              (a) =>
                  a.id == authState.user.id &&
                  (a.role == 'MAIN' || a.role == null),
            ));

    return Scaffold(
      appBar: AppBar(
        title: Text(detailAsync.value?.track.name ?? 'Chi tiết bài hát'),
        actions: [
          if (isOwner) ...[
            IconButton(
              key: const Key('track_detail_edit_btn'),
              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              tooltip: 'Chỉnh sửa bài hát',
              onPressed: () {
                final track = detailAsync.value?.track;
                if (track == null) return;
                EditTrackModal.show(
                  context,
                  trackId: track.id,
                  initialTitle: track.name,
                  initialAlbumId: track.album?.id,
                  initialAlbumName: track.album?.title,
                  initialCoverUrl: track.img,
                  initialCategoryIds: track.categories
                      .map((c) => c.id)
                      .toList(),
                  onSuccess: () => ref
                      .read(trackDetailControllerProvider(_id).notifier)
                      .refresh(),
                );
              },
            ),
            IconButton(
              key: const Key('track_detail_delete_btn'),
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: 'Xóa bài hát',
              onPressed: () {
                final track = detailAsync.value?.track;
                if (track != null) _handleDeleteTrack(track.name);
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Chia sẻ',
            onPressed: () {
              HapticFeedback.lightImpact();
              _shareTrack();
            },
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const TrackDetailShimmer(),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  error.toString().replaceAll('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => ref
                      .read(trackDetailControllerProvider(_id).notifier)
                      .refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (state) {
          final track = state.track;
          final artists = track.artists.isNotEmpty
              ? track.artists.map((a) => a.name).join(', ')
              : 'Nhiều nghệ sĩ';
          final genre = track.categories.isNotEmpty
              ? track.categories.map((c) => c.name).join(' / ')
              : 'Âm nhạc';

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(trackDetailControllerProvider(_id).notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: [
                TrackHeaderInfo(
                  title: track.name,
                  artist: artists,
                  genre: genre,
                  duration: _formatDuration(track.duration),
                  views: _formatViews(track.viewCount),
                  imageUrl: track.img,
                  onPlay: () => context.push(RouteNames.player),
                ),
                const SizedBox(height: 16),
                TrackActionBar(
                  isLiked: state.isLiked,
                  rating: state.userRating,
                  onLikeToggle: _toggleLike,
                  onAddToPlaylist: () => _addToPlaylist(
                    state.userPlaylists,
                    state.playlistsContainingTrack,
                  ),
                  onShare: _shareTrack,
                  onRatingChanged: (newRating) async {
                    try {
                      await ref
                          .read(trackDetailControllerProvider(_id).notifier)
                          .setRating(newRating);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppColors.warning, size: 20),
                              const SizedBox(width: 8),
                              Text('Đã đánh giá $newRating/5 sao thành công!'),
                            ],
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Không thể lưu đánh giá: ${e.toString().replaceAll("Exception: ", "")}',
                          ),
                          backgroundColor: AppColors.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),

                // UC49: Liên kết Album
                if (track.album != null &&
                    track.album!.title.trim().isNotEmpty &&
                    track.album!.title.trim().toLowerCase() != 'single') ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Material(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1.0,
                          ),
                        ),
                        child: ListTile(
                          key: const Key('track_detail_album_tile'),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          onTap: () async {
                            await context.push('/album/${track.album!.id}');
                            if (context.mounted) {
                              ref
                                  .read(
                                    trackDetailControllerProvider(_id).notifier,
                                  )
                                  .refresh();
                            }
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: track.album!.coverUrl != null
                                  ? Image.network(
                                      ImageUrlHelper.resolve(
                                            track.album!.coverUrl,
                                          ) ??
                                          track.album!.coverUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Container(
                                        color: AppColors.card,
                                        child: const Icon(
                                          Icons.album,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: AppColors.card,
                                      child: const Icon(
                                        Icons.album,
                                        color: AppColors.primary,
                                      ),
                                    ),
                            ),
                          ),
                          title: Text(
                            track.album!.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: const Text(
                            'Thuộc Album • Bấm để nghe toàn bộ Album',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // UC48: Chi tiết metadata (Ngày phát hành, Nghệ sĩ tham gia)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.divider.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Thông tin bài hát',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (track.uploadDate != null &&
                            track.uploadDate!.isNotEmpty) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Ngày phát hành: ',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                track.uploadDate!,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (track.artists.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Nghệ sĩ tham gia:',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: track.artists.map((artist) {
                              final isMain =
                                  artist.role == 'MAIN' || artist.role == null;
                              return InkWell(
                                onTap: () =>
                                    context.push('/artist/${artist.id}'),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMain
                                        ? AppColors.primary.withValues(
                                            alpha: 0.15,
                                          )
                                        : AppColors.card,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isMain
                                          ? AppColors.primary.withValues(
                                              alpha: 0.4,
                                            )
                                          : AppColors.divider,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isMain
                                            ? Icons.star_rounded
                                            : Icons.person_outline,
                                        size: 14,
                                        color: isMain
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        artist.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isMain
                                              ? AppColors.primary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isMain ? '(Chính)' : '(Collab)',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isMain
                                              ? AppColors.primary.withValues(
                                                  alpha: 0.8,
                                                )
                                              : AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.divider),
                TrackCommentSection(
                  comments: state.comments,
                  currentUserId: currentUserId,
                  currentDisplayName: currentDisplayName,
                  currentUsername: currentUsername,
                  onAddComment: _addComment,
                  onEditComment: _editComment,
                  onDeleteComment: _deleteComment,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
