class Track {
  final String id;
  final String title;
  final String artistName;

  /// Resolved artwork URL; null when the backend has no image.
  final String? artworkUrl;
  final int durationSeconds;

  Track({
    required this.id,
    required this.title,
    required this.artistName,
    this.artworkUrl,
    required this.durationSeconds,
  });
}
