import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/core/utils/image_url_helper.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:music4_mobile/features/auth/presentation/notifiers/auth_state.dart';
import 'package:music4_mobile/features/favorites/data/models/favorite_response.dart';
import 'package:music4_mobile/features/favorites/data/repositories/favorites_repository.dart';
import 'package:music4_mobile/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:music4_mobile/features/favorites/providers/favorites_provider.dart';
import 'package:music4_mobile/features/player/presentation/providers/player_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../favorites_test_helpers.dart';

void main() {
  late MockFavoritesRepository repository;
  late RecordingPlayerNotifier player;

  void stubList([List<FavoriteResponse>? favorites]) {
    when(
      () => repository.getMyFavorites(),
    ).thenAnswer((_) async => favorites ?? favoriteResponses());
  }

  /// FavoritesScreen at '/', with stub routes for the screens it opens.
  Widget buildApp({AuthState auth = const AuthUnauthenticated()}) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const FavoritesScreen()),
        GoRoute(
          path: '/player',
          builder: (_, _) => const Scaffold(body: Text('player-page')),
        ),
        GoRoute(
          path: '/login',
          builder: (_, _) => const Scaffold(body: Text('login-page')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        favoritesRepositoryProvider.overrideWithValue(repository),
        authNotifierProvider.overrideWith((ref) => FakeAuthNotifier(auth)),
        playerNotifierProvider.overrideWith((ref) => player),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  Future<void> pumpLoaded(WidgetTester tester) async {
    await tester.pumpWidget(buildApp(auth: authenticated(7)));
    await tester.pump();
    await tester.pump();
  }

  setUp(() {
    repository = MockFavoritesRepository();
    player = RecordingPlayerNotifier();
  });

  group('[CE190284] FavoritesScreen - states', () {
    testWidgets('1. Loaded favorites render the real data', (tester) async {
      stubList();

      await pumpLoaded(tester);

      expect(find.text('Bài hát yêu thích'), findsOneWidget);
      expect(find.text('Lạc Trôi'), findsOneWidget);
      expect(find.text('Sơn Tùng M-TP'), findsOneWidget);
      expect(find.text('Hai nghệ sĩ'), findsOneWidget);
      expect(find.text('A, B'), findsOneWidget);
      // Track 12 has no artist in the backend response.
      expect(find.text('Không có ảnh'), findsOneWidget);
      expect(find.text('Không rõ nghệ sĩ'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNWidgets(3));
    });

    testWidgets('2. Loading state shows the shimmer', (tester) async {
      final completer = Completer<List<FavoriteResponse>>();
      when(() => repository.getMyFavorites()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildApp(auth: authenticated(7)));
      await tester.pump();

      expect(find.byType(Shimmer), findsWidgets);
    });

    testWidgets('3. Empty list shows the empty state', (tester) async {
      stubList([]);

      await pumpLoaded(tester);

      expect(find.text('Chưa có bài hát yêu thích'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('4. Error state shows the message and Retry reloads', (tester) async {
      var fail = true;
      when(() => repository.getMyFavorites()).thenAnswer((_) async {
        if (fail) throw const FavoritesException('Không thể kết nối đến máy chủ.');
        return favoriteResponses();
      });

      await pumpLoaded(tester);

      expect(find.text('Đã xảy ra lỗi'), findsOneWidget);
      expect(find.text('Không thể kết nối đến máy chủ.'), findsOneWidget);

      fail = false;
      await tester.tap(find.text('Thử lại'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Lạc Trôi'), findsOneWidget);
      expect(find.text('Đã xảy ra lỗi'), findsNothing);
    });

    testWidgets('5. 360dp layout has no overflow with long text', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      stubList([
        const FavoriteResponse(
          favoriteId: 1,
          trackId: 11,
          trackName:
              'Một tên bài hát rất dài để kiểm tra việc hiển thị trên màn hình 360dp không bị tràn',
          artistName:
              'Một nghệ sĩ có tên cũng rất dài, ghép nhiều nghệ sĩ lại với nhau để thử tràn',
        ),
      ]);

      await pumpLoaded(tester);

      expect(find.byType(ListTile), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('[CE190284] FavoritesScreen - images and navigation', () {
    testWidgets('6. Cover keys are resolved; a missing cover uses the icon', (tester) async {
      stubList();

      await pumpLoaded(tester);

      final urls = tester
          .widgetList<Image>(find.byType(Image))
          .map((i) => (i.image as NetworkImage).url)
          .toSet();
      expect(urls, {
        '${ImageUrlHelper.s3BaseUrl}covers/t11.jpg',
        'https://cdn.example.com/t13.jpg',
      });
      // Track 12 has no image: the music-note placeholder is shown.
      expect(find.byIcon(Icons.music_note), findsWidgets);
    });

    testWidgets('7. Tapping a track plays the favorites from that track', (tester) async {
      stubList();

      await pumpLoaded(tester);

      await tester.tap(find.text('Hai nghệ sĩ'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Newest first: 12, 13, 11. 'Hai nghệ sĩ' (13) is index 1.
      expect(player.lastQueue?.map((t) => t.id), ['12', '13', '11']);
      expect(player.lastIndex, 1);
      expect(player.lastQueue?[1].coverUrl, 'https://cdn.example.com/t13.jpg');
      expect(player.lastQueue?[1].duration, Duration.zero);
      expect(find.text('player-page'), findsOneWidget);
    });
  });

  group('[CE190284] FavoritesScreen - remove favorite', () {
    testWidgets('8. Tapping the heart removes the track after the backend confirms', (tester) async {
      stubList();
      when(() => repository.toggleFavorite(12)).thenAnswer((_) async => false);

      await pumpLoaded(tester);

      // The first row is the newest like: track 12.
      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pump();
      await tester.pump();

      verify(() => repository.toggleFavorite(12)).called(1);
      expect(find.text('Không có ảnh'), findsNothing);
      expect(find.text('Lạc Trôi'), findsOneWidget);
    });

    testWidgets('9. A failed removal keeps the track and tells the user', (tester) async {
      stubList();
      when(
        () => repository.toggleFavorite(12),
      ).thenAnswer((_) async => throw const FavoritesException('Lỗi'));

      await pumpLoaded(tester);

      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pump();
      await tester.pump();

      expect(find.text('Không có ảnh'), findsOneWidget);
      expect(find.text('Không thể bỏ yêu thích. Vui lòng thử lại.'), findsOneWidget);
    });
  });

  group('[CE190284] FavoritesScreen - guest', () {
    testWidgets('10. A guest sees a sign-in prompt and no API call is made', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.text('Đăng nhập để xem yêu thích'), findsOneWidget);
      verifyNever(() => repository.getMyFavorites());

      await tester.tap(find.text('Đăng nhập'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('login-page'), findsOneWidget);
    });
  });
}
