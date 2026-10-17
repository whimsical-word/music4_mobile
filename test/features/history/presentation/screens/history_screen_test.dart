import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/utils/image_url_helper.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/history/data/models/history_page_response.dart';
import 'package:music4_mobile/features/history/data/models/history_track_response.dart';
import 'package:music4_mobile/features/history/data/repositories/history_repository.dart';
import 'package:music4_mobile/features/history/presentation/providers/history_provider.dart';
import 'package:music4_mobile/features/history/presentation/screens/history_screen.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../history_test_helpers.dart';

const int _pageSize = HistoryRepository.defaultPageSize;

void main() {
  late MockHistoryRepository repository;
  late RecordingPlayerNotifier player;

  void stubPage(int page, HistoryPageResponse response, {int userId = 1}) {
    when(
      () => repository.getListeningHistory(
        userId,
        page: page,
        size: _pageSize,
      ),
    ).thenAnswer((_) async => response);
  }

  /// HistoryScreen at '/', with stub routes for the screens it navigates to.
  Widget buildApp({AuthState? auth}) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const HistoryScreen()),
        GoRoute(
          path: '/track/:id',
          builder: (_, state) =>
              Scaffold(body: Text('track-page-${state.pathParameters['id']}')),
        ),
        GoRoute(
          path: '/player',
          builder: (_, _) => const Scaffold(body: Text('player-page')),
        ),
        GoRoute(
          path: '/artist/:id',
          builder: (_, state) =>
              Scaffold(body: Text('artist-page-${state.pathParameters['id']}')),
        ),
        GoRoute(
          path: '/login',
          builder: (_, _) => const Scaffold(body: Text('login-page')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        historyRepositoryProvider.overrideWithValue(repository),
        playerNotifierProvider.overrideWith((ref) => player),
        authNotifierProvider.overrideWith(
          (ref) => FakeAuthNotifier(auth ?? authenticated(1)),
        ),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  setUp(() {
    repository = MockHistoryRepository();
    player = RecordingPlayerNotifier();
  });

  group('[CE190284] HistoryScreen', () {
    testWidgets('1. Loaded history renders real mapped data', (tester) async {
      stubPage(
        0,
        HistoryPageResponse(
          content: [
            historyTrack(
              5,
              name: 'Lạc Trôi',
              playbackPosition: 120,
              artists: const [
                TrackArtistInfo(id: 10, name: 'Sơn Tùng M-TP', role: 'MAIN'),
              ],
            ),
            historyTrack(6, name: 'Chưa nghe', artists: const []),
          ],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.text('Lịch sử nghe nhạc'), findsOneWidget);
      expect(find.text('Lạc Trôi'), findsOneWidget);
      expect(find.text('Sơn Tùng M-TP'), findsOneWidget);
      // 120s of a 200s track: offers to continue from 2:00.
      expect(find.text('Nghe tiếp từ 2:00'), findsOneWidget);
      expect(find.text('Chưa nghe'), findsOneWidget);
      expect(find.text('Không rõ nghệ sĩ'), findsOneWidget);
      expect(find.text('Đã nghe xong'), findsOneWidget);
    });

    testWidgets('2. Loading state shows Shimmer', (tester) async {
      final completer = Completer<HistoryPageResponse>();
      when(
        () => repository.getListeningHistory(
          1,
          page: 0,
          size: _pageSize,
        ),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(Shimmer), findsWidgets);
    });

    testWidgets('3. Error state shows the message and Retry reloads', (tester) async {
      var fail = true;
      when(
        () => repository.getListeningHistory(
          1,
          page: 0,
          size: _pageSize,
        ),
      ).thenAnswer((_) async {
        if (fail) throw const HistoryException('Không thể tải lịch sử');
        return HistoryPageResponse(
          content: [historyTrack(5, name: 'Sau khi thử lại')],
        );
      });

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.text('Đã xảy ra lỗi'), findsOneWidget);
      expect(find.text('Không thể tải lịch sử'), findsOneWidget);
      expect(find.text('Thử lại'), findsOneWidget);

      fail = false;
      await tester.tap(find.text('Thử lại'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Sau khi thử lại'), findsOneWidget);
      expect(find.text('Đã xảy ra lỗi'), findsNothing);
    });

    testWidgets('4. Empty history shows the empty state', (tester) async {
      stubPage(0, historyPage(0));

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.text('Chưa có lịch sử'), findsOneWidget);
      expect(find.text('Tải lại'), findsOneWidget);

      await tester.tap(find.text('Tải lại'));
      await tester.pump();
      await tester.pump();

      verify(
        () => repository.getListeningHistory(1, page: 0, size: _pageSize),
      ).called(2);
    });

    testWidgets('5. 360dp layout has no overflow with long text', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      stubPage(
        0,
        HistoryPageResponse(
          content: [
            historyTrack(
              1,
              name: 'Lạc Trôi - A very long title that might overflow if not handled correctly',
              artists: const [
                TrackArtistInfo(
                  id: 1,
                  name: 'Sơn Tùng M-TP - With a very long artist name as well to check overflow',
                  role: 'MAIN',
                ),
              ],
              playbackPosition: 120,
            ),
          ],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.text('Lịch sử nghe nhạc'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('6. S3 cover key is resolved; missing cover uses a placeholder', (tester) async {
      stubPage(
        0,
        HistoryPageResponse(
          content: [
            historyTrack(1, name: 'Có ảnh', img: 'covers/abc.jpg'),
            historyTrack(2, name: 'Không ảnh', img: null),
          ],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pump();

      final images = tester.widgetList<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(images, hasLength(1));
      expect(
        images.single.imageUrl,
        '${ImageUrlHelper.s3BaseUrl}covers/abc.jpg',
      );
      // The track without a cover renders the music-note placeholder.
      expect(find.byIcon(Icons.music_note), findsWidgets);
    });

    testWidgets('7. Tapping a partly listened item resumes from the saved position', (tester) async {
      stubPage(
        0,
        HistoryPageResponse(
          content: [
            historyTrack(5, name: 'Lạc Trôi', playbackPosition: 120),
            historyTrack(6, name: 'Bài khác'),
          ],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.text('Lạc Trôi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(player.lastQueue?.map((t) => t.id), ['5', '6']);
      expect(player.lastIndex, 0);
      expect(player.lastStartPosition, const Duration(seconds: 120));
      expect(find.text('player-page'), findsOneWidget);
      expect(find.text('track-page-5'), findsNothing);
    });

    testWidgets('7-1. Tapping a finished item (position 0) plays it from the beginning', (tester) async {
      stubPage(0, HistoryPageResponse(content: [historyTrack(5, name: 'Lạc Trôi')]));

      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.text('Lạc Trôi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(player.lastQueue?.map((t) => t.id), ['5']);
      expect(player.lastStartPosition, isNull);
      expect(find.text('player-page'), findsOneWidget);
    });

    testWidgets('7-2. A saved position near the end of the track is not resumed', (tester) async {
      // 198s of a 200s track: practically finished.
      stubPage(
        0,
        HistoryPageResponse(
          content: [historyTrack(5, name: 'Lạc Trôi', playbackPosition: 198)],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.text('Đã nghe xong'), findsOneWidget);

      await tester.tap(find.text('Lạc Trôi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(player.lastStartPosition, isNull);
    });

    testWidgets('7-3. The options menu offers Nghe tiếp for a partly listened item', (tester) async {
      stubPage(
        0,
        HistoryPageResponse(
          content: [historyTrack(5, name: 'Lạc Trôi', playbackPosition: 75)],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Nghe tiếp từ 1:15'), findsNWidgets(2)); // row label + menu entry

      await tester.tap(find.text('Nghe tiếp từ 1:15').last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(player.lastStartPosition, const Duration(seconds: 75));
      expect(find.text('player-page'), findsOneWidget);
    });

    testWidgets('7-4. "Phát từ đầu" starts a partly listened item from 0', (tester) async {
      stubPage(
        0,
        HistoryPageResponse(
          content: [historyTrack(5, name: 'Lạc Trôi', playbackPosition: 75)],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('Phát từ đầu'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(player.lastQueue?.map((t) => t.id), ['5']);
      expect(player.lastStartPosition, isNull);
      expect(find.text('player-page'), findsOneWidget);
    });

    testWidgets('7-5. A finished item has no Nghe tiếp entry in the menu', (tester) async {
      stubPage(0, HistoryPageResponse(content: [historyTrack(5, name: 'Lạc Trôi')]));

      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.textContaining('Nghe tiếp từ'), findsNothing);
      expect(find.text('Phát từ đầu'), findsOneWidget);
    });

    testWidgets('7a. The options menu opens the track detail', (tester) async {
      stubPage(0, HistoryPageResponse(content: [historyTrack(5, name: 'Lạc Trôi')]));

      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Xem chi tiết bài hát'), findsOneWidget);
      expect(find.text('Xem hồ sơ nghệ sĩ'), findsOneWidget);

      await tester.tap(find.text('Xem chi tiết bài hát'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('track-page-5'), findsOneWidget);
    });

    testWidgets('7d. The options menu opens the artist profile', (tester) async {
      stubPage(
        0,
        HistoryPageResponse(
          content: [
            historyTrack(
              5,
              name: 'Lạc Trôi',
              artists: const [
                TrackArtistInfo(id: 10, name: 'Sơn Tùng M-TP', role: 'MAIN'),
              ],
            ),
          ],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('Xem hồ sơ nghệ sĩ'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('artist-page-10'), findsOneWidget);
    });

    testWidgets('7e. Without an artist the menu has no artist entry', (tester) async {
      stubPage(
        0,
        HistoryPageResponse(
          content: [historyTrack(5, name: 'Lạc Trôi', artists: const [])],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Xem chi tiết bài hát'), findsOneWidget);
      expect(find.text('Xem hồ sơ nghệ sĩ'), findsNothing);
    });

    testWidgets('7b. Tapping the artist name opens that artist profile', (tester) async {
      stubPage(
        0,
        HistoryPageResponse(
          content: [
            historyTrack(
              5,
              name: 'Lạc Trôi',
              artists: const [
                TrackArtistInfo(id: 10, name: 'Sơn Tùng M-TP', role: 'MAIN'),
              ],
            ),
          ],
        ),
      );

      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.text('Sơn Tùng M-TP'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('artist-page-10'), findsOneWidget);
      expect(find.text('track-page-5'), findsNothing);
      expect(player.lastQueue, isNull); // the name opens the profile, not the player
    });

    testWidgets('8. Scrolling to the bottom loads the next page', (tester) async {
      stubPage(0, historyPage(_pageSize));
      stubPage(1, historyPage(3, startId: 1000));

      await tester.pumpWidget(buildApp());
      await tester.pump();

      verifyNever(
        () => repository.getListeningHistory(1, page: 1, size: _pageSize),
      );

      await tester.drag(find.byType(ListView), const Offset(0, -6000));
      await tester.pump();
      await tester.pump();

      verify(
        () => repository.getListeningHistory(1, page: 1, size: _pageSize),
      ).called(1);
    });

    testWidgets('9. A guest sees a sign-in prompt and no API call is made', (tester) async {
      await tester.pumpWidget(buildApp(auth: const AuthUnauthenticated()));
      await tester.pump();

      expect(find.text('Đăng nhập để xem lịch sử'), findsOneWidget);
      verifyNever(
        () => repository.getListeningHistory(
          any(),
          page: any(named: 'page'),
          size: any(named: 'size'),
        ),
      );

      await tester.tap(find.text('Đăng nhập'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('login-page'), findsOneWidget);
    });
  });
}
