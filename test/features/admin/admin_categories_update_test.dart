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

  const initialCategory = AdminCategoryModel(id: 1, name: 'V-Pop');
  const updatedCategory = AdminCategoryModel(id: 1, name: 'V-Pop Modern');

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

  group('UC59 - Update Category Tests', () {
    test('updateCategory() — cập nhật tên thể loại trong state', () async {
      when(() => mockRepo.getCategories())
          .thenAnswer((_) async => [initialCategory]);
      when(() => mockRepo.updateCategory(1, 'V-Pop Modern'))
          .thenAnswer((_) async => updatedCategory);

      await container.read(adminCategoriesProvider.future);
      final notifier = container.read(adminCategoriesProvider.notifier);

      await notifier.updateCategory(1, 'V-Pop Modern');
      final list = container.read(adminCategoriesProvider).value;

      expect(list?.length, 1);
      expect(list?.first.id, 1);
      expect(list?.first.name, 'V-Pop Modern');
      verify(() => mockRepo.updateCategory(1, 'V-Pop Modern')).called(1);
    });
  });
}
