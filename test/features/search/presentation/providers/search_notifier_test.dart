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
      when(
        () => mockRepo.search(
          'Sơn Tùng',
          type: 'all',
          page: any(named: 'page'),
          size: any(named: 'size'),
        ),
      ).thenAnswer((_) async => fakeResponse);

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

      // Xác nhận Repository được gọi đúng 1 lần với page=0, size=20
      verify(
        () => mockRepo.search('Sơn Tùng', type: 'all', page: 0, size: 20),
      ).called(1);
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
      when(
        () => mockRepo.search(
          'xyz',
          type: 'all',
          page: any(named: 'page'),
          size: any(named: 'size'),
        ),
      ).thenThrow(Exception('Không có kết nối đến máy chủ backend.'));

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

      // Error message phải khớp chính xác nội dung lỗi đã loại bỏ tiền tố "Exception: "
      expect(
        state.error.toString(),
        equals('Không có kết nối đến máy chủ backend.'),
      );

      verify(
        () => mockRepo.search('xyz', type: 'all', page: 0, size: 20),
      ).called(1);
    },
  );

  // ============================================================
  // TEST CASE 3: Query rỗng → State trả về null (không gọi API)
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
      verifyNever(
        () => mockRepo.search(
          any(),
          type: any(named: 'type'),
          page: any(named: 'page'),
          size: any(named: 'size'),
        ),
      );
    },
  );

  // ============================================================
  // TEST CASE 4: Đổi FilterChip (searchTypeProvider) + refreshSearch()
  // ============================================================
  test(
    'refreshSearch() — khi người dùng chọn FilterChip (ví dụ: track), '
    'phải gọi lại API với type mới tương ứng',
    () async {
      when(
        () => mockRepo.search(
          'chayj ngay di',
          type: any(named: 'type'),
          page: any(named: 'page'),
          size: any(named: 'size'),
        ),
      ).thenAnswer((_) async => fakeResponse);

      final notifier = container.read(searchProvider.notifier);

      // Bước 1: Tìm với type mặc định 'all'
      notifier.onSearchChanged('chayj ngay di');
      await Future.delayed(const Duration(milliseconds: 500));

      // Bước 2: Người dùng bấm chọn FilterChip 'track'
      container.read(searchTypeProvider.notifier).state = 'track';
      notifier.refreshSearch();
      await Future.delayed(const Duration(milliseconds: 500));

      verify(
        () => mockRepo.search('chayj ngay di', type: 'all', page: 0, size: 20),
      ).called(1);
      verify(
        () => mockRepo.search(
          'chayj ngay di',
          type: 'track',
          page: 0,
          size: 20,
        ),
      ).called(1);
    },
  );
}
