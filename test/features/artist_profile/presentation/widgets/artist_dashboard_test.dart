import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/features/artist_profile/domain/models/artist_profile_data.dart';
import 'package:music4_mobile/features/artist_profile/presentation/widgets/artist_dashboard.dart';

void main() {
  final today = DateTime(2026, 10, 12);

  DailyActivity day(int daysAgo, int views) => DailyActivity(
    date: DateTime(2026, 10, 12 - daysAgo),
    views: views,
    likes: 0,
  );

  ArtistDashboardStats stats(List<DailyActivity> daily) => ArtistDashboardStats(
    totalViews: 19,
    totalLikes: 5,
    totalFollowers: 0,
    totalComments: 3,
    daily: daily,
  );

  Future<void> pump(WidgetTester tester, List<DailyActivity> daily) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ArtistDashboard(stats: stats(daily), today: today),
          ),
        ),
      ),
    );
  }

  group('[CE190284] ArtistDashboard', () {
    testWidgets('shows the totals and starts on the 7-day range', (tester) async {
      await pump(tester, [day(0, 5)]);

      expect(find.text('19'), findsOneWidget);
      expect(find.text('5'), findsWidgets);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('7 ngày gần nhất'), findsOneWidget);
    });

    testWidgets('the KPI grid adds no top padding (no blank gap)', (tester) async {
      await pump(tester, [day(0, 5)]);

      expect(tester.widget<GridView>(find.byType(GridView)).padding, EdgeInsets.zero);
    });

    testWidgets('14N and 30N can be selected and change the range', (tester) async {
      await pump(tester, [day(0, 5)]);

      await tester.tap(find.text('14N'));
      await tester.pump();
      expect(find.text('14 ngày gần nhất'), findsOneWidget);

      await tester.tap(find.text('30N'));
      await tester.pump();
      expect(find.text('30 ngày gần nhất'), findsOneWidget);

      await tester.tap(find.text('7N'));
      await tester.pump();
      expect(find.text('7 ngày gần nhất'), findsOneWidget);
    });

    testWidgets('the range changes which views are counted', (tester) async {
      // 10 views today, 40 views 10 days ago (only in 14N / 30N).
      await pump(tester, [day(0, 10), day(10, 40)]);

      expect(find.text('10 lượt nghe'), findsOneWidget);

      await tester.tap(find.text('14N'));
      await tester.pump();
      expect(find.text('50 lượt nghe'), findsOneWidget);
    });

    testWidgets('shows a growth chip with the percent against the previous 7 days', (tester) async {
      await pump(tester, [day(0, 100), day(8, 50)]);

      expect(find.text('100%'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
      expect(find.text('so với 7 ngày trước'), findsOneWidget);
    });

    testWidgets('shows a decrease with a down arrow', (tester) async {
      await pump(tester, [day(0, 50), day(9, 200)]);

      expect(find.text('75%'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('shows "Mới" when there were no views before', (tester) async {
      await pump(tester, [day(1, 10)]);

      expect(find.text('Mới'), findsOneWidget);
    });

    testWidgets('30N has no comparison text', (tester) async {
      await pump(tester, [day(1, 10)]);

      await tester.tap(find.text('30N'));
      await tester.pump();

      expect(find.textContaining('so với'), findsNothing);
    });

    testWidgets('shows an empty message when the range has no views', (tester) async {
      await pump(tester, []);

      expect(find.text('Chưa có lượt nghe trong 7 ngày qua.'), findsOneWidget);
      expect(find.text('0 lượt nghe'), findsOneWidget);
    });

    testWidgets('360dp: every range fits without overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pump(tester, [for (var i = 0; i < 30; i++) day(i, (i + 1) * 3)]);

      for (final label in ['7N', '14N', '30N']) {
        await tester.tap(find.text(label));
        await tester.pump();
        expect(tester.takeException(), isNull, reason: label);
      }
    });
  });
}
