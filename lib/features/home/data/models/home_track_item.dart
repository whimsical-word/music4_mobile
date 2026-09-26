class HomeTrackItem {
  final String id;
  final String title;
  final String artist;
  final String? artistId;
  final String? genre;
  final String duration;
  final String? playsCount;
  final int? matchPercentage;
  final String? coverUrl;

  const HomeTrackItem({
    required this.id,
    required this.title,
    required this.artist,
    this.artistId,
    this.genre,
    this.duration = '3:30',
    this.playsCount,
    this.matchPercentage,
    this.coverUrl,
  });
}
