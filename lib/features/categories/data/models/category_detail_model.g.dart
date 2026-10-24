// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryDetailModel _$CategoryDetailModelFromJson(Map<String, dynamic> json) =>
    _CategoryDetailModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      tracks:
          (json['tracks'] as List<dynamic>?)
              ?.map(
                (e) => CategoryTrackModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CategoryDetailModelToJson(
  _CategoryDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'tracks': instance.tracks,
};

_CategoryTrackModel _$CategoryTrackModelFromJson(Map<String, dynamic> json) =>
    _CategoryTrackModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      albumName: json['albumName'] as String?,
      img: json['img'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      filePath: json['filePath'] as String?,
      previewPath: json['previewPath'] as String?,
      viewCount: (json['viewCount'] as num?)?.toInt(),
      uploadDate: json['uploadDate'] as String?,
      playbackPosition: (json['playbackPosition'] as num?)?.toInt(),
      artists:
          (json['artists'] as List<dynamic>?)
              ?.map(
                (e) =>
                    CategoryTrackArtistInfo.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CategoryTrackModelToJson(_CategoryTrackModel instance) =>
    <String, dynamic>{
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

_CategoryTrackArtistInfo _$CategoryTrackArtistInfoFromJson(
  Map<String, dynamic> json,
) => _CategoryTrackArtistInfo(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  role: json['role'] as String?,
);

Map<String, dynamic> _$CategoryTrackArtistInfoToJson(
  _CategoryTrackArtistInfo instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'role': instance.role,
};
