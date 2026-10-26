// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminUserPageModel _$AdminUserPageModelFromJson(Map<String, dynamic> json) =>
    _AdminUserPageModel(
      content:
          (json['content'] as List<dynamic>?)
              ?.map((e) => AdminUserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 20,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      last: json['last'] as bool? ?? true,
    );

Map<String, dynamic> _$AdminUserPageModelToJson(_AdminUserPageModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'pageNumber': instance.pageNumber,
      'size': instance.size,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
    };
