import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));

    if (isSameDay(date, now)) {
      // Show today's date with the time
      return 'Today, ${DateFormat('hh:mm a').format(date)}';
    } else if (isSameDay(date, yesterday)) {
      // Show yesterday's date with the time
      return 'Yesterday, ${DateFormat('hh:mm a').format(date)}';
    } else {
      // For other dates, show the full formatted date with time
      return DateFormat('hh:mm a dd-MM-yy').format(date);
    }
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static String dateformat_hh_mm_a_dd_mm_yy(DateTime date) {
    String formattedDate = DateFormat('hh:mm a dd-MM-yy').format(date);
    return formattedDate;
  }

  static String dateformat_hh_mm_a(DateTime date) {
    String formattedDate = DateFormat('hh:mm a').format(date);
    return formattedDate;
  }

  static String dateformat_dd_mm_yy(DateTime date) {
    String formattedDate = DateFormat('dd-MM-yy').format(date);
    return formattedDate;
  }
}
