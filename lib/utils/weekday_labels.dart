import 'date_utils.dart';

/// Monday-first weekday ordering and short labels, shared by the recurring
/// schedule editor and its summary displays.
const List<int> weekdayOrder = [
  DateTime.monday,
  DateTime.tuesday,
  DateTime.wednesday,
  DateTime.thursday,
  DateTime.friday,
  DateTime.saturday,
  DateTime.sunday,
];

/// Localized short name for a [DateTime.weekday] value. 1 Jan 2024 was a
/// Monday, so that week maps weekday numbers straight onto dates.
String weekdayShortLabel(int weekday) => weekdayShort(DateTime(2024, 1, weekday));

String weekdaySummary(Set<int> days) =>
    weekdayOrder.where(days.contains).map(weekdayShortLabel).join(' · ');
