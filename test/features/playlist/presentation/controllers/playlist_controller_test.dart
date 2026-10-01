import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/playlist/data/models/playlist_model.dart';
import 'package:music4_mobile/features/playlist/data/repositories/playlist_repository.dart';
import 'package:music4_mobile/features/playlist/presentation/controllers/playlist_controller.dart';

class MockPlaylistRepository extends Mock implements PlaylistRepository {}

void main() {
  late MockPlaylistRepository mockRepository;

  setUp(() {
    mockRepository = MockPlaylistRepository();
  });

  ProviderContainer makeProviderContainer(MockPlaylistRepository repository) {
    final container = ProviderContainer(
      overrides: [
        playlistRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  const mockPlaylists = [
    PlaylistModel(id: 1, name: 'Nhạc Chill Buổi Tối', trackCount: 5),
    PlaylistModel(id: 2, name: 'Gym & Workout', trackCount: 12),
  ];

  group('PlaylistController Unit Tests', () {
    test('State ban đầu phải là AsyncLoading', () {
      when(() => mockRepository.getMyPlaylists())
          .thenAnswer((_) async => mockPlaylists);

      final container = makeProviderContainer(mockRepository);
      final initialState = container.read(playlistControllerProvider);

      expect(initialState, isA<AsyncLoading<List<PlaylistModel>>>());
    });

    test('Tải danh sách thành công -> State chuyển thành AsyncData', () async {
      when(() => mockRepository.getMyPlaylists())
          .thenAnswer((_) async => mockPlaylists);

      final container = makeProviderContainer(mockRepository);
      final controller = container.read(playlistControllerProvider.notifier);

      await controller.loadPlaylists();

      final state = container.read(playlistControllerProvider);
      expect(state, isA<AsyncData<List<PlaylistModel>>>());
      expect(state.value, equals(mockPlaylists));
      expect(state.value?.length, 2);
    });

    test('Tải danh sách thất bại -> State chuyển thành AsyncError', () async {
      when(() => mockRepository.getMyPlaylists())
          .thenThrow(Exception('Không thể kết nối máy chủ'));

      final container = makeProviderContainer(mockRepository);
      final controller = container.read(playlistControllerProvider.notifier);

      await controller.loadPlaylists();

      final state = container.read(playlistControllerProvider);
      expect(state, isA<AsyncError<List<PlaylistModel>>>());
      expect(state.hasError, true);
    });

    test('Tạo playlist mới thành công -> Danh sách được chèn lên đầu (Optimistic)', () async {
      when(() => mockRepository.getMyPlaylists())
          .thenAnswer((_) async => mockPlaylists);

      const created = PlaylistModel(id: 3, name: 'Nhạc Mới Nhất', trackCount: 0);
      when(() => mockRepository.createPlaylist(name: 'Nhạc Mới Nhất', description: null))
          .thenAnswer((_) async => created);

      final container = makeProviderContainer(mockRepository);
      final controller = container.read(playlistControllerProvider.notifier);

      await controller.loadPlaylists();
      await controller.createPlaylist('Nhạc Mới Nhất');

      final state = container.read(playlistControllerProvider);
      expect(state.value?.length, 3);
      expect(state.value?.first.name, 'Nhạc Mới Nhất');
      expect(state.value?.first.id, 3);
    });

    test('Xóa playlist thành công -> Xóa khỏi danh sách', () async {
      when(() => mockRepository.getMyPlaylists())
          .thenAnswer((_) async => mockPlaylists);
      when(() => mockRepository.deletePlaylist(1))
          .thenAnswer((_) async {});

      final container = makeProviderContainer(mockRepository);
      final controller = container.read(playlistControllerProvider.notifier);

      await controller.loadPlaylists();
      await controller.deletePlaylist(1);

      final state = container.read(playlistControllerProvider);
      expect(state.value?.length, 1);
      expect(state.value?.any((p) => p.id == 1), false);
    });

    test('Xóa playlist thất bại -> Hoàn tác lại danh sách ban đầu (Rollback)', () async {
      when(() => mockRepository.getMyPlaylists())
          .thenAnswer((_) async => mockPlaylists);
      when(() => mockRepository.deletePlaylist(1))
          .thenThrow(Exception('Lỗi mạng khi xóa'));

      final container = makeProviderContainer(mockRepository);
      final controller = container.read(playlistControllerProvider.notifier);

      await controller.loadPlaylists();

      // Khi xóa gặp lỗi, hàm sẽ rethrow
      expect(
        () async => await controller.deletePlaylist(1),
        throwsA(isA<Exception>()),
      );

      final state = container.read(playlistControllerProvider);
      expect(state.value?.length, 2);
      expect(state.value?.any((p) => p.id == 1), true);
    });

    test('Cập nhật thông tin playlist thành công -> Cập nhật item trong State', () async {
      when(() => mockRepository.getMyPlaylists())
          .thenAnswer((_) async => mockPlaylists);

      const updatedPlaylist = PlaylistModel(
        id: 1,
        name: 'Nhạc Chill Update',
        description: 'Mô tả mới',
        trackCount: 0,
      );

      when(() => mockRepository.updatePlaylist(
            1,
            name: 'Nhạc Chill Update',
            description: 'Mô tả mới',
          )).thenAnswer((_) async => updatedPlaylist);

      final container = makeProviderContainer(mockRepository);
      final controller = container.read(playlistControllerProvider.notifier);

      await controller.loadPlaylists();
      await controller.updatePlaylist(
        1,
        name: 'Nhạc Chill Update',
        description: 'Mô tả mới',
      );

      final state = container.read(playlistControllerProvider);
      final item = state.value?.firstWhere((p) => p.id == 1);
      expect(item?.name, 'Nhạc Chill Update');
      expect(item?.description, 'Mô tả mới');
      expect(item?.trackCount, 5);
    });
  });
}
