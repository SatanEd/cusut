import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/recurring_schedule.dart';
import '../models/round.dart';
import '../stores/lesson_store.dart';
import '../utils/date_utils.dart';
import '../utils/weekday_labels.dart';
import '../widgets/atelier_app_bar.dart';
import '../widgets/section_eyebrow.dart';
import 'recurring_schedule_dialog.dart';
import 'round_detail_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.store});

  final LessonStore store;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _thresholdController;

  @override
  void initState() {
    super.initState();
    _thresholdController = TextEditingController(
      text: widget.store.settings.lessonsPerRound.toString(),
    );
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  void _save() {
    final value = int.tryParse(_thresholdController.text.trim());
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).invalidWholeNumber)),
      );
      return;
    }
    widget.store.updateLessonsPerRound(value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).savedFromNextRound)),
    );
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final rounds = [...widget.store.rounds]..sort((a, b) => b.number.compareTo(a.number));
    final schedules = widget.store.recurringSchedules;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AtelierAppBar(title: l10n.appTitle, section: l10n.navSettings),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionEyebrow(l10n.roundSizeEyebrow),
                  const SizedBox(height: 6),
                  Text(l10n.defaultLessonsPerRound, style: textTheme.headlineSmall),
                  const SizedBox(height: 6),
                  Text(
                    l10n.roundSizeHelp,
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _thresholdController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: l10n.lessonsPerRoundLabel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(onPressed: _save, child: Text(l10n.save)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionEyebrow(l10n.appearanceEyebrow),
                  const SizedBox(height: 6),
                  Text(l10n.themeTitle, style: textTheme.headlineSmall),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      segments: [
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: const Icon(Icons.brightness_auto_outlined),
                          label: Text(l10n.themeSystem),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: const Icon(Icons.light_mode_outlined),
                          label: Text(l10n.themeLight),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: const Icon(Icons.dark_mode_outlined),
                          label: Text(l10n.themeDark),
                        ),
                      ],
                      selected: {widget.store.settings.themeMode},
                      onSelectionChanged: (s) => widget.store.updateThemeMode(s.first),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionEyebrow(l10n.languageEyebrow),
                  const SizedBox(height: 6),
                  Text(l10n.languageTitle, style: textTheme.headlineSmall),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      showSelectedIcon: false,
                      // Language names stay in their own language so they're
                      // recognizable whatever the app is currently set to.
                      segments: const [
                        ButtonSegment(value: 'en', label: Text('English')),
                        ButtonSegment(value: 'ro', label: Text('Română')),
                        ButtonSegment(value: 'ru', label: Text('Русский')),
                      ],
                      selected: {l10n.localeName},
                      onSelectionChanged: (s) => widget.store.updateLanguage(s.first),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionEyebrow(l10n.repeatsEyebrow),
                    const SizedBox(height: 6),
                    Text(l10n.recurringSchedulesTitle, style: textTheme.headlineSmall),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => recurringScheduleDialog(context, widget.store),
                icon: const Icon(Icons.add_circle_outline),
                tooltip: l10n.addRecurringSchedule,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.recurringSchedulesHelp,
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (schedules.isEmpty)
            Text(l10n.noRecurringSchedules, style: textTheme.bodyMedium)
          else
            for (final s in schedules)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RecurringScheduleCard(store: widget.store, schedule: s),
              ),
          const SizedBox(height: 28),
          SectionEyebrow(l10n.historyEyebrow),
          const SizedBox(height: 6),
          Text(l10n.roundsArchive, style: textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(l10n.roundsArchiveHelp, style: textTheme.bodySmall),
          const SizedBox(height: 12),
          for (final r in rounds)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RoundArchiveCard(store: widget.store, round: r),
            ),
        ],
      ),
    );
  }
}

class _RecurringScheduleCard extends StatelessWidget {
  const _RecurringScheduleCard({required this.store, required this.schedule});

  final LessonStore store;
  final RecurringSchedule schedule;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final time = TimeOfDay(hour: schedule.hour, minute: schedule.minute).format(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => recurringScheduleDialog(context, store, existing: schedule),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      schedule.active ? scheme.secondaryContainer : scheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.repeat,
                  size: 18,
                  color: schedule.active ? scheme.onSecondaryContainer : scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weekdaySummary(schedule.daysOfWeek),
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(l10n.atTime(time), style: textTheme.bodySmall),
                  ],
                ),
              ),
              Switch(
                value: schedule.active,
                onChanged: (v) => store.toggleScheduleActive(schedule.id, v),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: scheme.error),
                onPressed: () => store.deleteRecurringSchedule(schedule.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundArchiveCard extends StatelessWidget {
  const _RoundArchiveCard({required this.store, required this.round});

  final LessonStore store;
  final Round round;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final completed = store.completedCountFor(round.id);
    final due = store.isRoundDue(round);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RoundDetailScreen(store: store, roundId: round.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: round.paid ? scheme.surfaceContainerHighest : scheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.roundShort(round.number),
                  style: textTheme.labelMedium?.copyWith(
                    color: round.paid ? scheme.primary : scheme.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.roundTitle(round.number),
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.roundArchiveSummary(
                            formatDate(round.startDate),
                            completed,
                            round.lessonsRequired,
                          ) +
                          (round.completedAt != null
                              ? l10n.paidOnSuffix(formatDate(round.completedAt!))
                              : ''),
                      style: textTheme.bodySmall,
                    ),
                    if (due) ...[
                      const SizedBox(height: 4),
                      Text(
                        l10n.paymentDue,
                        style: textTheme.labelSmall?.copyWith(
                          color: scheme.error,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
              Switch(value: round.paid, onChanged: (v) => store.togglePaid(round.id, v)),
            ],
          ),
        ),
      ),
    );
  }
}
