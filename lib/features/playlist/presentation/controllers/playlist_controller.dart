import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/playlist_model.dart';
import '../../data/repositories/playlist_repository.dart';

final playlistControllerProvider =
    StateNotifierProvider<PlaylistController, AsyncValue<List<PlaylistModel>>>((
      ref,
    ) {
      final repository = ref.watch(playlistRepositoryProvider);
      return PlaylistController(repository);
    });

class PlaylistController
    extends StateNotifier<AsyncValue<List<PlaylistModel>>> {
  final PlaylistRepository _repository;

  PlaylistController(this._repository) : super(const AsyncValue.loading()) {
    loadPlaylists();
  }

  /// 1. Tải danh sách Playlist từ Backend
  Future<void> loadPlaylists() async {
    state = const AsyncValue.loading();
    try {
      final playlists = await _repository.getMyPlaylists();
      state = AsyncValue.data(playlists);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// 2. Tạo Playlist mới (Cập nhật giao diện tức thì - Optimistic UI)
  Future<void> createPlaylist(String name, [String? description]) async {
    try {
      final newPlaylist = await _repository.createPlaylist(
        name: name,
        description: description,
      );
      // Chèn playlist mới lên đầu danh sách đang có trên màn hình
      state.whenData((currentList) {
        state = AsyncValue.data([newPlaylist, ...currentList]);
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// 3. Xóa Playlist (Cập nhật giao diện tức thì)
  Future<void> deletePlaylist(int id) async {
    final previousState = state;
    // Tạm xóa khỏi UI ngay lập tức để người dùng thấy mượt mà
    state.whenData((currentList) {
      state = AsyncValue.data(currentList.where((p) => p.id != id).toList());
    });

    try {
      await _repository.deletePlaylist(id);
    } catch (e) {
      // Nếu Server báo lỗi không xóa được, hoàn tác lại danh sách cũ
      state = previousState;
      rethrow;
    }
  }

  /// 4. Cập nhật thông tin Playlist (Đổi tên, mô tả hoặc ảnh bìa)
  Future<void> updatePlaylist(
    int id, {
    required String name,
    String? description,
    String? coverFilePath,
  }) async {
    try {
      var updated = await _repository.updatePlaylist(
        id,
        name: name,
        description: description,
      );
      if (coverFilePath != null && coverFilePath.isNotEmpty) {
        updated = await _repository.uploadPlaylistImage(id, coverFilePath);
      }
      state.whenData((currentList) {
        state = AsyncValue.data(
          currentList
              .map(
                (p) => p.id == id
                    ? updated.copyWith(trackCount: p.trackCount)
                    : p,
              )
              .toList(),
        );
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// 5. Làm mới danh sách khi vuốt màn hình
  Future<void> refresh() async {
    await loadPlaylists();
  }
}
