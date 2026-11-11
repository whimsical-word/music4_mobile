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

  final lockedUser = AdminUserModel(
    id: 11,
    name: 'Người Dùng Khóa',
    email: 'locked@music4.vn',
    role: 'ROLE_USER',
    username: 'lockeduser',
    isDeleted: true,
    enabled: false,
  );

  final fakeUserPage = AdminUserPageModel(
    content: [lockedUser],
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

  group('UC62 - Delete & Reactivate User Tests', () {
    test('reactivateUser() — kích hoạt lại tài khoản thành công và cập nhật optimistic', () async {
      when(() => mockRepo.getUsers(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeUserPage);
      when(() => mockRepo.reactivateUser(11)).thenAnswer((_) async {});

      await container.read(adminUsersProvider.future);
      final notifier = container.read(adminUsersProvider.notifier);

      final result = await notifier.reactivateUser(11);
      expect(result, true);

      final state = container.read(adminUsersProvider).value;
      expect(state?.first.isDeleted, false);
      verify(() => mockRepo.reactivateUser(11)).called(1);
    });

    test('reactivateUser() — rollback khi xảy ra lỗi máy chủ', () async {
      when(() => mockRepo.getUsers(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeUserPage);
      when(() => mockRepo.reactivateUser(11))
          .thenThrow(const AdminException('Không thể kích hoạt lại tài khoản'));

      await container.read(adminUsersProvider.future);
      final notifier = container.read(adminUsersProvider.notifier);

      final result = await notifier.reactivateUser(11);
      expect(result, false);

      final state = container.read(adminUsersProvider).value;
      expect(state?.first.isDeleted, true);
    });
  });
}
