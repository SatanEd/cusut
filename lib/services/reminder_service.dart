import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../l10n/app_localizations.dart';
import '../models/lesson.dart';
import '../models/lesson_status.dart';
import '../utils/date_utils.dart';

/// One ringing reminder: everything the full-screen alarm needs, carried
/// in the notification payload so it still renders if the lesson was
/// edited or deleted in the meantime.
class ReminderAlarm {
  const ReminderAlarm({
    required this.lessonId,
    required this.title,
    required this.lessonDate,
    required this.fireTime,
  });

  final String lessonId;
  final String title;
  final DateTime lessonDate;
  final DateTime fireTime;

  String get key => '$lessonId|${fireTime.toIso8601String()}';

  /// Stable per lesson (FNV-1a), so re-syncing replaces a lesson's pending
  /// notification instead of adding a second one.
  int get notificationId {
    var hash = 0x811c9dc5;
    for (final unit in lessonId.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
    }
    return hash & 0x7fffffff;
  }

  String encode() => jsonEncode({
        'lessonId': lessonId,
        'title': title,
        'lessonDate': lessonDate.toIso8601String(),
        'fireTime': fireTime.toIso8601String(),
      });

  static ReminderAlarm? tryDecode(String? payload) {
    if (payload == null) return null;
    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;
      return ReminderAlarm(
        lessonId: json['lessonId'] as String,
        title: json['title'] as String,
        lessonDate: DateTime.parse(json['lessonDate'] as String),
        fireTime: DateTime.parse(json['fireTime'] as String),
      );
    } catch (_) {
      return null;
    }
  }
}

/// What [LessonStore] needs from the alarm layer; lets tests run without
/// any platform plugins.
abstract class ReminderScheduler {
  /// Makes the scheduled alarms match the reminders on [lessons].
  Future<void> sync(List<Lesson> lessons);

  /// Asks for whatever OS permissions alarms need. Safe to call repeatedly.
  Future<void> requestPermissions();
}

/// Rings lesson reminders as a full-screen alarm.
///
/// While the app is running, an in-process timer emits on [alarms] and the
/// app pushes the alarm screen. On Android ([useSystemAlarms]) each reminder
/// is also scheduled as an exact, full-screen-intent notification, so it
/// rings over the lock screen even when the app is closed; opening the app
/// from it replays the alarm via [takeLaunchAlarm].
class ReminderService implements ReminderScheduler {
  ReminderService({this.useSystemAlarms = false});

  final bool useSystemAlarms;

  static const _channelId = 'lesson_alarms';
  static const _dismissActionId = 'dismiss';

  final _plugin = FlutterLocalNotificationsPlugin();
  final _alarms = StreamController<ReminderAlarm>.broadcast();
  final _rung = <String>{};
  List<Timer> _timers = [];
  ReminderAlarm? _launchAlarm;
  Future<void> _syncQueue = Future.value();
  AppLocalizations _l10n = lookupAppLocalizations(const Locale('en'));
  List<Lesson>? _lastLessons;

  Stream<ReminderAlarm> get alarms => _alarms.stream;

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  Future<void> init() async {
    if (!useSystemAlarms) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final alarm = ReminderAlarm.tryDecode(response.payload);
        if (alarm == null) return;
        if (response.actionId == _dismissActionId) {
          _rung.add(alarm.key);
        } else {
          _ring(alarm);
        }
      },
    );
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch != null &&
        launch.didNotificationLaunchApp &&
        launch.notificationResponse?.actionId != _dismissActionId) {
      _launchAlarm = ReminderAlarm.tryDecode(launch.notificationResponse?.payload);
      if (_launchAlarm != null) _rung.add(_launchAlarm!.key);
    }
  }

  /// The alarm whose notification cold-started the app, if any. Returned
  /// once.
  ReminderAlarm? takeLaunchAlarm() {
    final alarm = _launchAlarm;
    _launchAlarm = null;
    return alarm;
  }

  /// Stops the alarm's notification (and its looping sound).
  Future<void> dismiss(ReminderAlarm alarm) async {
    _rung.add(alarm.key);
    if (useSystemAlarms) await _plugin.cancel(id: alarm.notificationId);
  }

  @override
  Future<void> requestPermissions() async {
    if (!useSystemAlarms) return;
    final android = _android;
    if (android == null) return;
    await android.requestNotificationsPermission();
    if (await android.canScheduleExactNotifications() != true) {
      await android.requestExactAlarmsPermission();
    }
    await android.requestFullScreenIntentPermission();
  }

  /// Language for notification text. Changing it reschedules pending
  /// alarms so they ring with the new wording.
  void updateStrings(AppLocalizations l10n) {
    if (l10n.localeName == _l10n.localeName) return;
    _l10n = l10n;
    final lessons = _lastLessons;
    if (lessons != null) sync(lessons);
  }

  @override
  Future<void> sync(List<Lesson> lessons) {
    _lastLessons = lessons;
    // Serialized: overlapping syncs could otherwise cancel each other's
    // freshly scheduled notifications.
    return _syncQueue = _syncQueue.then((_) => _sync(lessons)).catchError((_) {});
  }

  Future<void> _sync(List<Lesson> lessons) async {
    final now = DateTime.now();
    final upcoming = [
      for (final l in lessons)
        if (l.status == LessonStatus.scheduled && l.reminder != null)
          ReminderAlarm(
            lessonId: l.id,
            title: l.reminder!.title,
            lessonDate: l.date,
            fireTime: l.reminder!.fireTimeFor(l.date),
          ),
    ].where((a) => a.fireTime.isAfter(now)).toList();

    for (final t in _timers) {
      t.cancel();
    }
    _timers = [
      for (final a in upcoming) Timer(a.fireTime.difference(now), () => _ring(a)),
    ];

    if (!useSystemAlarms) return;
    final wanted = {for (final a in upcoming) a.notificationId};
    for (final pending in await _plugin.pendingNotificationRequests()) {
      if (!wanted.contains(pending.id)) await _plugin.cancel(id: pending.id);
    }
    final exact = await _android?.canScheduleExactNotifications() ?? false;
    for (final a in upcoming) {
      await _plugin.zonedSchedule(
        id: a.notificationId,
        title: a.title,
        body: _l10n.notificationBody(formatTime(a.lessonDate)),
        scheduledDate: tz.TZDateTime.from(a.fireTime, tz.UTC),
        notificationDetails: _details,
        androidScheduleMode:
            exact ? AndroidScheduleMode.alarmClock : AndroidScheduleMode.inexactAllowWhileIdle,
        payload: a.encode(),
      );
    }
  }

  void _ring(ReminderAlarm alarm) {
    if (!_rung.add(alarm.key)) return;
    _alarms.add(alarm);
  }

  NotificationDetails get _details => NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _l10n.notificationChannelName,
          channelDescription: _l10n.notificationChannelDescription,
          importance: Importance.max,
          priority: Priority.max,
          category: AndroidNotificationCategory.alarm,
          fullScreenIntent: true,
          audioAttributesUsage: AudioAttributesUsage.alarm,
          ongoing: true,
          autoCancel: false,
          // FLAG_INSISTENT: keep ringing until dismissed, like an alarm clock.
          additionalFlags: Int32List.fromList([4]),
          actions: [AndroidNotificationAction(_dismissActionId, _l10n.dismiss)],
        ),
      );
}
