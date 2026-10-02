import 'package:intl/intl.dart';

class DateFormatters {
  static final DateFormat _monthYear = DateFormat('MMM yyyy');
  static final DateFormat _fullMonthYear = DateFormat('MMMM yyyy');
  static final DateFormat _day = DateFormat('dd');
  static final DateFormat _weekday = DateFormat('EEE');
  static final DateFormat _dateWithDay = DateFormat('dd MMM (EEE)');
  static final DateFormat _dateTime = DateFormat('yyyy-MM-dd HH:mm');
  static final DateFormat _timeOnly = DateFormat('hh:mm a');
  static final DateFormat _dateOnlyIso = DateFormat('yyyy-MM-dd');

  static String formatMonthYear(DateTime dt) => _monthYear.format(dt);
  static String formatFullMonthYear(DateTime dt) => _fullMonthYear.format(dt);
  static String formatDay(DateTime dt) => _day.format(dt);
  static String formatWeekday(DateTime dt) => _weekday.format(dt);
  static String formatDateWithDay(DateTime dt) => _dateWithDay.format(dt);
  static String formatDateTime(DateTime dt) => _dateTime.format(dt);
  static String formatTime(DateTime dt) => _timeOnly.format(dt);
  static String formatDateIso(DateTime dt) => _dateOnlyIso.format(dt);

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSunday(DateTime dt) => dt.weekday == DateTime.sunday;
  static bool isSaturday(DateTime dt) => dt.weekday == DateTime.saturday;
}
