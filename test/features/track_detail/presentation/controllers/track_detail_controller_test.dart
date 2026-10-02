import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/home/data/models/track_detail_model.dart';
import 'package:music4_mobile/features/playlist/data/models/playlist_model.dart';
import 'package:music4_mobile/features/track_detail/data/models/track_comment_model.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';
import 'package:music4_mobile/features/track_detail/presentation/controllers/track_detail_controller.dart';

class MockTrackDetailRepository extends Mock implements TrackDetailRepository {}

void main() {
  late MockTrackDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockTrackDetailRepository();
    when(() => mockRepository.getComments(any()))
        .thenAnswer((_) async => <TrackCommentModel>[]);
  });

  ProviderContainer makeProviderContainer(MockTrackDetailRepository repo) {
    final container = ProviderContainer(
      overrides: [
        trackDetailRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  const mockTrack = TrackDetailModel(
    id: 1,
    name: 'Bài hát Test',
    duration: 200,
    viewCount: 500,
  );

  const mockPlaylists = [
    PlaylistModel(id: 1, name: 'Playlist A', trackCount: 2),
  ];

  group('TrackDetailController Unit Tests', () {
    const trackId = 1;

    test('Tải thông tin bài hát thành công -> State là AsyncData với đầy đủ dữ liệu', () async {
      when(() => mockRepository.getTrackDetail(trackId))
          .thenAnswer((_) async => mockTrack);
      when(() => mockRepository.checkIsFavorite(trackId))
          .thenAnswer((_) async => true);
      when(() => mockRepository.getUserPlaylists())
          .thenAnswer((_) async => mockPlaylists);

      final container = makeProviderContainer(mockRepository);
      final controller =
          container.read(trackDetailControllerProvider(trackId).notifier);

      await controller.loadTrackDetail();

      final state = container.read(trackDetailControllerProvider(trackId));
      expect(state, isA<AsyncData<TrackDetailState>>());
      expect(state.value?.track.name, 'Bài hát Test');
      expect(state.value?.isLiked, true);
      expect(state.value?.userPlaylists.length, 1);
    });

    test('Tải thông tin thất bại -> State chuyển thành AsyncError', () async {
      when(() => mockRepository.getTrackDetail(trackId))
          .thenThrow(Exception('Lỗi mạng kết nối'));
      when(() => mockRepository.checkIsFavorite(trackId))
          .thenAnswer((_) async => false);
      when(() => mockRepository.getUserPlaylists())
          .thenAnswer((_) async => <PlaylistModel>[]);

      final container = makeProviderContainer(mockRepository);
      final controller =
          container.read(trackDetailControllerProvider(trackId).notifier);

      await controller.loadTrackDetail();

      final state = container.read(trackDetailControllerProvider(trackId));
      expect(state, isA<AsyncError<TrackDetailState>>());
      expect(state.hasError, true);
    });

    test('toggleFavorite cập nhật isLiked thành công', () async {
      when(() => mockRepository.getTrackDetail(trackId))
          .thenAnswer((_) async => mockTrack);
      when(() => mockRepository.checkIsFavorite(trackId))
          .thenAnswer((_) async => false);
      when(() => mockRepository.getUserPlaylists())
          .thenAnswer((_) async => mockPlaylists);
      when(() => mockRepository.toggleFavorite(trackId))
          .thenAnswer((_) async => true);

      final container = makeProviderContainer(mockRepository);
      final controller =
          container.read(trackDetailControllerProvider(trackId).notifier);

      await controller.loadTrackDetail();
      await controller.toggleFavorite();

      final state = container.read(trackDetailControllerProvider(trackId));
      expect(state.value?.isLiked, true);
      verify(() => mockRepository.toggleFavorite(trackId)).called(1);
    });

    test('toggleFavorite gặp lỗi -> Hoàn tác lại isLiked ban đầu (Rollback)', () async {
      when(() => mockRepository.getTrackDetail(trackId))
          .thenAnswer((_) async => mockTrack);
      when(() => mockRepository.checkIsFavorite(trackId))
          .thenAnswer((_) async => false);
      when(() => mockRepository.getUserPlaylists())
          .thenAnswer((_) async => mockPlaylists);
      when(() => mockRepository.toggleFavorite(trackId))
          .thenThrow(Exception('Lỗi server'));

      final container = makeProviderContainer(mockRepository);
      final controller =
          container.read(trackDetailControllerProvider(trackId).notifier);

      await controller.loadTrackDetail();

      expect(
        () async => await controller.toggleFavorite(),
        throwsA(isA<Exception>()),
      );

      final state = container.read(trackDetailControllerProvider(trackId));
      expect(state.value?.isLiked, false);
    });

    test('setRating cập nhật userRating trong state', () async {
      when(() => mockRepository.getTrackDetail(trackId))
          .thenAnswer((_) async => mockTrack);
      when(() => mockRepository.checkIsFavorite(trackId))
          .thenAnswer((_) async => false);
      when(() => mockRepository.getUserPlaylists())
          .thenAnswer((_) async => mockPlaylists);

      final container = makeProviderContainer(mockRepository);
      final controller =
          container.read(trackDetailControllerProvider(trackId).notifier);

      await controller.loadTrackDetail();
      controller.setRating(4);

      final state = container.read(trackDetailControllerProvider(trackId));
      expect(state.value?.userRating, 4);
    });

    test('addTrackToPlaylist gọi đúng repository', () async {
      when(() => mockRepository.getTrackDetail(trackId))
          .thenAnswer((_) async => mockTrack);
      when(() => mockRepository.checkIsFavorite(trackId))
          .thenAnswer((_) async => false);
      when(() => mockRepository.getUserPlaylists())
          .thenAnswer((_) async => mockPlaylists);
      when(() => mockRepository.addTrackToPlaylist(10, trackId))
          .thenAnswer((_) async {});

      final container = makeProviderContainer(mockRepository);
      final controller =
          container.read(trackDetailControllerProvider(trackId).notifier);

      await controller.loadTrackDetail();
      await controller.addTrackToPlaylist(10);

      verify(() => mockRepository.addTrackToPlaylist(10, trackId)).called(1);
    });

    test('addComment gọi repository và cập nhật danh sách comments trong state', () async {
      when(() => mockRepository.getTrackDetail(trackId))
          .thenAnswer((_) async => mockTrack);
      when(() => mockRepository.checkIsFavorite(trackId))
          .thenAnswer((_) async => false);
      when(() => mockRepository.getUserPlaylists())
          .thenAnswer((_) async => mockPlaylists);
      when(() => mockRepository.addComment(trackId: trackId, content: 'Bình luận mới'))
          .thenAnswer((_) async {});
      when(() => mockRepository.getComments(trackId))
          .thenAnswer((_) async => [
                const TrackCommentModel(
                  commentId: 1,
                  commenterName: 'Test User',
                  content: 'Bình luận mới',
                ),
              ]);

      final container = makeProviderContainer(mockRepository);
      final controller =
          container.read(trackDetailControllerProvider(trackId).notifier);

      await controller.loadTrackDetail();
      await controller.addComment('Bình luận mới');

      final state = container.read(trackDetailControllerProvider(trackId));
      expect(state.value?.comments.length, 1);
      expect(state.value?.comments.first.content, 'Bình luận mới');
      verify(() => mockRepository.addComment(trackId: trackId, content: 'Bình luận mới')).called(1);
    });

    test('updateComment gọi repository và cập nhật lại state comments', () async {
      when(() => mockRepository.getTrackDetail(trackId))
          .thenAnswer((_) async => mockTrack);
      when(() => mockRepository.checkIsFavorite(trackId))
          .thenAnswer((_) async => false);
      when(() => mockRepository.getUserPlaylists())
          .thenAnswer((_) async => mockPlaylists);
      when(() => mockRepository.updateComment(commentId: 1, content: 'Bình luận sửa đổi'))
          .thenAnswer((_) async {});
      when(() => mockRepository.getComments(trackId))
          .thenAnswer((_) async => [
                const TrackCommentModel(
                  commentId: 1,
                  commenterName: 'Test User',
                  content: 'Bình luận sửa đổi',
                ),
              ]);

      final container = makeProviderContainer(mockRepository);
      final controller =
          container.read(trackDetailControllerProvider(trackId).notifier);

      await controller.loadTrackDetail();
      await controller.updateComment(commentId: 1, content: 'Bình luận sửa đổi');

      final state = container.read(trackDetailControllerProvider(trackId));
      expect(state.value?.comments.first.content, 'Bình luận sửa đổi');
      verify(() => mockRepository.updateComment(commentId: 1, content: 'Bình luận sửa đổi')).called(1);
    });

    test('deleteComment gọi repository và cập nhật lại state comments', () async {
      when(() => mockRepository.getTrackDetail(trackId))
          .thenAnswer((_) async => mockTrack);
      when(() => mockRepository.checkIsFavorite(trackId))
          .thenAnswer((_) async => false);
      when(() => mockRepository.getUserPlaylists())
          .thenAnswer((_) async => mockPlaylists);
      when(() => mockRepository.deleteComment(1))
          .thenAnswer((_) async {});
      when(() => mockRepository.getComments(trackId))
          .thenAnswer((_) async => <TrackCommentModel>[]);

      final container = makeProviderContainer(mockRepository);
      final controller =
          container.read(trackDetailControllerProvider(trackId).notifier);

      await controller.loadTrackDetail();
      await controller.deleteComment(1);

      final state = container.read(trackDetailControllerProvider(trackId));
      expect(state.value?.comments.isEmpty, true);
      verify(() => mockRepository.deleteComment(1)).called(1);
    });
  });
}
