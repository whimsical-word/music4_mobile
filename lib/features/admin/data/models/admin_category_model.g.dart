// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminCategoryModel _$AdminCategoryModelFromJson(Map<String, dynamic> json) =>
    _AdminCategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      trackCount: (json['trackCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AdminCategoryModelToJson(_AdminCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'trackCount': instance.trackCount,
    };
