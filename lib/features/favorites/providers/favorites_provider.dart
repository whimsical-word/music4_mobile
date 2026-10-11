import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/notifiers/auth_notifier.dart';
import '../../auth/presentation/notifiers/auth_state.dart';
import '../data/repositories/favorites_repository.dart';
import '../domain/models/favorite_track.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(ref.read(dioClientProvider));
});

/// Outcome of removing a track from the favorites list.
enum FavoriteRemoveResult {
  /// The backend unliked it and it left the list.
  removed,

  /// The backend answered `liked: true`: it was already unliked elsewhere and
  /// the toggle re-added it, so it stays in the list.
  stillFavorite,

  /// A request for this track is already running; this tap is ignored.
  inProgress,

  /// The request failed; the list is unchanged.
  failed,
}

class FavoritesNotifier extends AutoDisposeAsyncNotifier<List<FavoriteTrack>> {
  /// Track ids with a toggle request in flight (prevents duplicate toggles:
  /// the backend only has a toggle, so a second request would undo the first).
  final Set<String> _pending = {};

  @override
  Future<List<FavoriteTrack>> build() async {
    // Favorites belong to the signed-in user: a different user (or a sign-out)
    // rebuilds this provider, so one user never sees another's list. The
    // backend reads the user from the JWT, so the id itself is not sent.
    final userId = ref.watch(
      authNotifierProvider.select(
        (auth) => auth is AuthAuthenticated ? auth.user.id : null,
      ),
    );
    if (userId == null) {
      throw const FavoritesException(
        'Vui lòng đăng nhập để xem danh sách yêu thích.',
      );
    }
    return _fetchFavorites();
  }

  Future<List<FavoriteTrack>> _fetchFavorites() async {
    final responses = await ref
        .read(favoritesRepositoryProvider)
        .getMyFavorites();

    // The backend does not order the list: newest like first.
    final tracks = responses.map(FavoriteTrack.fromResponse).toList()
      ..sort((a, b) {
        final aTime = a.addedAt;
        final bTime = b.addedAt;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });
    return tracks;
  }

  /// Explicit retry: shows the loading state.
  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchFavorites);
  }

  /// Pull-to-refresh: keeps the current list until new data arrives, and keeps
  /// it if the refresh fails.
  Future<void> refresh() async {
    if (!state.hasValue) return retry();
    try {
      state = AsyncValue.data(await _fetchFavorites());
    } catch (_) {
      // Keep the list that is already displayed.
    }
  }

  /// Removes [trackId] from the favorites through the backend. The list only
  /// changes after the backend confirms.
  Future<FavoriteRemoveResult> removeFavorite(String trackId) async {
    final id = int.tryParse(trackId);
    final current = state.valueOrNull;
    if (id == null || current == null) return FavoriteRemoveResult.failed;
    if (!_pending.add(trackId)) return FavoriteRemoveResult.inProgress;

    try {
      final liked = await ref.read(favoritesRepositoryProvider).toggleFavorite(id);
      if (liked) return FavoriteRemoveResult.stillFavorite;

      final latest = state.valueOrNull ?? current;
      state = AsyncValue.data(
        latest.where((track) => track.id != trackId).toList(),
      );
      return FavoriteRemoveResult.removed;
    } catch (_) {
      return FavoriteRemoveResult.failed;
    } finally {
      _pending.remove(trackId);
    }
  }
}

final favoritesProvider =
    AsyncNotifierProvider.autoDispose<FavoritesNotifier, List<FavoriteTrack>>(
      FavoritesNotifier.new,
    );
