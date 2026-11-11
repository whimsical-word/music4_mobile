import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/theme/app_theme.dart';
import 'package:music4_mobile/features/album/data/models/album_model.dart';
import 'package:music4_mobile/features/search/data/models/search_models.dart';
import 'package:music4_mobile/features/search/data/repositories/search_repository.dart';
import 'package:music4_mobile/features/search/presentation/providers/search_provider.dart';
import 'package:music4_mobile/features/upload/data/models/category_model.dart';
import 'package:music4_mobile/features/upload/presentation/widgets/collab_artist_search_field.dart';
import 'package:music4_mobile/features/upload/presentation/widgets/upload_form_fields.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockSearchRepo;

  setUp(() {
    mockSearchRepo = MockSearchRepository();
  });

  final dummyCategory = const CategoryModel(id: 1, name: 'Pop');
  final dummyAlbum1 = AlbumModel(
    id: '101',
    title: 'Memories... Do Not Open',
    artistId: '1',
    artistName: 'The Chainsmokers',
    releaseDate: DateTime(2026, 1, 1),
    trackCount: 12,
  );
  final dummyAlbum2 = AlbumModel(
    id: '102',
    title: 'World War Joy',
    artistId: '1',
    artistName: 'The Chainsmokers',
    releaseDate: DateTime(2026, 2, 1),
    trackCount: 10,
  );

  Widget createTestWidget({required Widget child}) {
    return ProviderScope(
      overrides: [
        searchRepositoryProvider.overrideWithValue(mockSearchRepo),
      ],
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
      ),
    );
  }

  group('[CE190036] UploadFormFields Album & Collab Artist Tests', () {
    testWidgets('renders Album dropdown with Single and artist albums', (tester) async {
      int? selectedAlbumId;

      await tester.pumpWidget(
        createTestWidget(
          child: UploadFormFields(
            titleController: TextEditingController(),
            isUploading: false,
            selectedCategory: dummyCategory,
            categories: [dummyCategory],
            onCategoryChanged: (_) {},
            selectedAlbumId: selectedAlbumId,
            albums: [dummyAlbum1, dummyAlbum2],
            onAlbumChanged: (val) => selectedAlbumId = val,
            selectedCollabArtists: const [],
            onCollabArtistAdded: (_) {},
            onCollabArtistRemoved: (_) {},
            currentArtistId: 1,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify fields exist
      expect(find.text('Tên bài hát (Title)'), findsOneWidget);
      expect(find.text('Gán vào Album (Tùy chọn)'), findsOneWidget);
      expect(find.text('Single (Không thuộc Album nào)'), findsOneWidget);

      // Tap album dropdown
      await tester.tap(find.text('Single (Không thuộc Album nào)'));
      await tester.pumpAndSettle();

      // Should show the albums in the dropdown
      expect(find.text('Memories... Do Not Open'), findsWidgets);
      expect(find.text('World War Joy'), findsWidgets);

      // Select Album 101
      await tester.tap(find.text('Memories... Do Not Open').last);
      await tester.pumpAndSettle();

      expect(selectedAlbumId, 101);
    });

    testWidgets('CollabArtistSearchField searches artists and selects from suggestions', (tester) async {
      when(() => mockSearchRepo.search(
            'Halsey',
            type: 'artist',
            page: 0,
            size: 10,
          )).thenAnswer(
        (_) async => const SearchResponse(
          artists: SearchPage(
            content: [
              SearchItem(id: 202, name: 'Halsey', img: null),
              SearchItem(id: 1, name: 'The Chainsmokers', img: null), // Current artist (should be filtered out)
            ],
            totalElements: 2,
            totalPages: 1,
          ),
        ),
      );

      SearchItem? addedArtist;

      await tester.pumpWidget(
        createTestWidget(
          child: CollabArtistSearchField(
            selectedArtists: const [],
            onArtistAdded: (item) => addedArtist = item,
            onArtistRemoved: (_) {},
            currentArtistId: 1, // ID of logged-in artist
            enabled: true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter search query
      final searchField = find.widgetWithText(TextField, 'Ca sĩ hợp tác (Tìm theo tên nghệ sĩ)');
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Halsey');
      // Wait for debounce 300ms
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Verify Halsey appears in suggestion ListTile, but Chainsmokers (id 1) is filtered out
      final halseySuggestion = find.widgetWithText(ListTile, 'Halsey');
      expect(halseySuggestion, findsOneWidget);
      expect(find.widgetWithText(ListTile, 'The Chainsmokers'), findsNothing);

      // Tap suggestion to add Halsey
      await tester.tap(halseySuggestion);
      await tester.pumpAndSettle();

      expect(addedArtist?.id, 202);
      expect(addedArtist?.name, 'Halsey');
    });

    testWidgets('CollabArtistSearchField displays chips and allows removing', (tester) async {
      const selectedItem = SearchItem(id: 202, name: 'Halsey', img: null);
      SearchItem? removedArtist;

      await tester.pumpWidget(
        createTestWidget(
          child: CollabArtistSearchField(
            selectedArtists: const [selectedItem],
            onArtistAdded: (_) {},
            onArtistRemoved: (item) => removedArtist = item,
            currentArtistId: 1,
            enabled: true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify chip exists
      expect(find.widgetWithText(Chip, 'Halsey'), findsOneWidget);

      // Tap delete on chip
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(removedArtist?.id, 202);
    });
  });
}
