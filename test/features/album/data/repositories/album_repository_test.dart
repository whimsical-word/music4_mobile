import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/features/album/data/repositories/album_repository.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AlbumRepository repository;
  late File dummyCover;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(FormData());

    final tempDir = Directory.systemTemp.createTempSync('album_test_');
    dummyCover = File('${tempDir.path}/test_cover.png')..writeAsStringSync('dummy cover content');
  });

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

    test('getAlbumDetail ném lỗi rõ ràng khi album không tồn tại hoặc đã bị xóa', () async {
      when(() => mockDio.get('${ApiEndpoints.trackDetail}/album/$albumId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/album/$albumId'),
          statusCode: 200,
          data: [],
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
          data: [],
        ),
      );

      expect(
        () => repository.getAlbumDetail(albumId),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Album không tồn tại hoặc đã bị xóa.'),
        )),
      );
    });
  });

  group('[CE190036] AlbumRepository getAlbumsByArtist Unit Tests UC4', () {
    const artistId = 5;

    test('getAlbumsByArtist trả về danh sách AlbumModel khi API thành công', () async {
      final mockData = [
        {
          'id': 10,
          'name': 'Positions',
          'img': 'images/positions.jpg',
          'uploadDate': '2020-10-30',
          'trackTotal': 14,
          'artistId': 5,
        },
        {
          'id': 11,
          'name': 'Sweetener',
          'img': 'images/sweetener.jpg',
          'uploadDate': '2018-08-17',
          'trackTotal': 15,
          'artistId': 5,
        },
      ];

      when(() => mockDio.get('${ApiEndpoints.albums}/artist/$artistId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.albums}/artist/$artistId'),
          statusCode: 200,
          data: mockData,
        ),
      );

      final result = await repository.getAlbumsByArtist(artistId, artistName: 'Ariana Grande');

      expect(result.length, 2);
      expect(result[0].id, '10');
      expect(result[0].title, 'Positions');
      expect(result[0].artistName, 'Ariana Grande');
      expect(result[0].trackCount, 14);
      expect(result[1].title, 'Sweetener');
    });

    test('getAlbumsByArtist ném lỗi khi gặp connection error', () async {
      when(() => mockDio.get('${ApiEndpoints.albums}/artist/$artistId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '${ApiEndpoints.albums}/artist/$artistId'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        () => repository.getAlbumsByArtist(artistId),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Không thể kết nối đến máy chủ'),
        )),
      );
    });
  });

  group('[CE190036] AlbumRepository createAlbum Unit Tests UC2', () {
    const artistId = 5;

    test('createAlbum không có coverFile gửi form data và trả về AlbumModel', () async {
      final mockResponse = {
        'id': 99,
        'name': 'Eternal Sunshine',
        'img': 'images/default-cover.png',
        'uploadDate': '2024-03-08',
        'trackTotal': 0,
        'artist': {
          'id': 5,
          'name': 'Ariana Grande',
        },
      };

      when(() => mockDio.post(
            ApiEndpoints.albums,
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.albums),
          statusCode: 201,
          data: mockResponse,
        ),
      );

      final result = await repository.createAlbum(
        title: 'Eternal Sunshine',
        artistId: artistId,
        artistName: 'Ariana Grande',
      );

      expect(result.id, '99');
      expect(result.title, 'Eternal Sunshine');
      expect(result.artistId, '5');
      expect(result.artistName, 'Ariana Grande');
    });

    test('createAlbum có coverFile thực hiện upload temp rồi tạo album', () async {
      when(() => mockDio.post(
            ApiEndpoints.uploadTemp,
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.uploadTemp),
          statusCode: 200,
          data: {'s3Key': 'images/eternal_sunshine.png'},
        ),
      );

      final mockResponse = {
        'id': 100,
        'name': 'Eternal Sunshine Deluxe',
        'img': 'images/eternal_sunshine.png',
        'uploadDate': '2024-03-15',
        'trackTotal': 0,
        'artist': {'id': 5, 'name': 'Ariana Grande'},
      };

      when(() => mockDio.post(
            ApiEndpoints.albums,
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.albums),
          statusCode: 201,
          data: mockResponse,
        ),
      );

      final result = await repository.createAlbum(
        title: 'Eternal Sunshine Deluxe',
        artistId: artistId,
        coverFilePath: dummyCover.path,
        artistName: 'Ariana Grande',
      );

      expect(result.id, '100');
      expect(result.coverUrl, 'images/eternal_sunshine.png');
      expect(result.artistName, 'Ariana Grande');
    });
  });

  group('[CE190036] AlbumRepository deleteAlbum Unit Tests UC58', () {
    const albumId = '100';

    test('deleteAlbum gọi DELETE /api/albums/{id} thành công', () async {
      when(() => mockDio.delete('${ApiEndpoints.albums}/$albumId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.albums}/$albumId'),
          statusCode: 200,
          data: 'Xóa album thành công!',
        ),
      );

      await expectLater(repository.deleteAlbum(albumId), completes);
      verify(() => mockDio.delete('${ApiEndpoints.albums}/$albumId')).called(1);
    });

    test('deleteAlbum ném lỗi khi album không tồn tại (404)', () async {
      when(() => mockDio.delete('${ApiEndpoints.albums}/$albumId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '${ApiEndpoints.albums}/$albumId'),
          response: Response(
            requestOptions: RequestOptions(path: '${ApiEndpoints.albums}/$albumId'),
            statusCode: 404,
          ),
        ),
      );

      expect(
        () => repository.deleteAlbum(albumId),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Không tìm thấy dữ liệu Album.'),
        )),
      );
    });
  });

  group('[CE190036] AlbumRepository getArtistTracks & assign/remove tracks Unit Tests', () {
    const artistId = 1;
    const trackId = 101;
    const albumId = 5;

    test('getArtistTracks trả về danh sách tracks của artist thành công', () async {
      final mockData = [
        {
          'id': 101,
          'name': 'Bài Hát Single 1',
          'albumName': 'Single',
          'duration': 210,
        },
        {
          'id': 102,
          'name': 'Bài Hát Thuộc Album Khác',
          'albumName': 'Album Cũ',
          'duration': 180,
        },
      ];

      when(() => mockDio.get('${ApiEndpoints.trackDetail}/artist/$artistId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/artist/$artistId'),
          statusCode: 200,
          data: mockData,
        ),
      );

      final result = await repository.getArtistTracks(artistId);

      expect(result.length, 2);
      expect(result[0]['name'], 'Bài Hát Single 1');
      expect(result[0]['albumName'], 'Single');
      expect(result[1]['albumName'], 'Album Cũ');
      verify(() => mockDio.get('${ApiEndpoints.trackDetail}/artist/$artistId')).called(1);
    });

    test('assignTrackToAlbum gửi POST đến /api/tracks/update/{id} với albumId tương ứng', () async {
      when(() => mockDio.post(
            '${ApiEndpoints.trackDetail}/update/$trackId',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/update/$trackId'),
          statusCode: 200,
          data: {'message': 'Cập nhật thành công!'},
        ),
      );

      await expectLater(
        repository.assignTrackToAlbum(trackId: trackId, albumId: albumId),
        completes,
      );

      verify(() => mockDio.post(
            '${ApiEndpoints.trackDetail}/update/$trackId',
            data: any(named: 'data'),
          )).called(1);
    });

    test('removeTrackFromAlbum gửi POST đến /api/tracks/update/{id} với albumId: -1', () async {
      when(() => mockDio.post(
            '${ApiEndpoints.trackDetail}/update/$trackId',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/update/$trackId'),
          statusCode: 200,
          data: {'message': 'Gỡ khỏi album thành công!'},
        ),
      );

      await expectLater(
        repository.removeTrackFromAlbum(trackId: trackId),
        completes,
      );

      verify(() => mockDio.post(
            '${ApiEndpoints.trackDetail}/update/$trackId',
            data: any(named: 'data'),
          )).called(1);
    });
  });
}
