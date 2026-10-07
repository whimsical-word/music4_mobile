import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/features/history/data/repositories/history_repository.dart';

import '../../history_test_helpers.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late HistoryRepository repository;

  final path = '${ApiEndpoints.history}/7';
  final query = {'page': 0, 'size': HistoryRepository.defaultPageSize};

  setUp(() {
    dio = MockDio();
    final dioClient = MockDioClient();
    when(() => dioClient.dio).thenReturn(dio);
    repository = HistoryRepository(dioClient);
  });

  Response<dynamic> ok(Object? data) => Response(
    requestOptions: RequestOptions(path: path),
    data: data,
    statusCode: 200,
  );

  DioException badResponse(int status) => DioException(
    requestOptions: RequestOptions(path: path),
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: RequestOptions(path: path),
      statusCode: status,
    ),
  );

  group('[CE190284] HistoryRepository', () {
    test('GETs /api/tracking/history/{userId} with page and size', () async {
      when(
        () => dio.get(path, queryParameters: query),
      ).thenAnswer((_) async => ok(realHistoryJson));

      await repository.getListeningHistory(7);

      verify(() => dio.get(path, queryParameters: query)).called(1);
    });

    test('maps the real backend JSON to HistoryPageResponse', () async {
      when(
        () => dio.get(path, queryParameters: query),
      ).thenAnswer((_) async => ok(realHistoryJson));

      final page = await repository.getListeningHistory(7);

      expect(page.content, hasLength(2));

      final first = page.content[0];
      expect(first.id, 5);
      expect(first.name, 'Lạc Trôi');
      expect(first.albumName, 'Single');
      expect(first.img, 'covers/abc.jpg');
      expect(first.duration, 200);
      expect(first.viewCount, 12);
      expect(first.uploadDate, '2026-01-15');
      expect(first.playbackPosition, 120);
      expect(first.artists.single.name, 'Sơn Tùng M-TP');
      expect(first.artists.single.role, 'MAIN');

      // Nullable backend fields must not break parsing.
      final second = page.content[1];
      expect(second.img, isNull);
      expect(second.filePath, isNull);
      expect(second.previewPath, isNull);
      expect(second.uploadDate, isNull);
      expect(second.playbackPosition, 0);
      expect(second.artists, isEmpty);
    });

    test('an empty page parses to an empty list', () async {
      when(() => dio.get(path, queryParameters: query)).thenAnswer(
        (_) async => ok({
          'content': [],
          'page': {'size': 20, 'number': 0, 'totalElements': 0, 'totalPages': 0},
        }),
      );

      final page = await repository.getListeningHistory(7);

      expect(page.content, isEmpty);
    });

    test('maps HTTP errors to readable HistoryException messages', () async {
      final cases = {
        401: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
        403: 'Bạn không có quyền xem lịch sử này.',
        404: 'Không tìm thấy thông tin người dùng.',
        500: 'Lỗi máy chủ (500). Vui lòng thử lại sau.',
      };

      for (final entry in cases.entries) {
        when(
          () => dio.get(path, queryParameters: query),
        ).thenThrow(badResponse(entry.key));

        await expectLater(
          repository.getListeningHistory(7),
          throwsA(
            isA<HistoryException>().having(
              (e) => e.message,
              'message',
              entry.value,
            ),
          ),
        );
      }
    });

    test('maps timeout and connection errors', () async {
      when(() => dio.get(path, queryParameters: query)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      await expectLater(
        repository.getListeningHistory(7),
        throwsA(
          isA<HistoryException>().having(
            (e) => e.message,
            'message',
            'Kết nối máy chủ quá thời gian. Vui lòng kiểm tra mạng.',
          ),
        ),
      );

      when(() => dio.get(path, queryParameters: query)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.connectionError,
        ),
      );
      await expectLater(
        repository.getListeningHistory(7),
        throwsA(
          isA<HistoryException>().having(
            (e) => e.message,
            'message',
            'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.',
          ),
        ),
      );
    });

    test('an unexpected response body becomes a generic HistoryException', () async {
      when(
        () => dio.get(path, queryParameters: query),
      ).thenAnswer((_) async => ok('not json'));

      await expectLater(
        repository.getListeningHistory(7),
        throwsA(isA<HistoryException>()),
      );
    });
  });
}
