import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/admin_category_model.dart';
import '../../data/repositories/admin_repository.dart';

final adminCategoriesProvider =
    AsyncNotifierProvider<AdminCategoriesNotifier, List<AdminCategoryModel>>(
  () => AdminCategoriesNotifier(),
);

class AdminCategoriesNotifier extends AsyncNotifier<List<AdminCategoryModel>> {
  late final AdminRepository _repository;

  @override
  FutureOr<List<AdminCategoryModel>> build() {
    _repository = ref.watch(adminRepositoryProvider);
    return _fetchCategories();
  }

  Future<List<AdminCategoryModel>> _fetchCategories() async {
    return _repository.getCategories();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCategories());
  }

  /// Tạo mới thể loại nhạc (#UC58)
  Future<void> createCategory(String name) async {
    final newCat = await _repository.createCategory(name);
    final current = state.value ?? [];
    state = AsyncValue.data([...current, newCat]);
  }

  /// Cập nhật thông tin thể loại nhạc (#UC59)
  Future<void> updateCategory(int id, String name) async {
    final updated = await _repository.updateCategory(id, name);
    final current = state.value ?? [];
    state = AsyncValue.data(
      current.map((c) => c.id == id ? updated : c).toList(),
    );
  }

  Future<void> deleteCategory(int id) async {
    final previousState = state.value;
    if (previousState != null) {
      state = AsyncValue.data(previousState.where((c) => c.id != id).toList());
    }

    try {
      await _repository.deleteCategory(id);
    } catch (e) {
      if (previousState != null) {
        state = AsyncValue.data(previousState);
      }
      rethrow;
    }
  }
}
