import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/album_model.dart';
import '../../data/repositories/album_repository.dart';

final albumNotifierProvider = StateNotifierProvider<AlbumNotifier, AsyncValue<List<AlbumModel>>>((ref) {
  return AlbumNotifier(ref.watch(albumRepositoryProvider));
});

class AlbumNotifier extends StateNotifier<AsyncValue<List<AlbumModel>>> {
  final AlbumRepository _repository;

  AlbumNotifier(this._repository) : super(const AsyncLoading()) {
    fetchAlbums();
  }

  Future<void> fetchAlbums() async {
    try {
      state = const AsyncLoading();
      final albums = await _repository.getAlbums();
      state = AsyncData(albums);
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  Future<void> createAlbum(String title, String coverFilePath) async {
    try {
      // Keep old state while uploading
      final previousState = state;
      state = const AsyncLoading();
      final newAlbum = await _repository.createAlbum(title: title, coverFilePath: coverFilePath);
      
      // Update state
      if (previousState is AsyncData<List<AlbumModel>>) {
        state = AsyncData([newAlbum, ...previousState.value]);
      } else {
        state = AsyncData([newAlbum]);
      }
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
      // Re-fetch to ensure consistency if needed
    }
  }

  Future<void> deleteAlbum(String albumId) async {
    try {
      await _repository.deleteAlbum(albumId);
      if (state is AsyncData<List<AlbumModel>>) {
        final currentAlbums = state.value!;
        state = AsyncData(currentAlbums.where((a) => a.id != albumId).toList());
      }
    } catch (e) {
      // Don't override state with error, maybe just throw for UI to catch
      throw Exception(e.toString());
    }
  }
}
