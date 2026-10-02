import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Renders round progress as a row of "punched" stamps — filled circles for
/// completed lessons, outlined circles for the remaining ones still needed
/// to hit the round's threshold. A nod to the physical five-lesson punch
/// cards tailoring ateliers hand out.
class LessonStampGrid extends StatelessWidget {
  const LessonStampGrid({
    super.key,
    required this.completed,
    required this.required,
  });

  final int completed;
  final int required;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final total = required <= 0 ? completed : required;
    if (total <= 0) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: List.generate(total, (i) {
        final done = i < completed;
        return SizedBox(
          width: 40,
          child: Column(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: done ? scheme.primary : scheme.surfaceContainerLow,
                  shape: BoxShape.circle,
                  border: done ? null : Border.all(color: scheme.outlineVariant, width: 1.5),
                ),
                child: Icon(done ? Icons.check : null, size: 16, color: scheme.onPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.lessonStamp((i + 1).toString().padLeft(2, '0')),
                style: textTheme.labelSmall?.copyWith(
                  color: done ? scheme.primary : scheme.onSurfaceVariant,
                  fontWeight: done ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
