import 'artist_profile_data.dart';

/// The chart ranges the dashboard offers.
enum DashboardPeriod {
  week(7, '7N'),
  fortnight(14, '14N'),
  month(30, '30N');

  final int days;
  final String label;

  const DashboardPeriod(this.days, this.label);
}

/// Views of one calendar day.
class DashboardPoint {
  final DateTime date;
  final int views;

  const DashboardPoint({required this.date, required this.views});
}

/// The dashboard chart for one [DashboardPeriod].
class DashboardPeriodView {
  final DashboardPeriod period;

  /// One point per day, oldest first; days without activity count 0.
  final List<DashboardPoint> points;
  final int totalViews;

  /// Views of the window right before this one (same length). Null when that
  /// window does not fit inside the 30 days the backend returns.
  final int? previousViews;

  const DashboardPeriodView({
    required this.period,
    required this.points,
    required this.totalViews,
    required this.previousViews,
  });

  bool get hasActivity => totalViews > 0;

  /// Percent change of [totalViews] against [previousViews]. Null when there
  /// is nothing to compare with (no previous window, or it had 0 views).
  double? get growthPercent {
    final previous = previousViews;
    if (previous == null || previous == 0) return null;
    return (totalViews - previous) / previous * 100;
  }

  /// There were no views before, but there are now.
  bool get isNewActivity => previousViews == 0 && totalViews > 0;
}

/// How many days of history the backend returns.
const int dashboardBackendWindowDays = 30;

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Builds the chart for [period], ending on [today] (inclusive).
DashboardPeriodView buildPeriodView(
  List<DailyActivity> daily,
  DashboardPeriod period, {
  required DateTime today,
}) {
  final end = _dateOnly(today);

  final viewsByDay = <DateTime, int>{};
  for (final day in daily) {
    final key = _dateOnly(day.date);
    viewsByDay[key] = (viewsByDay[key] ?? 0) + day.views;
  }

  int viewsOn(int daysAgo) =>
      viewsByDay[DateTime(end.year, end.month, end.day - daysAgo)] ?? 0;

  final points = <DashboardPoint>[
    for (var daysAgo = period.days - 1; daysAgo >= 0; daysAgo--)
      DashboardPoint(
        date: DateTime(end.year, end.month, end.day - daysAgo),
        views: viewsOn(daysAgo),
      ),
  ];
  final total = points.fold<int>(0, (sum, p) => sum + p.views);

  int? previous;
  if (period.days * 2 <= dashboardBackendWindowDays) {
    previous = 0;
    for (var daysAgo = period.days; daysAgo < period.days * 2; daysAgo++) {
      previous = previous! + viewsOn(daysAgo);
    }
  }

  return DashboardPeriodView(
    period: period,
    points: points,
    totalViews: total,
    previousViews: previous,
  );
}
