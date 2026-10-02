import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/lesson.dart';
import '../models/lesson_status.dart';
import '../screens/reminder_dialog.dart';
import '../stores/lesson_store.dart';
import '../utils/date_utils.dart';
import '../utils/pick_date_time.dart';

/// Bottom sheet with everything you can do to a single lesson: mark it
/// visited/missed, reschedule it, fold a missed one into an upcoming slot,
/// or delete it outright.
void showLessonActions(BuildContext context, LessonStore store, Lesson lesson) {
  final l10n = AppLocalizations.of(context);
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(formatDateTime(lesson.date)),
              subtitle: Text(statusLabel(l10n, lesson.status)),
            ),
            const Divider(height: 1),
            if (lesson.status != LessonStatus.completed)
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(l10n.markAsVisited),
                onTap: () {
                  store.markVisited(lesson.id);
                  Navigator.pop(sheetContext);
                },
              ),
            if (lesson.status == LessonStatus.scheduled)
              ListTile(
                leading: const Icon(Icons.event_busy_outlined),
                title: Text(l10n.markAsMissed),
                onTap: () {
                  store.markMissed(lesson.id);
                  Navigator.pop(sheetContext);
                },
              ),
            ListTile(
              leading: const Icon(Icons.edit_calendar_outlined),
              title: Text(l10n.rescheduleToNewDate),
              onTap: () async {
                Navigator.pop(sheetContext);
                final picked = await pickDateTime(context, initial: lesson.date);
                if (picked != null) {
                  store.rescheduleLesson(lesson.id, picked);
                }
              },
            ),
            if (lesson.status == LessonStatus.scheduled)
              ListTile(
                leading: const Icon(Icons.alarm_add_outlined),
                title: Text(lesson.reminder == null ? l10n.setReminder : l10n.editReminder),
                onTap: () {
                  Navigator.pop(sheetContext);
                  reminderDialog(context, store, [lesson]);
                },
              ),
            if (lesson.status == LessonStatus.missed)
              ListTile(
                leading: const Icon(Icons.merge_type_outlined),
                title: Text(l10n.replaceUpcoming),
                subtitle: Text(l10n.replaceUpcomingHelp),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showMergeSheet(context, store, lesson);
                },
              ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(sheetContext).colorScheme.error,
              ),
              title: Text(
                l10n.deleteLesson,
                style: TextStyle(color: Theme.of(sheetContext).colorScheme.error),
              ),
              onTap: () {
                store.deleteLesson(lesson.id);
                Navigator.pop(sheetContext);
              },
            ),
          ],
        ),
      );
    },
  );
}

void _showMergeSheet(BuildContext context, LessonStore store, Lesson missed) {
  final candidates = store.lessons
      .where((l) => l.id != missed.id && l.status == LessonStatus.scheduled)
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      if (candidates.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Text(AppLocalizations.of(sheetContext).noMergeCandidates),
        );
      }
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: candidates
              .map(
                (l) => ListTile(
                  leading: const Icon(Icons.event_outlined),
                  title: Text(formatDateTime(l.date)),
                  onTap: () {
                    store.mergeIntoOtherSlot(missed.id, l.id);
                    Navigator.pop(sheetContext);
                  },
                ),
              )
              .toList(),
        ),
      );
    },
  );
}
