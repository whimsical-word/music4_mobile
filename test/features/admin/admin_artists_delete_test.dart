import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/admin/data/models/admin_artist_model.dart';
import 'package:music4_mobile/features/admin/data/models/admin_artist_page_model.dart';
import 'package:music4_mobile/features/admin/data/repositories/admin_repository.dart';
import 'package:music4_mobile/features/admin/presentation/providers/admin_artists_provider.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

void main() {
  late MockAdminRepository mockRepo;
  late ProviderContainer container;

  final lockedArtist = AdminArtistModel(
    id: 6,
    name: 'Nghệ Sĩ Bị Khóa',
    email: 'lockedartist@music4.vn',
    userName: 'lockedartist',
    trackTotal: 0,
    albumTotal: 0,
    isDeleted: true,
    enabled: false,
  );

  final fakeArtistPage = AdminArtistPageModel(
    content: [lockedArtist],
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

  group('UC65 - Delete & Reactivate Artist Tests', () {
    test('reactivateArtist() — khôi phục nghệ sĩ thành công và cập nhật optimistic', () async {
      when(() => mockRepo.getArtists(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeArtistPage);
      when(() => mockRepo.reactivateArtist(6)).thenAnswer((_) async {});

      await container.read(adminArtistsProvider.future);
      final notifier = container.read(adminArtistsProvider.notifier);

      final result = await notifier.reactivateArtist(6);
      expect(result, true);

      final state = container.read(adminArtistsProvider).value;
      expect(state?.first.isDeleted, false);
      verify(() => mockRepo.reactivateArtist(6)).called(1);
    });

    test('reactivateArtist() — rollback khi xảy ra lỗi máy chủ', () async {
      when(() => mockRepo.getArtists(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeArtistPage);
      when(() => mockRepo.reactivateArtist(6))
          .thenThrow(const AdminException('Không thể kích hoạt lại nghệ sĩ'));

      await container.read(adminArtistsProvider.future);
      final notifier = container.read(adminArtistsProvider.notifier);

      final result = await notifier.reactivateArtist(6);
      expect(result, false);

      final state = container.read(adminArtistsProvider).value;
      expect(state?.first.isDeleted, true);
    });
  });
}
