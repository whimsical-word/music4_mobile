import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/category_detail_model.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(DioClient().dio);
});

class CategoryException implements Exception {
  final String message;
  const CategoryException(this.message);

  @override
  String toString() => message;
}

class CategoryRepository {
  final Dio _dio;

  CategoryRepository(this._dio);

  Future<CategoryDetailModel> getCategoryDetail(int categoryId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.categories}/$categoryId');
      final data = response.data as Map<String, dynamic>;
      return CategoryDetailModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const CategoryException('Không tìm thấy thể loại nhạc này.');
      }
      throw CategoryException(
        e.response?.data?.toString() ?? 'Lỗi kết nối máy chủ.',
      );
    } catch (e) {
      throw CategoryException('Lỗi tải chi tiết thể loại: $e');
    }
  }
}
