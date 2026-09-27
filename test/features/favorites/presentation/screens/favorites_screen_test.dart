import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:music4_mobile/features/favorites/providers/favorites_provider.dart';

void main() {
  Widget createWidgetUnderTest({List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: const MaterialApp(
        home: FavoritesScreen(),
      ),
    );
  }

  testWidgets('FavoritesScreen displays Loading state initially', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(overrides: [
      favoritesProvider.overrideWith(() => _LoadingFavoritesNotifier()),
    ]));

    // Check if the loading state is displayed (Shimmer is used, so we can find a Row which is part of the skeleton)
    expect(find.byType(Row), findsWidgets);
    expect(find.text('Bài hát yêu thích'), findsOneWidget);
  });

  testWidgets('FavoritesScreen displays Loaded state with tracks', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(overrides: [
      favoritesProvider.overrideWith(() => _LoadedFavoritesNotifier()),
    ]));
    
    // Pump to settle the provider
    await tester.pumpAndSettle();

    expect(find.text('Track 1'), findsOneWidget);
    expect(find.text('Artist 1'), findsOneWidget);
    expect(find.text('Track 2'), findsOneWidget);
    expect(find.text('Artist 2'), findsOneWidget);
    
    // Artwork placeholder icon
    expect(find.byIcon(Icons.music_note), findsWidgets);
  });

  testWidgets('FavoritesScreen displays Empty state when no tracks', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(overrides: [
      favoritesProvider.overrideWith(() => _EmptyFavoritesNotifier()),
    ]));
    
    await tester.pumpAndSettle();

    expect(find.text('Chưa có bài hát yêu thích'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });

  testWidgets('FavoritesScreen displays Error state and handles retry', (WidgetTester tester) async {
    final errorNotifier = _ErrorFavoritesNotifier();
    await tester.pumpWidget(createWidgetUnderTest(overrides: [
      favoritesProvider.overrideWith(() => errorNotifier),
    ]));
    
    await tester.pumpAndSettle();

    expect(find.text('Đã xảy ra lỗi'), findsOneWidget);
    expect(find.text('Không thể tải danh sách yêu thích'), findsOneWidget);
    
    // Tap Retry
    await tester.tap(find.text('Thử lại'));
    await tester.pump();
    
    // Should verify retry was called
    expect(errorNotifier.retryCalled, isTrue);
  });

  testWidgets('FavoritesScreen is responsive without overflow at 360dp', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createWidgetUnderTest(overrides: [
      favoritesProvider.overrideWith(() => _LoadedFavoritesNotifier()),
    ]));
    
    await tester.pumpAndSettle();

    // If there is an overflow, the test would fail during rendering or we can explicitly assert no exceptions
    expect(tester.takeException(), isNull);
    expect(find.text('Track 1'), findsOneWidget);
  });
}

// Mocks for Riverpod Notifiers

class _LoadingFavoritesNotifier extends FavoritesNotifier {
  @override
  Future<List<FavoriteTrack>> build() async {
    // Return a never completing future so it stays in loading state without creating a timer
    return Completer<List<FavoriteTrack>>().future;
  }
}

class _LoadedFavoritesNotifier extends FavoritesNotifier {
  @override
  Future<List<FavoriteTrack>> build() async {
    return [
      FavoriteTrack(
        id: '1',
        title: 'Track 1',
        artist: 'Artist 1',
        artworkUrl: '',
        duration: '3:00',
        addedAt: DateTime.now(),
      ),
      FavoriteTrack(
        id: '2',
        title: 'Track 2',
        artist: 'Artist 2',
        artworkUrl: '',
        duration: '3:30',
        addedAt: DateTime.now(),
      ),
    ];
  }
}

class _EmptyFavoritesNotifier extends FavoritesNotifier {
  @override
  Future<List<FavoriteTrack>> build() async {
    return [];
  }
}

class _ErrorFavoritesNotifier extends FavoritesNotifier {
  bool retryCalled = false;

  @override
  Future<List<FavoriteTrack>> build() async {
    throw Exception('Error loading');
  }

  @override
  Future<void> retry() async {
    retryCalled = true;
    state = const AsyncValue.loading();
  }
}
