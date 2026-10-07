import 'artist.dart';
import 'artist_album.dart';
import 'track.dart';

class ArtistDashboardStats {
  final int totalViews;
  final int totalLikes;
  final int totalFollowers;
  final int totalComments;

  /// Daily views of the most recent days (at most 7) and their labels.
  final List<int> chartViews;
  final List<String> chartLabels;

  ArtistDashboardStats({
    required this.totalViews,
    required this.totalLikes,
    required this.totalFollowers,
    required this.totalComments,
    required this.chartViews,
    this.chartLabels = const [],
  });
}

class ArtistProfileData {
  final Artist artist;
  final List<Track> popularTracks;
  final List<ArtistAlbum> albums;
  final bool isFollowing;
  final ArtistDashboardStats? dashboardStats;

  ArtistProfileData({
    required this.artist,
    required this.popularTracks,
    this.albums = const [],
    required this.isFollowing,
    this.dashboardStats,
  });

  ArtistProfileData copyWith({
    Artist? artist,
    List<Track>? popularTracks,
    List<ArtistAlbum>? albums,
    bool? isFollowing,
    ArtistDashboardStats? dashboardStats,
  }) {
    return ArtistProfileData(
      artist: artist ?? this.artist,
      popularTracks: popularTracks ?? this.popularTracks,
      albums: albums ?? this.albums,
      isFollowing: isFollowing ?? this.isFollowing,
      dashboardStats: dashboardStats ?? this.dashboardStats,
    );
  }
}
