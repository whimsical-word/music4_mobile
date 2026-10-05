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
  final List<TrackCommentModel> comments;

  const TrackDetailState({
    required this.track,
    this.isLiked = false,
    this.userRating = 5,
    this.userPlaylists = const [],
    this.comments = const [],
  });

  TrackDetailState copyWith({
    TrackDetailModel? track,
    bool? isLiked,
    int? userRating,
    List<PlaylistModel>? userPlaylists,
    List<TrackCommentModel>? comments,
  }) {
    return TrackDetailState(
      track: track ?? this.track,
      isLiked: isLiked ?? this.isLiked,
      userRating: userRating ?? this.userRating,
      userPlaylists: userPlaylists ?? this.userPlaylists,
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
      ]);

      final track = results[0] as TrackDetailModel;
      final isLiked = results[1] as bool;
      final userPlaylists = results[2] as List<PlaylistModel>;
      final comments = results[3] as List<TrackCommentModel>;

      state = AsyncValue.data(
        TrackDetailState(
          track: track,
          isLiked: isLiked,
          userPlaylists: userPlaylists,
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

  /// Cập nhật số sao đánh giá
  void setRating(int rating) {
    state.whenData((current) {
      state = AsyncValue.data(current.copyWith(userRating: rating));
    });
  }

  /// Thêm bài hát này vào một playlist cụ thể
  Future<void> addTrackToPlaylist(int playlistId) async {
    await _repository.addTrackToPlaylist(playlistId, _trackId);
  }
}
