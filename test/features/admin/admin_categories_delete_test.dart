import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/admin/data/models/admin_category_model.dart';
import 'package:music4_mobile/features/admin/data/repositories/admin_repository.dart';
import 'package:music4_mobile/features/admin/presentation/providers/admin_categories_provider.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {
  late MockAdminRepository mockRepo;
  late ProviderContainer container;

  const fakeCategory = AdminCategoryModel(id: 1, name: 'V-Pop');

  setUp(() {
    mockRepo = MockAdminRepository();
    container = ProviderContainer(
      overrides: [
        adminRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('UC60 - Delete Category Tests', () {
    test('deleteCategory() — xóa thể loại khỏi state và gọi API', () async {
      when(() => mockRepo.getCategories())
          .thenAnswer((_) async => [fakeCategory]);
      when(() => mockRepo.deleteCategory(1)).thenAnswer((_) async {});

      await container.read(adminCategoriesProvider.future);
      final notifier = container.read(adminCategoriesProvider.notifier);

      await notifier.deleteCategory(1);
      final list = container.read(adminCategoriesProvider).value;

      expect(list, isEmpty);
      verify(() => mockRepo.deleteCategory(1)).called(1);
    });

    test('deleteCategory() — rollback khi xảy ra lỗi', () async {
      when(() => mockRepo.getCategories())
          .thenAnswer((_) async => [fakeCategory]);
      when(() => mockRepo.deleteCategory(1))
          .thenThrow(const AdminException('Không thể xóa thể loại do có ràng buộc'));

      await container.read(adminCategoriesProvider.future);
      final notifier = container.read(adminCategoriesProvider.notifier);

      expect(() => notifier.deleteCategory(1), throwsA(isA<AdminException>()));
      final list = container.read(adminCategoriesProvider).value;

      expect(list?.length, 1);
      expect(list?.first.name, 'V-Pop');
    });
  });
}
