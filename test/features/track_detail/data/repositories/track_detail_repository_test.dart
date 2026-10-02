import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/constants/api_endpoints.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late TrackDetailRepository repository;

  setUp(() {
    mockDio = MockDio();
    repository = TrackDetailRepository(mockDio);
  });

  group('TrackDetailRepository Unit Tests', () {
    const trackId = 1;

    test('getTrackDetail trả về TrackDetailModel khi API thành công', () async {
      final mockData = {
        'id': 1,
        'name': 'Chúng Ta Của Hiện Tại',
        'duration': 301,
        'viewCount': 12000,
        'artists': [
          {'id': 1, 'name': 'Sơn Tùng M-TP'},
        ],
        'categories': [
          {'id': 1, 'name': 'Pop'},
        ],
      };

      when(() => mockDio.get('${ApiEndpoints.trackDetail}/$trackId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/$trackId'),
          statusCode: 200,
          data: mockData,
        ),
      );

      final result = await repository.getTrackDetail(trackId);

      expect(result.id, 1);
      expect(result.name, 'Chúng Ta Của Hiện Tại');
      expect(result.duration, 301);
      expect(result.artists.first.name, 'Sơn Tùng M-TP');
      expect(result.categories.first.name, 'Pop');
      verify(() => mockDio.get('${ApiEndpoints.trackDetail}/$trackId')).called(1);
    });

    test('getTrackDetail ném ra thông báo tiếng Việt khi lỗi 404', () async {
      when(() => mockDio.get('${ApiEndpoints.trackDetail}/$trackId')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/$trackId'),
          response: Response(
            requestOptions: RequestOptions(path: '${ApiEndpoints.trackDetail}/$trackId'),
            statusCode: 404,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () async => await repository.getTrackDetail(trackId),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Không tìm thấy bài hát'),
          ),
        ),
      );
    });

    test('toggleFavorite gọi đúng endpoint POST và trả về trạng thái liked mới', () async {
      when(() => mockDio.post('${ApiEndpoints.toggleFavorite}/$trackId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.toggleFavorite}/$trackId'),
          statusCode: 200,
          data: {'liked': true, 'message': 'Đã thêm vào yêu thích'},
        ),
      );

      final result = await repository.toggleFavorite(trackId);

      expect(result, true);
      verify(() => mockDio.post('${ApiEndpoints.toggleFavorite}/$trackId')).called(1);
    });

    test('checkIsFavorite trả về true khi trackId nằm trong danh sách favorites', () async {
      when(() => mockDio.get(ApiEndpoints.favorites)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.favorites),
          statusCode: 200,
          data: [
            {'favoriteId': 10, 'trackId': 1, 'trackName': 'Song 1'},
            {'favoriteId': 11, 'trackId': 2, 'trackName': 'Song 2'},
          ],
        ),
      );

      final result = await repository.checkIsFavorite(1);

      expect(result, true);
      verify(() => mockDio.get(ApiEndpoints.favorites)).called(1);
    });

    test('getUserPlaylists trả về danh sách PlaylistModel của user', () async {
      when(() => mockDio.get(ApiEndpoints.myPlaylists)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.myPlaylists),
          statusCode: 200,
          data: [
            {'id': 10, 'name': 'Playlist Chill', 'trackCount': 3},
          ],
        ),
      );

      final result = await repository.getUserPlaylists();

      expect(result.length, 1);
      expect(result.first.name, 'Playlist Chill');
      expect(result.first.id, 10);
    });

    test('addTrackToPlaylist gọi đúng endpoint POST', () async {
      const playlistId = 10;
      when(() => mockDio.post('${ApiEndpoints.playlists}/$playlistId/tracks/$trackId'))
          .thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: '${ApiEndpoints.playlists}/$playlistId/tracks/$trackId',
          ),
          statusCode: 200,
        ),
      );

      await expectLater(
        repository.addTrackToPlaylist(playlistId, trackId),
        completes,
      );
      verify(() => mockDio.post('${ApiEndpoints.playlists}/$playlistId/tracks/$trackId')).called(1);
    });

    test('getComments trả về danh sách TrackCommentModel khi API thành công', () async {
      when(() => mockDio.get('${ApiEndpoints.trackComments}/$trackId')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.trackComments}/$trackId'),
          statusCode: 200,
          data: [
            {
              'commentId': 101,
              'userId': 5,
              'commenterName': 'Lan Anh',
              'content': 'Tuyệt vời',
              'createdAt': '2026-10-02T10:00:00Z',
            },
          ],
        ),
      );

      final comments = await repository.getComments(trackId);

      expect(comments.length, 1);
      expect(comments.first.commenterName, 'Lan Anh');
      expect(comments.first.content, 'Tuyệt vời');
      verify(() => mockDio.get('${ApiEndpoints.trackComments}/$trackId')).called(1);
    });

    test('addComment gọi đúng endpoint POST với body CommentRequest', () async {
      when(
        () => mockDio.post(
          ApiEndpoints.comments,
          data: {'trackId': trackId, 'content': 'Hay lắm'},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.comments),
          statusCode: 200,
        ),
      );

      await expectLater(
        repository.addComment(trackId: trackId, content: 'Hay lắm'),
        completes,
      );
      verify(
        () => mockDio.post(
          ApiEndpoints.comments,
          data: {'trackId': trackId, 'content': 'Hay lắm'},
        ),
      ).called(1);
    });

    test('addComment gửi userId khi được cung cấp', () async {
      const userId = 5;
      when(
        () => mockDio.post(
          ApiEndpoints.comments,
          data: {'trackId': trackId, 'userId': userId, 'content': 'Hay lắm'},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.comments),
          statusCode: 200,
        ),
      );

      await expectLater(
        repository.addComment(trackId: trackId, content: 'Hay lắm', userId: userId),
        completes,
      );
      verify(
        () => mockDio.post(
          ApiEndpoints.comments,
          data: {'trackId': trackId, 'userId': userId, 'content': 'Hay lắm'},
        ),
      ).called(1);
    });

    test('updateComment gọi đúng endpoint PUT với commentId và body content', () async {
      const commentId = 101;
      when(
        () => mockDio.put(
          '${ApiEndpoints.comments}/$commentId',
          data: {'content': 'Nội dung đã sửa'},
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.comments}/$commentId'),
          statusCode: 200,
        ),
      );

      await expectLater(
        repository.updateComment(commentId: commentId, content: 'Nội dung đã sửa'),
        completes,
      );
      verify(
        () => mockDio.put(
          '${ApiEndpoints.comments}/$commentId',
          data: {'content': 'Nội dung đã sửa'},
        ),
      ).called(1);
    });

    test('deleteComment gọi đúng endpoint DELETE với commentId', () async {
      const commentId = 101;
      when(
        () => mockDio.delete('${ApiEndpoints.comments}/$commentId'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '${ApiEndpoints.comments}/$commentId'),
          statusCode: 200,
        ),
      );

      await expectLater(
        repository.deleteComment(commentId),
        completes,
      );
      verify(() => mockDio.delete('${ApiEndpoints.comments}/$commentId')).called(1);
    });
  });
}
