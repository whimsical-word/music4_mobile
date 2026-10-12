import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/album_detail_model.dart';
import '../../data/repositories/album_repository.dart';

class AlbumDetailState {
  final AlbumDetailModel album;
  final bool isFavorite;

  const AlbumDetailState({
    required this.album,
    this.isFavorite = false,
  });

  AlbumDetailState copyWith({
    AlbumDetailModel? album,
    bool? isFavorite,
  }) {
    return AlbumDetailState(
      album: album ?? this.album,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

final albumDetailControllerProvider = StateNotifierProvider.autoDispose
    .family<AlbumDetailController, AsyncValue<AlbumDetailState>, int>((
      ref,
      albumId,
    ) {
      final repository = ref.watch(albumRepositoryProvider);
      return AlbumDetailController(repository, albumId);
    });

class AlbumDetailController
    extends StateNotifier<AsyncValue<AlbumDetailState>> {
  final AlbumRepository _repository;
  final int albumId;

  AlbumDetailController(this._repository, this.albumId)
      : super(const AsyncValue.loading()) {
    loadAlbumDetail();
  }

  Future<void> loadAlbumDetail() async {
    state = const AsyncValue.loading();
    try {
      final album = await _repository.getAlbumDetail(albumId);
      state = AsyncValue.data(
        AlbumDetailState(album: album, isFavorite: false),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void toggleFavorite() {
    state.whenData((currentState) {
      state = AsyncValue.data(
        currentState.copyWith(isFavorite: !currentState.isFavorite),
      );
    });
  }
}
