import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/features/artist_profile/domain/models/artist_profile_data.dart';
import 'package:music4_mobile/features/artist_profile/domain/models/dashboard_period.dart';

void main() {
  final today = DateTime(2026, 10, 12);

  DailyActivity day(int daysAgo, int views) => DailyActivity(
    date: DateTime(2026, 10, 12 - daysAgo),
    views: views,
    likes: 0,
  );

  group('[CE190284] buildPeriodView - chart points', () {
    test('has one point per day, oldest first, ending today', () {
      final view = buildPeriodView([], DashboardPeriod.week, today: today);

      expect(view.points, hasLength(7));
      expect(view.points.first.date, DateTime(2026, 10, 6));
      expect(view.points.last.date, DateTime(2026, 10, 12));
    });

    test('days without activity are filled with 0', () {
      final view = buildPeriodView(
        [day(0, 5), day(3, 8)],
        DashboardPeriod.week,
        today: today,
      );

      expect(view.points.map((p) => p.views), [0, 0, 0, 8, 0, 0, 5]);
      expect(view.totalViews, 13);
    });

    test('the window includes today and excludes the day before it', () {
      // 6 days ago is the oldest day of 7N; 7 days ago is outside it.
      final view = buildPeriodView(
        [day(6, 4), day(7, 100)],
        DashboardPeriod.week,
        today: today,
      );

      expect(view.totalViews, 4);
    });

    test('14N and 30N cover 14 and 30 days', () {
      expect(
        buildPeriodView([], DashboardPeriod.fortnight, today: today).points,
        hasLength(14),
      );
      expect(
        buildPeriodView([], DashboardPeriod.month, today: today).points,
        hasLength(30),
      );
    });

    test('the time of day of "today" does not matter', () {
      final view = buildPeriodView(
        [day(0, 5)],
        DashboardPeriod.week,
        today: DateTime(2026, 10, 12, 23, 59),
      );

      expect(view.points.last.views, 5);
    });

    test('hasActivity is false when nothing was listened to', () {
      final view = buildPeriodView([], DashboardPeriod.week, today: today);

      expect(view.hasActivity, isFalse);
      expect(view.totalViews, 0);
    });

    test('the window works across a month boundary', () {
      final view = buildPeriodView(
        [DailyActivity(date: DateTime(2026, 9, 30), views: 6, likes: 0)],
        DashboardPeriod.week,
        today: DateTime(2026, 10, 2),
      );

      expect(view.points.first.date, DateTime(2026, 9, 26));
      expect(view.totalViews, 6);
    });
  });

  group('[CE190284] buildPeriodView - growth against the previous window', () {
    test('growth is positive when the period beats the previous one', () {
      // 7N: 100 views now, 50 in the 7 days before.
      final view = buildPeriodView(
        [day(0, 100), day(8, 50)],
        DashboardPeriod.week,
        today: today,
      );

      expect(view.previousViews, 50);
      expect(view.growthPercent, 100);
      expect(view.isNewActivity, isFalse);
    });

    test('growth is negative when the period is below the previous one', () {
      final view = buildPeriodView(
        [day(0, 50), day(9, 200)],
        DashboardPeriod.week,
        today: today,
      );

      expect(view.growthPercent, -75);
    });

    test('no previous views but views now is new activity, not a percentage', () {
      final view = buildPeriodView([day(1, 10)], DashboardPeriod.week, today: today);

      expect(view.previousViews, 0);
      expect(view.growthPercent, isNull);
      expect(view.isNewActivity, isTrue);
    });

    test('14N compares with the 14 days before it', () {
      final view = buildPeriodView(
        [day(2, 30), day(20, 10)],
        DashboardPeriod.fortnight,
        today: today,
      );

      expect(view.previousViews, 10);
      expect(view.growthPercent, 200);
    });

    test('30N has no previous window inside the 30 days the backend returns', () {
      final view = buildPeriodView([day(1, 10)], DashboardPeriod.month, today: today);

      expect(view.previousViews, isNull);
      expect(view.growthPercent, isNull);
      expect(view.isNewActivity, isFalse);
    });

    test('no views in either window gives nothing to compare', () {
      final view = buildPeriodView([], DashboardPeriod.week, today: today);

      expect(view.previousViews, 0);
      expect(view.growthPercent, isNull);
      expect(view.isNewActivity, isFalse);
    });
  });
}
