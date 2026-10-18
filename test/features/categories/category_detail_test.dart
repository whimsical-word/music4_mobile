import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/categories/data/models/category_detail_model.dart';
import 'package:music4_mobile/features/categories/data/repositories/category_repository.dart';
import 'package:music4_mobile/features/categories/presentation/providers/category_detail_provider.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late MockCategoryRepository mockRepo;
  late ProviderContainer container;

  final fakeCategoryDetail = CategoryDetailModel(
    id: 1,
    name: 'V-Pop',
    tracks: [
      const CategoryTrackModel(
        id: 101,
        name: 'Chạy Ngay Đi',
        albumName: 'Single',
        duration: 210,
        viewCount: 5000,
        artists: [
          CategoryTrackArtistInfo(id: 1, name: 'Sơn Tùng M-TP', role: 'MAIN'),
        ],
      ),
    ],
  );

  setUp(() {
    mockRepo = MockCategoryRepository();
    container = ProviderContainer(
      overrides: [
        categoryRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('CategoryDetailNotifier Tests', () {
    test('build(id) — tải thông tin chi tiết thể loại và bài hát thành công', () async {
      when(() => mockRepo.getCategoryDetail(1))
          .thenAnswer((_) async => fakeCategoryDetail);

      final detail = await container.read(categoryDetailProvider(1).future);

      expect(detail.id, 1);
      expect(detail.name, 'V-Pop');
      expect(detail.tracks.length, 1);
      expect(detail.tracks.first.name, 'Chạy Ngay Đi');
    });

    test('build(id) — API lỗi trả về AsyncError', () async {
      when(() => mockRepo.getCategoryDetail(999))
          .thenThrow(const CategoryException('Không tìm thấy thể loại nhạc này.'));

      expect(
        () => container.read(categoryDetailProvider(999).future),
        throwsA(isA<CategoryException>()),
      );
    });
  });
}
