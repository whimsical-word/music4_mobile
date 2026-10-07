import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist_response.freezed.dart';
part 'artist_response.g.dart';

/// `GET /api/artists/{id}` -> ArtistResponseDTO.
///
/// The backend also returns `email` and `userName`; they are not needed by the
/// profile screen, so they are intentionally not parsed. There is no biography
/// and no follower count in this DTO.
@freezed
abstract class ArtistResponse with _$ArtistResponse {
  const factory ArtistResponse({
    required int id,
    required String name,
    String? img,
    String? cover,
    @Default(0) int trackTotal,
    @Default(0) int albumTotal,
  }) = _ArtistResponse;

  factory ArtistResponse.fromJson(Map<String, dynamic> json) =>
      _$ArtistResponseFromJson(json);
}
