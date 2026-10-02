import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import '../models/lesson.dart';
import '../models/recurring_schedule.dart';
import '../models/round.dart';

/// Persists lessons, rounds, settings and recurring schedules as JSON in
/// [SharedPreferences].
///
/// This is a single-user, on-device app, so a simple key/value store is
/// enough — no backend, no sync.
class StorageService {
  static const _lessonsKey = 'cusut.lessons';
  static const _roundsKey = 'cusut.rounds';
  static const _settingsKey = 'cusut.settings';
  static const _schedulesKey = 'cusut.recurring_schedules';
  static const _materializedKey = 'cusut.materialized_occurrences';

  Future<List<Lesson>> loadLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lessonsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Lesson.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveLessons(List<Lesson> lessons) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(lessons.map((l) => l.toJson()).toList());
    await prefs.setString(_lessonsKey, raw);
  }

  Future<List<Round>> loadRounds() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_roundsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Round.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveRounds(List<Round> rounds) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(rounds.map((r) => r.toJson()).toList());
    await prefs.setString(_roundsKey, raw);
  }

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null) return const AppSettings();
    return AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  Future<List<RecurringSchedule>> loadRecurringSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_schedulesKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => RecurringSchedule.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveRecurringSchedules(List<RecurringSchedule> schedules) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(schedules.map((s) => s.toJson()).toList());
    await prefs.setString(_schedulesKey, raw);
  }

  /// Keys of "scheduleId|isoDateTime" occurrences already turned into a
  /// [Lesson], so materialization never generates the same slot twice even
  /// if the resulting lesson later gets rescheduled or deleted.
  Future<Set<String>> loadMaterializedOccurrences() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_materializedKey) ?? const []).toSet();
  }

  Future<void> saveMaterializedOccurrences(Set<String> keys) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_materializedKey, keys.toList());
  }
}
