// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchItem _$SearchItemFromJson(Map<String, dynamic> json) =>
    _SearchItem(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$SearchItemToJson(_SearchItem instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_SearchPage _$SearchPageFromJson(Map<String, dynamic> json) => _SearchPage(
  content:
      (json['content'] as List<dynamic>?)
          ?.map((e) => SearchItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SearchItem>[],
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
  totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SearchPageToJson(_SearchPage instance) =>
    <String, dynamic>{
      'content': instance.content,
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
    };

_SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) =>
    _SearchResponse(
      tracks: json['tracks'] == null
          ? null
          : SearchPage.fromJson(json['tracks'] as Map<String, dynamic>),
      albums: json['albums'] == null
          ? null
          : SearchPage.fromJson(json['albums'] as Map<String, dynamic>),
      artists: json['artists'] == null
          ? null
          : SearchPage.fromJson(json['artists'] as Map<String, dynamic>),
      categories: json['categories'] == null
          ? null
          : SearchPage.fromJson(json['categories'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchResponseToJson(_SearchResponse instance) =>
    <String, dynamic>{
      'tracks': instance.tracks,
      'albums': instance.albums,
      'artists': instance.artists,
      'categories': instance.categories,
    };
