import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/reminder_service.dart';
import '../utils/date_utils.dart';

/// Full-screen alarm for a ringing lesson reminder: the reminder's title,
/// the lesson time, and one big button to dismiss it. Back also dismisses.
class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key, required this.alarm, required this.onDismiss});

  final ReminderAlarm alarm;
  final VoidCallback onDismiss;

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _dismiss() {
    widget.onDismiss();
    Navigator.of(context).pop();
  }

  String _startsIn(AppLocalizations l10n) {
    final minutes = widget.alarm.lessonDate.difference(DateTime.now()).inMinutes;
    if (minutes <= 0) return l10n.startingNow;
    if (minutes < 60) return l10n.startsInMinutes(minutes);
    final hours = minutes ~/ 60;
    if (hours < 24) return l10n.startsInHoursMinutes(hours, minutes % 60);
    return l10n.startsInDays(hours ~/ 24);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final alarm = widget.alarm;
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _dismiss();
      },
      child: Scaffold(
        backgroundColor: scheme.onPrimaryFixed,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              children: [
                Text(
                  l10n.lessonReminderEyebrow,
                  style: textTheme.labelMedium?.copyWith(
                    color: scheme.secondaryFixedDim,
                    letterSpacing: 2,
                  ),
                ),
                const Spacer(),
                ScaleTransition(
                  scale: Tween(begin: 0.92, end: 1.08).animate(
                    CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                  ),
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.secondary,
                    ),
                    child: Icon(Icons.alarm, size: 48, color: scheme.onSecondary),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  formatTime(alarm.lessonDate),
                  textAlign: TextAlign.center,
                  style: textTheme.displayLarge?.copyWith(color: scheme.primaryFixed),
                ),
                const SizedBox(height: 4),
                Text(
                  '${weekdayShort(alarm.lessonDate)}, ${formatDate(alarm.lessonDate)}',
                  style: textTheme.titleMedium?.copyWith(color: scheme.primaryFixedDim),
                ),
                const SizedBox(height: 32),
                Text(
                  alarm.title,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(color: scheme.primaryFixed),
                ),
                const SizedBox(height: 12),
                Text(
                  _startsIn(l10n),
                  style: textTheme.bodyLarge?.copyWith(color: scheme.secondaryFixedDim),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: scheme.secondary,
                      foregroundColor: scheme.onSecondary,
                      textStyle: textTheme.titleMedium,
                    ),
                    onPressed: _dismiss,
                    icon: const Icon(Icons.alarm_off),
                    label: Text(l10n.dismiss),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
