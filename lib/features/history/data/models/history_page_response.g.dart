// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_page_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistoryPageResponse _$HistoryPageResponseFromJson(Map<String, dynamic> json) =>
    _HistoryPageResponse(
      content:
          (json['content'] as List<dynamic>?)
              ?.map(
                (e) => HistoryTrackResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 10,
      number: (json['number'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$HistoryPageResponseToJson(
  _HistoryPageResponse instance,
) => <String, dynamic>{
  'content': instance.content,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'size': instance.size,
  'number': instance.number,
};
