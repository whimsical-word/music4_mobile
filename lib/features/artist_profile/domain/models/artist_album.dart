/// An album shown on the artist profile (from `GET /api/albums/artist/{id}`).
class ArtistAlbum {
  final String id;
  final String title;

  /// Resolved cover URL; null when the backend has no image.
  final String? coverUrl;
  final int trackCount;

  ArtistAlbum({
    required this.id,
    required this.title,
    this.coverUrl,
    this.trackCount = 0,
  });
}
