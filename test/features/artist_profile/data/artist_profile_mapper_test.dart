import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/core/utils/image_url_helper.dart';
import 'package:music4_mobile/features/artist_profile/data/mappers/artist_profile_mapper.dart';
import 'package:music4_mobile/features/artist_profile/data/models/artist_overview_response.dart';
import 'package:music4_mobile/features/artist_profile/data/models/artist_response.dart';
import 'package:music4_mobile/features/home/data/models/track_detail_model.dart';

import '../artist_profile_test_helpers.dart';

List<TrackDetailModel> _tracks() => realTracksJson
    .map((e) => TrackDetailModel.fromJson(e))
    .toList();

List<AlbumInfo> _albums() =>
    realAlbumsJson.map((e) => AlbumInfo.fromJson(e)).toList();

void main() {
  group('[CE190284] Real backend JSON -> models', () {
    test('ArtistResponse parses ArtistResponseDTO and ignores email/userName', () {
      final artist = ArtistResponse.fromJson(realArtistJson);

      expect(artist.id, 3);
      expect(artist.name, 'Ngọt');
      expect(artist.img, 'avatars/ngot.jpg');
      expect(artist.cover, 'covers/ngot-cover.jpg');
      expect(artist.trackTotal, 3);
      expect(artist.albumTotal, 2);
    });

    test('ArtistResponse accepts null images', () {
      final artist = ArtistResponse.fromJson({
        'id': 1,
        'name': 'No images',
        'img': null,
        'cover': null,
      });

      expect(artist.img, isNull);
      expect(artist.cover, isNull);
      expect(artist.trackTotal, 0);
    });

    test('TrackResponseDTO (playbackPosition null) parses as TrackDetailModel', () {
      final tracks = _tracks();

      expect(tracks, hasLength(3));
      expect(tracks[0].id, 11);
      expect(tracks[0].duration, 215);
      expect(tracks[0].viewCount, 100);
      expect(tracks[0].artists.single.name, 'Ngọt');
      expect(tracks[1].img, isNull);
      expect(tracks[1].artists, isEmpty);
    });

    test('AlbumResponseDTO parses as AlbumInfo', () {
      final albums = _albums();

      expect(albums[0].id, 21);
      expect(albums[0].title, 'Album Cũ');
      expect(albums[0].coverUrl, 'covers/a21.jpg');
      expect(albums[0].trackTotal, 5);
      expect(albums[1].coverUrl, isNull);
    });

    test('ArtistOverviewResponse parses totals and chart data', () {
      final overview = ArtistOverviewResponse.fromJson(realOverviewJson);

      expect(overview.totalViews, 1500);
      expect(overview.totalFavorites, 120);
      expect(overview.totalFollowers, 42);
      expect(overview.totalComments, 9);
      expect(overview.chartData, hasLength(9));
      // The fixture's chart ends today; the oldest of its 9 days is 8 days ago.
      final oldest = DateTime.now().subtract(const Duration(days: 8));
      expect(overview.chartData.first.day, startsWith('${oldest.year}-'));
      expect(overview.chartData.first.views, 10);
    });
  });

  group('[CE190284] ArtistProfileMapper', () {
    test('toArtist resolves S3 keys and keeps the follower count', () {
      final artist = ArtistProfileMapper.toArtist(
        ArtistResponse.fromJson(realArtistJson),
        followersCount: 42,
      );

      expect(artist.id, '3');
      expect(artist.name, 'Ngọt');
      expect(artist.avatarUrl, '${ImageUrlHelper.s3BaseUrl}avatars/ngot.jpg');
      expect(
        artist.coverUrl,
        '${ImageUrlHelper.s3BaseUrl}covers/ngot-cover.jpg',
      );
      expect(artist.followersCount, 42);
    });

    test('toArtist keeps images and followers null when missing', () {
      final artist = ArtistProfileMapper.toArtist(
        const ArtistResponse(id: 1, name: 'A', img: '', cover: null),
      );

      expect(artist.avatarUrl, isNull);
      expect(artist.coverUrl, isNull);
      expect(artist.followersCount, isNull);
    });

    test('toPopularTracks orders by views and resolves artwork', () {
      final tracks = ArtistProfileMapper.toPopularTracks(
        _tracks(),
        fallbackArtistName: 'Ngọt',
      );

      // 12 (900 views) first, then 11 and 13 (100 views each) by id.
      expect(tracks.map((t) => t.id), ['12', '11', '13']);
      expect(tracks[1].artworkUrl, '${ImageUrlHelper.s3BaseUrl}covers/t11.jpg');
      expect(tracks[2].artworkUrl, 'https://cdn.example.com/t13.jpg');
      expect(tracks[0].artworkUrl, isNull);
      expect(tracks[1].durationSeconds, 215);
      expect(tracks.map((t) => t.viewCount), [900, 100, 100]);
    });

    test('toPopularTracks joins artists and falls back to the artist name', () {
      final tracks = ArtistProfileMapper.toPopularTracks(
        _tracks(),
        fallbackArtistName: 'Ngọt',
      );

      expect(tracks[0].artistName, 'Ngọt'); // no artists in the DTO
      expect(tracks[2].artistName, 'Ngọt, Guest');
    });

    test('toPopularTracks maps a missing duration to 0', () {
      final tracks = ArtistProfileMapper.toPopularTracks(
        const [TrackDetailModel(id: 1, name: 'No duration')],
        fallbackArtistName: 'A',
      );

      expect(tracks.single.durationSeconds, 0);
    });

    test('toAlbums orders newest first and resolves covers', () {
      final albums = ArtistProfileMapper.toAlbums(_albums());

      expect(albums.map((a) => a.id), ['22', '21']);
      expect(albums[0].coverUrl, isNull);
      expect(albums[1].coverUrl, '${ImageUrlHelper.s3BaseUrl}covers/a21.jpg');
      expect(albums[0].trackCount, 8);
    });

    test('toDashboardStats maps the totals and the daily activity', () {
      final stats = ArtistProfileMapper.toDashboardStats(
        ArtistOverviewResponse.fromJson(realOverviewJson),
      );

      expect(stats.totalViews, 1500);
      expect(stats.totalLikes, 120); // totalFavorites
      expect(stats.totalFollowers, 42);
      expect(stats.totalComments, 9);

      // Nine days, oldest first, ending today.
      expect(stats.daily, hasLength(9));
      expect(stats.daily.map((d) => d.views), [10, 20, 30, 40, 50, 60, 70, 80, 90]);
      expect(stats.daily.map((d) => d.likes), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
      final now = DateTime.now();
      expect(stats.daily.last.date, DateTime(now.year, now.month, now.day));
    });

    test('toDashboardStats sorts the days and skips an unreadable day', () {
      final stats = ArtistProfileMapper.toDashboardStats(
        const ArtistOverviewResponse(
          chartData: [
            DailyAnalyticsResponse(day: '2026-10-06', views: 5, likes: 1),
            DailyAnalyticsResponse(day: 'not-a-date', views: 99, likes: 99),
            DailyAnalyticsResponse(day: '2026-10-03', views: 19, likes: 0),
            DailyAnalyticsResponse(views: 7, likes: 7),
          ],
        ),
      );

      expect(stats.daily.map((d) => d.views), [19, 5]);
      expect(stats.daily.first.date, DateTime(2026, 10, 3));
    });

    test('toDashboardStats handles an empty chart', () {
      final stats = ArtistProfileMapper.toDashboardStats(
        const ArtistOverviewResponse(),
      );

      expect(stats.daily, isEmpty);
    });
  });
}
