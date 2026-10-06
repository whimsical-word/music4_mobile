import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/features/tracking/data/tracking_repository.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late TrackingRepository repository;

  setUp(() {
    mockDio = MockDio();
    final mockDioClient = MockDioClient();
    when(() => mockDioClient.dio).thenReturn(mockDio);
    repository = TrackingRepository(mockDioClient);
  });

  Response<dynamic> ok(String path) =>
      Response(requestOptions: RequestOptions(path: path), statusCode: 200);

  group('[CE190284] TrackingRepository', () {
    test('recordCompletion POSTs the trackId to /api/tracking/history', () async {
      when(
        () => mockDio.post(ApiEndpoints.history, data: {'trackId': 5}),
      ).thenAnswer((_) async => ok(ApiEndpoints.history));

      await repository.recordCompletion(5);

      verify(
        () => mockDio.post(ApiEndpoints.history, data: {'trackId': 5}),
      ).called(1);
    });

    test('syncPlaybackPosition PUTs userId, trackId and position', () async {
      final body = {'userId': 7, 'trackId': 5, 'position': 20};
      when(
        () => mockDio.put(ApiEndpoints.syncPlaybackTime, data: body),
      ).thenAnswer((_) async => ok(ApiEndpoints.syncPlaybackTime));

      await repository.syncPlaybackPosition(
        userId: 7,
        trackId: 5,
        positionSeconds: 20,
      );

      verify(
        () => mockDio.put(ApiEndpoints.syncPlaybackTime, data: body),
      ).called(1);
    });

    test('wraps a 401 DioException into a readable TrackingException', () async {
      when(() => mockDio.post(ApiEndpoints.history, data: {'trackId': 5})).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.history),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: ApiEndpoints.history),
            statusCode: 401,
          ),
        ),
      );

      expect(
        repository.recordCompletion(5),
        throwsA(
          isA<TrackingException>().having(
            (e) => e.message,
            'message',
            'Phiên đăng nhập đã hết hạn',
          ),
        ),
      );
    });
  });
}
