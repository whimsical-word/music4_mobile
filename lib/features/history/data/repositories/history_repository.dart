import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/history_page_response.dart';

class HistoryRepository {
  final Dio _dio;

  HistoryRepository(this._dio);

  Future<HistoryPageResponse> getListeningHistory(int userId, {int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.history}/$userId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      
      return HistoryPageResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.';
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Kết nối máy chủ quá thời gian. Vui lòng kiểm tra mạng.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return 'Không tìm thấy thông tin người dùng.';
        }
        return 'Lỗi máy chủ ($statusCode). Vui lòng thử lại sau.';
      case DioExceptionType.connectionError:
        return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.';
      default:
        return 'Đã xảy ra lỗi mạng không xác định.';
    }
  }
}
