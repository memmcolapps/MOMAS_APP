import 'package:intl/intl.dart';

class AmountFormatter {
  static String format(double amount, {String locale = 'en_NG'}) {
    final formatter = NumberFormat.currency(locale: locale, symbol: '');
    return formatter.format(amount);
  }

  static String formatNaira(double amount, {String locale = 'en_NG'}) {
    final formatter = NumberFormat.currency(locale: locale, symbol: 'NGN');
    return formatter.format(amount);
  }

  /// Abbreviated — 120000 → 120k, 1500000 → 1.5M
  static String abbreviated(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}k';
    return value.toStringAsFixed(0);
  }

  /// Abbreviated with naira sign — 120000 → ₦120k, 1500000 → ₦1.5M
  static String abbreviatedWithSign(double value) {
    return '₦${abbreviated(value)}';
  }

  /// Full with naira sign and commas — 120000 → ₦120,000
  static String full(double value) {
    final formatted = value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
    );
    return '₦$formatted';
  }
}
