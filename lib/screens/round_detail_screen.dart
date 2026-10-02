import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../stores/lesson_store.dart';
import '../utils/date_utils.dart';
import '../widgets/atelier_app_bar.dart';
import '../widgets/lesson_actions.dart';
import '../widgets/lesson_selection.dart';
import '../widgets/lesson_stamp_grid.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/section_eyebrow.dart';

/// Full view of one round: edit how many lessons it takes, toggle paid, and
/// manage (reschedule/mark visited/missed) every lesson attached to it.
class RoundDetailScreen extends StatefulWidget {
  const RoundDetailScreen({super.key, required this.store, required this.roundId});

  final LessonStore store;
  final String roundId;

  @override
  State<RoundDetailScreen> createState() => _RoundDetailScreenState();
}

class _RoundDetailScreenState extends State<RoundDetailScreen> with LessonSelection {
  late final TextEditingController _thresholdController;

  @override
  void initState() {
    super.initState();
    final round = widget.store.roundById(widget.roundId);
    _thresholdController = TextEditingController(
      text: (round?.lessonsRequired ?? widget.store.settings.lessonsPerRound).toString(),
    );
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  void _saveThreshold() {
    final value = int.tryParse(_thresholdController.text.trim());
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).invalidWholeNumber)),
      );
      return;
    }
    widget.store.updateRoundLessonsRequired(widget.roundId, value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).roundUpdated)),
    );
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final round = widget.store.roundById(widget.roundId);
        if (round == null) {
          return Scaffold(
            appBar: AtelierAppBar(title: l10n.appTitle, section: l10n.sectionRound),
            body: Center(child: Text(l10n.roundNoLongerExists)),
          );
        }

        final scheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        final completed = widget.store.completedCountFor(round.id);
        final lessons = widget.store.lessonsForRound(round.id);

        return selectionPopScope(
          child: Scaffold(
            appBar: isSelecting
                ? selectionAppBar(widget.store, lessons)
                : AtelierAppBar(title: l10n.roundTitle(round.number), section: l10n.editRound),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionEyebrow(l10n.thisRoundEyebrow),
                        const SizedBox(height: 6),
                        Text(l10n.lessonsInRound(round.number), style: textTheme.headlineSmall),
                        const SizedBox(height: 6),
                        Text(
                          l10n.roundPricingHelp,
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _thresholdController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(labelText: l10n.lessonsRequiredLabel),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton(onPressed: _saveThreshold, child: Text(l10n.save)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                round.paid ? l10n.markedAsPaid : l10n.notYetPaid,
                                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Switch(
                              value: round.paid,
                              onChanged: (v) => widget.store.togglePaid(round.id, v),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LessonStampGrid(completed: completed, required: round.lessonsRequired),
                        const SizedBox(height: 10),
                        Text(
                          '${l10n.lessonsCompletedOf(completed, round.lessonsRequired)} · '
                          '${l10n.startedOn(formatDate(round.startDate))}',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SectionEyebrow(l10n.lessonsEyebrow),
                const SizedBox(height: 6),
                Text(l10n.allLessonsInRound, style: textTheme.headlineSmall),
                const SizedBox(height: 12),
                if (lessons.isEmpty)
                  Text(l10n.noLessonsInRound, style: textTheme.bodyMedium)
                else
                  Column(
                    children: [
                      for (final l in lessons)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: LessonTile(
                            lesson: l,
                            selected: selectedLessonIds.contains(l.id),
                            onTap:
                                onLessonTap(l, () => showLessonActions(context, widget.store, l)),
                            onLongPress: () => toggleLessonSelection(l.id),
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: 4),
                Text(
                  l10n.roundDetailHelp,
                  style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
