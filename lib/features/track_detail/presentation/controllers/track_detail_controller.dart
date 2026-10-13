import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/data/models/track_detail_model.dart';
import '../../../playlist/data/models/playlist_model.dart';
import '../../data/models/track_comment_model.dart';
import '../../data/repositories/track_detail_repository.dart';

class TrackDetailState {
  final TrackDetailModel track;
  final bool isLiked;
  final int userRating;
  final List<PlaylistModel> userPlaylists;
  final Set<int> playlistsContainingTrack;
  final List<TrackCommentModel> comments;

  const TrackDetailState({
    required this.track,
    this.isLiked = false,
    this.userRating = 0,
    this.userPlaylists = const [],
    this.playlistsContainingTrack = const {},
    this.comments = const [],
  });

  TrackDetailState copyWith({
    TrackDetailModel? track,
    bool? isLiked,
    int? userRating,
    List<PlaylistModel>? userPlaylists,
    Set<int>? playlistsContainingTrack,
    List<TrackCommentModel>? comments,
  }) {
    return TrackDetailState(
      track: track ?? this.track,
      isLiked: isLiked ?? this.isLiked,
      userRating: userRating ?? this.userRating,
      userPlaylists: userPlaylists ?? this.userPlaylists,
      playlistsContainingTrack: playlistsContainingTrack ?? this.playlistsContainingTrack,
      comments: comments ?? this.comments,
    );
  }
}

final trackDetailControllerProvider = StateNotifierProvider.family<
    TrackDetailController, AsyncValue<TrackDetailState>, int>((ref, trackId) {
  final repository = ref.watch(trackDetailRepositoryProvider);
  return TrackDetailController(repository, trackId);
});

class TrackDetailController
    extends StateNotifier<AsyncValue<TrackDetailState>> {
  final TrackDetailRepository _repository;
  final int _trackId;

  TrackDetailController(this._repository, this._trackId)
      : super(const AsyncValue.loading()) {
    loadTrackDetail();
  }

  /// Tải thông tin chi tiết bài hát, trạng thái yêu thích và danh sách playlist của người dùng
  Future<void> loadTrackDetail() async {
    state = const AsyncValue.loading();
    try {
      final results = await Future.wait([
        _repository.getTrackDetail(_trackId),
        _repository.checkIsFavorite(_trackId),
        _repository.getUserPlaylists().catchError((_) => <PlaylistModel>[]),
        _repository.getComments(_trackId).catchError((_) => <TrackCommentModel>[]),
        _repository.getUserRating(_trackId).catchError((_) => null),
      ]);

      final track = results[0] as TrackDetailModel;
      final isLiked = results[1] as bool;
      final rawPlaylists = results[2] as List<PlaylistModel>;
      final comments = results[3] as List<TrackCommentModel>;
      final userRating = results[4] as int?;

      // Tải số lượng bài hát và kiểm tra bài hiện tại đã có trong từng playlist chưa
      final Set<int> containingTrack = {};
      final List<PlaylistModel> updatedPlaylists = await Future.wait(
        rawPlaylists.map((playlist) async {
          try {
            final trackIds = await _repository.getPlaylistTrackIds(playlist.id);
            if (trackIds.contains(_trackId)) {
              containingTrack.add(playlist.id);
            }
            return playlist.copyWith(trackCount: trackIds.length);
          } catch (_) {
            return playlist;
          }
        }),
      );

      state = AsyncValue.data(
        TrackDetailState(
          track: track,
          isLiked: isLiked,
          userRating: userRating ?? 0,
          userPlaylists: updatedPlaylists,
          playlistsContainingTrack: containingTrack,
          comments: comments,
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Làm mới thông tin bài hát khi người dùng vuốt màn hình
  Future<void> refresh() async {
    await loadTrackDetail();
  }

  /// Thêm bình luận mới vào bài hát và tải lại danh sách bình luận
  Future<void> addComment(String content, {int? userId}) async {
    await _repository.addComment(
      trackId: _trackId,
      content: content,
      userId: userId,
    );
    final updatedComments = await _repository.getComments(_trackId).catchError((_) => <TrackCommentModel>[]);
    if (mounted) {
      state = state.whenData((current) => current.copyWith(comments: updatedComments));
    }
  }

  /// Chỉnh sửa bình luận và cập nhật lại danh sách bình luận
  Future<void> updateComment({required int commentId, required String content}) async {
    await _repository.updateComment(commentId: commentId, content: content);
    final updatedComments = await _repository.getComments(_trackId).catchError((_) => <TrackCommentModel>[]);
    if (mounted) {
      state = state.whenData((current) => current.copyWith(comments: updatedComments));
    }
  }

  /// Xóa bình luận và cập nhật lại danh sách bình luận
  Future<void> deleteComment(int commentId) async {
    await _repository.deleteComment(commentId);
    final updatedComments = await _repository.getComments(_trackId).catchError((_) => <TrackCommentModel>[]);
    if (mounted) {
      state = state.whenData((current) => current.copyWith(comments: updatedComments));
    }
  }

  /// Thả tim / Bỏ thích với cơ chế Optimistic UI (cập nhật giao diện tức thì)
  Future<void> toggleFavorite() async {
    final previousState = state;
    final currentState = state.value;
    if (currentState == null) return;

    final nextLiked = !currentState.isLiked;
    // 1. Cập nhật UI ngay lập tức
    state = AsyncValue.data(currentState.copyWith(isLiked: nextLiked));

    try {
      // 2. Gọi API thực tế
      final serverLiked = await _repository.toggleFavorite(_trackId);
      // Đồng bộ theo kết quả trả về từ server
      if (mounted) {
        state = AsyncValue.data(currentState.copyWith(isLiked: serverLiked));
      }
    } catch (e) {
      // 3. Hoàn tác nếu API thất bại
      if (mounted) {
        state = previousState;
      }
      rethrow;
    }
  }

  /// Cập nhật số sao đánh giá (lưu vào backend qua POST /api/ratings)
  Future<void> setRating(int rating) async {
    final previousState = state;
    final currentState = state.value;
    if (currentState == null) return;

    // 1. Cập nhật UI ngay lập tức (Optimistic UI)
    state = AsyncValue.data(currentState.copyWith(userRating: rating));

    try {
      // 2. Gửi API lưu đánh giá
      await _repository.submitRating(
        trackId: _trackId,
        ratingValue: rating,
      );
    } catch (e) {
      // 3. Hoàn tác nếu API thất bại
      if (mounted) {
        state = previousState;
      }
      rethrow;
    }
  }

  /// Thêm bài hát này vào một playlist cụ thể
  Future<void> addTrackToPlaylist(int playlistId) async {
    await _repository.addTrackToPlaylist(playlistId, _trackId);
    if (mounted) {
      state.whenData((current) {
        final updatedContaining = Set<int>.from(current.playlistsContainingTrack)
          ..add(playlistId);
        final updatedPlaylists = current.userPlaylists.map((p) {
          if (p.id == playlistId) {
            return p.copyWith(trackCount: p.trackCount + 1);
          }
          return p;
        }).toList();
        state = AsyncValue.data(
          current.copyWith(
            playlistsContainingTrack: updatedContaining,
            userPlaylists: updatedPlaylists,
          ),
        );
      });
    }
  }
}
