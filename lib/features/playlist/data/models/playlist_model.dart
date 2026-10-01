import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_model.freezed.dart';
part 'playlist_model.g.dart';

@freezed
abstract class PlaylistModel with _$PlaylistModel {
  const factory PlaylistModel({
    required int id,
    required String name,
    String? description,
    String? coverUrl,
    @Default(0) int trackCount,
    String? createdAt,
  }) = _PlaylistModel;

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);
}
