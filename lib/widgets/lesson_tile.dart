import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/lesson.dart';
import '../models/lesson_status.dart';
import '../utils/date_utils.dart';

/// A single lesson row: a date badge, the date/time, and status/note chips —
/// styled after the Atelier design system's "Recent Attended Sessions" list.
class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    required this.onTap,
    this.onLongPress,
    this.selected = false,
  });

  final Lesson lesson;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  /// Multi-select state: swaps the date badge for a check mark and tints
  /// the row.
  final bool selected;

  (Color, Color) _badgeColors(ColorScheme scheme) {
    switch (lesson.status) {
      case LessonStatus.completed:
        return (scheme.secondaryContainer, scheme.onSecondaryContainer);
      case LessonStatus.missed:
        return (scheme.errorContainer, scheme.onErrorContainer);
      case LessonStatus.scheduled:
        return (scheme.surfaceContainerHighest, scheme.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasNote = lesson.note != null && lesson.note!.isNotEmpty;
    final l10n = AppLocalizations.of(context);
    final (badgeColor, badgeTextColor) = _badgeColors(scheme);

    return Material(
      color: selected
          ? (scheme.brightness == Brightness.dark
              ? scheme.secondaryContainer
              : scheme.secondaryFixed)
          : scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? scheme.secondary : badgeColor,
                  shape: BoxShape.circle,
                ),
                child: selected
                    ? Icon(Icons.check, size: 16, color: scheme.onSecondary)
                    : Text(
                        lesson.date.day.toString().padLeft(2, '0'),
                        style: textTheme.labelSmall?.copyWith(
                          color: badgeTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${formatDate(lesson.date)} · ${formatTime(lesson.date)}',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _StatusChip(status: lesson.status),
                        if (lesson.scheduleId != null)
                          _IconChip(icon: Icons.repeat, label: l10n.chipRecurring),
                        if (lesson.reminder != null)
                          _IconChip(
                            icon: Icons.alarm,
                            label: lesson.reminder!.minutesBefore == 0
                                ? l10n.chipAlarm
                                : l10n.chipAlarmLead(
                                    _leadLabel(l10n, lesson.reminder!.minutesBefore),
                                  ),
                          ),
                        if (hasNote) _NoteChip(label: lesson.note!),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final LessonStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (status) {
      LessonStatus.completed => (scheme.secondaryFixed, scheme.onSecondaryFixedVariant),
      LessonStatus.missed => (scheme.errorContainer, scheme.onErrorContainer),
      LessonStatus.scheduled => (scheme.surfaceContainer, scheme.onSurfaceVariant),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        statusLabel(AppLocalizations.of(context), status).toUpperCase(),
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: fg, letterSpacing: 0.6),
      ),
    );
  }
}

String _leadLabel(AppLocalizations l10n, int minutes) {
  if (minutes % 1440 == 0) return l10n.leadDays(minutes ~/ 1440);
  if (minutes % 60 == 0) return l10n.leadHours(minutes ~/ 60);
  return l10n.leadMinutes(minutes);
}

class _IconChip extends StatelessWidget {
  const _IconChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: scheme.onSurfaceVariant),
          const SizedBox(width: 3),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant, letterSpacing: 0.6),
          ),
        ],
      ),
    );
  }
}

class _NoteChip extends StatelessWidget {
  const _NoteChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant, letterSpacing: 0),
      ),
    );
  }
}
