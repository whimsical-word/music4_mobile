// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_suggest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackSuggestModel _$TrackSuggestModelFromJson(Map<String, dynamic> json) =>
    _TrackSuggestModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      img: json['img'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      previewPath: json['previewPath'] as String?,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      matchScore: (json['matchScore'] as num?)?.toDouble(),
      artists:
          (json['artists'] as List<dynamic>?)
              ?.map((e) => TrackArtistInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TrackSuggestModelToJson(_TrackSuggestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'img': instance.img,
      'duration': instance.duration,
      'previewPath': instance.previewPath,
      'viewCount': instance.viewCount,
      'matchScore': instance.matchScore,
      'artists': instance.artists,
    };
