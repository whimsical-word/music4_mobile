import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/album/data/models/album_model.dart';
import 'package:music4_mobile/features/home/data/sources/home_repository.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_albums_controller.dart';
import 'package:music4_mobile/features/home/presentation/controllers/home_feed_controller.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

AlbumModel _album(int i) => AlbumModel(
  id: '$i',
  title: 'Album $i',
  artistId: '1',
  artistName: 'Artist',
  releaseDate: DateTime(2026, 1, 1),
  trackCount: 3,
);

List<AlbumModel> _albums(int count, {int start = 0}) => [
  for (var i = 0; i < count; i++) _album(start + i),
];

const int _size = HomeAlbumsNotifier.pageSize;

void main() {
  late MockHomeRepository repository;
  late ProviderContainer container;

  void stubPage(int page, List<AlbumModel> albums) {
    when(
      () => repository.getAlbumsPage(page: page, size: _size),
    ).thenAnswer((_) async => albums);
  }

  /// Creates the container and keeps the autoDispose provider alive.
  void start() {
    container = ProviderContainer(
      overrides: [homeRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    container.listen(homeAlbumsProvider, (_, _) {});
  }

  HomeAlbumsNotifier notifier() => container.read(homeAlbumsProvider.notifier);
  AsyncValue<HomeAlbumsState> state() => container.read(homeAlbumsProvider);

  setUp(() {
    repository = MockHomeRepository();
  });

  group('[CE190284] HomeAlbumsNotifier (Album nổi bật tab)', () {
    test('loads the first page and knows more may follow when it is full', () async {
      stubPage(0, _albums(_size));
      start();
      await pumpEventQueue();

      expect(state().value?.items, hasLength(_size));
      expect(state().value?.hasMore, isTrue);
    });

    test('a short first page means there is nothing more to load', () async {
      stubPage(0, _albums(_size - 1));
      start();
      await pumpEventQueue();

      expect(state().value?.hasMore, isFalse);
    });

    test('loadMore appends the next page and skips repeated albums', () async {
      stubPage(0, _albums(_size));
      // Page 1 repeats the last album of page 0 (the list shifted meanwhile).
      stubPage(1, _albums(3, start: _size - 1));
      start();
      await pumpEventQueue();

      await notifier().loadMore();

      final items = state().value!.items;
      expect(items, hasLength(_size + 2));
      expect(items.map((a) => a.id).toSet(), hasLength(items.length));
      expect(state().value?.hasMore, isFalse);
      expect(state().value?.isLoadingMore, isFalse);
    });

    test('loadMore does nothing when there is no more data', () async {
      stubPage(0, _albums(2));
      start();
      await pumpEventQueue();

      await notifier().loadMore();

      verifyNever(() => repository.getAlbumsPage(page: 1, size: _size));
    });

    test('a failed loadMore keeps the list and allows another try', () async {
      stubPage(0, _albums(_size));
      when(
        () => repository.getAlbumsPage(page: 1, size: _size),
      ).thenAnswer((_) async => throw const HomeException('Lỗi'));
      start();
      await pumpEventQueue();

      await notifier().loadMore();

      expect(state().hasError, isFalse);
      expect(state().value?.items, hasLength(_size));
      expect(state().value?.isLoadingMore, isFalse);
      expect(state().value?.hasMore, isTrue);
    });

    test('a failed first load is an error and fetch() retries', () async {
      var fail = true;
      when(() => repository.getAlbumsPage(page: 0, size: _size)).thenAnswer((_) async {
        if (fail) throw const HomeException('Mạng quá yếu, thử lại sau');
        return _albums(2);
      });
      start();
      await pumpEventQueue();

      expect(state().hasError, isTrue);
      expect(state().error.toString(), 'Mạng quá yếu, thử lại sau');

      fail = false;
      await notifier().fetch();

      expect(state().hasError, isFalse);
      expect(state().value?.items, hasLength(2));
    });
  });
}
