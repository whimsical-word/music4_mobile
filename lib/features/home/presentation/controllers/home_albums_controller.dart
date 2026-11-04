import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../album/data/models/album_model.dart';
import '../../data/sources/home_repository.dart';
import 'home_feed_controller.dart';

/// Loaded albums plus the paging flags the "Album nổi bật" tab needs.
class HomeAlbumsState {
  final List<AlbumModel> items;
  final bool hasMore;
  final bool isLoadingMore;

  const HomeAlbumsState({
    this.items = const [],
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  HomeAlbumsState copyWith({
    List<AlbumModel>? items,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return HomeAlbumsState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class HomeAlbumsNotifier extends StateNotifier<AsyncValue<HomeAlbumsState>> {
  static const int pageSize = 10;

  final HomeRepository _repository;
  int _nextPage = 0;

  HomeAlbumsNotifier(this._repository) : super(const AsyncValue.loading());

  /// First load / explicit retry: shows the loading state.
  Future<void> fetch() async {
    state = const AsyncValue.loading();
    try {
      final albums = await _repository.getAlbumsPage(page: 0, size: pageSize);
      if (!mounted) return;
      _nextPage = 1;
      state = AsyncValue.data(
        HomeAlbumsState(items: albums, hasMore: albums.length >= pageSize),
      );
    } catch (e, stackTrace) {
      if (!mounted) return;
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Appends the next page. No-op while loading or when there is no more.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));
    try {
      final albums = await _repository.getAlbumsPage(
        page: _nextPage,
        size: pageSize,
      );
      if (!mounted) return;
      _nextPage++;

      // The list can shift while the user scrolls: skip repeated albums.
      final knownIds = current.items.map((a) => a.id).toSet();
      final newItems = albums.where((a) => !knownIds.contains(a.id));

      state = AsyncValue.data(
        HomeAlbumsState(
          items: [...current.items, ...newItems],
          hasMore: albums.length >= pageSize,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      // Keep the list; scrolling to the bottom again retries.
      state = AsyncValue.data(current.copyWith(isLoadingMore: false));
    }
  }
}

/// autoDispose: created only while the "Album nổi bật" tab is on screen.
final homeAlbumsProvider =
    StateNotifierProvider.autoDispose<HomeAlbumsNotifier, AsyncValue<HomeAlbumsState>>(
      (ref) => HomeAlbumsNotifier(ref.watch(homeRepositoryProvider))..fetch(),
    );
