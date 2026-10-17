import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// Loại thông báo, suy ra từ dữ liệu đích Backend trả về (BE không có cột `type`).
enum NotificationType { newTrack, newAlbum, system }

/// Spring Boot có thể trả `LocalDateTime` dạng chuỗi ISO hoặc mảng
/// `[năm, tháng, ngày, giờ, phút, giây, nano]` → chấp nhận cả hai.
DateTime parseNotificationDate(Object? raw) {
  if (raw is List && raw.length >= 3) {
    return DateTime(
      raw[0] as int,
      raw[1] as int,
      raw[2] as int,
      raw.length > 3 ? raw[3] as int : 0,
      raw.length > 4 ? raw[4] as int : 0,
      raw.length > 5 ? raw[5] as int : 0,
    );
  }
  return DateTime.tryParse(raw?.toString() ?? '') ?? DateTime.now();
}

String _dateToJson(DateTime date) => date.toIso8601String();

/// Khớp 1-1 với `NotificationResponseDTO` của Backend (REST và SSE dùng chung).
@freezed
abstract class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required int id,
    int? trackId,
    String? trackName,
    int? albumId,
    String? albumName,
    String? artistName,
    @Default('') String content,
    @Default(false) bool isRead,
    @JsonKey(fromJson: parseNotificationDate, toJson: _dateToJson)
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  NotificationType get type {
    if (trackId != null) return NotificationType.newTrack;
    if (albumId != null) return NotificationType.newAlbum;
    return NotificationType.system;
  }

  String get title => switch (type) {
    NotificationType.newTrack => 'Bài hát mới',
    NotificationType.newAlbum => 'Album mới',
    NotificationType.system => 'Thông báo hệ thống',
  };
}
