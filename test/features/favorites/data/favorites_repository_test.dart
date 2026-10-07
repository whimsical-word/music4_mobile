import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/core/utils/image_url_helper.dart';
import 'package:music4_mobile/features/favorites/data/repositories/favorites_repository.dart';
import 'package:music4_mobile/features/favorites/domain/models/favorite_track.dart';

import '../favorites_test_helpers.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late FavoritesRepository repository;

  setUp(() {
    dio = MockDio();
    final dioClient = MockDioClient();
    when(() => dioClient.dio).thenReturn(dio);
    repository = FavoritesRepository(dioClient);
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

  group('[CE190284] Real backend JSON -> models', () {
    test('FavoriteResponse parses FavoriteResponseDTO', () {
      final favorites = favoriteResponses();

      expect(favorites, hasLength(3));
      expect(favorites[0].favoriteId, 1);
      expect(favorites[0].trackId, 11);
      expect(favorites[0].trackName, 'Lạc Trôi');
      expect(favorites[0].artistName, 'Sơn Tùng M-TP');
      expect(favorites[0].img, 'covers/t11.jpg');
      expect(favorites[0].likedAt, '2026-10-01T10:00:00.123456');
    });

    test('nullable fields do not break parsing', () {
      final favorite = favoriteResponses()[1];

      expect(favorite.img, isNull);
      expect(favorite.artistName, '');
    });

    test('FavoriteTrack maps ids, cover, artist fallback and time', () {
      final tracks = favoriteResponses().map(FavoriteTrack.fromResponse).toList();

      expect(tracks[0].id, '11'); // trackId, not favoriteId
      expect(tracks[0].title, 'Lạc Trôi');
      expect(tracks[0].artist, 'Sơn Tùng M-TP');
      expect(tracks[0].coverUrl, '${ImageUrlHelper.s3BaseUrl}covers/t11.jpg');
      expect(tracks[0].addedAt, DateTime.parse('2026-10-01T10:00:00.123456'));

      expect(tracks[1].artist, 'Không rõ nghệ sĩ');
      expect(tracks[1].coverUrl, isNull);

      expect(tracks[2].coverUrl, 'https://cdn.example.com/t13.jpg');
    });
  });

  group('[CE190284] FavoritesRepository - requests', () {
    test('getMyFavorites GETs /api/favorites/me and parses the list', () async {
      when(() => dio.get(ApiEndpoints.favorites)).thenAnswer(
        (_) async => ok(ApiEndpoints.favorites, realFavoritesJson),
      );

      final favorites = await repository.getMyFavorites();

      expect(favorites.map((f) => f.trackId), [11, 12, 13]);
      verify(() => dio.get(ApiEndpoints.favorites)).called(1);
    });

    test('an empty list parses to an empty list', () async {
      when(
        () => dio.get(ApiEndpoints.favorites),
      ).thenAnswer((_) async => ok(ApiEndpoints.favorites, []));

      expect(await repository.getMyFavorites(), isEmpty);
    });

    test('toggleFavorite POSTs /api/favorites/toggle/{trackId} and returns liked', () async {
      final path = '${ApiEndpoints.toggleFavorite}/11';
      when(() => dio.post(path)).thenAnswer(
        (_) async => ok(path, {
          'liked': false,
          'message': 'Đã xóa bài hát khỏi danh sách yêu thích!',
        }),
      );

      expect(await repository.toggleFavorite(11), isFalse);
      verify(() => dio.post(path)).called(1);
    });

    test('toggleFavorite returns true when the track was added', () async {
      final path = '${ApiEndpoints.toggleFavorite}/11';
      when(() => dio.post(path)).thenAnswer(
        (_) async => ok(path, {
          'liked': true,
          'message': 'Đã thêm bài hát vào danh sách yêu thích!',
        }),
      );

      expect(await repository.toggleFavorite(11), isTrue);
    });
  });

  group('[CE190284] FavoritesRepository - errors', () {
    test('maps HTTP errors to readable FavoritesException messages', () async {
      final cases = {
        401: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
        403: 'Bạn không có quyền thực hiện thao tác này.',
        404: 'Không tìm thấy dữ liệu yêu thích.',
        500: 'Lỗi máy chủ (500). Vui lòng thử lại sau.',
      };

      for (final entry in cases.entries) {
        when(
          () => dio.get(ApiEndpoints.favorites),
        ).thenThrow(badResponse(ApiEndpoints.favorites, entry.key));

        await expectLater(
          repository.getMyFavorites(),
          throwsA(
            isA<FavoritesException>().having(
              (e) => e.message,
              'message',
              entry.value,
            ),
          ),
        );
      }
    });

    test('maps timeout and connection errors', () async {
      when(() => dio.get(ApiEndpoints.favorites)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.favorites),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      await expectLater(
        repository.getMyFavorites(),
        throwsA(
          isA<FavoritesException>().having(
            (e) => e.message,
            'message',
            'Kết nối máy chủ quá thời gian. Vui lòng kiểm tra mạng.',
          ),
        ),
      );

      when(() => dio.get(ApiEndpoints.favorites)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.favorites),
          type: DioExceptionType.connectionError,
        ),
      );
      await expectLater(
        repository.getMyFavorites(),
        throwsA(
          isA<FavoritesException>().having(
            (e) => e.message,
            'message',
            'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.',
          ),
        ),
      );
    });

    test('an unexpected list body becomes a generic FavoritesException', () async {
      when(
        () => dio.get(ApiEndpoints.favorites),
      ).thenAnswer((_) async => ok(ApiEndpoints.favorites, 'not json'));

      await expectLater(
        repository.getMyFavorites(),
        throwsA(isA<FavoritesException>()),
      );
    });

    test('a toggle response without `liked` is an error, not a guess', () async {
      final path = '${ApiEndpoints.toggleFavorite}/11';
      when(
        () => dio.post(path),
      ).thenAnswer((_) async => ok(path, {'message': 'ok'}));

      await expectLater(
        repository.toggleFavorite(11),
        throwsA(isA<FavoritesException>()),
      );
    });

    test('a failed toggle throws a readable exception', () async {
      final path = '${ApiEndpoints.toggleFavorite}/11';
      when(() => dio.post(path)).thenThrow(badResponse(path, 500));

      await expectLater(
        repository.toggleFavorite(11),
        throwsA(
          isA<FavoritesException>().having(
            (e) => e.message,
            'message',
            'Lỗi máy chủ (500). Vui lòng thử lại sau.',
          ),
        ),
      );
    });
  });
}
