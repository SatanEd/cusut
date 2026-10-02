import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/recurring_schedule.dart';
import '../stores/lesson_store.dart';
import '../utils/weekday_labels.dart';

/// Create or edit a recurring schedule: pick one or more days of the week
/// and a time; lessons get generated automatically going forward.
Future<void> recurringScheduleDialog(
  BuildContext context,
  LessonStore store, {
  RecurringSchedule? existing,
}) async {
  final selectedDays = <int>{...?existing?.daysOfWeek};
  final l10n = AppLocalizations.of(context);
  var time = TimeOfDay(hour: existing?.hour ?? 18, minute: existing?.minute ?? 0);

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: Text(existing == null ? l10n.newRecurringSchedule : l10n.editSchedule),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.repeatsOn, style: Theme.of(dialogContext).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final day in weekdayOrder)
                        FilterChip(
                          label: Text(weekdayShortLabel(day)),
                          selected: selectedDays.contains(day),
                          onSelected: (v) => setState(() {
                            if (v) {
                              selectedDays.add(day);
                            } else {
                              selectedDays.remove(day);
                            }
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.schedule),
                    title: Text(l10n.atTime(time.format(dialogContext))),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: dialogContext,
                        initialTime: time,
                      );
                      if (picked != null) setState(() => time = picked);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: selectedDays.isEmpty
                    ? null
                    : () {
                        if (existing == null) {
                          store.addRecurringSchedule(
                            daysOfWeek: selectedDays,
                            hour: time.hour,
                            minute: time.minute,
                          );
                        } else {
                          store.updateRecurringSchedule(
                            existing.id,
                            daysOfWeek: selectedDays,
                            hour: time.hour,
                            minute: time.minute,
                          );
                        }
                        Navigator.pop(dialogContext);
                      },
                child: Text(l10n.save),
              ),
            ],
          );
        },
      );
    },
  );
}
