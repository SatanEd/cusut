import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/lesson_status.dart';

// All formatting follows [Intl.defaultLocale], which CusutApp keeps in sync
// with the selected app language.

String formatDate(DateTime d) => DateFormat('d MMM y').format(d);

String formatTime(DateTime d) => DateFormat.jm().format(d);

String formatDateTime(DateTime d) => '${formatDate(d)}, ${formatTime(d)}';

String weekdayShort(DateTime d) => DateFormat.E().format(d);

String statusLabel(AppLocalizations l10n, LessonStatus status) => switch (status) {
      LessonStatus.scheduled => l10n.statusScheduled,
      LessonStatus.completed => l10n.statusVisited,
      LessonStatus.missed => l10n.statusMissed,
    };
