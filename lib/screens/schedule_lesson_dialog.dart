import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../stores/lesson_store.dart';
import '../utils/date_utils.dart';
import '../utils/pick_date_time.dart';

Future<void> scheduleLessonDialog(
  BuildContext context,
  LessonStore store, {
  DateTime? initialDate,
}) {
  final now = DateTime.now();
  return showDialog<void>(
    context: context,
    builder: (_) => _ScheduleLessonDialog(
      store: store,
      initialDate: initialDate ?? DateTime(now.year, now.month, now.day, now.hour + 1),
    ),
  );
}

/// Owns the note controller so it is disposed only once the dialog route is
/// fully gone. Disposing it as soon as [showDialog] returns breaks the
/// closing animation, which still rebuilds the TextField.
class _ScheduleLessonDialog extends StatefulWidget {
  const _ScheduleLessonDialog({required this.store, required this.initialDate});

  final LessonStore store;
  final DateTime initialDate;

  @override
  State<_ScheduleLessonDialog> createState() => _ScheduleLessonDialogState();
}

class _ScheduleLessonDialogState extends State<_ScheduleLessonDialog> {
  late DateTime _date = widget.initialDate;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.scheduleALesson),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event),
            title: Text(formatDateTime(_date)),
            onTap: () async {
              final picked = await pickDateTime(context, initial: _date);
              if (picked != null && mounted) setState(() => _date = picked);
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: l10n.noteOptional,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final note = _noteController.text.trim();
            widget.store.scheduleLesson(_date, note: note.isEmpty ? null : note);
            Navigator.pop(context);
          },
          child: Text(l10n.scheduleAction),
        ),
      ],
    );
  }
}
