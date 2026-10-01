import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/upload_repository.dart';

final uploadNotifierProvider = StateNotifierProvider<UploadNotifier, AsyncValue<void>>((ref) {
  return UploadNotifier(ref.watch(uploadRepositoryProvider));
});

class UploadNotifier extends StateNotifier<AsyncValue<void>> {
  final UploadRepository _repository;

  UploadNotifier(this._repository) : super(const AsyncData(null));

  Future<void> uploadTrack({
    required String title,
    required String categoryId,
    String? albumId,
    String? collabArtists,
    required String audioFilePath,
    required String coverFilePath,
  }) async {
    try {
      state = const AsyncLoading();
      await _repository.uploadTrack(
        title: title,
        categoryId: categoryId,
        albumId: albumId,
        collabArtists: collabArtists,
        audioFilePath: audioFilePath,
        coverFilePath: coverFilePath,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }
}
