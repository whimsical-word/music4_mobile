import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/search_models.dart';

class SearchRepository {
  final Dio _dio;

  SearchRepository(this._dio);

  Future<SearchResponse> search(String query, {String type = 'all'}) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.baseUrl}/api/search',
        queryParameters: {'q': query, 'type': type},
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
