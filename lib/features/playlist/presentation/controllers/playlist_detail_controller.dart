import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/playlist_model.dart';
import '../../data/models/playlist_track_model.dart';
import '../../data/repositories/playlist_repository.dart';

/// Lớp lưu trữ trạng thái tổng hợp của màn hình Playlist Detail
class PlaylistDetailState {
  final PlaylistModel playlist;
  final List<PlaylistTrackModel> tracks;
  final List<PlaylistTrackModel> availableTracks;

  const PlaylistDetailState({
    required this.playlist,
    required this.tracks,
    this.availableTracks = const [],
  });

  PlaylistDetailState copyWith({
    PlaylistModel? playlist,
    List<PlaylistTrackModel>? tracks,
    List<PlaylistTrackModel>? availableTracks,
  }) {
    return PlaylistDetailState(
      playlist: playlist ?? this.playlist,
      tracks: tracks ?? this.tracks,
      availableTracks: availableTracks ?? this.availableTracks,
    );
  }
}

/// Provider quản lý chi tiết Playlist theo từng ID
final playlistDetailControllerProvider = StateNotifierProvider.autoDispose
    .family<PlaylistDetailController, AsyncValue<PlaylistDetailState>, int>((
      ref,
      playlistId,
    ) {
      final repository = ref.watch(playlistRepositoryProvider);
      return PlaylistDetailController(repository, playlistId);
    });

class PlaylistDetailController
    extends StateNotifier<AsyncValue<PlaylistDetailState>> {
  final PlaylistRepository _repository;
  final int playlistId;

  PlaylistDetailController(this._repository, this.playlistId)
    : super(const AsyncValue.loading()) {
    loadPlaylistDetail();
  }

  /// 1. Tải thông tin Playlist và danh sách bài hát từ Server
  Future<void> loadPlaylistDetail() async {
    state = const AsyncValue.loading();
    try {
      final playlist = await _repository.getPlaylistById(playlistId);
      final tracks = await _repository.getTracksByPlaylistId(playlistId);
      final available = await _repository.getAllTracks();
      state = AsyncValue.data(
        PlaylistDetailState(
          playlist: playlist,
          tracks: tracks,
          availableTracks: available,
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 2. Thêm bài hát vào Playlist (POST /api/playlists/{id}/tracks)
  Future<void> addTrack(int trackId) async {
    try {
      await _repository.addTrackToPlaylist(playlistId, trackId);
      final updatedTracks = await _repository.getTracksByPlaylistId(playlistId);
      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(
            tracks: updatedTracks,
            playlist: currentState.playlist.copyWith(
              trackCount: updatedTracks.length,
            ),
          ),
        );
      });
    } catch (e) {
      rethrow;
    }
  }

  /// 3. Xóa bài hát khỏi Playlist (DELETE /api/playlists/{id}/tracks/{trackId})
  Future<void> removeTrack(int trackId) async {
    final previousState = state;
    // Optimistic UI: Xóa khỏi giao diện tức thì
    state.whenData((currentState) {
      final updated = currentState.tracks
          .where((t) => t.id != trackId)
          .toList();
      state = AsyncValue.data(
        currentState.copyWith(
          tracks: updated,
          playlist: currentState.playlist.copyWith(trackCount: updated.length),
        ),
      );
    });

    try {
      await _repository.removeTrackFromPlaylist(playlistId, trackId);
    } catch (e) {
      // Rollback lại danh sách cũ nếu Backend lỗi
      state = previousState;
      rethrow;
    }
  }

  /// 4. Cập nhật thông tin và ảnh bìa Playlist (PUT /api/playlists/{id} & PUT /api/playlists/{id}/image)
  Future<PlaylistModel> updatePlaylist({
    required String name,
    String? description,
    String? coverFilePath,
  }) async {
    try {
      var updated = await _repository.updatePlaylist(
        playlistId,
        name: name,
        description: description,
      );
      if (coverFilePath != null && coverFilePath.isNotEmpty) {
        updated = await _repository.uploadPlaylistImage(playlistId, coverFilePath);
      }
      state.whenData((currentState) {
        state = AsyncValue.data(
          currentState.copyWith(
            playlist: currentState.playlist.copyWith(
              name: updated.name,
              description: updated.description,
              coverUrl: updated.coverUrl,
            ),
          ),
        );
      });
      return updated;
    } catch (e) {
      rethrow;
    }
  }

  /// 5. Làm mới dữ liệu
  Future<void> refresh() async {
    await loadPlaylistDetail();
  }
}
