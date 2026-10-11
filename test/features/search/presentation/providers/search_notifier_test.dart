import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:music4_mobile/features/search/data/models/search_models.dart';
import 'package:music4_mobile/features/search/data/repositories/search_repository.dart';
import 'package:music4_mobile/features/search/presentation/providers/search_provider.dart';

// ============================================================
// 1. MOCK CLASSES
// ============================================================
class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockRepo;
  late ProviderContainer container;

  /// Dữ liệu giả (Fake Data) trả về khi API thành công
  final fakeResponse = SearchResponse(
    tracks: SearchPage(
      content: [SearchItem(id: 1, name: 'Chạy Ngay Đi')],
      totalPages: 1,
      totalElements: 1,
    ),
  );

  setUp(() {
    mockRepo = MockSearchRepository();

    // Tạo ProviderContainer với override để inject MockRepository
    container = ProviderContainer(
      overrides: [
        searchRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  // ============================================================
  // TEST CASE 1: Search thành công → State: Loading → Data
  // ============================================================
  test(
    'onSearchChanged() — khi API trả về thành công, '
    'state phải chuyển từ AsyncLoading sang AsyncData chứa SearchResponse',
    () async {
      // ARRANGE: Giả lập Repository trả về dữ liệu thành công
      when(() => mockRepo.search('Sơn Tùng', type: 'all'))
          .thenAnswer((_) async => fakeResponse);

      // Lấy SearchNotifier từ container
      final notifier = container.read(searchProvider.notifier);

      // ACT: Gọi onSearchChanged (sẽ kích hoạt debounce 300ms)
      notifier.onSearchChanged('Sơn Tùng');

      // Ngay sau khi gọi, state phải là AsyncLoading
      expect(container.read(searchProvider), isA<AsyncLoading>());

      // Chờ debounce 300ms + thời gian xử lý async
      await Future.delayed(const Duration(milliseconds: 500));

      // ASSERT: State phải chuyển sang AsyncData chứa SearchResponse
      final state = container.read(searchProvider);
      expect(state, isA<AsyncData<SearchResponse?>>());

      final data = state.value;
      expect(data, isNotNull);
      expect(data!.tracks!.content.length, equals(1));
      expect(data.tracks!.content.first.name, equals('Chạy Ngay Đi'));

      // Xác nhận Repository được gọi đúng 1 lần
      verify(() => mockRepo.search('Sơn Tùng', type: 'all')).called(1);
    },
  );

  // ============================================================
  // TEST CASE 2: Search thất bại → State: Loading → Error
  // ============================================================
  test(
    'onSearchChanged() — khi API thất bại (Exception), '
    'state phải chuyển từ AsyncLoading sang AsyncError',
    () async {
      // ARRANGE: Giả lập Repository ném lỗi
      when(() => mockRepo.search('xyz', type: 'all'))
          .thenThrow(Exception('Không có kết nối đến máy chủ backend.'));

      final notifier = container.read(searchProvider.notifier);

      // ACT
      notifier.onSearchChanged('xyz');

      // Ngay sau khi gọi, state phải là AsyncLoading
      expect(container.read(searchProvider), isA<AsyncLoading>());

      // Chờ debounce 300ms + thời gian xử lý async
      await Future.delayed(const Duration(milliseconds: 500));

      // ASSERT: State phải chuyển sang AsyncError
      final state = container.read(searchProvider);
      expect(state, isA<AsyncError<SearchResponse?>>());

      // Error message phải chứa nội dung lỗi (đã strip "Exception: " ở Notifier)
      expect(
        state.error.toString(),
        contains('Không có kết nối đến máy chủ backend.'),
      );

      verify(() => mockRepo.search('xyz', type: 'all')).called(1);
    },
  );

  // ============================================================
  // TEST CASE 3 (Bonus): Query rỗng → State trả về null (không gọi API)
  // ============================================================
  test(
    'onSearchChanged() — khi query rỗng, '
    'state phải là AsyncData(null) và KHÔNG gọi API',
    () async {
      final notifier = container.read(searchProvider.notifier);

      // ACT: Gọi với chuỗi rỗng
      notifier.onSearchChanged('   ');

      // Chờ để đảm bảo debounce không kích hoạt
      await Future.delayed(const Duration(milliseconds: 500));

      // ASSERT
      final state = container.read(searchProvider);
      expect(state, isA<AsyncData<SearchResponse?>>());
      expect(state.value, isNull);

      // Repository KHÔNG ĐƯỢC gọi
      verifyNever(() => mockRepo.search(any(), type: any(named: 'type')));
    },
  );
}
