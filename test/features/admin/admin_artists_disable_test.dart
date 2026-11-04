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

  final fakeArtist = AdminArtistModel(
    id: 5,
    name: 'Đen Vâu',
    email: 'denvau@music4.vn',
    userName: 'denvau',
    trackTotal: 25,
    albumTotal: 3,
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

  group('UC66 - Disable Artist Tests', () {
    test('disableArtist() — vô hiệu hóa nghệ sĩ và cập nhật optimistic', () async {
      when(() => mockRepo.getArtists(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeArtistPage);
      when(() => mockRepo.deleteArtist(5)).thenAnswer((_) async {});

      await container.read(adminArtistsProvider.future);
      final notifier = container.read(adminArtistsProvider.notifier);

      final result = await notifier.disableArtist(5);
      expect(result, true);

      final state = container.read(adminArtistsProvider).value;
      expect(state?.first.isDeleted, true);
      verify(() => mockRepo.deleteArtist(5)).called(1);
    });

    test('disableArtist() — rollback khi xảy ra sự cố mạng', () async {
      when(() => mockRepo.getArtists(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeArtistPage);
      when(() => mockRepo.deleteArtist(5))
          .thenThrow(const AdminException('Không thể vô hiệu hóa nghệ sĩ'));

      await container.read(adminArtistsProvider.future);
      final notifier = container.read(adminArtistsProvider.notifier);

      final result = await notifier.disableArtist(5);
      expect(result, false);

      final state = container.read(adminArtistsProvider).value;
      expect(state?.first.isDeleted, false);
    });
  });
}
