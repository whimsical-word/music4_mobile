// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlaylistModel _$PlaylistModelFromJson(Map<String, dynamic> json) =>
    _PlaylistModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      coverUrl: _readImg(json, 'coverUrl') as String?,
      trackCount: (json['trackCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$PlaylistModelToJson(_PlaylistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'coverUrl': instance.coverUrl,
      'trackCount': instance.trackCount,
      'createdAt': instance.createdAt,
    };
