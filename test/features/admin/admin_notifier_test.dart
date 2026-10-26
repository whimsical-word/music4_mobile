import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/admin/data/models/admin_artist_model.dart';
import 'package:music4_mobile/features/admin/data/models/admin_artist_page_model.dart';
import 'package:music4_mobile/features/admin/data/models/admin_category_model.dart';
import 'package:music4_mobile/features/admin/data/models/admin_user_model.dart';
import 'package:music4_mobile/features/admin/data/models/admin_user_page_model.dart';
import 'package:music4_mobile/features/admin/data/repositories/admin_repository.dart';
import 'package:music4_mobile/features/admin/presentation/providers/admin_artists_provider.dart';
import 'package:music4_mobile/features/admin/presentation/providers/admin_categories_provider.dart';
import 'package:music4_mobile/features/admin/presentation/providers/admin_users_provider.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {
  late MockAdminRepository mockRepo;
  late ProviderContainer container;

  final fakeUser = AdminUserModel(
    id: 1,
    name: 'Quoc Leader',
    email: 'quoc@example.com',
    role: 'ROLE_ADMIN',
    username: 'quocnt',
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

  final fakeArtist = AdminArtistModel(
    id: 1,
    name: 'Sơn Tùng M-TP',
    email: 'sontung@mtp.vn',
    userName: 'sontungmtp',
    trackTotal: 15,
    albumTotal: 2,
    isDeleted: false,
    enabled: true,
  );

  final fakeArtistPage = AdminArtistPageModel(
    content: [fakeArtist],
    totalElements: 1,
    totalPages: 1,
    pageNumber: 0,
    size: 20,
    last: true,
  );

  final fakeCategory = AdminCategoryModel(id: 1, name: 'V-Pop');

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

  group('AdminUsersNotifier Tests', () {
    test('build() — tải danh sách người dùng thành công', () async {
      when(() => mockRepo.getUsers(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeUserPage);

      final state = await container.read(adminUsersProvider.future);
      expect(state.length, 1);
      expect(state.first.name, 'Quoc Leader');
      expect(state.first.isDeleted, false);
    });

    test('deleteUser() — vô hiệu hóa tài khoản và cập nhật optimistic', () async {
      when(() => mockRepo.getUsers(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeUserPage);
      when(() => mockRepo.deleteUser(1)).thenAnswer((_) async {});

      await container.read(adminUsersProvider.future);
      final notifier = container.read(adminUsersProvider.notifier);

      final result = await notifier.deleteUser(1);
      expect(result, true);

      final updatedState = container.read(adminUsersProvider).value;
      expect(updatedState?.first.isDeleted, true);
      verify(() => mockRepo.deleteUser(1)).called(1);
    });

    test('reactivateUser() — kích hoạt lại tài khoản thành công', () async {
      final lockedUser = fakeUser.copyWith(isDeleted: true);
      final lockedPage = fakeUserPage.copyWith(content: [lockedUser]);

      when(() => mockRepo.getUsers(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => lockedPage);
      when(() => mockRepo.reactivateUser(1)).thenAnswer((_) async {});

      await container.read(adminUsersProvider.future);
      final notifier = container.read(adminUsersProvider.notifier);

      final result = await notifier.reactivateUser(1);
      expect(result, true);

      final updatedState = container.read(adminUsersProvider).value;
      expect(updatedState?.first.isDeleted, false);
      verify(() => mockRepo.reactivateUser(1)).called(1);
    });
  });

  group('AdminCategoriesNotifier Tests', () {
    test('build() — tải danh sách thể loại thành công', () async {
      when(() => mockRepo.getCategories())
          .thenAnswer((_) async => [fakeCategory]);

      final state = await container.read(adminCategoriesProvider.future);
      expect(state.length, 1);
      expect(state.first.name, 'V-Pop');
    });

    test('createCategory() — thêm mới thể loại vào state', () async {
      when(() => mockRepo.getCategories()).thenAnswer((_) async => []);
      when(() => mockRepo.createCategory('Pop'))
          .thenAnswer((_) async => const AdminCategoryModel(id: 2, name: 'Pop'));

      await container.read(adminCategoriesProvider.future);
      final notifier = container.read(adminCategoriesProvider.notifier);

      await notifier.createCategory('Pop');
      final list = container.read(adminCategoriesProvider).value;

      expect(list?.length, 1);
      expect(list?.first.name, 'Pop');
    });

    test('updateCategory() — cập nhật tên thể loại trong state', () async {
      when(() => mockRepo.getCategories())
          .thenAnswer((_) async => [fakeCategory]);
      when(() => mockRepo.updateCategory(1, 'V-Pop Modern'))
          .thenAnswer((_) async => const AdminCategoryModel(id: 1, name: 'V-Pop Modern'));

      await container.read(adminCategoriesProvider.future);
      final notifier = container.read(adminCategoriesProvider.notifier);

      await notifier.updateCategory(1, 'V-Pop Modern');
      final list = container.read(adminCategoriesProvider).value;

      expect(list?.first.name, 'V-Pop Modern');
    });

    test('deleteCategory() — xóa thể loại khỏi state', () async {
      when(() => mockRepo.getCategories())
          .thenAnswer((_) async => [fakeCategory]);
      when(() => mockRepo.deleteCategory(1)).thenAnswer((_) async {});

      await container.read(adminCategoriesProvider.future);
      final notifier = container.read(adminCategoriesProvider.notifier);

      await notifier.deleteCategory(1);
      final list = container.read(adminCategoriesProvider).value;

      expect(list, isEmpty);
    });
  });

  group('AdminArtistsNotifier Tests', () {
    test('build() — tải danh sách nghệ sĩ thành công', () async {
      when(() => mockRepo.getArtists(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeArtistPage);

      final state = await container.read(adminArtistsProvider.future);
      expect(state.length, 1);
      expect(state.first.name, 'Sơn Tùng M-TP');
      expect(state.first.isDeleted, false);
      expect(state.first.trackTotal, 15);
    });

    test('deleteArtist() — vô hiệu hóa nghệ sĩ và cập nhật optimistic', () async {
      when(() => mockRepo.getArtists(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeArtistPage);
      when(() => mockRepo.deleteArtist(1)).thenAnswer((_) async {});

      await container.read(adminArtistsProvider.future);
      final notifier = container.read(adminArtistsProvider.notifier);

      final result = await notifier.deleteArtist(1);
      expect(result, true);

      final updatedState = container.read(adminArtistsProvider).value;
      expect(updatedState?.first.isDeleted, true);
      verify(() => mockRepo.deleteArtist(1)).called(1);
    });

    test('reactivateArtist() — kích hoạt lại nghệ sĩ thành công', () async {
      final lockedArtist = fakeArtist.copyWith(isDeleted: true);
      final lockedPage = fakeArtistPage.copyWith(content: [lockedArtist]);

      when(() => mockRepo.getArtists(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => lockedPage);
      when(() => mockRepo.reactivateArtist(1)).thenAnswer((_) async {});

      await container.read(adminArtistsProvider.future);
      final notifier = container.read(adminArtistsProvider.notifier);

      final result = await notifier.reactivateArtist(1);
      expect(result, true);

      final updatedState = container.read(adminArtistsProvider).value;
      expect(updatedState?.first.isDeleted, false);
      verify(() => mockRepo.reactivateArtist(1)).called(1);
    });
  });
}
