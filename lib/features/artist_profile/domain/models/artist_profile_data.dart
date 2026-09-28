import 'artist.dart';
import 'track.dart';

class ArtistDashboardStats {
  final int totalViews;
  final int totalLikes;
  final int totalFollowers;
  final int totalComments;
  final List<int> chartViews; // Mock 7 days data

  ArtistDashboardStats({
    required this.totalViews,
    required this.totalLikes,
    required this.totalFollowers,
    required this.totalComments,
    required this.chartViews,
  });
}

class ArtistProfileData {
  final Artist artist;
  final List<Track> popularTracks;
  final bool isFollowing;
  final ArtistDashboardStats? dashboardStats;

  ArtistProfileData({
    required this.artist,
    required this.popularTracks,
    required this.isFollowing,
    this.dashboardStats,
  });

  ArtistProfileData copyWith({
    Artist? artist,
    List<Track>? popularTracks,
    bool? isFollowing,
    ArtistDashboardStats? dashboardStats,
  }) {
    return ArtistProfileData(
      artist: artist ?? this.artist,
      popularTracks: popularTracks ?? this.popularTracks,
      isFollowing: isFollowing ?? this.isFollowing,
      dashboardStats: dashboardStats ?? this.dashboardStats,
    );
  }
}
