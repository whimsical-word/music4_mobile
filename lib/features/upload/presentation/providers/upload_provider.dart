import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/upload_repository.dart';

class UploadState {
  final bool isLoading;
  final double progress; // 0.0 to 1.0
  final String? error;
  final bool isSuccess;

  const UploadState({
    this.isLoading = false,
    this.progress = 0.0,
    this.error,
    this.isSuccess = false,
  });

  UploadState copyWith({
    bool? isLoading,
    double? progress,
    String? error,
    bool? isSuccess,
  }) {
    return UploadState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

final uploadNotifierProvider = StateNotifierProvider<UploadNotifier, UploadState>((ref) {
  return UploadNotifier(ref.watch(uploadRepositoryProvider));
});

class UploadNotifier extends StateNotifier<UploadState> {
  final UploadRepository _repository;

  UploadNotifier(this._repository) : super(const UploadState());

  Future<void> uploadTrack({
    required String title,
    required List<int> categoryIds,
    String? albumId,
    List<int>? artistIds,
    required String audioFilePath,
    required String coverFilePath,
  }) async {
    try {
      state = state.copyWith(isLoading: true, progress: 0.0, error: null, isSuccess: false);
      await _repository.uploadTrack(
        title: title,
        categoryIds: categoryIds,
        albumId: albumId,
        artistIds: artistIds,
        audioFilePath: audioFilePath,
        coverFilePath: coverFilePath,
        onSendProgress: (sent, total) {
          if (total > 0) {
            state = state.copyWith(progress: sent / total);
          }
        },
      );
      state = state.copyWith(isLoading: false, progress: 1.0, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void reset() {
    state = const UploadState();
  }
}
