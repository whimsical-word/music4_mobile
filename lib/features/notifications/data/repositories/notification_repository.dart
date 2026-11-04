import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final Dio _dio;

  NotificationRepository(this._dio);

  /// GET /api/notifications/user/{userId}
  Future<List<NotificationModel>> getNotifications(int userId) async {
    return _guard(() async {
      final response = await _dio.get('${ApiEndpoints.notifications}/$userId');
      final raw = response.data;
      final List<dynamic> data = raw is List
          ? raw
          : (raw['data'] ?? raw['content'] ?? const []) as List<dynamic>;
      return data
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  /// PUT /api/notifications/{id}/read
  Future<void> markAsRead(int id) =>
      _guard(() => _dio.put('${ApiEndpoints.notificationBase}/$id/read'));

  /// DELETE /api/notifications/{id}
  Future<void> deleteNotification(int id) =>
      _guard(() => _dio.delete('${ApiEndpoints.notificationBase}/$id'));

  /// DELETE /api/notifications/clear-all (BE lấy user từ JWT)
  Future<void> clearAll() =>
      _guard(() => _dio.delete('${ApiEndpoints.notificationBase}/clear-all'));

  Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  String _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Kết nối mạng quá chậm, vui lòng thử lại sau.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.';
    }
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 404) return 'Không tìm thấy dữ liệu.';
      return 'Máy chủ báo lỗi ($statusCode). Vui lòng thử lại sau.';
    }
    return 'Đã có lỗi mạng xảy ra.';
  }
}
