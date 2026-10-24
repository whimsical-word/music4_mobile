import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../../data/models/artist_track_model.dart';
import '../../data/repositories/track_management_repository.dart';

final artistTracksNotifierProvider = StateNotifierProvider<ArtistTracksNotifier, AsyncValue<List<ArtistTrackItemModel>>>((ref) {
  final repo = ref.watch(trackManagementRepositoryProvider);
  final authState = ref.watch(authNotifierProvider);
  final notifier = ArtistTracksNotifier(repo, ref);

  if (authState is AuthAuthenticated && authState.user.isArtist) {
    notifier.fetchArtistTracks(authState.user.id);
  }
  return notifier;
});

class ArtistTracksNotifier extends StateNotifier<AsyncValue<List<ArtistTrackItemModel>>> {
  final TrackManagementRepository _repository;
  final Ref? _ref;
  int? _currentArtistId;

  ArtistTracksNotifier(this._repository, [this._ref]) : super(const AsyncLoading());

  /// UC47: Tải danh sách toàn bộ bài hát của nghệ sĩ
  Future<void> fetchArtistTracks(int artistId) async {
    _currentArtistId = artistId;
    try {
      if (state is! AsyncData) {
        state = const AsyncLoading();
      }
      final tracks = await _repository.getArtistTracks(artistId);
      state = AsyncData(tracks);
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  /// Làm mới danh sách
  Future<void> refresh([int? artistId]) async {
    int? targetId = artistId ?? _currentArtistId;
    if (targetId == null && _ref != null) {
      final auth = _ref.read(authNotifierProvider);
      if (auth is AuthAuthenticated && auth.user.isArtist) {
        targetId = auth.user.id;
      }
    }
    if (targetId != null) {
      return fetchArtistTracks(targetId);
    }
  }

  /// UC50: Cập nhật thông tin bài hát và refresh state
  Future<void> updateTrackMetadata({
    required int trackId,
    String? title,
    int? albumId,
    List<int>? categoryIds,
    List<int>? collabArtistIds,
    File? coverImageFile,
  }) async {
    await _repository.updateTrackMetadata(
      trackId: trackId,
      title: title,
      albumId: albumId,
      categoryIds: categoryIds,
      collabArtistIds: collabArtistIds,
      coverImageFile: coverImageFile,
    );
    if (_currentArtistId != null) {
      await fetchArtistTracks(_currentArtistId!);
    }
  }

  /// UC51: Xóa bài hát khỏi hệ thống và loại bỏ khỏi state
  Future<void> deleteTrack(int trackId) async {
    await _repository.deleteTrack(trackId);
    if (state is AsyncData<List<ArtistTrackItemModel>>) {
      final currentList = state.value ?? [];
      state = AsyncData(currentList.where((t) => t.id != trackId).toList());
    }
  }
}
