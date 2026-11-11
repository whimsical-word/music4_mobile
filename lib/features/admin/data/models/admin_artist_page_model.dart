import 'package:freezed_annotation/freezed_annotation.dart';
import 'admin_artist_model.dart';

part 'admin_artist_page_model.freezed.dart';
part 'admin_artist_page_model.g.dart';

@freezed
sealed class AdminArtistPageModel with _$AdminArtistPageModel {
  const factory AdminArtistPageModel({
    @Default([]) List<AdminArtistModel> content,
    @Default(0) int pageNumber,
    @Default(20) int size,
    @Default(0) int totalElements,
    @Default(0) int totalPages,
    @Default(true) bool last,
  }) = _AdminArtistPageModel;

  factory AdminArtistPageModel.fromJson(Map<String, dynamic> json) =>
      _$AdminArtistPageModelFromJson(json);
}
