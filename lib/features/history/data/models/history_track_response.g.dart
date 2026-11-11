// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_track_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistoryTrackResponse _$HistoryTrackResponseFromJson(
  Map<String, dynamic> json,
) => _HistoryTrackResponse(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  albumName: json['albumName'] as String,
  img: json['img'] as String?,
  duration: (json['duration'] as num).toInt(),
  filePath: json['filePath'] as String?,
  previewPath: json['previewPath'] as String?,
  viewCount: (json['viewCount'] as num?)?.toInt(),
  uploadDate: json['uploadDate'] as String?,
  playbackPosition: (json['playbackPosition'] as num).toInt(),
  artists:
      (json['artists'] as List<dynamic>?)
          ?.map((e) => TrackArtistInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$HistoryTrackResponseToJson(
  _HistoryTrackResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'albumName': instance.albumName,
  'img': instance.img,
  'duration': instance.duration,
  'filePath': instance.filePath,
  'previewPath': instance.previewPath,
  'viewCount': instance.viewCount,
  'uploadDate': instance.uploadDate,
  'playbackPosition': instance.playbackPosition,
  'artists': instance.artists,
};

_TrackArtistInfo _$TrackArtistInfoFromJson(Map<String, dynamic> json) =>
    _TrackArtistInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$TrackArtistInfoToJson(_TrackArtistInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
    };
