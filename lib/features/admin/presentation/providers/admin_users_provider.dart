import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/admin_user_model.dart';
import '../../data/repositories/admin_repository.dart';

final adminUsersProvider =
    AsyncNotifierProvider<AdminUsersNotifier, List<AdminUserModel>>(() {
  return AdminUsersNotifier();
});

class AdminUsersNotifier extends AsyncNotifier<List<AdminUserModel>> {
  late final AdminRepository _repository;

  @override
  FutureOr<List<AdminUserModel>> build() {
    _repository = ref.watch(adminRepositoryProvider);
    return _fetchUsers();
  }

  Future<List<AdminUserModel>> _fetchUsers() async {
    final page = await _repository.getUsers();
    return page.content;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchUsers());
  }

  /// Vô hiệu hóa tài khoản người dùng (#UC61)
  Future<bool> disableUser(int id) => deleteUser(id);

  Future<bool> deleteUser(int id) async {
    final previousState = state.value;
    if (previousState != null) {
      // Optimistic update: đánh dấu isDeleted = true
      state = AsyncValue.data(
        previousState
            .map((u) => u.id == id ? u.copyWith(isDeleted: true) : u)
            .toList(),
      );
    }

    try {
      await _repository.deleteUser(id);
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

  Future<bool> reactivateUser(int id) async {
    final previousState = state.value;
    if (previousState != null) {
      // Optimistic update: đánh dấu isDeleted = false
      state = AsyncValue.data(
        previousState
            .map((u) => u.id == id ? u.copyWith(isDeleted: false) : u)
            .toList(),
      );
    }

    try {
      await _repository.reactivateUser(id);
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
