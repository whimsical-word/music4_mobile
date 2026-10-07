import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/history/data/models/history_page_response.dart';
import 'package:music4_mobile/features/history/data/repositories/history_repository.dart';
import 'package:music4_mobile/features/history/presentation/providers/history_provider.dart';

import '../../history_test_helpers.dart';

const int _pageSize = HistoryRepository.defaultPageSize;

void main() {
  late MockHistoryRepository repository;
  late ProviderContainer container;

  void stubPage(int userId, int page, HistoryPageResponse response) {
    when(
      () => repository.getListeningHistory(
        userId,
        page: page,
        size: _pageSize,
      ),
    ).thenAnswer((_) async => response);
  }

  /// Creates the container and keeps the autoDispose provider alive.
  Future<void> start(AuthState auth) async {
    container = ProviderContainer(
      overrides: [
        historyRepositoryProvider.overrideWithValue(repository),
        authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(auth)),
      ],
    );
    addTearDown(container.dispose);
    container.listen(historyNotifierProvider, (_, _) {});
    await pumpEventQueue();
  }

  HistoryNotifier notifier() => container.read(historyNotifierProvider.notifier);
  AsyncValue<HistoryState> state() => container.read(historyNotifierProvider);

  setUp(() {
    repository = MockHistoryRepository();
  });

  group('[CE190284] HistoryNotifier - user id / auth', () {
    test('loads the history of the authenticated user (no hardcoded id)', () async {
      stubPage(42, 0, historyPage(3));

      await start(authenticated(42));

      verify(
        () => repository.getListeningHistory(42, page: 0, size: _pageSize),
      ).called(1);
      verifyNever(
        () => repository.getListeningHistory(
          1,
          page: any(named: 'page'),
          size: any(named: 'size'),
        ),
      );
      expect(state().value?.items, hasLength(3));
    });

    test('a guest never calls the API', () async {
      await start(const AuthUnauthenticated());

      verifyNever(
        () => repository.getListeningHistory(
          any(),
          page: any(named: 'page'),
          size: any(named: 'size'),
        ),
      );
      expect(state().hasError, isTrue);
      expect(
        state().error.toString(),
        'Vui lòng đăng nhập để xem lịch sử nghe nhạc.',
      );
    });

    test('switching user loads the new user history, not the cached one', () async {
      stubPage(1, 0, historyPage(2, startId: 100));
      stubPage(2, 0, historyPage(1, startId: 200));

      await start(authenticated(1));
      expect(state().value?.items.first.id, 100);

      (container.read(authNotifierProvider.notifier) as FakeAuthNotifier)
          .setAuthState(authenticated(2));
      await pumpEventQueue();

      expect(state().value?.items, hasLength(1));
      expect(state().value?.items.first.id, 200);
    });
  });

  group('[CE190284] HistoryNotifier - states', () {
    test('empty history is a valid data state with an empty list', () async {
      stubPage(1, 0, historyPage(0));

      await start(authenticated(1));

      expect(state().hasError, isFalse);
      expect(state().value?.items, isEmpty);
      expect(state().value?.hasMore, isFalse);
    });

    test('an API failure becomes an error and fetchHistory() retries', () async {
      var fail = true;
      when(
        () => repository.getListeningHistory(
          1,
          page: 0,
          size: _pageSize,
        ),
      ).thenAnswer((_) async {
        if (fail) throw const HistoryException('Lỗi kết nối');
        return historyPage(2);
      });

      await start(authenticated(1));
      expect(state().hasError, isTrue);
      expect(state().error.toString(), 'Lỗi kết nối');

      fail = false;
      await notifier().fetchHistory();

      expect(state().hasError, isFalse);
      expect(state().value?.items, hasLength(2));
    });

    test('refreshHistory replaces the list without a loading state', () async {
      stubPage(1, 0, historyPage(2));
      await start(authenticated(1));

      final emitted = <AsyncValue<HistoryState>>[];
      container.listen(historyNotifierProvider, (_, next) => emitted.add(next));

      stubPage(1, 0, historyPage(3, startId: 50));
      await notifier().refreshHistory();

      expect(emitted.any((s) => s.isLoading), isFalse);
      expect(state().value?.items.map((e) => e.id), [50, 51, 52]);
    });

    test('a failed refresh keeps the current list', () async {
      stubPage(1, 0, historyPage(2));
      await start(authenticated(1));

      when(
        () => repository.getListeningHistory(1, page: 0, size: _pageSize),
      ).thenAnswer((_) async => throw const HistoryException('Lỗi'));
      await notifier().refreshHistory();

      expect(state().hasError, isFalse);
      expect(state().value?.items, hasLength(2));
    });
  });

  group('[CE190284] HistoryNotifier - pagination', () {
    test('hasMore is true only when a full page was returned', () async {
      stubPage(1, 0, historyPage(_pageSize));
      await start(authenticated(1));
      expect(state().value?.hasMore, isTrue);

      stubPage(1, 0, historyPage(_pageSize - 1));
      await notifier().fetchHistory();
      expect(state().value?.hasMore, isFalse);
    });

    test('loadMore appends the next page and skips repeated tracks', () async {
      stubPage(1, 0, historyPage(_pageSize));
      // Page 1 repeats the last id of page 0 (the list shifted meanwhile).
      stubPage(1, 1, historyPage(3, startId: _pageSize));

      await start(authenticated(1));
      await notifier().loadMore();

      final items = state().value!.items;
      expect(items, hasLength(_pageSize + 2));
      expect(items.map((e) => e.id).toSet(), hasLength(items.length));
      expect(state().value?.hasMore, isFalse);
      expect(state().value?.isLoadingMore, isFalse);
    });

    test('loadMore does nothing when there is no more data', () async {
      stubPage(1, 0, historyPage(2));
      await start(authenticated(1));

      await notifier().loadMore();

      verifyNever(
        () => repository.getListeningHistory(1, page: 1, size: _pageSize),
      );
    });

    test('a failed loadMore keeps the list and allows another try', () async {
      stubPage(1, 0, historyPage(_pageSize));
      when(
        () => repository.getListeningHistory(1, page: 1, size: _pageSize),
      ).thenAnswer((_) async => throw const HistoryException('Lỗi'));

      await start(authenticated(1));
      await notifier().loadMore();

      expect(state().hasError, isFalse);
      expect(state().value?.items, hasLength(_pageSize));
      expect(state().value?.isLoadingMore, isFalse);
      expect(state().value?.hasMore, isTrue);
    });
  });
}
