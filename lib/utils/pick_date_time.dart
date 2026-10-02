import 'package:flutter/material.dart';

/// Shows a date picker followed by a time picker and combines the result
/// into a single [DateTime]. Returns null if the user cancels either step.
Future<DateTime?> pickDateTime(
  BuildContext context, {
  DateTime? initial,
}) async {
  final now = DateTime.now();
  final base = initial ?? now;
  final date = await showDatePicker(
    context: context,
    initialDate: base.isBefore(now) ? now : base,
    firstDate: DateTime(now.year - 1),
    lastDate: DateTime(now.year + 2),
  );
  if (date == null) return null;
  if (!context.mounted) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(base),
  );
  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
