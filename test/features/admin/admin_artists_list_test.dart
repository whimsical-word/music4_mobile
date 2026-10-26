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

  group('UC64 - Artist List Tests', () {
    test('build() — tải danh sách nghệ sĩ thành công với số lượng track và album', () async {
      when(() => mockRepo.getArtists(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeArtistPage);

      final state = await container.read(adminArtistsProvider.future);
      expect(state.length, 1);
      expect(state.first.name, 'Sơn Tùng M-TP');
      expect(state.first.trackTotal, 15);
      expect(state.first.albumTotal, 2);
      expect(state.first.isDeleted, false);
      verify(() => mockRepo.getArtists(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).called(1);
    });

    test('refresh() — làm mới danh sách nghệ sĩ', () async {
      when(() => mockRepo.getArtists(
            page: any(named: 'page'),
            size: any(named: 'size'),
            includeDeleted: any(named: 'includeDeleted'),
          )).thenAnswer((_) async => fakeArtistPage);

      await container.read(adminArtistsProvider.future);
      final notifier = container.read(adminArtistsProvider.notifier);

      await notifier.refresh();
      final updatedState = container.read(adminArtistsProvider).value;
      expect(updatedState?.length, 1);
    });
  });
}
