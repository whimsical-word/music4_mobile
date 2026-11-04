import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/features/admin/data/repositories/admin_sync_repository.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AdminSyncRepository repository;

  setUp(() {
    mockDio = MockDio();
    final mockDioClient = MockDioClient();
    when(() => mockDioClient.dio).thenReturn(mockDio);
    repository = AdminSyncRepository(mockDioClient);
  });

  DioException failure(String path, {int? status, DioExceptionType? type}) {
    final request = RequestOptions(path: path);
    return DioException(
      requestOptions: request,
      type: type ?? DioExceptionType.badResponse,
      response: status == null
          ? null
          : Response(requestOptions: request, statusCode: status),
    );
  }

  group('[CE190284] AdminSyncRepository.getStatus', () {
    test('GETs /api/recommendations/sync/status and parses the answer', () async {
      when(() => mockDio.get(ApiEndpoints.recommendationsSyncStatus)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.recommendationsSyncStatus),
          statusCode: 200,
          data: {
            'sqlTracks': 5,
            'indexedVectors': 5,
            'inSync': true,
            'syncRunning': false,
            'lastFullSync': null,
          },
        ),
      );

      final status = await repository.getStatus();

      expect(status.sqlTracks, 5);
      expect(status.inSync, isTrue);
      verify(() => mockDio.get(ApiEndpoints.recommendationsSyncStatus)).called(1);
    });

    test('an answer that is not a JSON object is an error', () async {
      when(() => mockDio.get(ApiEndpoints.recommendationsSyncStatus)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.recommendationsSyncStatus),
          statusCode: 200,
          data: 'oops',
        ),
      );

      expect(
        repository.getStatus(),
        throwsA(isA<AdminSyncException>().having((e) => e.message, 'message', 'Dữ liệu trạng thái không hợp lệ')),
      );
    });

    test('maps 401, 403, 404 and network errors to readable messages', () async {
      Future<String> messageFor(DioException error) async {
        when(() => mockDio.get(ApiEndpoints.recommendationsSyncStatus)).thenThrow(error);
        try {
          await repository.getStatus();
        } on AdminSyncException catch (e) {
          return e.message;
        }
        return '';
      }

      final path = ApiEndpoints.recommendationsSyncStatus;
      expect(await messageFor(failure(path, status: 401)), 'Phiên đăng nhập đã hết hạn');
      expect(await messageFor(failure(path, status: 403)), 'Chỉ tài khoản ADMIN mới dùng được chức năng này');
      expect(
        await messageFor(failure(path, status: 404)),
        'Backend chưa có API trạng thái đồng bộ (cần cập nhật backend)',
      );
      expect(
        await messageFor(failure(path, type: DioExceptionType.connectionTimeout)),
        'Mạng quá yếu, thử lại sau',
      );
      expect(await messageFor(failure(path, status: 500)), 'Lỗi kết nối máy chủ');
    });
  });

  group('[CE190284] AdminSyncRepository.startSync', () {
    test('POSTs /api/recommendations/sync and reports started', () async {
      when(() => mockDio.post(ApiEndpoints.recommendationsSync)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.recommendationsSync),
          statusCode: 202,
          data: 'accepted',
        ),
      );

      expect(await repository.startSync(), SyncStartResult.started);
      verify(() => mockDio.post(ApiEndpoints.recommendationsSync)).called(1);
    });

    test('409 means a run is already going: not an error', () async {
      when(() => mockDio.post(ApiEndpoints.recommendationsSync))
          .thenThrow(failure(ApiEndpoints.recommendationsSync, status: 409));

      expect(await repository.startSync(), SyncStartResult.alreadyRunning);
    });

    test('403 for a non-admin is an error with a readable message', () async {
      when(() => mockDio.post(ApiEndpoints.recommendationsSync))
          .thenThrow(failure(ApiEndpoints.recommendationsSync, status: 403));

      expect(
        repository.startSync(),
        throwsA(isA<AdminSyncException>().having(
          (e) => e.message,
          'message',
          'Chỉ tài khoản ADMIN mới dùng được chức năng này',
        )),
      );
    });

    test('a 404 on start is a plain server error (that endpoint always exists)', () async {
      when(() => mockDio.post(ApiEndpoints.recommendationsSync))
          .thenThrow(failure(ApiEndpoints.recommendationsSync, status: 404));

      expect(
        repository.startSync(),
        throwsA(isA<AdminSyncException>().having((e) => e.message, 'message', 'Lỗi kết nối máy chủ')),
      );
    });
  });
}
