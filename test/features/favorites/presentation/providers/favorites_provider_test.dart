import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/favorites/data/repositories/favorites_repository.dart';
import 'package:music4_mobile/features/favorites/domain/models/favorite_track.dart';
import 'package:music4_mobile/features/favorites/providers/favorites_provider.dart';

import '../../favorites_test_helpers.dart';

void main() {
  late MockFavoritesRepository repository;
  late ProviderContainer container;

  void stubList() {
    when(
      () => repository.getMyFavorites(),
    ).thenAnswer((_) async => favoriteResponses());
  }

  /// Creates the container and keeps the autoDispose provider alive.
  void start([AuthState auth = const AuthUnauthenticated()]) {
    container = ProviderContainer(
      overrides: [
        favoritesRepositoryProvider.overrideWithValue(repository),
        authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(auth)),
      ],
    );
    addTearDown(container.dispose);
    container.listen(favoritesProvider, (_, _) {});
  }

  Future<List<FavoriteTrack>> load() => container.read(favoritesProvider.future);

  FavoritesNotifier notifier() => container.read(favoritesProvider.notifier);
  AsyncValue<List<FavoriteTrack>> state() => container.read(favoritesProvider);

  setUp(() {
    repository = MockFavoritesRepository();
  });

  group('[CE190284] FavoritesNotifier - loading and auth', () {
    test('loads the favorites newest first and maps them', () async {
      stubList();
      start(authenticated(7));

      final tracks = await load();

      verify(() => repository.getMyFavorites()).called(1);
      // likedAt: 12 (Oct 5) > 13 (Oct 3) > 11 (Oct 1).
      expect(tracks.map((t) => t.id), ['12', '13', '11']);
      expect(tracks.last.title, 'Lạc Trôi');
    });

    test('a guest never calls the API', () async {
      start();

      await expectLater(load(), throwsA(isA<FavoritesException>()));

      verifyNever(() => repository.getMyFavorites());
      expect(
        state().error.toString(),
        'Vui lòng đăng nhập để xem danh sách yêu thích.',
      );
    });

    test('an empty list is a valid data state', () async {
      when(() => repository.getMyFavorites()).thenAnswer((_) async => []);
      start(authenticated(7));

      expect(await load(), isEmpty);
      expect(state().hasError, isFalse);
    });

    test('an API failure is an error and retry() recovers', () async {
      var fail = true;
      when(() => repository.getMyFavorites()).thenAnswer((_) async {
        if (fail) throw const FavoritesException('Lỗi kết nối');
        return favoriteResponses();
      });
      start(authenticated(7));

      await expectLater(load(), throwsA(isA<FavoritesException>()));
      expect(state().error.toString(), 'Lỗi kết nối');

      fail = false;
      await notifier().retry();

      expect(state().hasError, isFalse);
      expect(state().value, hasLength(3));
    });

    test('switching user reloads the favorites for the new user', () async {
      stubList();
      start(authenticated(1));
      await load();

      (container.read(authNotifierProvider.notifier) as FakeAuthNotifier)
          .setAuthState(authenticated(2));
      await pumpEventQueue();

      verify(() => repository.getMyFavorites()).called(2);
    });

    test('refresh() replaces the list without a loading state', () async {
      stubList();
      start(authenticated(7));
      await load();

      final emitted = <AsyncValue<List<FavoriteTrack>>>[];
      container.listen(favoritesProvider, (_, next) => emitted.add(next));

      when(
        () => repository.getMyFavorites(),
      ).thenAnswer((_) async => [favoriteResponses().first]);
      await notifier().refresh();

      expect(emitted.any((s) => s.isLoading), isFalse);
      expect(state().value?.map((t) => t.id), ['11']);
    });

    test('a failed refresh keeps the current list', () async {
      stubList();
      start(authenticated(7));
      await load();

      when(
        () => repository.getMyFavorites(),
      ).thenAnswer((_) async => throw const FavoritesException('Lỗi'));
      await notifier().refresh();

      expect(state().hasError, isFalse);
      expect(state().value, hasLength(3));
    });
  });

  group('[CE190284] FavoritesNotifier - removeFavorite', () {
    test('removes the track only after the backend confirms', () async {
      stubList();
      final completer = Completer<bool>();
      when(() => repository.toggleFavorite(11)).thenAnswer((_) => completer.future);
      start(authenticated(7));
      await load();

      final future = notifier().removeFavorite('11');
      await pumpEventQueue();

      // The request is still running: the list must not have changed yet.
      expect(state().value, hasLength(3));

      completer.complete(false); // backend: no longer a favorite
      expect(await future, FavoriteRemoveResult.removed);
      expect(state().value?.map((t) => t.id), ['12', '13']);
    });

    test('a failed request keeps the list and reports failure', () async {
      stubList();
      when(
        () => repository.toggleFavorite(11),
      ).thenAnswer((_) async => throw const FavoritesException('Lỗi'));
      start(authenticated(7));
      await load();

      final result = await notifier().removeFavorite('11');

      expect(result, FavoriteRemoveResult.failed);
      expect(state().hasError, isFalse);
      expect(state().value, hasLength(3));
    });

    test('a second tap while the first is running is ignored', () async {
      stubList();
      final completer = Completer<bool>();
      when(() => repository.toggleFavorite(11)).thenAnswer((_) => completer.future);
      start(authenticated(7));
      await load();

      final first = notifier().removeFavorite('11');
      final second = await notifier().removeFavorite('11');

      expect(second, FavoriteRemoveResult.inProgress);
      verify(() => repository.toggleFavorite(11)).called(1);

      completer.complete(false);
      expect(await first, FavoriteRemoveResult.removed);
    });

    test('the track can be removed again after a failed attempt', () async {
      stubList();
      var fail = true;
      when(() => repository.toggleFavorite(11)).thenAnswer((_) async {
        if (fail) throw const FavoritesException('Lỗi');
        return false;
      });
      start(authenticated(7));
      await load();

      expect(await notifier().removeFavorite('11'), FavoriteRemoveResult.failed);

      fail = false;
      expect(await notifier().removeFavorite('11'), FavoriteRemoveResult.removed);
      expect(state().value?.map((t) => t.id), ['12', '13']);
    });

    test('liked == true means it was already unliked: it stays in the list', () async {
      stubList();
      when(() => repository.toggleFavorite(11)).thenAnswer((_) async => true);
      start(authenticated(7));
      await load();

      final result = await notifier().removeFavorite('11');

      expect(result, FavoriteRemoveResult.stillFavorite);
      expect(state().value, hasLength(3));
    });

    test('an invalid track id is rejected without a request', () async {
      stubList();
      start(authenticated(7));
      await load();

      expect(await notifier().removeFavorite('abc'), FavoriteRemoveResult.failed);

      verifyNever(() => repository.toggleFavorite(any()));
    });
  });
}
