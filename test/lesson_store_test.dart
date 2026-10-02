import 'package:cusut/models/lesson_status.dart';
import 'package:cusut/services/storage_service.dart';
import 'package:cusut/stores/lesson_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<LessonStore> freshStore() async {
  SharedPreferences.setMockInitialValues({});
  final store = LessonStore(StorageService());
  await store.load();
  return store;
}

void main() {
  test('default lessons-per-round threshold is 5', () async {
    final store = await freshStore();
    expect(store.settings.lessonsPerRound, 5);
    expect(store.activeRound?.lessonsRequired, 5);
  });

  test('recurring schedule materializes lessons on the right days/time only', () async {
    final store = await freshStore();
    final now = DateTime.now();

    await store.addRecurringSchedule(
      daysOfWeek: {DateTime.tuesday, DateTime.thursday},
      hour: 18,
      minute: 0,
    );
    final schedule = store.recurringSchedules.single;

    final generated = store.lessons.where((l) => l.scheduleId == schedule.id).toList();
    expect(generated, isNotEmpty);
    for (final lesson in generated) {
      expect(
        lesson.date.weekday == DateTime.tuesday || lesson.date.weekday == DateTime.thursday,
        isTrue,
      );
      expect(lesson.date.hour, 18);
      expect(lesson.date.minute, 0);
      expect(lesson.date.isAfter(now), isTrue);
      expect(lesson.status, LessonStatus.scheduled);
      expect(lesson.roundId, store.activeRound!.id);
    }

    // No id collisions even though many lessons were minted in one
    // synchronous burst.
    final ids = store.lessons.map((l) => l.id).toSet();
    expect(ids.length, store.lessons.length);
  });

  test('rescheduling a generated lesson detaches it from the series', () async {
    final store = await freshStore();
    await store.addRecurringSchedule(daysOfWeek: {DateTime.monday}, hour: 9, minute: 0);
    final schedule = store.recurringSchedules.single;
    final generated = store.lessons.firstWhere((l) => l.scheduleId == schedule.id);

    final newDate = generated.date.add(const Duration(days: 3));
    await store.rescheduleLesson(generated.id, newDate);

    final moved = store.lessons.firstWhere((l) => l.id == generated.id);
    expect(moved.date, newDate);
    expect(moved.scheduleId, isNull);
  });

  test('deleting a schedule clears its untouched future lessons but keeps detached ones', () async {
    final store = await freshStore();
    await store.addRecurringSchedule(daysOfWeek: {DateTime.wednesday}, hour: 10, minute: 0);
    final schedule = store.recurringSchedules.single;
    final generated =
        store.lessons.where((l) => l.scheduleId == schedule.id).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    expect(generated.length, greaterThan(1));

    // Detach one occurrence by rescheduling it manually.
    final kept = generated.first;
    await store.rescheduleLesson(kept.id, kept.date.add(const Duration(days: 1)));

    await store.deleteRecurringSchedule(schedule.id);

    expect(store.recurringSchedules, isEmpty);
    expect(store.lessons.any((l) => l.scheduleId == schedule.id), isFalse);
    expect(store.lessons.any((l) => l.id == kept.id), isTrue);
  });

  test('editing a round\'s lesson count only affects that round', () async {
    final store = await freshStore();
    final round = store.activeRound!;
    expect(round.lessonsRequired, 5);

    await store.updateRoundLessonsRequired(round.id, 12);

    expect(store.roundById(round.id)!.lessonsRequired, 12);
    // The global default used for future rounds is untouched.
    expect(store.settings.lessonsPerRound, 5);
  });

  test('a round becomes due once its (possibly edited) threshold is met', () async {
    final store = await freshStore();
    final round = store.activeRound!;
    await store.updateRoundLessonsRequired(round.id, 2);

    await store.scheduleLesson(DateTime.now().add(const Duration(days: 1)));
    final lessonId = store.lessons.first.id;
    await store.markVisited(lessonId);
    expect(store.isRoundDue(store.roundById(round.id)!), isFalse);

    await store.scheduleLesson(DateTime.now().add(const Duration(days: 2)));
    final secondId = store.lessons.firstWhere((l) => l.id != lessonId).id;
    await store.markVisited(secondId);

    expect(store.isRoundDue(store.roundById(round.id)!), isTrue);
    expect(store.roundsDueForPayment.map((r) => r.id), contains(round.id));
  });
}
