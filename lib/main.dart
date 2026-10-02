import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'l10n/app_localizations.dart';

import 'screens/alarm_screen.dart';
import 'screens/app_shell.dart';
import 'services/reminder_service.dart';
import 'services/storage_service.dart';
import 'stores/lesson_store.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final reminders = ReminderService(
    useSystemAlarms: !kIsWeb && defaultTargetPlatform == TargetPlatform.android,
  );
  await reminders.init();
  runApp(
    CusutApp(
      store: LessonStore(StorageService(), reminders: reminders),
      reminders: reminders,
    ),
  );
}

class CusutApp extends StatefulWidget {
  const CusutApp({super.key, required this.store, required this.reminders});

  final LessonStore store;
  final ReminderService reminders;

  @override
  State<CusutApp> createState() => _CusutAppState();
}

class _CusutAppState extends State<CusutApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final StreamSubscription<ReminderAlarm> _alarmSub;

  @override
  void initState() {
    super.initState();
    widget.store.load();
    _alarmSub = widget.reminders.alarms.listen(_showAlarm);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final launchAlarm = widget.reminders.takeLaunchAlarm();
      if (launchAlarm != null) _showAlarm(launchAlarm);
    });
  }

  @override
  void dispose() {
    _alarmSub.cancel();
    super.dispose();
  }

  void _showAlarm(ReminderAlarm alarm) {
    _navigatorKey.currentState?.push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => AlarmScreen(
          alarm: alarm,
          onDismiss: () => widget.reminders.dismiss(alarm),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        locale: switch (widget.store.settings.languageCode) {
          final code? => Locale(code),
          null => null,
        },
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) {
          // Date formatting and alarm notifications live outside the widget
          // tree, so hand them the resolved language here.
          final l10n = AppLocalizations.of(context);
          Intl.defaultLocale = l10n.localeName;
          widget.reminders.updateStrings(l10n);
          return child!;
        },
        theme: AppTheme.theme,
        darkTheme: AppTheme.darkTheme,
        themeMode: widget.store.settings.themeMode,
        navigatorKey: _navigatorKey,
        home: AppShell(store: widget.store),
      ),
    );
  }
}
