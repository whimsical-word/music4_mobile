// Trigger build_runner
import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_model.freezed.dart';
part 'album_model.g.dart';

@freezed
sealed class AlbumModel with _$AlbumModel {
  const factory AlbumModel({
    required String id,
    required String title,
    String? coverUrl,
    required String artistId,
    required String artistName,
    @Default(0) int trackCount,
    required DateTime releaseDate,
  }) = _AlbumModel;

  factory AlbumModel.fromJson(Map<String, dynamic> json) => _$AlbumModelFromJson(json);
}
