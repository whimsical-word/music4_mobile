import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_artist_model.freezed.dart';
part 'admin_artist_model.g.dart';

@freezed
sealed class AdminArtistModel with _$AdminArtistModel {
  const factory AdminArtistModel({
    required int id,
    required String name,
    String? img,
    String? cover,
    String? email,
    String? userName,
    @Default(0) int trackTotal,
    @Default(0) int albumTotal,
    @Default(false) bool isDeleted,
    @Default(true) bool enabled,
  }) = _AdminArtistModel;

  factory AdminArtistModel.fromJson(Map<String, dynamic> json) =>
      _$AdminArtistModelFromJson(json);
}
