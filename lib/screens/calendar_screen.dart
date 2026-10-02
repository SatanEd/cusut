import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../l10n/app_localizations.dart';
import '../models/lesson.dart';
import '../stores/lesson_store.dart';
import '../widgets/atelier_app_bar.dart';
import '../widgets/lesson_actions.dart';
import '../widgets/lesson_selection.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/schedule_choice_sheet.dart';
import '../widgets/section_eyebrow.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.store});

  final LessonStore store;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with LessonSelection {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  List<Lesson> _eventsForDay(DateTime day) => widget.store.lessonsOnDay(day);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selected = _selectedDay ?? _focusedDay;
    final dayLessons = _eventsForDay(selected);
    final l10n = AppLocalizations.of(context);

    return selectionPopScope(
      child: Scaffold(
        appBar: isSelecting
            ? selectionAppBar(widget.store, dayLessons)
            : AtelierAppBar(title: l10n.appTitle, section: l10n.navSchedule),
        floatingActionButton: isSelecting
            ? null
            : FloatingActionButton(
                onPressed: () => showScheduleChoiceSheet(
                  context,
                  widget.store,
                  initialDate: DateTime(
                    selected.year,
                    selected.month,
                    selected.day,
                    DateTime.now().hour + 1,
                  ),
                ),
                child: const Icon(Icons.add),
              ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TableCalendar<Lesson>(
                  locale: l10n.localeName,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  eventLoader: _eventsForDay,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      // Selection is scoped to the day's list shown below.
                      selectedLessonIds.clear();
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: false,
                    titleTextStyle: textTheme.headlineSmall!.copyWith(color: scheme.primary),
                    leftChevronIcon: Icon(Icons.chevron_left, color: scheme.onSurfaceVariant),
                    rightChevronIcon: Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: textTheme.labelSmall!.copyWith(color: scheme.onSurfaceVariant),
                    weekendStyle: textTheme.labelSmall!.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: textTheme.bodyMedium!,
                    weekendTextStyle: textTheme.bodyMedium!,
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: scheme.secondary, width: 1.5),
                    ),
                    todayTextStyle: textTheme.bodyMedium!.copyWith(
                      color: scheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                    selectedDecoration:
                        BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
                    selectedTextStyle: textTheme.bodyMedium!.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    markerDecoration:
                        BoxDecoration(color: scheme.secondary, shape: BoxShape.circle),
                    markersMaxCount: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SectionEyebrow(l10n.selectedDayEyebrow),
            const SizedBox(height: 6),
            Text(l10n.lessonsOnThisDay, style: textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (dayLessons.isEmpty)
              Text(l10n.noLessonsOnThisDay, style: textTheme.bodyMedium)
            else
              Column(
                children: [
                  for (final l in dayLessons)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: LessonTile(
                        lesson: l,
                        selected: selectedLessonIds.contains(l.id),
                        onTap: onLessonTap(l, () => showLessonActions(context, widget.store, l)),
                        onLongPress: () => toggleLessonSelection(l.id),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
