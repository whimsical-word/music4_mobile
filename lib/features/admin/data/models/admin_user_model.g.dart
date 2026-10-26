// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminUserModel _$AdminUserModelFromJson(Map<String, dynamic> json) =>
    _AdminUserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      img: json['img'] as String?,
      email: json['email'] as String,
      gender: json['gender'] as bool?,
      role: json['role'] as String,
      username: json['username'] as String,
      isDeleted: json['isDeleted'] as bool? ?? false,
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$AdminUserModelToJson(_AdminUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'img': instance.img,
      'email': instance.email,
      'gender': instance.gender,
      'role': instance.role,
      'username': instance.username,
      'isDeleted': instance.isDeleted,
      'enabled': instance.enabled,
    };
