import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/utils/image_url_helper.dart';
import 'package:music4_mobile/features/artist_profile/data/models/artist_overview_response.dart';
import 'package:music4_mobile/features/artist_profile/data/models/artist_response.dart';
import 'package:music4_mobile/features/artist_profile/data/repositories/artist_profile_repository.dart';
import 'package:music4_mobile/features/artist_profile/presentation/providers/artist_profile_provider.dart';
import 'package:music4_mobile/features/artist_profile/presentation/screens/artist_profile_screen.dart';
import 'package:music4_mobile/features/artist_profile/presentation/widgets/artist_album_item.dart';
import 'package:music4_mobile/features/artist_profile/presentation/widgets/artist_dashboard.dart';
import 'package:music4_mobile/features/artist_profile/presentation/widgets/artist_header.dart';
import 'package:music4_mobile/features/artist_profile/presentation/widgets/artist_profile_shimmer.dart';
import 'package:music4_mobile/features/artist_profile/presentation/widgets/track_list_item.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/state/auth_state.dart';
import 'package:music4_mobile/features/home/data/models/track_detail_model.dart';
import 'package:music4_mobile/features/player/data/services/app_audio_handler.dart';
import 'package:music4_mobile/features/player/domain/models/player_state_data.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';
import 'package:music4_mobile/features/track_detail/data/repositories/track_detail_repository.dart';
import 'package:shimmer/shimmer.dart';

import '../../artist_profile_test_helpers.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockTrackDetailRepo extends Mock implements TrackDetailRepository {}

class _MockAppAudioHandler extends Mock implements AppAudioHandler {}

AudioPlayer _createMockAudioPlayer() {
  final mock = _MockAudioPlayer();
  when(() => mock.playerStateStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.positionStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.bufferedPositionStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.durationStream).thenAnswer((_) => const Stream.empty());
  when(() => mock.playbackEventStream).thenAnswer((_) => const Stream.empty());
  return mock;
}

/// Player that only records what the profile asked it to play.
class _RecordingPlayerNotifier extends PlayerNotifier {
  List<TrackQueueItem>? lastQueue;
  int? lastIndex;

  _RecordingPlayerNotifier()
    : super(_createMockAudioPlayer(), _MockTrackDetailRepo(), _MockAppAudioHandler());

  @override
  Future<void> playPlaylist(List<TrackQueueItem> playlist, int initialIndex) async {
    lastQueue = playlist;
    lastIndex = initialIndex;
  }
}

/// `n` tracks; Bài 0 has the most views (so it is first), Bài n-1 the fewest.
List<Map<String, dynamic>> manyTracksJson(int n) => [
  for (var i = 0; i < n; i++)
    {
      'id': 100 + i,
      'name': 'Bài $i',
      'albumName': 'Single',
      'img': null,
      'duration': 180,
      'viewCount': (n - i) * 10,
      'playbackPosition': null,
      'artists': [],
    },
];

/// `n` albums (n <= 9); Album n-1 is the newest (so it is first).
List<Map<String, dynamic>> manyAlbumsJson(int n) => [
  for (var i = 0; i < n; i++)
    {
      'id': 200 + i,
      'name': 'Album $i',
      'img': null,
      'uploadDate': '2026-01-0${i + 1}',
      'trackTotal': 3,
      'artistId': 3,
    },
];

void main() {
  late MockArtistProfileRepository repository;
  late _RecordingPlayerNotifier player;

  void stubSuccess({
    Map<String, dynamic>? artistJson,
    List<Map<String, dynamic>>? tracksJson,
    List<Map<String, dynamic>>? albumsJson,
  }) {
    when(() => repository.getArtist(3)).thenAnswer(
      (_) async => ArtistResponse.fromJson(artistJson ?? realArtistJson),
    );
    when(() => repository.getArtistTracks(3)).thenAnswer(
      (_) async => (tracksJson ?? realTracksJson)
          .map(TrackDetailModel.fromJson)
          .toList(),
    );
    when(() => repository.getArtistAlbums(3)).thenAnswer(
      (_) async =>
          (albumsJson ?? realAlbumsJson).map(AlbumInfo.fromJson).toList(),
    );
    when(() => repository.getOverview(3)).thenAnswer(
      (_) async => ArtistOverviewResponse.fromJson(realOverviewJson),
    );
    when(
      () => repository.isFollowing(
        userId: any(named: 'userId'),
        artistId: any(named: 'artistId'),
      ),
    ).thenAnswer((_) async => false);
  }

  /// ArtistProfileScreen at '/', with stub routes for the screens it opens.
  Widget buildApp({
    ArtistProfileMode mode = ArtistProfileMode.listener,
    String? artistId = '3',
    AuthState auth = const AuthUnauthenticated(),
  }) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => ArtistProfileScreen(artistId: artistId, mode: mode),
        ),
        GoRoute(
          path: '/player',
          builder: (_, _) => const Scaffold(body: Text('player-page')),
        ),
        GoRoute(
          path: '/album/:id',
          builder: (_, state) =>
              Scaffold(body: Text('album-page-${state.pathParameters['id']}')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        artistProfileRepositoryProvider.overrideWithValue(repository),
        authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(auth)),
        playerNotifierProvider.overrideWith((ref) => player),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  /// Text inside the header only (track subtitles repeat the artist name).
  Finder inHeader(String text) => find.descendant(
    of: find.byType(ArtistHeader),
    matching: find.text(text),
  );

  /// Tall view so the whole profile is built without scrolling.
  void useTallView(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  setUp(() {
    repository = MockArtistProfileRepository();
    player = _RecordingPlayerNotifier();
  });

  group('[CE190284] ArtistProfileScreen - data', () {
    testWidgets('1. Listener mode shows the real artist, tracks and albums', (tester) async {
      useTallView(tester);
      stubSuccess();

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      // The artist id of the route reaches the repository.
      verify(() => repository.getArtist(3)).called(1);

      expect(find.byType(ArtistHeader), findsOneWidget);
      expect(inHeader('Ngọt'), findsOneWidget);
      expect(find.text('42 Người theo dõi'), findsOneWidget);
      expect(find.text('Theo dõi'), findsOneWidget);

      expect(find.text('Cho Tôi Đi Theo'), findsOneWidget);
      expect(find.text('Lần Cuối'), findsOneWidget);
      expect(find.text('Em Dạo Này'), findsOneWidget);
      expect(find.byType(TrackListItem), findsNWidgets(3));

      expect(find.text('Album'), findsOneWidget);
      expect(find.text('Album Mới'), findsOneWidget);
      expect(find.text('Album Cũ'), findsOneWidget);

      expect(find.byType(ArtistDashboard), findsNothing);
    });

    testWidgets('2. Owner mode shows the dashboard with real stats and no Follow button', (tester) async {
      useTallView(tester);
      stubSuccess();

      await tester.pumpWidget(buildApp(mode: ArtistProfileMode.owner));
      await tester.pump();
      await tester.pump();

      expect(find.byType(ArtistDashboard), findsOneWidget);
      expect(find.text('Tổng quan dữ liệu của bạn'), findsOneWidget);
      // Real chart labels: the last 7 days end today, no fake T2/T3.
      final now = DateTime.now();
      String two(int n) => n.toString().padLeft(2, '0');
      expect(find.text('${two(now.day)}/${two(now.month)}'), findsOneWidget);
      expect(find.text('T2'), findsNothing);
      // 7 days: 30 + 40 + ... + 90 views, versus 30 in the 7 days before.
      expect(find.text('420 lượt nghe'), findsOneWidget);
      expect(find.text('1300%'), findsOneWidget);
      expect(find.text('Theo dõi'), findsNothing);
      expect(find.text('Đang theo dõi'), findsNothing);
    });

    testWidgets('2b. Each track shows its play count next to the artist', (tester) async {
      useTallView(tester);
      stubSuccess();

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      // Track 12 has no artist in the backend response: the profile's name is used.
      expect(find.text('Ngọt • 900 lượt nghe'), findsOneWidget);
      expect(find.text('Ngọt • 100 lượt nghe'), findsOneWidget);
      expect(find.text('Ngọt, Guest • 100 lượt nghe'), findsOneWidget);
    });

    testWidgets('3. Empty content shows the empty tracks message and no album section', (tester) async {
      useTallView(tester);
      stubSuccess(tracksJson: [], albumsJson: []);

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Chưa có bài hát nào.'), findsOneWidget);
      expect(find.byType(TrackListItem), findsNothing);
      expect(find.text('Album'), findsNothing);
    });

    testWidgets('4. Missing images fall back to placeholders without errors', (tester) async {
      useTallView(tester);
      stubSuccess(
        artistJson: {'id': 3, 'name': 'No images', 'img': null, 'cover': null},
      );

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      expect(inHeader('No images'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('[CE190284] ArtistProfileScreen - top 5 and view all', () {
    testWidgets('17. More than 5 tracks: top 5 plus Xem tất cả, which expands', (tester) async {
      useTallView(tester);
      stubSuccess(tracksJson: manyTracksJson(7));

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      expect(find.byType(TrackListItem), findsNWidgets(5));
      expect(find.text('Bài 4'), findsOneWidget);
      expect(find.text('Bài 5'), findsNothing);
      expect(find.text('Xem tất cả (7)'), findsOneWidget);

      await tester.tap(find.text('Xem tất cả (7)'));
      await tester.pump();

      expect(find.byType(TrackListItem), findsNWidgets(7));
      expect(find.text('Bài 6'), findsOneWidget);
      expect(find.text('Thu gọn'), findsOneWidget);

      await tester.tap(find.text('Thu gọn'));
      await tester.pump();

      expect(find.byType(TrackListItem), findsNWidgets(5));
      expect(find.text('Xem tất cả (7)'), findsOneWidget);
    });

    testWidgets('18. Exactly 5 tracks: no Xem tất cả button', (tester) async {
      useTallView(tester);
      stubSuccess(tracksJson: manyTracksJson(5));

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      expect(find.byType(TrackListItem), findsNWidgets(5));
      expect(find.textContaining('Xem tất cả'), findsNothing);
    });

    testWidgets('19. More than 5 albums: newest 5 plus Xem tất cả', (tester) async {
      useTallView(tester);
      stubSuccess(albumsJson: manyAlbumsJson(6));

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      expect(find.byType(ArtistAlbumItem), findsNWidgets(5));
      expect(find.text('Album 5'), findsOneWidget); // newest
      expect(find.text('Album 0'), findsNothing); // oldest, hidden
      expect(find.text('Xem tất cả (6)'), findsOneWidget);

      await tester.tap(find.text('Xem tất cả (6)'));
      await tester.pump();

      expect(find.byType(ArtistAlbumItem), findsNWidgets(6));
      expect(find.text('Album 0'), findsOneWidget);
    });

    testWidgets('20. Playing from the preview queues the whole track list', (tester) async {
      useTallView(tester);
      stubSuccess(tracksJson: manyTracksJson(7));

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Bài 2'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(player.lastQueue, hasLength(7));
      expect(player.lastIndex, 2);
    });
  });

  group('[CE190284] ArtistProfileScreen - artist accounts', () {
    testWidgets('13. An artist opening their own profile gets owner mode and settings', (tester) async {
      useTallView(tester);
      stubSuccess();

      // Route /artist/3 with NO explicit mode, signed in as artist 3.
      await tester.pumpWidget(buildApp(auth: authenticatedArtist(3)));
      await tester.pump();
      await tester.pump();

      expect(find.byType(ArtistDashboard), findsOneWidget);
      expect(find.text('Theo dõi'), findsNothing);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      // The artist's own profile never asks for a followings list.
      verifyNever(
        () => repository.isFollowing(
          userId: any(named: 'userId'),
          artistId: any(named: 'artistId'),
        ),
      );
    });

    testWidgets('14. The settings icon opens the settings sheet (logout lives there)', (tester) async {
      useTallView(tester);
      stubSuccess();

      await tester.pumpWidget(buildApp(auth: authenticatedArtist(3)));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Cài đặt'), findsWidgets);
    });

    testWidgets('15. An artist viewing ANOTHER artist stays in listener mode', (tester) async {
      useTallView(tester);
      stubSuccess();

      await tester.pumpWidget(buildApp(auth: authenticatedArtist(9)));
      await tester.pump();
      await tester.pump();

      expect(find.byType(ArtistDashboard), findsNothing);
      expect(find.byIcon(Icons.settings_outlined), findsNothing);

      await tester.tap(find.text('Theo dõi'));
      await tester.pump();
      await tester.pump();

      expect(
        find.text('Tài khoản nghệ sĩ không thể theo dõi nghệ sĩ khác.'),
        findsOneWidget,
      );
    });

    testWidgets('16. A listener never sees the settings icon', (tester) async {
      useTallView(tester);
      stubSuccess();

      await tester.pumpWidget(buildApp(auth: authenticated(7)));
      await tester.pump();
      await tester.pump();

      expect(find.byIcon(Icons.settings_outlined), findsNothing);
    });
  });

  group('[CE190284] ArtistProfileScreen - states', () {
    testWidgets('5. Loading state shows the shimmer', (tester) async {
      final completer = Completer<ArtistResponse>();
      stubSuccess();
      when(() => repository.getArtist(3)).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(ArtistProfileShimmer), findsOneWidget);
      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('6. Error state shows the message and Retry reloads', (tester) async {
      useTallView(tester);
      stubSuccess();
      var fail = true;
      when(() => repository.getArtist(3)).thenAnswer((_) async {
        if (fail) throw const ArtistProfileException('Không tìm thấy nghệ sĩ.');
        return ArtistResponse.fromJson(realArtistJson);
      });

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Đã xảy ra lỗi khi tải dữ liệu'), findsOneWidget);
      expect(find.text('Không tìm thấy nghệ sĩ.'), findsOneWidget);
      expect(find.text('Thử lại'), findsOneWidget);

      fail = false;
      await tester.tap(find.text('Thử lại'));
      await tester.pump();
      await tester.pump();

      expect(inHeader('Ngọt'), findsOneWidget);
      expect(find.text('Đã xảy ra lỗi khi tải dữ liệu'), findsNothing);
    });

    testWidgets('7. A missing artist id shows the error state', (tester) async {
      stubSuccess();

      await tester.pumpWidget(buildApp(artistId: null));
      await tester.pump();
      await tester.pump();

      expect(find.text('Không tìm thấy nghệ sĩ.'), findsOneWidget);
      verifyNever(() => repository.getArtist(any()));
    });

    testWidgets('8. 360dp layout has no overflow in owner mode', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      stubSuccess();

      await tester.pumpWidget(buildApp(mode: ArtistProfileMode.owner));
      await tester.pump();
      await tester.pump();

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -2000));
      await tester.pump();

      expect(find.byType(ArtistDashboard), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('[CE190284] ArtistProfileScreen - navigation and actions', () {
    testWidgets('9. Tapping a track plays the artist queue from that track', (tester) async {
      useTallView(tester);
      stubSuccess();

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Lần Cuối'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Queue is the popularity order (12, 11, 13); 'Lần Cuối' is index 1.
      expect(player.lastQueue?.map((t) => t.id), ['12', '11', '13']);
      expect(player.lastIndex, 1);
      expect(
        player.lastQueue?[1].coverUrl,
        '${ImageUrlHelper.s3BaseUrl}covers/t11.jpg',
      );
      expect(player.lastQueue?[1].duration, const Duration(seconds: 215));
      expect(find.text('player-page'), findsOneWidget);
    });

    testWidgets('10. Tapping an album opens the album detail route', (tester) async {
      useTallView(tester);
      stubSuccess();

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Album Cũ'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('album-page-21'), findsOneWidget);
    });

    testWidgets('11. A guest tapping Follow is asked to sign in', (tester) async {
      useTallView(tester);
      stubSuccess();

      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Theo dõi'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Vui lòng đăng nhập để theo dõi nghệ sĩ.'), findsOneWidget);
      verifyNever(
        () => repository.toggleFollow(
          userId: any(named: 'userId'),
          artistId: any(named: 'artistId'),
        ),
      );
    });

    testWidgets('12. A signed-in user can follow and the button updates', (tester) async {
      useTallView(tester);
      stubSuccess();
      when(
        () => repository.toggleFollow(userId: 7, artistId: 3),
      ).thenAnswer((_) async => true);

      await tester.pumpWidget(buildApp(auth: authenticated(7)));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Theo dõi'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Đang theo dõi'), findsOneWidget);
      expect(find.text('43 Người theo dõi'), findsOneWidget);
      verify(() => repository.toggleFollow(userId: 7, artistId: 3)).called(1);
    });
  });
}
