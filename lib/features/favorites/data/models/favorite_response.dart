import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_response.freezed.dart';
part 'favorite_response.g.dart';

/// `GET /api/favorites/me` -> list of FavoriteResponseDTO.
///
/// `artistName` is the artists' names already joined with ", " (empty string
/// when the track has no artist). There is no duration in this DTO.
@freezed
abstract class FavoriteResponse with _$FavoriteResponse {
  const factory FavoriteResponse({
    required int favoriteId,
    required int trackId,
    required String trackName,
    @Default('') String artistName,
    String? img,

    /// ISO local date-time, e.g. 2026-10-08T12:30:45.123456.
    String? likedAt,
  }) = _FavoriteResponse;

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) =>
      _$FavoriteResponseFromJson(json);
}
