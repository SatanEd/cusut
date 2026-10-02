import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../stores/lesson_store.dart';
import '../utils/date_utils.dart';
import '../widgets/atelier_app_bar.dart';
import '../widgets/lesson_actions.dart';
import '../widgets/lesson_selection.dart';
import '../widgets/lesson_stamp_grid.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/schedule_choice_sheet.dart';
import '../widgets/section_eyebrow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});

  final LessonStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with LessonSelection {
  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final round = store.activeRound;
    final dueRounds = store.roundsDueForPayment;
    final upcoming = store.upcomingLessons;
    final l10n = AppLocalizations.of(context);

    return selectionPopScope(
      child: Scaffold(
        appBar: isSelecting
            ? selectionAppBar(store, upcoming)
            : AtelierAppBar(title: l10n.appTitle, section: l10n.navTracker),
        floatingActionButton: isSelecting
            ? null
            : FloatingActionButton.extended(
                onPressed: () => showScheduleChoiceSheet(context, store),
                icon: const Icon(Icons.add),
                label: Text(l10n.scheduleLesson),
              ),
        body: RefreshIndicator(
          onRefresh: store.load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              for (final r in dueRounds)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PaymentBanner(store: store, roundId: r.id),
                ),
              if (round != null) _RoundProgressCard(store: store, roundId: round.id),
              const SizedBox(height: 28),
              SectionEyebrow(l10n.comingUpEyebrow),
              const SizedBox(height: 6),
              Text(l10n.upcomingLessons, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              if (upcoming.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    l10n.noUpcomingLessons,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              else
                Column(
                  children: [
                    for (final l in upcoming)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: LessonTile(
                          lesson: l,
                          selected: selectedLessonIds.contains(l.id),
                          onTap: onLessonTap(l, () => showLessonActions(context, store, l)),
                          onLongPress: () => toggleLessonSelection(l.id),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentBanner extends StatelessWidget {
  const _PaymentBanner({required this.store, required this.roundId});

  final LessonStore store;
  final String roundId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final round = store.roundById(roundId);
    if (round == null) return const SizedBox.shrink();
    final completed = store.completedCountFor(round.id);
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: scheme.secondary, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(Icons.payments_outlined, size: 18, color: scheme.onSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.paymentBannerEyebrow,
                      style: textTheme.labelSmall?.copyWith(
                        color: scheme.secondaryFixedDim,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.paymentBannerTitle,
                      style: textTheme.headlineSmall?.copyWith(color: scheme.primaryFixed),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.paymentBannerBody(
                        completed,
                        round.lessonsRequired,
                        round.number,
                        round.number + 1,
                      ),
                      style: textTheme.bodySmall?.copyWith(color: scheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: scheme.secondary,
                foregroundColor: scheme.onSecondary,
              ),
              onPressed: () => store.markRoundPaidAndStartNewRound(round.id),
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: Text(l10n.markPaidAndStartNew),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundProgressCard extends StatelessWidget {
  const _RoundProgressCard({required this.store, required this.roundId});

  final LessonStore store;
  final String roundId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final round = store.roundById(roundId);
    if (round == null) return const SizedBox.shrink();
    final completed = store.completedCountFor(round.id);
    final due = store.isRoundDue(round);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionEyebrow(l10n.activeRoundEyebrow),
                      const SizedBox(height: 4),
                      Text(
                        due ? l10n.roundCompleteTitle(round.number) : l10n.roundTitle(round.number),
                        style: textTheme.headlineMedium?.copyWith(color: scheme.primary),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.startedLabel,
                      style: textTheme.labelSmall?.copyWith(
                        color: scheme.outline,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(formatDate(round.startDate), style: textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LessonStampGrid(completed: completed, required: round.lessonsRequired),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.content_cut, size: 14),
                const SizedBox(width: 6),
                Text(
                  l10n.perforationLabel,
                  style: textTheme.labelSmall?.copyWith(letterSpacing: 1.4),
                ),
                const SizedBox(width: 10),
                Expanded(child: Divider(color: scheme.outlineVariant, height: 1)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              l10n.lessonsCompletedOf(completed, round.lessonsRequired),
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
