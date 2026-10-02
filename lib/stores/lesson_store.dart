import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;

import '../models/app_settings.dart';
import '../models/lesson.dart';
import '../models/lesson_reminder.dart';
import '../models/lesson_status.dart';
import '../models/recurring_schedule.dart';
import '../models/round.dart';
import '../services/reminder_service.dart';
import '../services/storage_service.dart';

/// How far ahead recurring schedules get materialized into real [Lesson]
/// entries. Re-extended every time the store loads (e.g. app start, or a
/// pull-to-refresh), so it stays current without needing a background job.
const _materializationHorizon = Duration(days: 70);

/// Single source of truth for lessons, rounds, settings and recurring
/// schedules.
///
/// UI widgets rebuild via [ListenableBuilder] whenever this notifies.
class LessonStore extends ChangeNotifier {
  LessonStore(this._storage, {ReminderScheduler? reminders}) : _reminders = reminders;

  final StorageService _storage;
  final ReminderScheduler? _reminders;

  List<Lesson> _lessons = [];
  List<Round> _rounds = [];
  List<RecurringSchedule> _schedules = [];
  Set<String> _materializedOccurrences = {};
  AppSettings _settings = const AppSettings();
  bool _loaded = false;
  int _idCounter = 0;

  bool get isLoaded => _loaded;
  List<Lesson> get lessons => List.unmodifiable(_lessons);
  List<Round> get rounds => List.unmodifiable(_rounds);
  List<RecurringSchedule> get recurringSchedules => List.unmodifiable(_schedules);
  AppSettings get settings => _settings;

  /// The round new lessons get attached to: the not-yet-paid round, or (if
  /// everything has somehow been paid) the most recent round as a fallback.
  Round? get activeRound {
    if (_rounds.isEmpty) return null;
    final unpaid = _rounds.where((r) => !r.paid).toList()
      ..sort((a, b) => a.number.compareTo(b.number));
    if (unpaid.isNotEmpty) return unpaid.first;
    final sorted = [..._rounds]..sort((a, b) => a.number.compareTo(b.number));
    return sorted.last;
  }

  Round? roundById(String id) {
    for (final r in _rounds) {
      if (r.id == id) return r;
    }
    return null;
  }

  int completedCountFor(String roundId) => _lessons
      .where(
        (l) => l.roundId == roundId && l.status == LessonStatus.completed,
      )
      .length;

  bool isRoundDue(Round round) =>
      !round.paid && completedCountFor(round.id) >= round.lessonsRequired;

  /// Rounds that hit their lesson threshold but haven't been marked paid yet.
  List<Round> get roundsDueForPayment =>
      _rounds.where(isRoundDue).toList()..sort((a, b) => a.number.compareTo(b.number));

  List<Lesson> get upcomingLessons {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final list = _lessons
        .where(
          (l) => l.status == LessonStatus.scheduled && !l.date.isBefore(today),
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  List<Lesson> lessonsOnDay(DateTime day) => _lessons
      .where(
        (l) => l.date.year == day.year && l.date.month == day.month && l.date.day == day.day,
      )
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  /// All lessons belonging to one round, most recent first.
  List<Lesson> lessonsForRound(String roundId) =>
      _lessons.where((l) => l.roundId == roundId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  Future<void> load() async {
    _lessons = await _storage.loadLessons();
    _rounds = await _storage.loadRounds();
    _settings = await _storage.loadSettings();
    _schedules = await _storage.loadRecurringSchedules();
    _materializedOccurrences = await _storage.loadMaterializedOccurrences();
    if (_rounds.isEmpty) {
      _rounds = [
        Round(
          id: _newId(),
          number: 1,
          lessonsRequired: _settings.lessonsPerRound,
          startDate: DateTime.now(),
        ),
      ];
      await _storage.saveRounds(_rounds);
    }
    await _materializeSchedules();
    _reminders?.sync(_lessons);
    _loaded = true;
    notifyListeners();
  }

  /// Monotonically unique even when several ids are minted in the same
  /// synchronous loop (e.g. materializing a week of recurring lessons),
  /// where clock resolution alone (especially on web) isn't reliable.
  String _newId() => '${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';

  Future<void> scheduleLesson(DateTime date, {String? note}) async {
    final round = activeRound;
    if (round == null) return;
    _lessons = [
      ..._lessons,
      Lesson(id: _newId(), roundId: round.id, date: date, note: note),
    ];
    await _saveLessons();
    notifyListeners();
  }

  Future<void> markVisited(String lessonId) async {
    _replaceLesson(
      lessonId,
      (l) => l.copyWith(status: LessonStatus.completed),
    );
    await _saveLessons();
    notifyListeners();
  }

  Future<void> markMissed(String lessonId) async {
    _replaceLesson(lessonId, (l) => l.copyWith(status: LessonStatus.missed));
    await _saveLessons();
    notifyListeners();
  }

  Future<void> rescheduleLesson(String lessonId, DateTime newDate) async {
    _replaceLesson(
      lessonId,
      (l) => l.copyWith(date: newDate, status: LessonStatus.scheduled, detachSchedule: true),
    );
    await _saveLessons();
    notifyListeners();
  }

  /// "Replace next session with the missed one": drops [otherLessonId]
  /// entirely and moves [missedLessonId] onto its date/time, so a postponed
  /// lesson doesn't turn into two calendar slots.
  Future<void> mergeIntoOtherSlot(
    String missedLessonId,
    String otherLessonId,
  ) async {
    final other = _lessons.firstWhere((l) => l.id == otherLessonId);
    _lessons = _lessons.where((l) => l.id != otherLessonId).toList();
    _replaceLesson(
      missedLessonId,
      (l) => l.copyWith(date: other.date, status: LessonStatus.scheduled, detachSchedule: true),
    );
    await _saveLessons();
    notifyListeners();
  }

  Future<void> deleteLesson(String lessonId) => deleteLessons({lessonId});

  Future<void> deleteLessons(Set<String> lessonIds) async {
    _lessons = _lessons.where((l) => !lessonIds.contains(l.id)).toList();
    await _saveLessons();
    notifyListeners();
  }

  /// Sets (or, with a null [reminder], removes) the alarm on every lesson
  /// in [lessonIds].
  Future<void> setReminder(Set<String> lessonIds, LessonReminder? reminder) async {
    _lessons = [
      for (final l in _lessons)
        if (lessonIds.contains(l.id))
          l.copyWith(reminder: reminder, clearReminder: reminder == null)
        else
          l,
    ];
    await _saveLessons();
    notifyListeners();
    if (reminder != null) await _reminders?.requestPermissions();
  }

  /// Persists lessons and re-syncs their alarms, since almost any lesson
  /// change (move, status, delete) affects what should ring when.
  Future<void> _saveLessons() async {
    await _storage.saveLessons(_lessons);
    await _reminders?.sync(_lessons);
  }

  void _replaceLesson(String id, Lesson Function(Lesson) update) {
    final index = _lessons.indexWhere((l) => l.id == id);
    if (index == -1) return;
    final next = [..._lessons];
    next[index] = update(next[index]);
    _lessons = next;
  }

  Future<void> updateLessonsPerRound(int value) async {
    _settings = _settings.copyWith(lessonsPerRound: value);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateLanguage(String languageCode) async {
    _settings = _settings.copyWith(languageCode: languageCode);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  /// Edits how many lessons make up a specific round (e.g. the tailor's
  /// pricing changed mid-cycle). Only affects that one round.
  Future<void> updateRoundLessonsRequired(String roundId, int value) async {
    final index = _rounds.indexWhere((r) => r.id == roundId);
    if (index == -1) return;
    final next = [..._rounds];
    next[index] = next[index].copyWith(lessonsRequired: value);
    _rounds = next;
    await _storage.saveRounds(_rounds);
    notifyListeners();
  }

  /// Closes out [roundId] as paid and immediately opens the next round using
  /// the current threshold setting.
  Future<void> markRoundPaidAndStartNewRound(String roundId) async {
    final index = _rounds.indexWhere((r) => r.id == roundId);
    if (index == -1) return;
    final next = [..._rounds];
    next[index] = next[index].copyWith(paid: true, completedAt: DateTime.now());
    final nextNumber = next.map((r) => r.number).fold<int>(0, (a, b) => a > b ? a : b) + 1;
    next.add(
      Round(
        id: _newId(),
        number: nextNumber,
        lessonsRequired: _settings.lessonsPerRound,
        startDate: DateTime.now(),
      ),
    );
    _rounds = next;
    await _storage.saveRounds(_rounds);
    notifyListeners();
  }

  Future<void> togglePaid(String roundId, bool paid) async {
    final index = _rounds.indexWhere((r) => r.id == roundId);
    if (index == -1) return;
    final next = [..._rounds];
    next[index] = next[index].copyWith(paid: paid);
    _rounds = next;
    await _storage.saveRounds(_rounds);
    notifyListeners();
  }

  // --- Recurring schedules -------------------------------------------------

  Future<void> addRecurringSchedule({
    required Set<int> daysOfWeek,
    required int hour,
    required int minute,
  }) async {
    final schedule = RecurringSchedule(
      id: _newId(),
      daysOfWeek: daysOfWeek,
      hour: hour,
      minute: minute,
    );
    _schedules = [..._schedules, schedule];
    await _storage.saveRecurringSchedules(_schedules);
    await _materializeSchedules();
    notifyListeners();
  }

  Future<void> updateRecurringSchedule(
    String id, {
    required Set<int> daysOfWeek,
    required int hour,
    required int minute,
  }) async {
    final index = _schedules.indexWhere((s) => s.id == id);
    if (index == -1) return;
    final next = [..._schedules];
    next[index] = next[index].copyWith(daysOfWeek: daysOfWeek, hour: hour, minute: minute);
    _schedules = next;
    await _storage.saveRecurringSchedules(_schedules);
    // The old pattern's not-yet-happened auto-generated slots no longer
    // apply; clear them before regenerating under the new pattern.
    await _clearFutureGeneratedFor(id);
    await _materializeSchedules();
    notifyListeners();
  }

  Future<void> toggleScheduleActive(String id, bool active) async {
    final index = _schedules.indexWhere((s) => s.id == id);
    if (index == -1) return;
    final next = [..._schedules];
    next[index] = next[index].copyWith(active: active);
    _schedules = next;
    await _storage.saveRecurringSchedules(_schedules);
    if (active) {
      await _materializeSchedules();
    } else {
      await _clearFutureGeneratedFor(id);
    }
    notifyListeners();
  }

  Future<void> deleteRecurringSchedule(String id) async {
    await _clearFutureGeneratedFor(id);
    _schedules = _schedules.where((s) => s.id != id).toList();
    await _storage.saveRecurringSchedules(_schedules);
    notifyListeners();
  }

  /// Removes this schedule's not-yet-happened, untouched auto-generated
  /// lessons. Anything already completed/missed, or manually moved (which
  /// detaches [Lesson.scheduleId]), is left alone.
  Future<void> _clearFutureGeneratedFor(String scheduleId) async {
    final now = DateTime.now();
    _lessons = _lessons.where((l) {
      final isFutureGenerated =
          l.scheduleId == scheduleId && l.status == LessonStatus.scheduled && l.date.isAfter(now);
      return !isFutureGenerated;
    }).toList();
    await _saveLessons();
  }

  /// Ensures every active recurring schedule has real [Lesson] entries for
  /// every occurrence between now and [_materializationHorizon], without
  /// ever generating the same occurrence twice.
  Future<void> _materializeSchedules() async {
    if (_schedules.isEmpty) return;
    final round = activeRound;
    if (round == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final horizon = today.add(_materializationHorizon);

    final newLessons = <Lesson>[];
    final newKeys = <String>{};

    for (final schedule in _schedules.where((s) => s.active)) {
      for (var day = today; !day.isAfter(horizon); day = day.add(const Duration(days: 1))) {
        if (!schedule.daysOfWeek.contains(day.weekday)) continue;
        final occurrence = DateTime(day.year, day.month, day.day, schedule.hour, schedule.minute);
        if (occurrence.isBefore(now)) continue;

        final key = '${schedule.id}|${occurrence.toIso8601String()}';
        if (_materializedOccurrences.contains(key) || newKeys.contains(key)) continue;

        newKeys.add(key);
        newLessons.add(
          Lesson(id: _newId(), roundId: round.id, date: occurrence, scheduleId: schedule.id),
        );
      }
    }

    if (newLessons.isEmpty) return;
    _lessons = [..._lessons, ...newLessons];
    _materializedOccurrences = {..._materializedOccurrences, ...newKeys};
    await _saveLessons();
    await _storage.saveMaterializedOccurrences(_materializedOccurrences);
  }
}
