import 'package:intl/intl.dart';

/// Date helpers for slot keys and labels. Named [AppDateUtils] to avoid
/// clashing with Flutter's material `DateUtils`.
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  /// Firestore day key, e.g. "2026-06-10". Used in booking document IDs.
  static String dayKey(DateTime date) => _dayKeyFormat.format(date);

  /// Short slot label, e.g. "09:00".
  static String timeLabel(DateTime time) => _timeFormat.format(time);

  /// Strips the time component, keeping the calendar day.
  static DateTime dayOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
