import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/lesson.dart';
import '../models/lesson_reminder.dart';
import '../stores/lesson_store.dart';

const _offsets = [0, 5, 15, 30, 60, 120, 1440];

String _offsetLabel(AppLocalizations l10n, int minutes) {
  if (minutes == 0) return l10n.reminderAtStart;
  if (minutes % 1440 == 0) return l10n.reminderDaysBefore(minutes ~/ 1440);
  if (minutes % 60 == 0) return l10n.reminderHoursBefore(minutes ~/ 60);
  return l10n.reminderMinutesBefore(minutes);
}

/// Set, change or remove the full-screen alarm on one or more lessons. The
/// same title and lead time are applied to every lesson in [lessons].
Future<void> reminderDialog(
  BuildContext context,
  LessonStore store,
  List<Lesson> lessons,
) {
  return showDialog<void>(
    context: context,
    builder: (_) => _ReminderDialog(store: store, lessons: lessons),
  );
}

/// Owns the title controller so it is disposed only once the dialog route is
/// fully gone, not while its closing animation still rebuilds the TextField.
class _ReminderDialog extends StatefulWidget {
  const _ReminderDialog({required this.store, required this.lessons});

  final LessonStore store;
  final List<Lesson> lessons;

  @override
  State<_ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<_ReminderDialog> {
  late final List<LessonReminder> _existing =
      widget.lessons.map((l) => l.reminder).whereType<LessonReminder>().toList();
  late final Set<String> _ids = widget.lessons.map((l) => l.id).toSet();
  late int _minutesBefore = _existing.isNotEmpty ? _existing.first.minutesBefore : 15;
  TextEditingController? _titleController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _titleController ??= TextEditingController(
      text: _existing.isNotEmpty
          ? _existing.first.title
          : AppLocalizations.of(context).defaultReminderTitle,
    );
  }

  @override
  void dispose() {
    _titleController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lessons = widget.lessons;
    return AlertDialog(
      title: Text(
        lessons.length == 1 ? l10n.lessonReminder : l10n.remindForLessons(lessons.length),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: l10n.alarmTitleLabel),
            ),
            const SizedBox(height: 16),
            Text(l10n.ringLabel, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final offset in _offsets)
                  ChoiceChip(
                    label: Text(_offsetLabel(l10n, offset)),
                    selected: _minutesBefore == offset,
                    onSelected: (_) => setState(() => _minutesBefore = offset),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        if (_existing.isNotEmpty)
          TextButton(
            onPressed: () {
              widget.store.setReminder(_ids, null);
              Navigator.pop(context);
            },
            child: Text(_existing.length == 1 ? l10n.remove : l10n.removeAll),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final title = _titleController!.text.trim();
            widget.store.setReminder(
              _ids,
              LessonReminder(
                title: title.isEmpty ? l10n.defaultReminderTitle : title,
                minutesBefore: _minutesBefore,
              ),
            );
            Navigator.pop(context);
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
