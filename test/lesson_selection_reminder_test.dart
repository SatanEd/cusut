import 'package:cusut/main.dart';
import 'package:cusut/models/lesson.dart';
import 'package:cusut/models/lesson_reminder.dart';
import 'package:cusut/screens/alarm_screen.dart';
import 'package:cusut/services/reminder_service.dart';
import 'package:cusut/services/storage_service.dart';
import 'package:cusut/stores/lesson_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeScheduler implements ReminderScheduler {
  List<Lesson> lastSynced = [];
  int permissionRequests = 0;

  @override
  Future<void> sync(List<Lesson> lessons) async => lastSynced = lessons;

  @override
  Future<void> requestPermissions() async => permissionRequests++;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('deleteLessons removes exactly the given lessons', () async {
    final store = LessonStore(StorageService());
    await store.load();
    final base = DateTime.now().add(const Duration(days: 1));
    for (var i = 0; i < 3; i++) {
      await store.scheduleLesson(base.add(Duration(days: i)));
    }
    final ids = store.lessons.map((l) => l.id).toList();

    await store.deleteLessons({ids[0], ids[2]});

    expect(store.lessons.map((l) => l.id), [ids[1]]);
  });

  test('reminders persist, follow reschedules, clear, and are synced', () async {
    final scheduler = _FakeScheduler();
    final store = LessonStore(StorageService(), reminders: scheduler);
    await store.load();
    await store.scheduleLesson(DateTime.now().add(const Duration(days: 1)));
    await store.scheduleLesson(DateTime.now().add(const Duration(days: 2)));
    final ids = store.lessons.map((l) => l.id).toSet();

    await store.setReminder(ids, const LessonReminder(title: 'Bring fabric', minutesBefore: 30));
    expect(scheduler.permissionRequests, 1);
    expect(scheduler.lastSynced.every((l) => l.reminder?.title == 'Bring fabric'), isTrue);

    // Survives a reload from storage.
    final reloaded = LessonStore(StorageService());
    await reloaded.load();
    expect(reloaded.lessons.every((l) => l.reminder?.minutesBefore == 30), isTrue);

    final first = store.lessons.first;
    await store.rescheduleLesson(first.id, first.date.add(const Duration(hours: 3)));
    expect(store.lessons.firstWhere((l) => l.id == first.id).reminder?.title, 'Bring fabric');

    await store.setReminder({first.id}, null);
    expect(store.lessons.firstWhere((l) => l.id == first.id).reminder, isNull);
    expect(store.lessons.where((l) => l.reminder != null).length, 1);
    expect(scheduler.permissionRequests, 1);
  });

  testWidgets('long press enters selection and bulk-deletes lessons', (tester) async {
    final reminders = ReminderService();
    final store = LessonStore(StorageService(), reminders: reminders);
    await tester.pumpWidget(CusutApp(store: store, reminders: reminders));
    await tester.pumpAndSettle();
    final base = DateTime.now().add(const Duration(days: 1));
    for (var i = 0; i < 3; i++) {
      store.scheduleLesson(base.add(Duration(days: i)));
      await tester.pumpAndSettle();
    }

    final lessonTiles = find.descendant(
      of: find.byType(ListView),
      matching: find.textContaining('SCHEDULED'),
    );
    expect(lessonTiles, findsNWidgets(3));

    await tester.longPress(lessonTiles.at(0));
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsOneWidget);
    expect(find.text('Schedule lesson'), findsNothing);

    await tester.tap(lessonTiles.at(1));
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete 2 lessons?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(store.lessons.length, 1);
    expect(find.textContaining('selected'), findsNothing);
    expect(find.text('Schedule lesson'), findsOneWidget);
  });

  testWidgets('a due reminder shows the full-screen alarm', (tester) async {
    final reminders = ReminderService();
    final store = LessonStore(StorageService(), reminders: reminders);
    await tester.pumpWidget(CusutApp(store: store, reminders: reminders));
    await tester.pumpAndSettle();

    store.scheduleLesson(DateTime.now().add(const Duration(minutes: 10)));
    await tester.pumpAndSettle();
    store.setReminder(
      {store.lessons.single.id},
      const LessonReminder(title: 'Hemming class', minutesBefore: 9),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AlarmScreen), findsNothing);
    expect(find.textContaining('ALARM'), findsOneWidget);
    await tester.pump(const Duration(minutes: 2));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(AlarmScreen), findsOneWidget);
    expect(find.text('Hemming class'), findsOneWidget);

    await tester.tap(find.text('Dismiss'));
    await tester.pumpAndSettle();
    expect(find.byType(AlarmScreen), findsNothing);
  });
}
