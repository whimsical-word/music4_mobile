import 'package:freezed_annotation/freezed_annotation.dart';

import 'track_artist_info.dart';

part 'track_detail_model.freezed.dart';
part 'track_detail_model.g.dart';

@freezed
abstract class TrackDetailModel with _$TrackDetailModel {
  const factory TrackDetailModel({
    required int id,
    required String name,
    String? img,
    int? duration,
    String? filePath,
    String? previewPath,
    String? uploadDate,
    @Default(0) int viewCount,
    AlbumInfo? album,
    @Default([]) List<TrackArtistInfo> artists,
    @Default([]) List<TrackCategoryInfo> categories,
  }) = _TrackDetailModel;

  factory TrackDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TrackDetailModelFromJson(json);
}

@freezed
abstract class AlbumInfo with _$AlbumInfo {
  const factory AlbumInfo({
    required int id,
    @JsonKey(name: 'name') required String title,
    @JsonKey(name: 'img') String? coverUrl,
    String? uploadDate,
    int? trackTotal,
    int? artistId,
  }) = _AlbumInfo;

  factory AlbumInfo.fromJson(Map<String, dynamic> json) =>
      _$AlbumInfoFromJson(json);
}

@freezed
abstract class TrackCategoryInfo with _$TrackCategoryInfo {
  const factory TrackCategoryInfo({required int id, required String name}) =
      _TrackCategoryInfo;

  factory TrackCategoryInfo.fromJson(Map<String, dynamic> json) =>
      _$TrackCategoryInfoFromJson(json);
}
