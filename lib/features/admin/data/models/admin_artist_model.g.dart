// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_artist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminArtistModel _$AdminArtistModelFromJson(Map<String, dynamic> json) =>
    _AdminArtistModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      img: json['img'] as String?,
      cover: json['cover'] as String?,
      email: json['email'] as String?,
      userName: json['userName'] as String?,
      trackTotal: (json['trackTotal'] as num?)?.toInt() ?? 0,
      albumTotal: (json['albumTotal'] as num?)?.toInt() ?? 0,
      isDeleted: json['isDeleted'] as bool? ?? false,
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$AdminArtistModelToJson(_AdminArtistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'img': instance.img,
      'cover': instance.cover,
      'email': instance.email,
      'userName': instance.userName,
      'trackTotal': instance.trackTotal,
      'albumTotal': instance.albumTotal,
      'isDeleted': instance.isDeleted,
      'enabled': instance.enabled,
    };
