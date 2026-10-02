import 'dart:convert';

import 'package:cusut/main.dart';
import 'package:cusut/services/reminder_service.dart';
import 'package:cusut/services/storage_service.dart';
import 'package:cusut/stores/lesson_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<LessonStore> _pumpApp(WidgetTester tester, {String? languageCode}) async {
  SharedPreferences.setMockInitialValues({
    if (languageCode != null) 'cusut.settings': jsonEncode({'languageCode': languageCode}),
  });
  final reminders = ReminderService();
  final store = LessonStore(StorageService(), reminders: reminders);
  await tester.pumpWidget(CusutApp(store: store, reminders: reminders));
  await tester.pumpAndSettle();
  return store;
}

void main() {
  setUpAll(initializeDateFormatting);

  for (final (code, title, scheduleLesson, settings) in [
    ('en', 'Tailor Lessons', 'Schedule lesson', 'Settings'),
    ('ro', 'Lecții de croitorie', 'Programează lecția', 'Setări'),
    ('ru', 'Уроки шитья', 'Запланировать урок', 'Настройки'),
  ]) {
    testWidgets('renders every tab in $code', (tester) async {
      final store = await _pumpApp(tester, languageCode: code);
      await store.scheduleLesson(DateTime.now().add(const Duration(days: 2)));
      await tester.pumpAndSettle();

      expect(find.text(title), findsOneWidget);
      expect(find.text(scheduleLesson), findsOneWidget);

      for (final icon in [Icons.calendar_today_outlined, Icons.settings_outlined]) {
        await tester.tap(find.byIcon(icon));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      expect(find.text(settings), findsWidgets);
    });
  }

  testWidgets('switching language in settings re-translates the app', (tester) async {
    // Phone-sized (S24-like) surface so the bottom nav doesn't cover the picker.
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final store = await _pumpApp(tester, languageCode: 'en');
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // Centre the picker so neither the app bar nor the bottom nav covers it.
    await Scrollable.ensureVisible(tester.element(find.text('Русский')), alignment: 0.5);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Русский'));
    await tester.pumpAndSettle();

    expect(store.settings.languageCode, 'ru');
    expect(find.text('Настройки'), findsWidgets);
    expect(find.text('Settings'), findsNothing);
  });
}
