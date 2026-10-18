import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/history_page_response.dart';

/// Readable error raised by [HistoryRepository]; its message is shown as-is in
/// the History error state.
class HistoryException implements Exception {
  final String message;

  const HistoryException(this.message);

  @override
  String toString() => message;
}

/// Listening history API.
///
/// `GET /api/tracking/history/{userId}?page=&size=` returns a Spring Data page:
/// `{ "content": [TrackResponseDTO...], "page": { size, number,
/// totalElements, totalPages } }`. The backend already de-duplicates by track
/// (latest listen per track, newest first).
class HistoryRepository {
  static const int defaultPageSize = 20;

  final DioClient _dioClient;

  HistoryRepository(this._dioClient);

  Future<HistoryPageResponse> getListeningHistory(
    int userId, {
    int page = 0,
    int size = defaultPageSize,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiEndpoints.history}/$userId',
        queryParameters: {'page': page, 'size': size},
      );

      return HistoryPageResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw HistoryException(_handleDioError(e));
    } catch (_) {
      throw const HistoryException(
        'Đã xảy ra lỗi không xác định. Vui lòng thử lại.',
      );
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
        if (statusCode == 401) {
          return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
        }
        if (statusCode == 403) {
          return 'Bạn không có quyền xem lịch sử này.';
        }
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
