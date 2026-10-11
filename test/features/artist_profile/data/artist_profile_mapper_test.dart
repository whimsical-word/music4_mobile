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
      expect(overview.chartData.first.day, '2026-10-01');
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

    test('toDashboardStats keeps the last 7 days with dd/MM labels', () {
      final stats = ArtistProfileMapper.toDashboardStats(
        ArtistOverviewResponse.fromJson(realOverviewJson),
      );

      expect(stats.totalViews, 1500);
      expect(stats.totalLikes, 120); // totalFavorites
      expect(stats.totalFollowers, 42);
      expect(stats.totalComments, 9);
      expect(stats.chartViews, [30, 40, 50, 60, 70, 80, 90]);
      expect(stats.chartLabels, [
        '03/10',
        '04/10',
        '05/10',
        '06/10',
        '07/10',
        '08/10',
        '09/10',
      ]);
    });

    test('toDashboardStats handles an empty chart', () {
      final stats = ArtistProfileMapper.toDashboardStats(
        const ArtistOverviewResponse(),
      );

      expect(stats.chartViews, isEmpty);
      expect(stats.chartLabels, isEmpty);
    });
  });
}
