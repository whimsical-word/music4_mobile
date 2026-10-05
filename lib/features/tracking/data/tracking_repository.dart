import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';

/// Readable error raised by [TrackingRepository].
class TrackingException implements Exception {
  final String message;

  const TrackingException(this.message);

  @override
  String toString() => message;
}

/// Listening tracking API.
///
/// - `POST /api/tracking/history`  : a track was genuinely listened to the end
///   (backend: VIEW +1 and a History row).
/// - `PUT  /api/tracking/sync-time`: save the current playback position so the
///   user can resume later.
class TrackingRepository {
  final DioClient _dioClient;

  TrackingRepository(this._dioClient);

  Future<void> recordCompletion(int trackId) async {
    try {
      await _dioClient.dio.post(ApiEndpoints.history, data: {'trackId': trackId});
    } on DioException catch (e) {
      throw TrackingException(_handleError(e));
    }
  }

  Future<void> syncPlaybackPosition({
    required int userId,
    required int trackId,
    required int positionSeconds,
  }) async {
    try {
      await _dioClient.dio.put(
        ApiEndpoints.syncPlaybackTime,
        data: {
          'userId': userId,
          'trackId': trackId,
          'position': positionSeconds,
        },
      );
    } on DioException catch (e) {
      throw TrackingException(_handleError(e));
    }
  }

  String _handleError(DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 401) return 'Phiên đăng nhập đã hết hạn';
    if (statusCode == 403) return 'Bạn không có quyền thực hiện thao tác này';
    if (statusCode == 404) return 'Không tìm thấy dữ liệu';

    return 'Lỗi kết nối máy chủ';
  }
}
