import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/search_models.dart';

class SearchRepository {
  final Dio _dio;

  SearchRepository(this._dio);

  Future<SearchResponse> search(
    String query, {
    String type = 'all',
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.search,
        queryParameters: {
          'q': query,
          'type': type,
          'page': page,
          'size': size,
        },
      );
      return SearchResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Lỗi hệ thống: $e');
    }
  }

  String _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Kết nối mạng quá chậm, vui lòng thử lại.';
    }
    if (error.response != null) {
      return 'Lỗi Server (${error.response?.statusCode}).';
    }
    return 'Không có kết nối đến máy chủ backend.';
  }
}
