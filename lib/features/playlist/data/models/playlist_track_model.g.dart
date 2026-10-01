// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackArtistInfoModel _$TrackArtistInfoModelFromJson(
  Map<String, dynamic> json,
) => _TrackArtistInfoModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$TrackArtistInfoModelToJson(
  _TrackArtistInfoModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'role': instance.role,
};

_PlaylistTrackModel _$PlaylistTrackModelFromJson(Map<String, dynamic> json) =>
    _PlaylistTrackModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      albumName: json['albumName'] as String?,
      img: json['img'] as String?,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      filePath: json['filePath'] as String?,
      previewPath: json['previewPath'] as String?,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      artists:
          (json['artists'] as List<dynamic>?)
              ?.map(
                (e) => TrackArtistInfoModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PlaylistTrackModelToJson(_PlaylistTrackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'albumName': instance.albumName,
      'img': instance.img,
      'duration': instance.duration,
      'filePath': instance.filePath,
      'previewPath': instance.previewPath,
      'viewCount': instance.viewCount,
      'artists': instance.artists,
    };
