import 'artist.dart';
import 'artist_album.dart';
import 'track.dart';

/// One day of activity, from the backend's `chartData`. The backend only
/// returns days that had activity, within the last 30 days.
class DailyActivity {
  final DateTime date;
  final int views;
  final int likes;

  const DailyActivity({
    required this.date,
    required this.views,
    required this.likes,
  });
}

class ArtistDashboardStats {
  final int totalViews;
  final int totalLikes;
  final int totalFollowers;
  final int totalComments;

  /// Daily activity of the last 30 days, oldest first (days without activity
  /// are absent).
  final List<DailyActivity> daily;

  ArtistDashboardStats({
    required this.totalViews,
    required this.totalLikes,
    required this.totalFollowers,
    required this.totalComments,
    this.daily = const [],
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
