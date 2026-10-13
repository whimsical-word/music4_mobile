import '../../../../core/utils/image_url_helper.dart';
import '../../data/models/favorite_response.dart';

/// A favorite track as shown by FavoritesScreen.
class FavoriteTrack {
  /// Track id (the backend's `trackId`, not the favorite row id).
  final String id;
  final String title;
  final String artist;

  /// Resolved cover URL; null when the backend has no image.
  final String? coverUrl;
  final DateTime? addedAt;

  FavoriteTrack({
    required this.id,
    required this.title,
    required this.artist,
    this.coverUrl,
    this.addedAt,
  });

  factory FavoriteTrack.fromResponse(FavoriteResponse response) {
    return FavoriteTrack(
      id: response.trackId.toString(),
      title: response.trackName,
      artist: response.artistName.isEmpty
          ? 'Không rõ nghệ sĩ'
          : response.artistName,
      coverUrl: ImageUrlHelper.resolve(response.img),
      addedAt: DateTime.tryParse(response.likedAt ?? ''),
    );
  }
}
