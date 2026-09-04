import 'package:intl/intl.dart';

/// Formatting utilities for currency, dates, etc.
class Formatters {
  Formatters._();

  /// Format as Indian Rupees: ₹12,500
  static String currency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format as Indian Rupees with decimals: ₹12,500.00
  static String currencyWithDecimals(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format date: 20 Jun, 2026
  static String date(DateTime date) {
    return DateFormat('dd MMM, yyyy').format(date);
  }

  /// Format date short: 20 Jun
  static String dateShort(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  /// Format time: 2:30 PM
  static String time(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Format date and time: 20 Jun, 2026 • 2:30 PM
  static String dateTime(DateTime date) {
    return '${Formatters.date(date)} • ${Formatters.time(date)}';
  }

  /// Relative time: "2 hours ago", "Yesterday", etc.
  static String relative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return Formatters.date(date);
  }

  /// Day name: Monday, Tuesday, etc.
  static String dayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// Short day name: Mon, Tue, etc.
  static String dayNameShort(DateTime date) {
    return DateFormat('EEE').format(date);
  }
}
