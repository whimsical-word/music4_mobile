import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/upload_repository.dart';

const List<CategoryModel> defaultBackendCategories = [
  CategoryModel(id: 1, name: 'Pop'),
  CategoryModel(id: 2, name: 'R&B'),
  CategoryModel(id: 3, name: 'Hip-Hop'),
  CategoryModel(id: 4, name: 'Rap'),
  CategoryModel(id: 5, name: 'Ballad'),
  CategoryModel(id: 6, name: 'Indie'),
  CategoryModel(id: 7, name: 'EDM'),
  CategoryModel(id: 8, name: 'Lofi'),
];

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  try {
    final dio = ref.watch(dioProvider);
    final response = await dio.get('/api/categories');
    if (response.statusCode == 200 && response.data is List) {
      final list = (response.data as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) return list;
    }
  } catch (_) {
    // If backend /api/categories is temporarily unreachable, fallback to default seed categories
  }
  return defaultBackendCategories;
});
