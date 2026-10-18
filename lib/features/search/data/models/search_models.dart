import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_models.freezed.dart';
part 'search_models.g.dart';

@freezed
sealed class SearchArtistInfo with _$SearchArtistInfo {
  const factory SearchArtistInfo({
    required int id,
    required String name,
    String? role,
  }) = _SearchArtistInfo;

  factory SearchArtistInfo.fromJson(Map<String, dynamic> json) =>
      _$SearchArtistInfoFromJson(json);
}

@freezed
sealed class SearchItem with _$SearchItem {
  const factory SearchItem({
    required int id,
    required String name,
    String? img,
    String? albumName,
    int? duration,
    @Default(<SearchArtistInfo>[]) List<SearchArtistInfo> artists,
  }) = _SearchItem;

  factory SearchItem.fromJson(Map<String, dynamic> json) =>
      _$SearchItemFromJson(json);
}

extension SearchItemX on SearchItem {
  String get artistNames {
    if (artists.isEmpty) return 'Nghệ sĩ độc lập';
    return artists.map((a) => a.name).join(', ');
  }
}

@freezed
sealed class SearchPage with _$SearchPage {
  const factory SearchPage({
    @Default(<SearchItem>[]) List<SearchItem> content,
    @Default(0) int totalPages,
    @Default(0) int totalElements,
  }) = _SearchPage;

  factory SearchPage.fromJson(Map<String, dynamic> json) =>
      _$SearchPageFromJson(json);
}

@freezed
sealed class SearchResponse with _$SearchResponse {
  const factory SearchResponse({
    SearchPage? tracks,
    SearchPage? albums,
    SearchPage? artists,
    SearchPage? categories,
  }) = _SearchResponse;

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);
}
