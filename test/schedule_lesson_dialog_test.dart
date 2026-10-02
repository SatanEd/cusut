import 'package:cusut/main.dart';
import 'package:cusut/models/lesson.dart';
import 'package:cusut/services/reminder_service.dart';
import 'package:cusut/services/storage_service.dart';
import 'package:cusut/stores/lesson_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _NoopScheduler implements ReminderScheduler {
  @override
  Future<void> sync(List<Lesson> lessons) async {}

  @override
  Future<void> requestPermissions() async {}
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('scheduling a one-off lesson closes the dialog cleanly', (tester) async {
    final reminders = ReminderService();
    final store = LessonStore(StorageService(), reminders: reminders);
    await tester.pumpWidget(CusutApp(store: store, reminders: reminders));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Schedule lesson'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('One-off lesson'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Hem the skirt');
    await tester.tap(find.widgetWithText(FilledButton, 'Schedule'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(store.lessons.single.note, 'Hem the skirt');
  });

  testWidgets('saving a reminder closes the dialog cleanly', (tester) async {
    final reminders = ReminderService();
    // The real service would leave the alarm's timer pending.
    final store = LessonStore(StorageService(), reminders: _NoopScheduler());
    await tester.pumpWidget(CusutApp(store: store, reminders: reminders));
    await tester.pumpAndSettle();
    await store.scheduleLesson(DateTime.now().add(const Duration(days: 1)));
    await tester.pumpAndSettle();

    await tester.longPress(find.textContaining('SCHEDULED'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Set reminder'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Bring fabric');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(store.lessons.single.reminder?.title, 'Bring fabric');
  });
}
