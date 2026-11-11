// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) => _AlbumModel(
  id: json['id'] as String,
  title: json['title'] as String,
  coverUrl: json['coverUrl'] as String?,
  artistId: json['artistId'] as String,
  artistName: json['artistName'] as String,
  trackCount: (json['trackCount'] as num?)?.toInt() ?? 0,
  releaseDate: DateTime.parse(json['releaseDate'] as String),
);

Map<String, dynamic> _$AlbumModelToJson(_AlbumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'coverUrl': instance.coverUrl,
      'artistId': instance.artistId,
      'artistName': instance.artistName,
      'trackCount': instance.trackCount,
      'releaseDate': instance.releaseDate.toIso8601String(),
    };
