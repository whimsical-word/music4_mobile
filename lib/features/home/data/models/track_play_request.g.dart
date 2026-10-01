// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_play_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackPlayRequest _$TrackPlayRequestFromJson(Map<String, dynamic> json) =>
    _TrackPlayRequest(
      trackId: json['trackId'] as String,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$TrackPlayRequestToJson(_TrackPlayRequest instance) =>
    <String, dynamic>{'trackId': instance.trackId, 'userId': instance.userId};
