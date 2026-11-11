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

  group('UC58 - Create Category Tests', () {
    test('createCategory() — thêm mới thể loại vào state', () async {
      when(() => mockRepo.getCategories()).thenAnswer((_) async => []);
      when(() => mockRepo.createCategory('Acoustic'))
          .thenAnswer((_) async => const AdminCategoryModel(id: 10, name: 'Acoustic'));

      await container.read(adminCategoriesProvider.future);
      final notifier = container.read(adminCategoriesProvider.notifier);

      await notifier.createCategory('Acoustic');
      final list = container.read(adminCategoriesProvider).value;

      expect(list?.length, 1);
      expect(list?.first.id, 10);
      expect(list?.first.name, 'Acoustic');
      verify(() => mockRepo.createCategory('Acoustic')).called(1);
    });
  });
}
