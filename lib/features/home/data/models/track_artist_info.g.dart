// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_artist_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackArtistInfo _$TrackArtistInfoFromJson(Map<String, dynamic> json) =>
    _TrackArtistInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$TrackArtistInfoToJson(_TrackArtistInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
    };
