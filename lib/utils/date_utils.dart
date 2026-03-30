class MoDateUtils {
  MoDateUtils._();

  static const List<String> monthNames = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];

  /// Returns "This month" + last 5 months
  /// Rolls over year e.g. "December 2025" when crossing year boundary
  static List<String> get rollingMonths {
    final now = DateTime.now();
    return [
      "This month",
      ...List.generate(5, (index) {
        final date = DateTime(now.year, now.month - 1 - index);
        final isCurrentYear = date.year == now.year;
        return isCurrentYear
            ? monthNames[date.month - 1]
            : '${monthNames[date.month - 1]} ${date.year}';
      }),
    ];
  }

  static List<String> get years {
    return [
      "This year",
      ...List.generate(
        5,
            (index) => (DateTime.now().year - 1 - index).toString(),
      ),
    ];
  }
}