import 'package:cusut/main.dart';
import 'package:cusut/services/reminder_service.dart';
import 'package:cusut/services/storage_service.dart';
import 'package:cusut/stores/lesson_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App launches and shows the home screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final reminders = ReminderService();
    final store = LessonStore(StorageService(), reminders: reminders);

    await tester.pumpWidget(CusutApp(store: store, reminders: reminders));
    await tester.pumpAndSettle();

    expect(find.text('Tailor Lessons'), findsOneWidget);
    expect(find.text('Schedule lesson'), findsOneWidget);
  });
}
