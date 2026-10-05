import 'dart:async';

import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/search_repository.dart';
import '../../data/models/search_models.dart';

// Provider quản lý loại tìm kiếm đang được chọn (Tab/Chip)
final searchTypeProvider = StateProvider<String>((ref) => 'all');

// Provider cung cấp Repository
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(DioClient().dio);
});

// Provider quản lý State bằng AsyncValue
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

  void onSearchChanged(String query) {
    _currentQuery = query;
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    if (query.trim().isEmpty) {
      state = const AsyncData(null);
      return;
    }

    state = const AsyncLoading();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        final currentType = _ref.read(searchTypeProvider);
        final result = await _repository.search(query, type: currentType);
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
