import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/track_management/data/models/artist_track_model.dart';
import 'package:music4_mobile/features/track_management/data/repositories/track_management_repository.dart';
import 'package:music4_mobile/features/track_management/presentation/screens/artist_track_management_screen.dart';

import '../../artist_profile/artist_profile_test_helpers.dart';

class MockTrackManagementRepo extends Mock implements TrackManagementRepository {}

void main() {
  late MockTrackManagementRepo mockRepo;

  final sampleTracks = [
    const ArtistTrackItemModel(
      id: 101,
      name: 'Bài Hát Single Test',
      albumName: 'Single',
      duration: 180,
      viewCount: 1200,
    ),
    const ArtistTrackItemModel(
      id: 102,
      name: 'Bài Hát Album Test',
      albumName: 'Album Mùa Hè',
      duration: 210,
      viewCount: 45000,
    ),
  ];

  setUp(() {
    mockRepo = MockTrackManagementRepo();
    when(() => mockRepo.getArtistTracks(5)).thenAnswer((_) async => sampleTracks);
  });

  Widget buildApp({
    AuthState authState = const AuthUnauthenticated(),
  }) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const ArtistTrackManagementScreen(),
        ),
        GoRoute(
          path: '/upload',
          builder: (_, _) => const Scaffold(body: Text('upload-page')),
        ),
        GoRoute(
          path: '/track/:id',
          builder: (_, state) => Scaffold(body: Text('track-detail-${state.pathParameters['id']}')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        trackManagementRepositoryProvider.overrideWithValue(mockRepo),
        authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(authState)),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('[CE190036] ArtistTrackManagementScreen Widget Tests (UC47, UC51)', () {
    testWidgets('Non-artist sees access denied screen', (tester) async {
      await tester.pumpWidget(buildApp(authState: authenticated(10)));
      await tester.pumpAndSettle();

      expect(find.text('Chỉ dành cho Nghệ sĩ'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('Artist user sees track list with search, filter chips and track items (UC47)', (tester) async {
      await tester.pumpWidget(buildApp(authState: authenticatedArtist(5)));
      await tester.pumpAndSettle();

      expect(find.text('Artist Studio - Quản lý Bài hát'), findsOneWidget);
      expect(find.text('Bài Hát Single Test'), findsOneWidget);
      expect(find.text('Bài Hát Album Test'), findsOneWidget);
      expect(find.text('Single'), findsOneWidget);
      expect(find.text('Album: Album Mùa Hè'), findsOneWidget);

      // Verify filter chips
      expect(find.text('Tất cả (2)'), findsOneWidget);
      expect(find.text('Single (1)'), findsOneWidget);
      expect(find.text('Thuộc Album (1)'), findsOneWidget);

      // Tap 'Single' filter chip
      await tester.tap(find.text('Single (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Bài Hát Single Test'), findsOneWidget);
      expect(find.text('Bài Hát Album Test'), findsNothing);

      // Tap 'Thuộc Album' filter chip
      await tester.tap(find.text('Thuộc Album (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Bài Hát Single Test'), findsNothing);
      expect(find.text('Bài Hát Album Test'), findsOneWidget);
    });

    testWidgets('Search input filters tracks properly', (tester) async {
      await tester.pumpWidget(buildApp(authState: authenticatedArtist(5)));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Single');
      await tester.pumpAndSettle();

      expect(find.text('Bài Hát Single Test'), findsOneWidget);
      expect(find.text('Bài Hát Album Test'), findsNothing);
    });

    testWidgets('Deleting track shows confirmation dialog and removes track on confirm (UC51)', (tester) async {
      when(() => mockRepo.deleteTrack(101)).thenAnswer((_) async {});

      await tester.pumpWidget(buildApp(authState: authenticatedArtist(5)));
      await tester.pumpAndSettle();

      // Tap the more_vert icon of the first track
      final moreIcons = find.byIcon(Icons.more_vert);
      expect(moreIcons, findsWidgets);
      await tester.tap(moreIcons.first);
      await tester.pumpAndSettle();

      // Tap 'Xóa bài hát'
      await tester.tap(find.text('Xóa bài hát'));
      await tester.pumpAndSettle();

      // Confirm dialog appears
      expect(find.text('Xác nhận xóa bài hát'), findsOneWidget);
      expect(find.byKey(const Key('confirm_delete_track_btn')), findsOneWidget);

      // Tap confirm button
      await tester.tap(find.byKey(const Key('confirm_delete_track_btn')));
      await tester.pumpAndSettle();

      verify(() => mockRepo.deleteTrack(101)).called(1);
      expect(find.text('Đã xóa bài hát "Bài Hát Single Test" thành công!'), findsOneWidget);
    });
  });
}
