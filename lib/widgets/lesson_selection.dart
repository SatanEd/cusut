import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/lesson.dart';
import '../screens/reminder_dialog.dart';
import '../stores/lesson_store.dart';

/// Long-press multi-select for a screen's lesson list. A long press on any
/// lesson enters selection mode; taps then toggle lessons in and out, and
/// the app bar swaps to [selectionAppBar] with bulk remind/delete actions.
/// Back (or the close button) leaves selection mode.
mixin LessonSelection<T extends StatefulWidget> on State<T> {
  final Set<String> selectedLessonIds = {};

  bool get isSelecting => selectedLessonIds.isNotEmpty;

  void toggleLessonSelection(String lessonId) {
    setState(() {
      if (!selectedLessonIds.remove(lessonId)) selectedLessonIds.add(lessonId);
    });
  }

  void clearLessonSelection() => setState(selectedLessonIds.clear);

  /// Tap handler for a lesson tile: toggles it while selecting, otherwise
  /// runs [onOpen].
  VoidCallback onLessonTap(Lesson lesson, VoidCallback onOpen) =>
      () => isSelecting ? toggleLessonSelection(lesson.id) : onOpen();

  /// Keeps back navigation from leaving the screen while selecting.
  Widget selectionPopScope({required Widget child}) => PopScope(
        canPop: !isSelecting,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) clearLessonSelection();
        },
        child: child,
      );

  /// [visible] is the list the user is selecting from, for "select all".
  PreferredSizeWidget selectionAppBar(LessonStore store, List<Lesson> visible) {
    // Lessons can disappear underneath us (e.g. a recurring schedule was
    // edited); only act on the ones that still exist.
    final selected = store.lessons.where((l) => selectedLessonIds.contains(l.id)).toList();
    final allSelected = visible.every((l) => selectedLessonIds.contains(l.id));
    final l10n = AppLocalizations.of(context);

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        tooltip: l10n.cancelSelection,
        onPressed: clearLessonSelection,
      ),
      title: Text(l10n.selectedCount(selectedLessonIds.length)),
      actions: [
        IconButton(
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          tooltip: allSelected ? l10n.deselectAll : l10n.selectAll,
          onPressed: () => setState(() {
            if (allSelected) {
              selectedLessonIds.clear();
            } else {
              selectedLessonIds.addAll(visible.map((l) => l.id));
            }
          }),
        ),
        IconButton(
          icon: const Icon(Icons.alarm_add_outlined),
          tooltip: l10n.setReminder,
          onPressed: selected.isEmpty
              ? null
              : () async {
                  await reminderDialog(context, store, selected);
                  if (mounted) clearLessonSelection();
                },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: l10n.delete,
          onPressed: selected.isEmpty ? null : () => _confirmDelete(store, selected),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(LessonStore store, List<Lesson> lessons) async {
    final count = lessons.length;
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteLessonsTitle(count)),
        content: Text(l10n.cannotBeUndone),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
              foregroundColor: Theme.of(dialogContext).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await store.deleteLessons(lessons.map((l) => l.id).toSet());
    if (mounted) clearLessonSelection();
  }
}
