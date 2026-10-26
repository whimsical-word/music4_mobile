import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/admin_artist_model.dart';
import '../../data/repositories/admin_repository.dart';

final adminArtistsProvider =
    AsyncNotifierProvider<AdminArtistsNotifier, List<AdminArtistModel>>(() {
  return AdminArtistsNotifier();
});

class AdminArtistsNotifier extends AsyncNotifier<List<AdminArtistModel>> {
  late final AdminRepository _repository;

  @override
  FutureOr<List<AdminArtistModel>> build() {
    _repository = ref.watch(adminRepositoryProvider);
    return _fetchArtists();
  }

  Future<List<AdminArtistModel>> _fetchArtists() async {
    final page = await _repository.getArtists();
    return page.content;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchArtists());
  }

  /// Vô hiệu hóa nghệ sĩ (#UC66)
  Future<bool> disableArtist(int id) => deleteArtist(id);

  Future<bool> deleteArtist(int id) async {
    final previousState = state.value;
    if (previousState != null) {
      // Optimistic update: đánh dấu isDeleted = true
      state = AsyncValue.data(
        previousState
            .map((a) => a.id == id ? a.copyWith(isDeleted: true) : a)
            .toList(),
      );
    }

    try {
      await _repository.deleteArtist(id);
      return true;
    } catch (e, st) {
      // Rollback nếu thất bại
      if (previousState != null) {
        state = AsyncValue.data(previousState);
      } else {
        state = AsyncValue.error(e, st);
      }
      return false;
    }
  }

  /// Khôi phục nghệ sĩ đã vô hiệu hóa (#UC65)
  Future<bool> reactivateArtist(int id) async {
    final previousState = state.value;
    if (previousState != null) {
      // Optimistic update: đánh dấu isDeleted = false
      state = AsyncValue.data(
        previousState
            .map((a) => a.id == id ? a.copyWith(isDeleted: false) : a)
            .toList(),
      );
    }

    try {
      await _repository.reactivateArtist(id);
      return true;
    } catch (e, st) {
      // Rollback nếu thất bại
      if (previousState != null) {
        state = AsyncValue.data(previousState);
      } else {
        state = AsyncValue.error(e, st);
      }
      return false;
    }
  }
}
