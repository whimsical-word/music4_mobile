import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/features/history/data/models/history_item.dart';
import 'package:music4_mobile/features/history/presentation/providers/history_provider.dart';
import 'package:music4_mobile/features/history/presentation/screens/history_screen.dart';

import 'package:shimmer/shimmer.dart';

void main() {
  Widget createWidgetUnderTest(AsyncValue<List<HistoryItem>> providerState, {bool isError = false}) {
    return ProviderScope(
      overrides: [
        historyNotifierProvider.overrideWith(() => MockHistoryNotifier(providerState, isError: isError)),
      ],
      child: const MaterialApp(
        home: HistoryScreen(),
      ),
    );
  }

  testWidgets('1. Loaded history list renders correctly', (WidgetTester tester) async {
    final mockItems = [
      HistoryItem(
        id: '1',
        trackId: 't1',
        trackTitle: 'Lạc Trôi',
        artistName: 'Sơn Tùng M-TP',
        artworkUrl: 'https://via.placeholder.com/150',
        playedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];

    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(mockItems)));
    await tester.pumpAndSettle();

    expect(find.text('Lịch sử nghe nhạc'), findsOneWidget);
    expect(find.text('Lạc Trôi'), findsOneWidget);
    expect(find.text('Sơn Tùng M-TP'), findsOneWidget);
  });

  testWidgets('2. Loading state renders with Shimmer', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const AsyncValue.loading()));
    
    // Shimmer effect
    expect(find.byType(Shimmer), findsWidgets);
  });

  testWidgets('3. Error state renders and Retry works', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(
      const AsyncValue.error('Không thể tải lịch sử', StackTrace.empty),
      isError: true,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Đã xảy ra lỗi'), findsOneWidget);
    expect(find.text('Không thể tải lịch sử'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);

    await tester.tap(find.text('Thử lại'));
    await tester.pump();
  });

  testWidgets('4. Empty state renders', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const AsyncValue.data([])));
    await tester.pumpAndSettle();

    expect(find.text('Chưa có lịch sử'), findsOneWidget);
    expect(find.text('Tải lại'), findsOneWidget);
  });

  testWidgets('5. 360dp responsive layout has no overflow', (WidgetTester tester) async {
    final mockItems = [
      HistoryItem(
        id: '1',
        trackId: 't1',
        trackTitle: 'Lạc Trôi - A very long title that might overflow if not handled correctly',
        artistName: 'Sơn Tùng M-TP - With a very long artist name as well to check overflow',
        artworkUrl: 'https://via.placeholder.com/150',
        playedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];

    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(mockItems)));
    await tester.pumpAndSettle();

    // If there's overflow, pumpAndSettle might throw or flutter test will complain about RenderFlex overflow.
    expect(find.text('Lịch sử nghe nhạc'), findsOneWidget);
    
    // Reset view
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}

class MockHistoryNotifier extends HistoryNotifier {
  final AsyncValue<List<HistoryItem>> initialState;
  final bool isError;

  MockHistoryNotifier(this.initialState, {this.isError = false});

  @override
  FutureOr<List<HistoryItem>> build() async {
    if (initialState.isLoading) {
       // Return a never completing future if it's loading, to simulate loading indefinitely
       final completer = Completer<List<HistoryItem>>();
       return completer.future;
    }
    if (initialState.hasError) {
       throw initialState.error!;
    }
    return initialState.value ?? [];
  }

  @override
  Future<void> refreshHistory() async {
    // Just a mock implementation
    return Future.value();
  }
}
