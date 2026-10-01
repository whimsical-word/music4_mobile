import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/core/network/dio_client.dart';
import 'package:music4_mobile/features/home/data/sources/home_repository.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockDioClient mockDioClient;
  late MockDio mockDio;
  late HomeRepository repository;

  setUp(() {
    mockDioClient = MockDioClient();
    mockDio = MockDio();

    when(() => mockDioClient.dio).thenReturn(mockDio);

    repository = HomeRepository(mockDioClient);
  });

  group('TrackSuggestModel & HomeRepository Mapping', () {
    test(
      'Should fetch and parse JSON array to List<TrackSuggestModel>',
      () async {
        // Arrange: match the REAL /api/recommendations response shape.
        final jsonResponse = [
          {
            'id': 1,
            'name': 'Track 1',
            'img': 'img1.jpg',
            'duration': 200,
            'previewPath': 'preview1.mp3',
            'viewCount': 100,
            'matchScore': 0.95,
            'artists': [
              {'id': 10, 'name': 'Artist A', 'role': 'MAIN'},
              {'id': 11, 'name': 'Artist B', 'role': 'FEATURED'},
            ],
          },
          {
            'id': 2,
            'name': 'Track 2',
            'img': 'img2.jpg',
            'duration': 180,
            'previewPath': 'preview2.mp3',
            'viewCount': 50,
            'matchScore': 0.85,
            'artists': [
              {'id': 12, 'name': 'Artist C', 'role': 'MAIN'},
            ],
          },
        ];

        when(() => mockDio.get(ApiEndpoints.recommendations)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ApiEndpoints.recommendations),
            data: jsonResponse,
            statusCode: 200,
          ),
        );

        // Act
        final result = await repository.getRecommendations();

        // Assert
        expect(result, hasLength(2));

        expect(result[0].id, 1);
        expect(result[0].name, 'Track 1');
        expect(result[0].duration, 200);
        expect(result[0].viewCount, 100);
        expect(result[0].matchScore, 0.95);

        expect(result[0].artists, hasLength(2));
        expect(result[0].artists[0].id, 10);
        expect(result[0].artists[0].name, 'Artist A');
        expect(result[0].artists[0].role, 'MAIN');

        expect(result[0].artists[1].id, 11);
        expect(result[0].artists[1].name, 'Artist B');

        expect(result[1].id, 2);
        expect(result[1].name, 'Track 2');
        expect(result[1].duration, 180);
        expect(result[1].viewCount, 50);
        expect(result[1].matchScore, 0.85);

        expect(result[1].artists, hasLength(1));
        expect(result[1].artists[0].id, 12);
        expect(result[1].artists[0].name, 'Artist C');

        verify(() => mockDio.get(ApiEndpoints.recommendations)).called(1);
      },
    );
  });
}
