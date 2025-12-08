import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  /// Formats date as "24 Feb, 2026"
  String toFormattedDate() {
    return DateFormat('d MMM, yyyy').format(this);
  }

  /// Formats date with time as "24 Feb, 2026 10:30 AM"
  String toFormattedDateTime() {
    return DateFormat('d MMM, yyyy hh:mm a').format(this);
  }
}

extension StringDateParsing on String {
  /// Parses ISO 8601 date string and formats it as "24 Feb, 2026"
  String toFormattedDate() {
    try {
      final dateTime = DateTime.parse(this);
      return dateTime.toFormattedDate();
    } catch (e) {
      // If parsing fails, return the original string
      return this;
    }
  }

  /// Parses ISO 8601 date string and formats it with time
  String toFormattedDateTime() {
    try {
      final dateTime = DateTime.parse(this);
      return dateTime.toFormattedDateTime();
    } catch (e) {
      // If parsing fails, return the original string
      return this;
    }
  }
}

