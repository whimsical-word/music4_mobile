import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/features/history/data/models/history_track_response.dart';
import 'package:music4_mobile/features/history/data/repositories/history_repository.dart';
import 'package:music4_mobile/features/history/presentation/providers/history_provider.dart';
import 'package:music4_mobile/features/history/presentation/screens/history_screen.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  Widget createWidgetUnderTest(AsyncValue<List<HistoryTrackResponse>> providerState, {bool isError = false}) {
    return ProviderScope(
      overrides: [
        historyNotifierProvider.overrideWith((ref) => MockHistoryNotifier(providerState, isError: isError)..fetchHistory()),
      ],
      child: const MaterialApp(
        home: HistoryScreen(),
      ),
    );
  }

  testWidgets('1. Loaded history list renders correctly', (WidgetTester tester) async {
    final mockItems = [
      const HistoryTrackResponse(
        id: 1,
        name: 'Lạc Trôi',
        albumName: 'Single',
        img: 'https://via.placeholder.com/150',
        duration: 200,
        filePath: '',
        previewPath: '',
        viewCount: 100,
        uploadDate: '2026-10-01',
        playbackPosition: 120,
        artists: [TrackArtistInfo(id: 1, name: 'Sơn Tùng M-TP', role: 'Singer')],
      ),
    ];

    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(mockItems)));
    await tester.pump();

    expect(find.text('Lịch sử nghe nhạc'), findsOneWidget);
    expect(find.text('Lạc Trôi'), findsOneWidget);
    expect(find.text('Sơn Tùng M-TP'), findsOneWidget);
    expect(find.text('Đã nghe đến 120s'), findsOneWidget);
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
    await tester.pump();

    expect(find.text('Đã xảy ra lỗi'), findsOneWidget);
    expect(find.text('Không thể tải lịch sử'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);

    await tester.tap(find.text('Thử lại'));
    await tester.pump();
  });

  testWidgets('4. Empty state renders', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(const AsyncValue.data([])));
    await tester.pump();

    expect(find.text('Chưa có lịch sử'), findsOneWidget);
    expect(find.text('Tải lại'), findsOneWidget);
  });

  testWidgets('5. 360dp responsive layout has no overflow', (WidgetTester tester) async {
    final mockItems = [
      const HistoryTrackResponse(
        id: 1,
        name: 'Lạc Trôi - A very long title that might overflow if not handled correctly',
        albumName: 'Single',
        img: 'https://via.placeholder.com/150',
        duration: 200,
        filePath: '',
        previewPath: '',
        viewCount: 100,
        uploadDate: '2026-10-01',
        playbackPosition: 120,
        artists: [TrackArtistInfo(id: 1, name: 'Sơn Tùng M-TP - With a very long artist name as well to check overflow', role: 'Singer')],
      ),
    ];

    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createWidgetUnderTest(AsyncValue.data(mockItems)));
    await tester.pump();

    // If there's overflow, pumpAndSettle might throw or flutter test will complain about RenderFlex overflow.
    expect(find.text('Lịch sử nghe nhạc'), findsOneWidget);
    
    // Reset view
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}

class FakeHistoryRepository implements HistoryRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHistoryNotifier extends HistoryNotifier {
  final AsyncValue<List<HistoryTrackResponse>> initialState;
  final bool isError;

  MockHistoryNotifier(this.initialState, {this.isError = false}) : super(FakeHistoryRepository());

  @override
  Future<void> fetchHistory() async {
    if (initialState.isLoading) {
       state = const AsyncValue.loading();
       return;
    }
    if (initialState.hasError) {
       state = initialState;
       return;
    }
    state = AsyncValue.data(initialState.value ?? []);
  }

  @override
  Future<void> refreshHistory() async {
    // mock refresh
  }
}
