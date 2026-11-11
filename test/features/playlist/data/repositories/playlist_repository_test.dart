import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/features/playlist/data/repositories/playlist_repository.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late PlaylistRepository repository;

  setUp(() {
    mockDio = MockDio();
    repository = PlaylistRepository(mockDio);
  });

  group('PlaylistRepository Unit Tests', () {
    test('getMyPlaylists trả về danh sách PlaylistModel khi API thành công', () async {
      final mockData = [
        {
          'id': 1,
          'name': 'Nhạc Chill',
          'description': 'Mô tả chill',
          'trackCount': 3,
        },
      ];

      when(() => mockDio.get(ApiEndpoints.myPlaylists)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.myPlaylists),
          statusCode: 200,
          data: mockData,
        ),
      );

      final result = await repository.getMyPlaylists();

      expect(result.length, 1);
      expect(result.first.name, 'Nhạc Chill');
      expect(result.first.id, 1);
      verify(() => mockDio.get(ApiEndpoints.myPlaylists)).called(1);
    });

    test('createPlaylist gửi đúng dữ liệu và trả về PlaylistModel', () async {
      final responseData = {
        'id': 10,
        'name': 'Playlist Test',
        'description': 'Mô tả test',
      };

      when(() => mockDio.post(
            ApiEndpoints.playlists,
            data: {'name': 'Playlist Test', 'description': 'Mô tả test'},
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.playlists),
          statusCode: 201,
          data: responseData,
        ),
      );

      final result = await repository.createPlaylist(
        name: 'Playlist Test',
        description: 'Mô tả test',
      );

      expect(result.id, 10);
      expect(result.name, 'Playlist Test');
      expect(result.description, 'Mô tả test');
    });

    test('deletePlaylist gọi đúng endpoint DELETE', () async {
      when(() => mockDio.delete('${ApiEndpoints.playlists}/10')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.playlists}/10'),
          statusCode: 200,
        ),
      );

      await expectLater(repository.deletePlaylist(10), completes);
      verify(() => mockDio.delete('${ApiEndpoints.playlists}/10')).called(1);
    });

    test('updatePlaylist gửi đúng dữ liệu PUT và trả về PlaylistModel đã sửa', () async {
      final responseData = {
        'id': 10,
        'name': 'Playlist Đã Sửa',
        'description': 'Mô tả mới',
        'trackCount': 2,
      };

      when(() => mockDio.put(
            '${ApiEndpoints.playlists}/10',
            data: {'name': 'Playlist Đã Sửa', 'description': 'Mô tả mới'},
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.playlists}/10'),
          statusCode: 200,
          data: responseData,
        ),
      );

      final result = await repository.updatePlaylist(
        10,
        name: 'Playlist Đã Sửa',
        description: 'Mô tả mới',
      );

      expect(result.id, 10);
      expect(result.name, 'Playlist Đã Sửa');
      expect(result.description, 'Mô tả mới');
      verify(() => mockDio.put(
            '${ApiEndpoints.playlists}/10',
            data: {'name': 'Playlist Đã Sửa', 'description': 'Mô tả mới'},
          )).called(1);
    });

    test('DioException 401 ném ra thông báo tiếng Việt', () async {
      when(() => mockDio.get(ApiEndpoints.myPlaylists)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.myPlaylists),
          response: Response(
            requestOptions: RequestOptions(path: ApiEndpoints.myPlaylists),
            statusCode: 401,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () async => await repository.getMyPlaylists(),
        throwsA(
          predicate((e) =>
              e is Exception &&
              e.toString().contains('Phiên đăng nhập đã hết hạn')),
        ),
      );
    });
  });
}
