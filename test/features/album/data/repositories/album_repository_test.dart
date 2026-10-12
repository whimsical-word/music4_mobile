import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/features/album/data/repositories/album_repository.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AlbumRepository repository;

  setUp(() {
    mockDio = MockDio();
    repository = AlbumRepository(mockDio);
  });

  group('AlbumRepository getAlbumDetail Unit Tests', () {
    const albumId = 1;

    test('getAlbumDetail trả về AlbumDetailModel đầy đủ khi các API thành công', () async {
      final mockTracksData = [
        {
          'id': 101,
          'name': 'Bài Hát 1',
          'albumName': 'Album Mùa Hè',
          'img': 'covers/t1.jpg',
          'duration': 210,
          'artists': [
            {'id': 1, 'name': 'Sơn Tùng M-TP', 'role': 'MAIN'},
          ],
        },
        {
          'id': 102,
          'name': 'Bài Hát 2',
          'albumName': 'Album Mùa Hè',
          'img': 'covers/t2.jpg',
          'duration': 195,
          'artists': [
            {'id': 1, 'name': 'Sơn Tùng M-TP', 'role': 'MAIN'},
          ],
        },
      ];

      final mockAlbumData = {
        'id': 1,
        'name': 'Album Mùa Hè',
        'img': 'covers/summer.jpg',
        'uploadDate': '2024-06-01',
        'trackTotal': 2,
        'artist': {
          'id': 1,
          'name': 'Sơn Tùng M-TP',
        },
      };

      when(() => mockDio.get('${ApiEndpoints.trackDetail}/album/$albumId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/album/$albumId'),
          statusCode: 200,
          data: mockTracksData,
        ),
      );

      when(() => mockDio.get('${ApiEndpoints.albums}/$albumId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.albums}/$albumId'),
          statusCode: 200,
          data: mockAlbumData,
        ),
      );

      final result = await repository.getAlbumDetail(albumId);

      expect(result.id, 1);
      expect(result.title, 'Album Mùa Hè');
      expect(result.artistName, 'Sơn Tùng M-TP');
      expect(result.tracks.length, 2);
      expect(result.tracks[0].name, 'Bài Hát 1');
      expect(result.tracks[0].formattedDuration, '3:30');
      expect(result.releaseYear, '2024');
    });

    test('getAlbumDetail fallback sang GET /api/albums khi GET /api/albums/{id} bị 404', () async {
      final mockTracksData = [
        {
          'id': 101,
          'name': 'Bài Hát 1',
          'albumName': 'Album Mùa Hè',
          'duration': 200,
          'artists': [],
        },
      ];

      final mockAllAlbums = [
        {
          'id': 1,
          'name': 'Album Mùa Hè',
          'img': 'covers/summer.jpg',
          'uploadDate': '2024-06-01',
          'artist': {'id': 1, 'name': 'Sơn Tùng M-TP'},
        },
        {
          'id': 2,
          'name': 'Album Khác',
          'img': null,
        },
      ];

      when(() => mockDio.get('${ApiEndpoints.trackDetail}/album/$albumId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/album/$albumId'),
          statusCode: 200,
          data: mockTracksData,
        ),
      );

      when(() => mockDio.get('${ApiEndpoints.albums}/$albumId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '${ApiEndpoints.albums}/$albumId'),
          response: Response(
            requestOptions: RequestOptions(path: '${ApiEndpoints.albums}/$albumId'),
            statusCode: 404,
          ),
        ),
      );

      when(() => mockDio.get(ApiEndpoints.albums)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.albums),
          statusCode: 200,
          data: mockAllAlbums,
        ),
      );

      final result = await repository.getAlbumDetail(albumId);

      expect(result.id, 1);
      expect(result.title, 'Album Mùa Hè');
      expect(result.tracks.length, 1);
    });

    test('getAlbumDetail ném lỗi tiếng Việt khi gặp timeout mạng', () async {
      when(() => mockDio.get('${ApiEndpoints.trackDetail}/album/$albumId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/album/$albumId'),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      when(() => mockDio.get('${ApiEndpoints.albums}/$albumId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '${ApiEndpoints.albums}/$albumId'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => repository.getAlbumDetail(albumId),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Mạng quá yếu, vui lòng thử lại sau.'),
        )),
      );
    });
  });
}
