// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArtistResponse _$ArtistResponseFromJson(Map<String, dynamic> json) =>
    _ArtistResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      img: json['img'] as String?,
      cover: json['cover'] as String?,
      trackTotal: (json['trackTotal'] as num?)?.toInt() ?? 0,
      albumTotal: (json['albumTotal'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ArtistResponseToJson(_ArtistResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'img': instance.img,
      'cover': instance.cover,
      'trackTotal': instance.trackTotal,
      'albumTotal': instance.albumTotal,
    };
