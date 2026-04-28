class DailyUsageData {
  final int hour;   // 0-23
  final double kwh;

  const DailyUsageData({required this.hour, required this.kwh});
}

class DayUsageData {
  final String day;
  final double totalKwh;
  final double peakKwh;
  final String peakTime;
  final double avgKwh;

  const DayUsageData({
    required this.day,
    required this.totalKwh,
    required this.peakKwh,
    required this.peakTime,
    required this.avgKwh,
  });
}

class WeekUsageData {
  final String week;
  final double totalKwh;
  final double peakKwh;
  final String peakDay;
  final String peakTime;
  final double avgKwh;

  const WeekUsageData({
    required this.week,
    required this.totalKwh,
    required this.peakKwh,
    required this.peakDay,
    required this.peakTime,
    required this.avgKwh,
  });
}

enum AnalyticsFilter { daily, weekly, monthly }