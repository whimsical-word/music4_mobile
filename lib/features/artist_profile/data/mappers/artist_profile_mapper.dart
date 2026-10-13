import '../../../../core/utils/image_url_helper.dart';
import '../../../home/data/models/track_detail_model.dart';
import '../../domain/models/artist.dart';
import '../../domain/models/artist_album.dart';
import '../../domain/models/artist_profile_data.dart';
import '../../domain/models/track.dart';
import '../models/artist_overview_response.dart';
import '../models/artist_response.dart';

/// Backend DTO -> Artist Profile domain models (pure functions).
class ArtistProfileMapper {
  ArtistProfileMapper._();

  static Artist toArtist(ArtistResponse response, {int? followersCount}) {
    return Artist(
      id: response.id.toString(),
      name: response.name,
      avatarUrl: ImageUrlHelper.resolve(response.img),
      coverUrl: ImageUrlHelper.resolve(response.cover),
      followersCount: followersCount,
    );
  }

  /// The backend returns every track of the artist (no ranking), so they are
  /// ordered by view count, most listened first.
  static List<Track> toPopularTracks(
    List<TrackDetailModel> tracks, {
    required String fallbackArtistName,
  }) {
    final sorted = [...tracks]
      ..sort((a, b) {
        final byViews = b.viewCount.compareTo(a.viewCount);
        return byViews != 0 ? byViews : a.id.compareTo(b.id);
      });

    return sorted
        .map(
          (t) => Track(
            id: t.id.toString(),
            title: t.name,
            artistName: t.artists.isNotEmpty
                ? t.artists.map((a) => a.name).join(', ')
                : fallbackArtistName,
            artworkUrl: ImageUrlHelper.resolve(t.img),
            durationSeconds: t.duration ?? 0,
            viewCount: t.viewCount,
          ),
        )
        .toList();
  }

  /// Newest album first (`uploadDate` is an ISO date, so strings sort fine).
  static List<ArtistAlbum> toAlbums(List<AlbumInfo> albums) {
    final sorted = [...albums]
      ..sort((a, b) => (b.uploadDate ?? '').compareTo(a.uploadDate ?? ''));

    return sorted
        .map(
          (a) => ArtistAlbum(
            id: a.id.toString(),
            title: a.title,
            coverUrl: ImageUrlHelper.resolve(a.coverUrl),
            trackCount: a.trackTotal ?? 0,
          ),
        )
        .toList();
  }

  static ArtistDashboardStats toDashboardStats(
    ArtistOverviewResponse overview,
  ) {
    final daily = <DailyActivity>[];
    for (final point in overview.chartData) {
      final date = DateTime.tryParse(point.day ?? '');
      if (date == null) continue;
      daily.add(
        DailyActivity(
          date: DateTime(date.year, date.month, date.day),
          views: point.views,
          likes: point.likes,
        ),
      );
    }
    daily.sort((a, b) => a.date.compareTo(b.date));

    return ArtistDashboardStats(
      totalViews: overview.totalViews,
      totalLikes: overview.totalFavorites,
      totalFollowers: overview.totalFollowers,
      totalComments: overview.totalComments,
      daily: daily,
    );
  }
}
