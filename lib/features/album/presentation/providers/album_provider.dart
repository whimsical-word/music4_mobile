import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../data/models/album_model.dart';
import '../../data/repositories/album_repository.dart';

final albumNotifierProvider = StateNotifierProvider<AlbumNotifier, AsyncValue<List<AlbumModel>>>((ref) {
  final repo = ref.watch(albumRepositoryProvider);
  final authState = ref.watch(authNotifierProvider);
  final notifier = AlbumNotifier(repo);
  if (authState is AuthAuthenticated && authState.user.isArtist) {
    notifier.fetchMyAlbums(authState.user.id, artistName: authState.user.displayName);
  } else {
    notifier.fetchAlbums();
  }
  return notifier;
});

class AlbumNotifier extends StateNotifier<AsyncValue<List<AlbumModel>>> {
  final AlbumRepository _repository;

  int? _currentArtistId;
  String? _currentArtistName;

  AlbumNotifier(this._repository) : super(const AsyncLoading());

  /// UC4: Tải danh sách album riêng của nghệ sĩ
  Future<void> fetchMyAlbums(int artistId, {String? artistName}) async {
    _currentArtistId = artistId;
    _currentArtistName = artistName;
    try {
      if (state is! AsyncData) {
        state = const AsyncLoading();
      }
      final albums = await _repository.getAlbumsByArtist(artistId, artistName: artistName);
      state = AsyncData(albums);
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  /// Tải danh sách tất cả album
  Future<void> fetchAlbums() async {
    if (_currentArtistId != null) {
      return fetchMyAlbums(_currentArtistId!, artistName: _currentArtistName);
    }
    try {
      if (state is! AsyncData) {
        state = const AsyncLoading();
      }
      final albums = await _repository.getAlbums();
      state = AsyncData(albums);
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  /// UC2: Tạo Album mới cho ca sĩ và cập nhật danh sách
  Future<AlbumModel> createAlbum({
    required String title,
    required int artistId,
    String? coverFilePath,
    String? artistName,
  }) async {
    try {
      final newAlbum = await _repository.createAlbum(
        title: title,
        artistId: artistId,
        coverFilePath: coverFilePath,
        artistName: artistName,
      );
      _currentArtistId = artistId;
      _currentArtistName = artistName;
      if (state is AsyncData<List<AlbumModel>>) {
        final currentList = state.value ?? [];
        state = AsyncData([newAlbum, ...currentList]);
      } else {
        state = AsyncData([newAlbum]);
      }
      return newAlbum;
    } catch (e) {
      rethrow;
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
