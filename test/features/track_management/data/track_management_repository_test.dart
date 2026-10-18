import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/features/track_management/data/repositories/track_management_repository.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late TrackManagementRepository repository;
  late File dummyCover;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(FormData());

    final tempDir = Directory.systemTemp.createTempSync('track_mgmt_test_');
    dummyCover = File('${tempDir.path}/test_cover.png')..writeAsStringSync('dummy cover content');
  });

  setUp(() {
    mockDio = MockDio();
    repository = TrackManagementRepository(mockDio);
  });

  group('[CE190036] TrackManagementRepository Unit Tests (UC47, UC49, UC50, UC51, UC52)', () {
    final mockTracksJson = [
      {
        'id': 101,
        'name': 'Bài Hát Test 1',
        'albumName': 'Single',
        'img': 'covers/t1.jpg',
        'duration': 210,
        'filePath': 'tracks/t1.mp3',
        'viewCount': 1500,
        'uploadDate': '2026-03-01',
        'artists': [
          {'name': 'Ariana Grande'},
        ],
      },
      {
        'id': 102,
        'name': 'Bài Hát Test 2',
        'albumName': 'Album Mùa Hè',
        'img': 'covers/t2.jpg',
        'duration': 180,
        'filePath': 'tracks/t2.mp3',
        'viewCount': 2500000,
        'uploadDate': '2026-03-05',
        'artists': [
          {'name': 'Ariana Grande'},
          {'name': 'The Weeknd'},
        ],
      },
    ];

    test('getArtistTracks returns list of ArtistTrackItemModel successfully (UC47)', () async {
      when(() => mockDio.get('${ApiEndpoints.trackDetail}/artist/5')).thenAnswer(
        (_) async => Response(
          data: mockTracksJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/artist/5'),
        ),
      );

      final tracks = await repository.getArtistTracks(5);

      expect(tracks.length, 2);
      expect(tracks[0].id, 101);
      expect(tracks[0].name, 'Bài Hát Test 1');
      expect(tracks[0].isSingle, isTrue);
      expect(tracks[0].formattedDuration, '3:30');
      expect(tracks[0].formattedViews, '1.5K');

      expect(tracks[1].id, 102);
      expect(tracks[1].name, 'Bài Hát Test 2');
      expect(tracks[1].isSingle, isFalse);
      expect(tracks[1].formattedViews, '2.5M');
      expect(tracks[1].artistNames, ['Ariana Grande', 'The Weeknd']);
    });

    test('getTracksByAlbum returns list of tracks belonging to album (UC49)', () async {
      when(() => mockDio.get('${ApiEndpoints.trackDetail}/album/12')).thenAnswer(
        (_) async => Response(
          data: mockTracksJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/album/12'),
        ),
      );

      final tracks = await repository.getTracksByAlbum(12);

      expect(tracks.length, 2);
      expect(tracks[1].albumName, 'Album Mùa Hè');
    });

    test('updateTrackMetadata posts FormData correctly (UC50)', () async {
      when(() => mockDio.post(
            '${ApiEndpoints.trackDetail}/update/101',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          data: {'message': 'Cập nhật thành công'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/update/101'),
        ),
      );

      await repository.updateTrackMetadata(
        trackId: 101,
        title: 'New Track Title',
        albumId: 10,
        categoryIds: [1, 2],
        collabArtistIds: [7],
        coverImageFile: dummyCover,
      );

      verify(() => mockDio.post(
            '${ApiEndpoints.trackDetail}/update/101',
            data: any(named: 'data'),
          )).called(1);
    });

    test('deleteTrack calls DELETE endpoint (UC51)', () async {
      when(() => mockDio.delete('${ApiEndpoints.trackDetail}/101')).thenAnswer(
        (_) async => Response(
          data: {'message': 'Đã xóa bài hát'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/101'),
        ),
      );

      await repository.deleteTrack(101);

      verify(() => mockDio.delete('${ApiEndpoints.trackDetail}/101')).called(1);
    });

    test('getTop5Trending returns top 5 tracks (UC52)', () async {
      when(() => mockDio.get(ApiEndpoints.top5Tracks)).thenAnswer(
        (_) async => Response(
          data: mockTracksJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.top5Tracks),
        ),
      );

      final trending = await repository.getTop5Trending();

      expect(trending.length, 2);
      expect(trending[0].name, 'Bài Hát Test 1');
    });

    test('handles 403 Forbidden properly', () async {
      when(() => mockDio.delete('${ApiEndpoints.trackDetail}/999')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/999'),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/999'),
          ),
        ),
      );

      expect(
        () => repository.deleteTrack(999),
        throwsA(predicate((e) => e.toString().contains('không có quyền'))),
      );
    });
  });
}
