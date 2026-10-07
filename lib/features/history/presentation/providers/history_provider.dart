import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../data/models/history_track_response.dart';
import '../../data/repositories/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(ref.read(dioClientProvider));
});

/// Loaded history plus the paging flags the screen needs.
class HistoryState {
  final List<HistoryTrackResponse> items;
  final bool hasMore;
  final bool isLoadingMore;

  const HistoryState({
    this.items = const [],
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  HistoryState copyWith({
    List<HistoryTrackResponse>? items,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return HistoryState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class HistoryNotifier extends StateNotifier<AsyncValue<HistoryState>> {
  static const int pageSize = HistoryRepository.defaultPageSize;

  final HistoryRepository _repository;

  /// The signed-in user's id, or null for a guest (History is auth-only).
  final int? _userId;

  int _nextPage = 0;

  HistoryNotifier(this._repository, this._userId)
    : super(const AsyncValue.loading());

  /// First load / explicit retry: shows the loading state.
  Future<void> fetchHistory() async {
    final userId = _userId;
    if (userId == null) {
      state = const AsyncValue.error(
        HistoryException('Vui lòng đăng nhập để xem lịch sử nghe nhạc.'),
        StackTrace.empty,
      );
      return;
    }

    state = const AsyncValue.loading();
    try {
      final page = await _repository.getListeningHistory(
        userId,
        page: 0,
        size: pageSize,
      );
      if (!mounted) return;
      _nextPage = 1;
      state = AsyncValue.data(
        HistoryState(
          items: page.content,
          hasMore: page.content.length >= pageSize,
        ),
      );
    } catch (e, stackTrace) {
      if (!mounted) return;
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Pull-to-refresh: keeps the current list on screen until new data arrives,
  /// and keeps it if the refresh fails.
  Future<void> refreshHistory() async {
    final userId = _userId;
    if (userId == null || !state.hasValue) {
      return fetchHistory();
    }

    try {
      final page = await _repository.getListeningHistory(
        userId,
        page: 0,
        size: pageSize,
      );
      if (!mounted) return;
      _nextPage = 1;
      state = AsyncValue.data(
        HistoryState(
          items: page.content,
          hasMore: page.content.length >= pageSize,
        ),
      );
    } catch (_) {
      // Keep the list that is already displayed.
    }
  }

  /// Appends the next page (infinite scroll). No-op while loading or when
  /// there is nothing more to load.
  Future<void> loadMore() async {
    final userId = _userId;
    final current = state.valueOrNull;
    if (userId == null ||
        current == null ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));
    try {
      final page = await _repository.getListeningHistory(
        userId,
        page: _nextPage,
        size: pageSize,
      );
      if (!mounted) return;
      _nextPage++;

      // The list can shift while the user listens, so skip repeated tracks.
      final knownIds = current.items.map((e) => e.id).toSet();
      final newItems = page.content.where((e) => !knownIds.contains(e.id));

      state = AsyncValue.data(
        HistoryState(
          items: [...current.items, ...newItems],
          hasMore: page.content.length >= pageSize,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      // Keep the list; the next scroll to the bottom tries again.
      state = AsyncValue.data(current.copyWith(isLoadingMore: false));
    }
  }
}

/// autoDispose: History is re-fetched every time the screen is opened, and a
/// different signed-in user never sees the previous user's cached history.
final historyNotifierProvider =
    StateNotifierProvider.autoDispose<HistoryNotifier, AsyncValue<HistoryState>>(
      (ref) {
        final repository = ref.watch(historyRepositoryProvider);
        final userId = ref.watch(
          authNotifierProvider.select(
            (auth) => auth is AuthAuthenticated ? auth.user.id : null,
          ),
        );
        return HistoryNotifier(repository, userId)..fetchHistory();
      },
    );
