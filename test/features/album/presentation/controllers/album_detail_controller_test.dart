import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/album/data/models/album_detail_model.dart';
import 'package:music4_mobile/features/album/data/repositories/album_repository.dart';
import 'package:music4_mobile/features/album/presentation/controllers/album_detail_controller.dart';

class MockAlbumRepository extends Mock implements AlbumRepository {}

void main() {
  late MockAlbumRepository mockRepository;

  setUp(() {
    mockRepository = MockAlbumRepository();
  });

  group('AlbumDetailController Unit Tests', () {
    const albumId = 1;
    final testAlbum = AlbumDetailModel(
      id: 1,
      title: 'Tuyển Tập Sơn Tùng',
      artistName: 'Sơn Tùng M-TP',
      uploadDate: '2024-05-20',
      trackTotal: 2,
      tracks: [
        const AlbumTrackModel(id: 1, name: 'Lạc Trôi', duration: 230),
        const AlbumTrackModel(id: 2, name: 'Nơi Này Có Anh', duration: 260),
      ],
    );

    test('loadAlbumDetail phát ra AsyncData khi repository thành công', () async {
      when(() => mockRepository.getAlbumDetail(albumId))
          .thenAnswer((_) async => testAlbum);

      final controller = AlbumDetailController(mockRepository, albumId);

      // Đợi async loadAlbumDetail hoàn tất
      await Future<void>.delayed(Duration.zero);

      expect(controller.state, isA<AsyncData<AlbumDetailState>>());
      final stateData = controller.state.value!;
      expect(stateData.album.id, 1);
      expect(stateData.album.title, 'Tuyển Tập Sơn Tùng');
      expect(stateData.album.tracks.length, 2);
      expect(stateData.isFavorite, false);
      verify(() => mockRepository.getAlbumDetail(albumId)).called(1);
    });

    test('loadAlbumDetail phát ra AsyncError khi repository gặp lỗi', () async {
      when(() => mockRepository.getAlbumDetail(albumId))
          .thenThrow(Exception('Không thể tải chi tiết album'));

      final controller = AlbumDetailController(mockRepository, albumId);

      await Future<void>.delayed(Duration.zero);

      expect(controller.state, isA<AsyncError<AlbumDetailState>>());
      expect(
        controller.state.error.toString(),
        contains('Không thể tải chi tiết album'),
      );
    });

    test('toggleFavorite thay đổi trạng thái yêu thích album đúng logic', () async {
      when(() => mockRepository.getAlbumDetail(albumId))
          .thenAnswer((_) async => testAlbum);

      final controller = AlbumDetailController(mockRepository, albumId);
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.value!.isFavorite, false);

      controller.toggleFavorite();
      expect(controller.state.value!.isFavorite, true);

      controller.toggleFavorite();
      expect(controller.state.value!.isFavorite, false);
    });
  });
}
