import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_detail_model.freezed.dart';
part 'category_detail_model.g.dart';

@freezed
sealed class CategoryDetailModel with _$CategoryDetailModel {
  const factory CategoryDetailModel({
    required int id,
    required String name,
    @Default([]) List<CategoryTrackModel> tracks,
  }) = _CategoryDetailModel;

  factory CategoryDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryDetailModelFromJson(json);
}

@freezed
sealed class CategoryTrackModel with _$CategoryTrackModel {
  const factory CategoryTrackModel({
    required int id,
    required String name,
    String? albumName,
    String? img,
    int? duration,
    String? filePath,
    String? previewPath,
    int? viewCount,
    String? uploadDate,
    int? playbackPosition,
    @Default([]) List<CategoryTrackArtistInfo> artists,
  }) = _CategoryTrackModel;

  factory CategoryTrackModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryTrackModelFromJson(json);
}

@freezed
sealed class CategoryTrackArtistInfo with _$CategoryTrackArtistInfo {
  const factory CategoryTrackArtistInfo({
    required int id,
    required String name,
    String? role,
  }) = _CategoryTrackArtistInfo;

  factory CategoryTrackArtistInfo.fromJson(Map<String, dynamic> json) =>
      _$CategoryTrackArtistInfoFromJson(json);
}
