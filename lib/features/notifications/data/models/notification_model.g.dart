// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: (json['id'] as num).toInt(),
      trackId: (json['trackId'] as num?)?.toInt(),
      trackName: json['trackName'] as String?,
      albumId: (json['albumId'] as num?)?.toInt(),
      albumName: json['albumName'] as String?,
      artistName: json['artistName'] as String?,
      content: json['content'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: parseNotificationDate(json['createdAt']),
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trackId': instance.trackId,
      'trackName': instance.trackName,
      'albumId': instance.albumId,
      'albumName': instance.albumName,
      'artistName': instance.artistName,
      'content': instance.content,
      'isRead': instance.isRead,
      'createdAt': _dateToJson(instance.createdAt),
    };
