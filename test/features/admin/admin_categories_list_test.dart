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

  final fakeCategories = [
    const AdminCategoryModel(id: 1, name: 'V-Pop'),
    const AdminCategoryModel(id: 2, name: 'Ballad'),
    const AdminCategoryModel(id: 3, name: 'Hip-Hop / Rap'),
  ];

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

  group('UC56 - Category List Tests', () {
    test('build() — tải danh sách thể loại thành công', () async {
      when(() => mockRepo.getCategories())
          .thenAnswer((_) async => fakeCategories);

      final state = await container.read(adminCategoriesProvider.future);
      expect(state.length, 3);
      expect(state[0].name, 'V-Pop');
      expect(state[1].name, 'Ballad');
      expect(state[2].name, 'Hip-Hop / Rap');
      verify(() => mockRepo.getCategories()).called(1);
    });

    test('refresh() — làm mới danh sách thể loại', () async {
      when(() => mockRepo.getCategories())
          .thenAnswer((_) async => fakeCategories);

      await container.read(adminCategoriesProvider.future);
      final notifier = container.read(adminCategoriesProvider.notifier);

      await notifier.refresh();
      final updatedState = container.read(adminCategoriesProvider).value;
      expect(updatedState?.length, 3);
    });
  });
}
