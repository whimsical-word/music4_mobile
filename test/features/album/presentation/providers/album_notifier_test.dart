import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/album/data/models/album_model.dart';
import 'package:music4_mobile/features/album/data/repositories/album_repository.dart';
import 'package:music4_mobile/features/album/presentation/providers/album_provider.dart';

class MockAlbumRepository extends Mock implements AlbumRepository {}

void main() {
  late MockAlbumRepository mockRepository;
  late AlbumNotifier notifier;

  final sampleAlbum1 = AlbumModel(
    id: '1',
    title: 'Thank U, Next',
    coverUrl: 'images/tun.jpg',
    artistId: '5',
    artistName: 'Ariana Grande',
    trackCount: 12,
    releaseDate: DateTime(2019, 2, 8),
  );

  final sampleAlbum2 = AlbumModel(
    id: '2',
    title: 'Sweetener',
    coverUrl: 'images/sweetener.jpg',
    artistId: '5',
    artistName: 'Ariana Grande',
    trackCount: 15,
    releaseDate: DateTime(2018, 8, 17),
  );

  setUp(() {
    mockRepository = MockAlbumRepository();
    notifier = AlbumNotifier(mockRepository);
  });

  group('[CE190036] AlbumNotifier Unit Tests UC4 UC2 UC58', () {
    test('fetchMyAlbums emits AsyncData with artist albums when successful (UC4)', () async {
      when(() => mockRepository.getAlbumsByArtist(5, artistName: 'Ariana Grande'))
          .thenAnswer((_) async => [sampleAlbum1, sampleAlbum2]);

      await notifier.fetchMyAlbums(5, artistName: 'Ariana Grande');

      expect(notifier.state, isA<AsyncData<List<AlbumModel>>>());
      expect(notifier.state.value?.length, 2);
      expect(notifier.state.value?[0].title, 'Thank U, Next');
      expect(notifier.state.value?[1].title, 'Sweetener');
    });

    test('fetchMyAlbums emits AsyncError when repository fails (UC4)', () async {
      when(() => mockRepository.getAlbumsByArtist(5, artistName: any(named: 'artistName')))
          .thenThrow(Exception('Lỗi mạng'));

      await notifier.fetchMyAlbums(5);

      expect(notifier.state, isA<AsyncError>());
    });

    test('fetchAlbums re-fetches artist albums if _currentArtistId is set (UC4)', () async {
      when(() => mockRepository.getAlbumsByArtist(5, artistName: 'Ariana Grande'))
          .thenAnswer((_) async => [sampleAlbum1]);

      await notifier.fetchMyAlbums(5, artistName: 'Ariana Grande');

      when(() => mockRepository.getAlbumsByArtist(5, artistName: 'Ariana Grande'))
          .thenAnswer((_) async => [sampleAlbum1, sampleAlbum2]);

      await notifier.fetchAlbums();

      expect(notifier.state.value?.length, 2);
      verify(() => mockRepository.getAlbumsByArtist(5, artistName: 'Ariana Grande')).called(2);
    });

    test('createAlbum prepends new album to state (UC2)', () async {
      when(() => mockRepository.getAlbumsByArtist(5, artistName: 'Ariana Grande'))
          .thenAnswer((_) async => [sampleAlbum1]);

      await notifier.fetchMyAlbums(5, artistName: 'Ariana Grande');

      final newAlbum = AlbumModel(
        id: '3',
        title: 'Positions',
        coverUrl: 'images/positions.jpg',
        artistId: '5',
        artistName: 'Ariana Grande',
        trackCount: 14,
        releaseDate: DateTime(2020, 10, 30),
      );

      when(() => mockRepository.createAlbum(
            title: 'Positions',
            artistId: 5,
            coverFilePath: any(named: 'coverFilePath'),
            artistName: 'Ariana Grande',
          )).thenAnswer((_) async => newAlbum);

      final result = await notifier.createAlbum(
        title: 'Positions',
        artistId: 5,
        artistName: 'Ariana Grande',
      );

      expect(result.id, '3');
      expect(notifier.state.value?.length, 2);
      expect(notifier.state.value?[0].title, 'Positions');
      expect(notifier.state.value?[1].title, 'Thank U, Next');
    });

    test('deleteAlbum removes deleted album from state (UC58)', () async {
      when(() => mockRepository.getAlbumsByArtist(5, artistName: 'Ariana Grande'))
          .thenAnswer((_) async => [sampleAlbum1, sampleAlbum2]);

      await notifier.fetchMyAlbums(5, artistName: 'Ariana Grande');
      expect(notifier.state.value?.length, 2);

      when(() => mockRepository.deleteAlbum('1')).thenAnswer((_) async {});

      await notifier.deleteAlbum('1');

      expect(notifier.state.value?.length, 1);
      expect(notifier.state.value?[0].id, '2');
      expect(notifier.state.value?[0].title, 'Sweetener');
      verify(() => mockRepository.deleteAlbum('1')).called(1);
    });
  });
}
