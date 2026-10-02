import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      debugPrint('[AUTH DEBUG] Stored access_token: ${token != null ? "FOUND (${token.length} chars)" : "NULL"}');
      if (token != null && mounted) {
        final uid = JwtHelper.getUserId(token);
        final dName = JwtHelper.getUserName(token);
        final uName = JwtHelper.getUsername(token);
        debugPrint('[AUTH DEBUG] Decoded from JWT -> ID: $uid, Name: "$dName", Username: "$uName"');
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
      await ref.read(trackDetailControllerProvider(_id).notifier).toggleFavorite();
      if (!mounted) return;
      final isLikedNow =
          ref.read(trackDetailControllerProvider(_id)).value?.isLiked ?? false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isLikedNow
                ? '❤️ Đã thêm vào bài hát yêu thích'
                : 'Đã xóa khỏi bài hát yêu thích',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
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

  void _addToPlaylist(List<PlaylistModel> playlists) {
    SelectPlaylistModal.show(
      context,
      playlists: playlists,
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
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Thêm vào playlist thất bại: ${e.toString().replaceAll("Exception: ", "")}',
              ),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(detailAsync.value?.track.name ?? 'Chi tiết bài hát'),
        actions: [
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
            onRefresh: () => ref
                .read(trackDetailControllerProvider(_id).notifier)
                .refresh(),
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
                  onAddToPlaylist: () => _addToPlaylist(state.userPlaylists),
                  onShare: _shareTrack,
                  onRatingChanged: (newRating) {
                    ref
                        .read(trackDetailControllerProvider(_id).notifier)
                        .setRating(newRating);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('⭐ Đã đánh giá $newRating sao'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
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
