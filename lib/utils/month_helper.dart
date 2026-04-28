class MonthHelper {
  MonthHelper._(); // prevent instantiation

  static const _labels = [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static const _shortLabels = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String fullName(int month) =>
      (month >= 1 && month <= 12) ? _labels[month] : '';

  static String shortName(int month) =>
      (month >= 1 && month <= 12) ? _shortLabels[month] : '';

  static List<String> get fullLabels => _labels.sublist(1);

  static List<String> get shortLabels => _shortLabels.sublist(1);
}