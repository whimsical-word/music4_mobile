import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/category_detail_model.dart';
import '../../data/repositories/category_repository.dart';

final categoryDetailProvider = AutoDisposeAsyncNotifierProviderFamily<
    CategoryDetailNotifier, CategoryDetailModel, int>(
  () => CategoryDetailNotifier(),
);

class CategoryDetailNotifier
    extends AutoDisposeFamilyAsyncNotifier<CategoryDetailModel, int> {
  @override
  FutureOr<CategoryDetailModel> build(int arg) {
    return ref.watch(categoryRepositoryProvider).getCategoryDetail(arg);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(categoryRepositoryProvider).getCategoryDetail(arg),
    );
  }
}
