import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final Dio _dio;

  NotificationRepository(this._dio);

  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.baseUrl}/api/notifications/user/$userId',
      );

      // Dữ liệu thô từ API

      final dynamic rawData = response.data;
      final List<dynamic> data = rawData is List
          ? rawData
          : (rawData['data'] ?? rawData['content'] ?? []);

      return data.map((json) {
        // Xử lý ngày tháng từ Spring Boot (có thể là chuỗi ISO hoặc Mảng [năm, tháng, ngày, giờ...])
        DateTime parsedDate = DateTime.now();
        if (json['createdAt'] != null) {
          final rawDate = json['createdAt'];
          if (rawDate is List && rawDate.length >= 3) {
            parsedDate = DateTime(
              rawDate[0], // Year
              rawDate[1], // Month
              rawDate[2], // Day
              rawDate.length > 3 ? rawDate[3] : 0, // Hour
              rawDate.length > 4 ? rawDate[4] : 0, // Minute
              rawDate.length > 5 ? rawDate[5] : 0, // Second
            );
          } else {
            parsedDate =
                DateTime.tryParse(rawDate.toString()) ?? DateTime.now();
          }
        }

        // Backend của bạn trả về: artistName, trackName, content thay vì title/message
        final artist = json['artistName'];
        final track = json['trackName'];
        final content = json['content'] ?? 'Bạn có một thông báo mới.';

        final finalTitle = artist != null
            ? 'Từ: $artist'
            : 'Thông báo hệ thống';
        final finalMessage = track != null ? '$content ($track)' : content;

        return NotificationModel(
          id: json['id'].toString(), // Ép an toàn kiểu int -> String
          title: finalTitle,
          message: finalMessage,
          isRead: json['isRead'] ?? false,
          createdAt: parsedDate,
        );
      }).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  Future<void> subscribe(String userId, String fcmToken) async {
    try {
      await _dio.post(
        '${ApiEndpoints.baseUrl}/api/notifications/subscribe/$userId',
        data: {'fcmToken': fcmToken},
      );
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
