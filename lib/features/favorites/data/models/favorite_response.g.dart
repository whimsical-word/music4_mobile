// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavoriteResponse _$FavoriteResponseFromJson(Map<String, dynamic> json) =>
    _FavoriteResponse(
      favoriteId: (json['favoriteId'] as num).toInt(),
      trackId: (json['trackId'] as num).toInt(),
      trackName: json['trackName'] as String,
      artistName: json['artistName'] as String? ?? '',
      img: json['img'] as String?,
      likedAt: json['likedAt'] as String?,
    );

Map<String, dynamic> _$FavoriteResponseToJson(_FavoriteResponse instance) =>
    <String, dynamic>{
      'favoriteId': instance.favoriteId,
      'trackId': instance.trackId,
      'trackName': instance.trackName,
      'artistName': instance.artistName,
      'img': instance.img,
      'likedAt': instance.likedAt,
    };
