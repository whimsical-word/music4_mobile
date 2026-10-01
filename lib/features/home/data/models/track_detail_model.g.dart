// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackDetailModel _$TrackDetailModelFromJson(Map<String, dynamic> json) =>
    _TrackDetailModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      img: json['img'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      filePath: json['filePath'] as String?,
      previewPath: json['previewPath'] as String?,
      uploadDate: json['uploadDate'] as String?,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      album: json['album'] == null
          ? null
          : AlbumInfo.fromJson(json['album'] as Map<String, dynamic>),
      artists:
          (json['artists'] as List<dynamic>?)
              ?.map((e) => TrackArtistInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map(
                (e) => TrackCategoryInfo.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TrackDetailModelToJson(_TrackDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'img': instance.img,
      'duration': instance.duration,
      'filePath': instance.filePath,
      'previewPath': instance.previewPath,
      'uploadDate': instance.uploadDate,
      'viewCount': instance.viewCount,
      'album': instance.album,
      'artists': instance.artists,
      'categories': instance.categories,
    };

_AlbumInfo _$AlbumInfoFromJson(Map<String, dynamic> json) => _AlbumInfo(
  id: (json['id'] as num).toInt(),
  title: json['name'] as String,
  coverUrl: json['img'] as String?,
  uploadDate: json['uploadDate'] as String?,
  trackTotal: (json['trackTotal'] as num?)?.toInt(),
  artistId: (json['artistId'] as num?)?.toInt(),
);

Map<String, dynamic> _$AlbumInfoToJson(_AlbumInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'img': instance.coverUrl,
      'uploadDate': instance.uploadDate,
      'trackTotal': instance.trackTotal,
      'artistId': instance.artistId,
    };

_TrackCategoryInfo _$TrackCategoryInfoFromJson(Map<String, dynamic> json) =>
    _TrackCategoryInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$TrackCategoryInfoToJson(_TrackCategoryInfo instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
