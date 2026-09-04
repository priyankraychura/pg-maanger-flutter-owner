import 'package:intl/intl.dart';

/// Date utility extensions.
extension DateExtensions on DateTime {
  /// Check if this date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if this date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if this date is in the future.
  bool get isFuture => isAfter(DateTime.now());

  /// Check if this date is in the past.
  bool get isPast => isBefore(DateTime.now());

  /// Get day name (Monday, Tuesday, etc.)
  String get dayName => DateFormat('EEEE').format(this);

  /// Get short day name (Mon, Tue, etc.)
  String get dayNameShort => DateFormat('EEE').format(this);

  /// Get month name (January, February, etc.)
  String get monthName => DateFormat('MMMM').format(this);

  /// Format as dd MMM, yyyy (20 Jun, 2026)
  String get formatted => DateFormat('dd MMM, yyyy').format(this);

  /// Get the start of the day.
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get days remaining until this date.
  int get daysFromNow => difference(DateTime.now()).inDays;
}
