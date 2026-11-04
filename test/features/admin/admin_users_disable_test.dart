import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/admin/data/models/admin_user_model.dart';
import 'package:music4_mobile/features/admin/data/models/admin_user_page_model.dart';
import 'package:music4_mobile/features/admin/data/repositories/admin_repository.dart';
import 'package:music4_mobile/features/admin/presentation/providers/admin_users_provider.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {
  late MockAdminRepository mockRepo;
  late ProviderContainer container;

  final fakeUser = AdminUserModel(
    id: 10,
    name: 'Nguyễn Văn Test',
    email: 'test@music4.vn',
    role: 'ROLE_USER',
    username: 'vantest',
    isDeleted: false,
    enabled: true,
  );

  final fakeUserPage = AdminUserPageModel(
    content: [fakeUser],
    totalElements: 1,
    totalPages: 1,
    pageNumber: 0,
    size: 20,
    last: true,
  );

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

  group('UC61 - Disable User Tests', () {
    test('disableUser() — cập nhật optimistic isDeleted = true và gọi API xóa', () async {
      when(() => mockRepo.getUsers(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeUserPage);
      when(() => mockRepo.deleteUser(10)).thenAnswer((_) async {});

      await container.read(adminUsersProvider.future);
      final notifier = container.read(adminUsersProvider.notifier);

      final result = await notifier.disableUser(10);
      expect(result, true);

      final state = container.read(adminUsersProvider).value;
      expect(state?.first.isDeleted, true);
      verify(() => mockRepo.deleteUser(10)).called(1);
    });

    test('disableUser() — rollback optimistic state khi repository ném ngoại lệ', () async {
      when(() => mockRepo.getUsers(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeUserPage);
      when(() => mockRepo.deleteUser(10))
          .thenThrow(const AdminException('Lỗi mạng khi vô hiệu hóa'));

      await container.read(adminUsersProvider.future);
      final notifier = container.read(adminUsersProvider.notifier);

      final result = await notifier.disableUser(10);
      expect(result, false);

      final state = container.read(adminUsersProvider).value;
      expect(state?.first.isDeleted, false);
    });
  });
}
