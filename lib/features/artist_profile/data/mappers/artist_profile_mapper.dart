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

  static const int maxChartDays = 7;

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
    final days = overview.chartData.length > maxChartDays
        ? overview.chartData.sublist(overview.chartData.length - maxChartDays)
        : overview.chartData;

    return ArtistDashboardStats(
      totalViews: overview.totalViews,
      totalLikes: overview.totalFavorites,
      totalFollowers: overview.totalFollowers,
      totalComments: overview.totalComments,
      chartViews: days.map((d) => d.views).toList(),
      chartLabels: days.map((d) => _dayLabel(d.day)).toList(),
    );
  }

  /// 'yyyy-MM-dd' -> 'dd/MM'.
  static String _dayLabel(String? isoDate) {
    if (isoDate == null || isoDate.length < 10) return '';
    return '${isoDate.substring(8, 10)}/${isoDate.substring(5, 7)}';
  }
}
