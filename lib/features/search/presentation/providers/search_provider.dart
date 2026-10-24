import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/models/search_models.dart';
import '../../data/repositories/search_repository.dart';

/// Provider quản lý loại tìm kiếm đang được chọn trên FilterChip (all, track, artist, album, category)
final searchTypeProvider = StateProvider<String>((ref) => 'all');

/// Provider cung cấp SearchRepository dùng DioClient nội bộ
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(DioClient().dio);
});

/// Provider quản lý trạng thái tìm kiếm bằng AsyncValue
final searchProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<SearchResponse?>>((ref) {
      return SearchNotifier(ref.watch(searchRepositoryProvider), ref);
    });

class SearchNotifier extends StateNotifier<AsyncValue<SearchResponse?>> {
  final SearchRepository _repository;
  final Ref _ref;
  Timer? _debounceTimer;
  String _currentQuery = '';

  SearchNotifier(this._repository, this._ref) : super(const AsyncData(null));

  void onSearchChanged(String query, {int page = 0, int size = 20}) {
    _currentQuery = query;
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = const AsyncData(null);
      return;
    }

    state = const AsyncLoading();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        final currentType = _ref.read(searchTypeProvider);
        final result = await _repository.search(
          trimmed,
          type: currentType,
          page: page,
          size: size,
        );
        if (mounted) {
          state = AsyncData(result);
        }
      } catch (e, stack) {
        if (mounted) {
          state = AsyncError(e.toString().replaceAll('Exception: ', ''), stack);
        }
      }
    });
  }

  void refreshSearch() {
    if (_currentQuery.trim().isNotEmpty) {
      onSearchChanged(_currentQuery);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
