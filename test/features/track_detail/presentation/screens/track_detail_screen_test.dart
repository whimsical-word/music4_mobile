import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/home/data/models/track_artist_info.dart';
import 'package:music4_mobile/features/home/data/models/track_detail_model.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';
import 'package:music4_mobile/features/track_detail/presentation/controllers/track_detail_controller.dart';
import 'package:music4_mobile/features/track_detail/presentation/screens/track_detail_screen.dart';
import 'package:music4_mobile/features/track_management/data/repositories/track_management_repository.dart';

import '../../../artist_profile/artist_profile_test_helpers.dart';

class MockTrackDetailRepository extends Mock implements TrackDetailRepository {}
class MockTrackManagementRepo extends Mock implements TrackManagementRepository {}

class FakeTrackDetailController extends StateNotifier<AsyncValue<TrackDetailState>>
    implements TrackDetailController {
  FakeTrackDetailController(TrackDetailState initial)
      : super(AsyncData(initial));

  @override
  Future<void> loadTrackDetail() async {}

  @override
  Future<void> refresh() async {}

  @override
  Future<void> toggleFavorite() async {}

  @override
  Future<void> setRating(int rating) async {}

  @override
  Future<void> addTrackToPlaylist(int playlistId) async {}

  @override
  Future<void> addComment(String content, {int? userId}) async {}

  @override
  Future<void> updateComment({required int commentId, required String content}) async {}

  @override
  Future<void> deleteComment(int commentId) async {}
}

void main() {
  late MockTrackManagementRepo mockTrackMgmtRepo;

  const sampleTrackWithAlbum = TrackDetailModel(
    id: 101,
    name: 'Bài Hát Test Album',
    uploadDate: '2026-03-01',
    duration: 210,
    viewCount: 1500,
    album: AlbumInfo(
      id: 5,
      title: 'Album Mùa Hè 2026',
      coverUrl: 'images/album5.jpg',
      artistId: 5,
    ),
    artists: [
      TrackArtistInfo(id: 5, name: 'Sơn Tùng M-TP', role: 'MAIN'),
      TrackArtistInfo(id: 7, name: 'Snoop Dogg', role: 'COLLAB'),
    ],
    categories: [
      TrackCategoryInfo(id: 1, name: 'Pop'),
    ],
  );

  final sampleState = const TrackDetailState(
    track: sampleTrackWithAlbum,
    isLiked: false,
    userRating: 5,
  );

  setUp(() {
    mockTrackMgmtRepo = MockTrackManagementRepo();
  });

  Widget buildApp({
    AuthState authState = const AuthUnauthenticated(),
    TrackDetailState? state,
  }) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const TrackDetailScreen(trackId: '101'),
        ),
        GoRoute(
          path: '/album/:id',
          builder: (_, s) => Scaffold(body: Text('album-page-${s.pathParameters['id']}')),
        ),
        GoRoute(
          path: '/artist/:id',
          builder: (_, s) => Scaffold(body: Text('artist-page-${s.pathParameters['id']}')),
        ),
        GoRoute(
          path: '/player',
          builder: (_, _) => const Scaffold(body: Text('player-page')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        trackDetailControllerProvider(101).overrideWith(
          (ref) => FakeTrackDetailController(state ?? sampleState),
        ),
        trackManagementRepositoryProvider.overrideWithValue(mockTrackMgmtRepo),
        authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(authState)),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('[CE190036] TrackDetailScreen Unit & Widget Tests (UC48, UC49, UC50, UC51)', () {
    testWidgets('Displays album tile and tapping navigates to Album Detail (UC49)', (tester) async {
      await tester.pumpWidget(buildApp(authState: authenticated(1)));
      await tester.pumpAndSettle();

      // Check Album tile
      expect(find.byKey(const Key('track_detail_album_tile')), findsOneWidget);
      expect(find.text('Album Mùa Hè 2026'), findsOneWidget);
      expect(find.text('Thuộc Album • Bấm để nghe toàn bộ Album'), findsOneWidget);

      // Tap Album tile
      await tester.tap(find.byKey(const Key('track_detail_album_tile')));
      await tester.pumpAndSettle();

      expect(find.text('album-page-5'), findsOneWidget);
    });

    testWidgets('Does NOT display album tile when track is Single or album is null', (tester) async {
      const sampleTrackSingle = TrackDetailModel(
        id: 102,
        name: 'Single Test',
        uploadDate: '2026-03-01',
        album: null,
        artists: [TrackArtistInfo(id: 5, name: 'Sơn Tùng M-TP', role: 'MAIN')],
      );

      await tester.pumpWidget(buildApp(
        authState: authenticated(1),
        state: const TrackDetailState(track: sampleTrackSingle),
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('track_detail_album_tile')), findsNothing);
    });

    testWidgets('Displays release date, main artist and collab artist with badges (UC48)', (tester) async {
      await tester.pumpWidget(buildApp(authState: authenticated(1)));
      await tester.pumpAndSettle();

      // Scroll to Thông tin bài hát
      await tester.scrollUntilVisible(find.text('Thông tin bài hát'), 200);
      await tester.pumpAndSettle();

      expect(find.text('Thông tin bài hát'), findsOneWidget);
      expect(find.text('Ngày phát hành: '), findsOneWidget);
      expect(find.text('2026-03-01'), findsOneWidget);

      // Artists with roles
      expect(find.text('Sơn Tùng M-TP'), findsWidgets);
      expect(find.text('(Chính)'), findsOneWidget);
      expect(find.text('Snoop Dogg'), findsOneWidget);
      expect(find.text('(Collab)'), findsOneWidget);

      // Tapping artist navigates to artist profile
      await tester.tap(find.text('Snoop Dogg'));
      await tester.pumpAndSettle();

      expect(find.text('artist-page-7'), findsOneWidget);
    });

    testWidgets('Owner artist sees edit and delete buttons in AppBar (UC50, UC51)', (tester) async {
      when(() => mockTrackMgmtRepo.deleteTrack(101)).thenAnswer((_) async {});

      // Signed in as artist ID 5 (MAIN artist of this track)
      await tester.pumpWidget(buildApp(authState: authenticatedArtist(5)));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('track_detail_edit_btn')), findsOneWidget);
      expect(find.byKey(const Key('track_detail_delete_btn')), findsOneWidget);

      // Tap delete button
      await tester.tap(find.byKey(const Key('track_detail_delete_btn')));
      await tester.pumpAndSettle();

      // Confirm delete dialog appears
      expect(find.text('Xác nhận xóa bài hát'), findsOneWidget);
      expect(find.byKey(const Key('confirm_delete_track_btn')), findsOneWidget);

      // Confirm delete
      await tester.tap(find.byKey(const Key('confirm_delete_track_btn')));
      await tester.pumpAndSettle();

      verify(() => mockTrackMgmtRepo.deleteTrack(101)).called(1);
    });

    testWidgets('Non-owner listener does NOT see edit/delete buttons in AppBar', (tester) async {
      await tester.pumpWidget(buildApp(authState: authenticated(10)));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('track_detail_edit_btn')), findsNothing);
      expect(find.byKey(const Key('track_detail_delete_btn')), findsNothing);
    });
  });
}
