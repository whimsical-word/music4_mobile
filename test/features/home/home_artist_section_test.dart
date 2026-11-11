import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/core/theme/app_theme.dart';
import 'package:music4_mobile/features/artist_profile/data/models/artist_response.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_artist_card.dart';
import 'package:music4_mobile/features/home/presentation/widgets/home_artist_section.dart';

void main() {
  group('[CE191634] HomeArtistSection & HomeArtistCard Widget Tests', () {
    const mockArtists = [
      ArtistResponse(
        id: 101,
        name: 'Sơn Tùng M-TP',
        img: 'https://example.com/artist1.jpg',
        trackTotal: 10,
        albumTotal: 2,
      ),
      ArtistResponse(
        id: 102,
        name: 'Đen Vâu',
        img: null,
        trackTotal: 20,
        albumTotal: 3,
      ),
    ];

    testWidgets('HomeArtistSection renders title and artist cards correctly',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeArtistListProvider.overrideWith((ref) => Future.value(mockArtists)),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: SingleChildScrollView(child: HomeArtistSection()),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Nghệ sĩ tiêu biểu'), findsOneWidget);
      expect(find.byIcon(Icons.mic_external_on_outlined), findsOneWidget);
      expect(find.text('Sơn Tùng M-TP'), findsOneWidget);
      expect(find.text('Đen Vâu'), findsOneWidget);
      expect(find.byType(HomeArtistCard), findsNWidgets(2));
    });

    testWidgets('HomeArtistSection hides when artist list is empty',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeArtistListProvider.overrideWith((ref) => Future.value([])),
          ],
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: HomeArtistSection(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Nghệ sĩ tiêu biểu'), findsNothing);
      expect(find.byType(HomeArtistCard), findsNothing);
    });

    testWidgets('HomeArtistCard displays placeholder when image is null',
        (tester) async {
      const artistWithoutImg = ArtistResponse(
        id: 103,
        name: 'Vũ.',
        img: null,
        trackTotal: 5,
        albumTotal: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(
            body: HomeArtistCard(artist: artistWithoutImg),
          ),
        ),
      );

      expect(find.text('Vũ.'), findsOneWidget);
      expect(find.text('Nghệ sĩ'), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    });
  });
}
