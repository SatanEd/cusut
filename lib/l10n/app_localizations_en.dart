// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tailor Lessons';

  @override
  String get navTracker => 'Tracker';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navSettings => 'Settings';

  @override
  String get sectionRound => 'Round';

  @override
  String get editRound => 'Edit round';

  @override
  String get scheduleLesson => 'Schedule lesson';

  @override
  String get comingUpEyebrow => 'Coming Up';

  @override
  String get upcomingLessons => 'Upcoming lessons';

  @override
  String get noUpcomingLessons =>
      'No lessons scheduled yet. Tap \"Schedule lesson\" to add one.';

  @override
  String get paymentBannerEyebrow => 'ROUND COMPLETE • RENEWAL DUE';

  @override
  String get paymentBannerTitle => 'Time to pay for the next round';

  @override
  String paymentBannerBody(int completed, int total, int round, int next) {
    return 'You’ve completed $completed of $total lessons in Round $round. Settle up to start Round $next.';
  }

  @override
  String get markPaidAndStartNew => 'Mark as paid & start new round';

  @override
  String get activeRoundEyebrow => 'Active Round';

  @override
  String roundTitle(int number) {
    return 'Round $number';
  }

  @override
  String roundCompleteTitle(int number) {
    return 'Round $number Complete';
  }

  @override
  String get startedLabel => 'STARTED';

  @override
  String get perforationLabel => 'PERFORATION';

  @override
  String lessonsCompletedOf(int completed, int total) {
    return '$completed of $total lessons completed';
  }

  @override
  String get roundSizeEyebrow => 'Round Size';

  @override
  String get defaultLessonsPerRound => 'Default lessons per round';

  @override
  String get roundSizeHelp =>
      'How many lessons make up a new round. Change this any time — it only affects rounds started after the change. (To edit an existing round, open it below.)';

  @override
  String get lessonsPerRoundLabel => 'Lessons per round';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get invalidWholeNumber => 'Enter a whole number greater than 0';

  @override
  String get savedFromNextRound => 'Saved. Applies from the next round onward.';

  @override
  String get appearanceEyebrow => 'Appearance';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageEyebrow => 'Language';

  @override
  String get languageTitle => 'App language';

  @override
  String get repeatsEyebrow => 'Repeats';

  @override
  String get recurringSchedulesTitle => 'Recurring schedules';

  @override
  String get addRecurringSchedule => 'Add recurring schedule';

  @override
  String get recurringSchedulesHelp =>
      'Automatically schedules lessons ahead of time on the days and time you pick.';

  @override
  String get noRecurringSchedules => 'No recurring schedules yet.';

  @override
  String get historyEyebrow => 'History';

  @override
  String get roundsArchive => 'Rounds archive';

  @override
  String get roundsArchiveHelp =>
      'Tap a round to edit its lesson count or manage its lessons.';

  @override
  String atTime(String time) {
    return 'At $time';
  }

  @override
  String roundShort(int number) {
    return 'R$number';
  }

  @override
  String roundArchiveSummary(String date, int completed, int total) {
    return 'Started $date · $completed/$total lessons';
  }

  @override
  String paidOnSuffix(String date) {
    return ' · paid $date';
  }

  @override
  String get paymentDue => 'PAYMENT DUE';

  @override
  String get roundUpdated => 'Round updated.';

  @override
  String get roundNoLongerExists => 'This round no longer exists.';

  @override
  String get thisRoundEyebrow => 'This Round';

  @override
  String lessonsInRound(int number) {
    return 'Lessons in Round $number';
  }

  @override
  String get roundPricingHelp =>
      'Change this if the tailor’s pricing changed mid-cycle. Only affects this round.';

  @override
  String get lessonsRequiredLabel => 'Lessons required';

  @override
  String get markedAsPaid => 'Marked as paid';

  @override
  String get notYetPaid => 'Not yet paid';

  @override
  String startedOn(String date) {
    return 'Started $date';
  }

  @override
  String get lessonsEyebrow => 'Lessons';

  @override
  String get allLessonsInRound => 'All lessons in this round';

  @override
  String get noLessonsInRound => 'No lessons scheduled in this round yet.';

  @override
  String get roundDetailHelp =>
      'Tap any lesson to mark it visited/missed, reschedule it, or fold a missed one into an upcoming slot. Long-press to select several lessons to delete or set a reminder on.';

  @override
  String get reminderAtStart => 'At start';

  @override
  String reminderMinutesBefore(int minutes) {
    return '$minutes min before';
  }

  @override
  String reminderHoursBefore(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours before',
      one: '1 hour before',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days before',
      one: '1 day before',
    );
    return '$_temp0';
  }

  @override
  String get defaultReminderTitle => 'Tailoring lesson';

  @override
  String get lessonReminder => 'Lesson reminder';

  @override
  String remindForLessons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Remind for $count lessons',
      one: 'Remind for 1 lesson',
    );
    return '$_temp0';
  }

  @override
  String get alarmTitleLabel => 'Alarm title';

  @override
  String get ringLabel => 'Ring';

  @override
  String get remove => 'Remove';

  @override
  String get removeAll => 'Remove all';

  @override
  String get newRecurringSchedule => 'New recurring schedule';

  @override
  String get editSchedule => 'Edit schedule';

  @override
  String get repeatsOn => 'Repeats on';

  @override
  String get scheduleALesson => 'Schedule a lesson';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get scheduleAction => 'Schedule';

  @override
  String get markAsVisited => 'Mark as visited';

  @override
  String get markAsMissed => 'Mark as missed';

  @override
  String get rescheduleToNewDate => 'Reschedule to a new date';

  @override
  String get setReminder => 'Set reminder';

  @override
  String get editReminder => 'Edit reminder';

  @override
  String get replaceUpcoming => 'Replace an upcoming session with this one';

  @override
  String get replaceUpcomingHelp =>
      'Fold this missed lesson into an already-scheduled one, instead of adding an extra slot';

  @override
  String get deleteLesson => 'Delete lesson';

  @override
  String get noMergeCandidates =>
      'No upcoming lessons to merge into yet. Schedule one first, then merge this missed lesson into it.';

  @override
  String get cancelSelection => 'Cancel selection';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get selectAll => 'Select all';

  @override
  String get deselectAll => 'Deselect all';

  @override
  String deleteLessonsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $count lessons?',
      one: 'Delete 1 lesson?',
    );
    return '$_temp0';
  }

  @override
  String get cannotBeUndone => 'This can’t be undone.';

  @override
  String get oneOffLesson => 'One-off lesson';

  @override
  String get oneOffLessonHelp => 'Add a single lesson on a specific date';

  @override
  String get recurringSchedule => 'Recurring schedule';

  @override
  String get recurringScheduleHelp =>
      'Repeat on chosen days and time, automatically';

  @override
  String get selectedDayEyebrow => 'Selected Day';

  @override
  String get lessonsOnThisDay => 'Lessons on this day';

  @override
  String get noLessonsOnThisDay => 'No lessons on this day.';

  @override
  String get statusScheduled => 'Scheduled';

  @override
  String get statusVisited => 'Visited';

  @override
  String get statusMissed => 'Missed';

  @override
  String get chipRecurring => 'RECURRING';

  @override
  String get chipAlarm => 'ALARM';

  @override
  String chipAlarmLead(String lead) {
    return 'ALARM −$lead';
  }

  @override
  String leadDays(int days) {
    return '${days}D';
  }

  @override
  String leadHours(int hours) {
    return '${hours}H';
  }

  @override
  String leadMinutes(int minutes) {
    return '${minutes}M';
  }

  @override
  String lessonStamp(String number) {
    return 'L$number';
  }

  @override
  String get lessonReminderEyebrow => 'LESSON REMINDER';

  @override
  String get startingNow => 'Starting now';

  @override
  String startsInMinutes(int minutes) {
    return 'Starts in $minutes min';
  }

  @override
  String startsInHoursMinutes(int hours, int minutes) {
    return 'Starts in $hours h $minutes min';
  }

  @override
  String startsInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Starts in $days days',
      one: 'Starts in 1 day',
    );
    return '$_temp0';
  }

  @override
  String get dismiss => 'Dismiss';

  @override
  String notificationBody(String time) {
    return 'Lesson at $time';
  }

  @override
  String get notificationChannelName => 'Lesson alarms';

  @override
  String get notificationChannelDescription =>
      'Full-screen alarms for lesson reminders';
}
