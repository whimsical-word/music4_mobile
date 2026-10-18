import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/features/artist_profile/data/repositories/artist_profile_repository.dart';

import '../artist_profile_test_helpers.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late ArtistProfileRepository repository;

  setUp(() {
    dio = MockDio();
    final dioClient = MockDioClient();
    when(() => dioClient.dio).thenReturn(dio);
    repository = ArtistProfileRepository(dioClient);
  });

  Response<dynamic> ok(String path, Object? data) => Response(
    requestOptions: RequestOptions(path: path),
    data: data,
    statusCode: 200,
  );

  DioException badResponse(String path, int status) => DioException(
    requestOptions: RequestOptions(path: path),
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: RequestOptions(path: path),
      statusCode: status,
    ),
  );

  group('[CE190284] ArtistProfileRepository - requests and parsing', () {
    test('getArtist GETs /api/artists/{id} and parses the DTO', () async {
      final path = '${ApiEndpoints.artists}/3';
      when(() => dio.get(path)).thenAnswer((_) async => ok(path, realArtistJson));

      final artist = await repository.getArtist(3);

      expect(artist.id, 3);
      expect(artist.name, 'Ngọt');
      verify(() => dio.get(path)).called(1);
    });

    test('getArtistTracks GETs /api/tracks/artist/{id}', () async {
      final path = '${ApiEndpoints.trackDetail}/artist/3';
      when(() => dio.get(path)).thenAnswer((_) async => ok(path, realTracksJson));

      final tracks = await repository.getArtistTracks(3);

      expect(tracks.map((t) => t.id), [11, 12, 13]);
      verify(() => dio.get(path)).called(1);
    });

    test('getArtistAlbums GETs /api/albums/artist/{id}', () async {
      final path = '${ApiEndpoints.albums}/artist/3';
      when(() => dio.get(path)).thenAnswer((_) async => ok(path, realAlbumsJson));

      final albums = await repository.getArtistAlbums(3);

      expect(albums.map((a) => a.id), [21, 22]);
      verify(() => dio.get(path)).called(1);
    });

    test('getOverview GETs /api/analytics/artist/{id}/overview', () async {
      final path = '${ApiEndpoints.analytics}/artist/3/overview';
      when(
        () => dio.get(path),
      ).thenAnswer((_) async => ok(path, realOverviewJson));

      final overview = await repository.getOverview(3);

      expect(overview.totalFollowers, 42);
      verify(() => dio.get(path)).called(1);
    });

    test('empty track and album lists parse to empty lists', () async {
      final tracksPath = '${ApiEndpoints.trackDetail}/artist/3';
      final albumsPath = '${ApiEndpoints.albums}/artist/3';
      when(() => dio.get(tracksPath)).thenAnswer((_) async => ok(tracksPath, []));
      when(() => dio.get(albumsPath)).thenAnswer((_) async => ok(albumsPath, []));

      expect(await repository.getArtistTracks(3), isEmpty);
      expect(await repository.getArtistAlbums(3), isEmpty);
    });
  });

  group('[CE190284] ArtistProfileRepository - follow', () {
    test('isFollowing is true when the artist is in the followings list', () async {
      final path = '${ApiEndpoints.follows}/user/7';
      when(() => dio.get(path)).thenAnswer(
        (_) async => ok(path, [
          {'followId': 1, 'artistId': 9, 'artistName': 'Other'},
          {'followId': 2, 'artistId': 3, 'artistName': 'Ngọt'},
        ]),
      );

      expect(await repository.isFollowing(userId: 7, artistId: 3), isTrue);
      expect(await repository.isFollowing(userId: 7, artistId: 4), isFalse);
    });

    test('toggleFollow POSTs userId/artistId and returns the new state', () async {
      final path = '${ApiEndpoints.follows}/toggle';
      final query = {'userId': 7, 'artistId': 3};
      when(() => dio.post(path, queryParameters: query)).thenAnswer(
        (_) async => ok(path, {
          'success': true,
          'following': true,
          'message': 'Đã theo dõi nghệ sĩ!',
        }),
      );

      expect(await repository.toggleFollow(userId: 7, artistId: 3), isTrue);
      verify(() => dio.post(path, queryParameters: query)).called(1);
    });
  });

  group('[CE190284] ArtistProfileRepository - errors', () {
    test('maps HTTP errors to readable ArtistProfileException messages', () async {
      final path = '${ApiEndpoints.artists}/3';
      final cases = {
        401: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
        403: 'Bạn không có quyền thực hiện thao tác này.',
        404: 'Không tìm thấy nghệ sĩ.',
        500: 'Lỗi máy chủ (500). Vui lòng thử lại sau.',
      };

      for (final entry in cases.entries) {
        when(() => dio.get(path)).thenThrow(badResponse(path, entry.key));

        await expectLater(
          repository.getArtist(3),
          throwsA(
            isA<ArtistProfileException>().having(
              (e) => e.message,
              'message',
              entry.value,
            ),
          ),
        );
      }
    });

    test('maps timeout and connection errors', () async {
      final path = '${ApiEndpoints.artists}/3';

      when(() => dio.get(path)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      await expectLater(
        repository.getArtist(3),
        throwsA(
          isA<ArtistProfileException>().having(
            (e) => e.message,
            'message',
            'Kết nối máy chủ quá thời gian. Vui lòng kiểm tra mạng.',
          ),
        ),
      );

      when(() => dio.get(path)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.connectionError,
        ),
      );
      await expectLater(
        repository.getArtist(3),
        throwsA(
          isA<ArtistProfileException>().having(
            (e) => e.message,
            'message',
            'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.',
          ),
        ),
      );
    });

    test('an unexpected body becomes a generic ArtistProfileException', () async {
      final path = '${ApiEndpoints.artists}/3';
      when(() => dio.get(path)).thenAnswer((_) async => ok(path, 'not json'));

      await expectLater(
        repository.getArtist(3),
        throwsA(isA<ArtistProfileException>()),
      );
    });

    test('a failed follow toggle throws a readable exception', () async {
      final path = '${ApiEndpoints.follows}/toggle';
      when(
        () => dio.post(path, queryParameters: {'userId': 7, 'artistId': 3}),
      ).thenThrow(badResponse(path, 500));

      await expectLater(
        repository.toggleFollow(userId: 7, artistId: 3),
        throwsA(isA<ArtistProfileException>()),
      );
    });
  });
}
