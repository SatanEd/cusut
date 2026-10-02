import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../screens/recurring_schedule_dialog.dart';
import '../screens/schedule_lesson_dialog.dart';
import '../stores/lesson_store.dart';

/// Bottom sheet offered by the "Schedule lesson" FAB: a single one-off
/// lesson, or a repeating pattern that generates lessons automatically.
Future<void> showScheduleChoiceSheet(
  BuildContext context,
  LessonStore store, {
  DateTime? initialDate,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final l10n = AppLocalizations.of(sheetContext);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.event_outlined),
              title: Text(l10n.oneOffLesson),
              subtitle: Text(l10n.oneOffLessonHelp),
              onTap: () {
                Navigator.pop(sheetContext);
                scheduleLessonDialog(context, store, initialDate: initialDate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.repeat),
              title: Text(l10n.recurringSchedule),
              subtitle: Text(l10n.recurringScheduleHelp),
              onTap: () {
                Navigator.pop(sheetContext);
                recurringScheduleDialog(context, store);
              },
            ),
          ],
        ),
      );
    },
  );
}
