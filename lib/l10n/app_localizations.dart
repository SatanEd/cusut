import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ro'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tailor Lessons'**
  String get appTitle;

  /// No description provided for @navTracker.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get navTracker;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @sectionRound.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get sectionRound;

  /// No description provided for @editRound.
  ///
  /// In en, this message translates to:
  /// **'Edit round'**
  String get editRound;

  /// No description provided for @scheduleLesson.
  ///
  /// In en, this message translates to:
  /// **'Schedule lesson'**
  String get scheduleLesson;

  /// No description provided for @comingUpEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Coming Up'**
  String get comingUpEyebrow;

  /// No description provided for @upcomingLessons.
  ///
  /// In en, this message translates to:
  /// **'Upcoming lessons'**
  String get upcomingLessons;

  /// No description provided for @noUpcomingLessons.
  ///
  /// In en, this message translates to:
  /// **'No lessons scheduled yet. Tap \"Schedule lesson\" to add one.'**
  String get noUpcomingLessons;

  /// No description provided for @paymentBannerEyebrow.
  ///
  /// In en, this message translates to:
  /// **'ROUND COMPLETE • RENEWAL DUE'**
  String get paymentBannerEyebrow;

  /// No description provided for @paymentBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to pay for the next round'**
  String get paymentBannerTitle;

  /// No description provided for @paymentBannerBody.
  ///
  /// In en, this message translates to:
  /// **'You’ve completed {completed} of {total} lessons in Round {round}. Settle up to start Round {next}.'**
  String paymentBannerBody(int completed, int total, int round, int next);

  /// No description provided for @markPaidAndStartNew.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid & start new round'**
  String get markPaidAndStartNew;

  /// No description provided for @activeRoundEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Active Round'**
  String get activeRoundEyebrow;

  /// No description provided for @roundTitle.
  ///
  /// In en, this message translates to:
  /// **'Round {number}'**
  String roundTitle(int number);

  /// No description provided for @roundCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Round {number} Complete'**
  String roundCompleteTitle(int number);

  /// No description provided for @startedLabel.
  ///
  /// In en, this message translates to:
  /// **'STARTED'**
  String get startedLabel;

  /// No description provided for @perforationLabel.
  ///
  /// In en, this message translates to:
  /// **'PERFORATION'**
  String get perforationLabel;

  /// No description provided for @lessonsCompletedOf.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} lessons completed'**
  String lessonsCompletedOf(int completed, int total);

  /// No description provided for @roundSizeEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Round Size'**
  String get roundSizeEyebrow;

  /// No description provided for @defaultLessonsPerRound.
  ///
  /// In en, this message translates to:
  /// **'Default lessons per round'**
  String get defaultLessonsPerRound;

  /// No description provided for @roundSizeHelp.
  ///
  /// In en, this message translates to:
  /// **'How many lessons make up a new round. Change this any time — it only affects rounds started after the change. (To edit an existing round, open it below.)'**
  String get roundSizeHelp;

  /// No description provided for @lessonsPerRoundLabel.
  ///
  /// In en, this message translates to:
  /// **'Lessons per round'**
  String get lessonsPerRoundLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @invalidWholeNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number greater than 0'**
  String get invalidWholeNumber;

  /// No description provided for @savedFromNextRound.
  ///
  /// In en, this message translates to:
  /// **'Saved. Applies from the next round onward.'**
  String get savedFromNextRound;

  /// No description provided for @appearanceEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceEyebrow;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageEyebrow;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get languageTitle;

  /// No description provided for @repeatsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get repeatsEyebrow;

  /// No description provided for @recurringSchedulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring schedules'**
  String get recurringSchedulesTitle;

  /// No description provided for @addRecurringSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add recurring schedule'**
  String get addRecurringSchedule;

  /// No description provided for @recurringSchedulesHelp.
  ///
  /// In en, this message translates to:
  /// **'Automatically schedules lessons ahead of time on the days and time you pick.'**
  String get recurringSchedulesHelp;

  /// No description provided for @noRecurringSchedules.
  ///
  /// In en, this message translates to:
  /// **'No recurring schedules yet.'**
  String get noRecurringSchedules;

  /// No description provided for @historyEyebrow.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyEyebrow;

  /// No description provided for @roundsArchive.
  ///
  /// In en, this message translates to:
  /// **'Rounds archive'**
  String get roundsArchive;

  /// No description provided for @roundsArchiveHelp.
  ///
  /// In en, this message translates to:
  /// **'Tap a round to edit its lesson count or manage its lessons.'**
  String get roundsArchiveHelp;

  /// No description provided for @atTime.
  ///
  /// In en, this message translates to:
  /// **'At {time}'**
  String atTime(String time);

  /// No description provided for @roundShort.
  ///
  /// In en, this message translates to:
  /// **'R{number}'**
  String roundShort(int number);

  /// No description provided for @roundArchiveSummary.
  ///
  /// In en, this message translates to:
  /// **'Started {date} · {completed}/{total} lessons'**
  String roundArchiveSummary(String date, int completed, int total);

  /// No description provided for @paidOnSuffix.
  ///
  /// In en, this message translates to:
  /// **' · paid {date}'**
  String paidOnSuffix(String date);

  /// No description provided for @paymentDue.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT DUE'**
  String get paymentDue;

  /// No description provided for @roundUpdated.
  ///
  /// In en, this message translates to:
  /// **'Round updated.'**
  String get roundUpdated;

  /// No description provided for @roundNoLongerExists.
  ///
  /// In en, this message translates to:
  /// **'This round no longer exists.'**
  String get roundNoLongerExists;

  /// No description provided for @thisRoundEyebrow.
  ///
  /// In en, this message translates to:
  /// **'This Round'**
  String get thisRoundEyebrow;

  /// No description provided for @lessonsInRound.
  ///
  /// In en, this message translates to:
  /// **'Lessons in Round {number}'**
  String lessonsInRound(int number);

  /// No description provided for @roundPricingHelp.
  ///
  /// In en, this message translates to:
  /// **'Change this if the tailor’s pricing changed mid-cycle. Only affects this round.'**
  String get roundPricingHelp;

  /// No description provided for @lessonsRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Lessons required'**
  String get lessonsRequiredLabel;

  /// No description provided for @markedAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Marked as paid'**
  String get markedAsPaid;

  /// No description provided for @notYetPaid.
  ///
  /// In en, this message translates to:
  /// **'Not yet paid'**
  String get notYetPaid;

  /// No description provided for @startedOn.
  ///
  /// In en, this message translates to:
  /// **'Started {date}'**
  String startedOn(String date);

  /// No description provided for @lessonsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessonsEyebrow;

  /// No description provided for @allLessonsInRound.
  ///
  /// In en, this message translates to:
  /// **'All lessons in this round'**
  String get allLessonsInRound;

  /// No description provided for @noLessonsInRound.
  ///
  /// In en, this message translates to:
  /// **'No lessons scheduled in this round yet.'**
  String get noLessonsInRound;

  /// No description provided for @roundDetailHelp.
  ///
  /// In en, this message translates to:
  /// **'Tap any lesson to mark it visited/missed, reschedule it, or fold a missed one into an upcoming slot. Long-press to select several lessons to delete or set a reminder on.'**
  String get roundDetailHelp;

  /// No description provided for @reminderAtStart.
  ///
  /// In en, this message translates to:
  /// **'At start'**
  String get reminderAtStart;

  /// No description provided for @reminderMinutesBefore.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before'**
  String reminderMinutesBefore(int minutes);

  /// No description provided for @reminderHoursBefore.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, =1{1 hour before} other{{hours} hours before}}'**
  String reminderHoursBefore(int hours);

  /// No description provided for @reminderDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day before} other{{days} days before}}'**
  String reminderDaysBefore(int days);

  /// No description provided for @defaultReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Tailoring lesson'**
  String get defaultReminderTitle;

  /// No description provided for @lessonReminder.
  ///
  /// In en, this message translates to:
  /// **'Lesson reminder'**
  String get lessonReminder;

  /// No description provided for @remindForLessons.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Remind for 1 lesson} other{Remind for {count} lessons}}'**
  String remindForLessons(int count);

  /// No description provided for @alarmTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Alarm title'**
  String get alarmTitleLabel;

  /// No description provided for @ringLabel.
  ///
  /// In en, this message translates to:
  /// **'Ring'**
  String get ringLabel;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removeAll.
  ///
  /// In en, this message translates to:
  /// **'Remove all'**
  String get removeAll;

  /// No description provided for @newRecurringSchedule.
  ///
  /// In en, this message translates to:
  /// **'New recurring schedule'**
  String get newRecurringSchedule;

  /// No description provided for @editSchedule.
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get editSchedule;

  /// No description provided for @repeatsOn.
  ///
  /// In en, this message translates to:
  /// **'Repeats on'**
  String get repeatsOn;

  /// No description provided for @scheduleALesson.
  ///
  /// In en, this message translates to:
  /// **'Schedule a lesson'**
  String get scheduleALesson;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @scheduleAction.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleAction;

  /// No description provided for @markAsVisited.
  ///
  /// In en, this message translates to:
  /// **'Mark as visited'**
  String get markAsVisited;

  /// No description provided for @markAsMissed.
  ///
  /// In en, this message translates to:
  /// **'Mark as missed'**
  String get markAsMissed;

  /// No description provided for @rescheduleToNewDate.
  ///
  /// In en, this message translates to:
  /// **'Reschedule to a new date'**
  String get rescheduleToNewDate;

  /// No description provided for @setReminder.
  ///
  /// In en, this message translates to:
  /// **'Set reminder'**
  String get setReminder;

  /// No description provided for @editReminder.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get editReminder;

  /// No description provided for @replaceUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Replace an upcoming session with this one'**
  String get replaceUpcoming;

  /// No description provided for @replaceUpcomingHelp.
  ///
  /// In en, this message translates to:
  /// **'Fold this missed lesson into an already-scheduled one, instead of adding an extra slot'**
  String get replaceUpcomingHelp;

  /// No description provided for @deleteLesson.
  ///
  /// In en, this message translates to:
  /// **'Delete lesson'**
  String get deleteLesson;

  /// No description provided for @noMergeCandidates.
  ///
  /// In en, this message translates to:
  /// **'No upcoming lessons to merge into yet. Schedule one first, then merge this missed lesson into it.'**
  String get noMergeCandidates;

  /// No description provided for @cancelSelection.
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get cancelSelection;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get deselectAll;

  /// No description provided for @deleteLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 lesson?} other{Delete {count} lessons?}}'**
  String deleteLessonsTitle(int count);

  /// No description provided for @cannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This can’t be undone.'**
  String get cannotBeUndone;

  /// No description provided for @oneOffLesson.
  ///
  /// In en, this message translates to:
  /// **'One-off lesson'**
  String get oneOffLesson;

  /// No description provided for @oneOffLessonHelp.
  ///
  /// In en, this message translates to:
  /// **'Add a single lesson on a specific date'**
  String get oneOffLessonHelp;

  /// No description provided for @recurringSchedule.
  ///
  /// In en, this message translates to:
  /// **'Recurring schedule'**
  String get recurringSchedule;

  /// No description provided for @recurringScheduleHelp.
  ///
  /// In en, this message translates to:
  /// **'Repeat on chosen days and time, automatically'**
  String get recurringScheduleHelp;

  /// No description provided for @selectedDayEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Selected Day'**
  String get selectedDayEyebrow;

  /// No description provided for @lessonsOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'Lessons on this day'**
  String get lessonsOnThisDay;

  /// No description provided for @noLessonsOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'No lessons on this day.'**
  String get noLessonsOnThisDay;

  /// No description provided for @statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get statusScheduled;

  /// No description provided for @statusVisited.
  ///
  /// In en, this message translates to:
  /// **'Visited'**
  String get statusVisited;

  /// No description provided for @statusMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get statusMissed;

  /// No description provided for @chipRecurring.
  ///
  /// In en, this message translates to:
  /// **'RECURRING'**
  String get chipRecurring;

  /// No description provided for @chipAlarm.
  ///
  /// In en, this message translates to:
  /// **'ALARM'**
  String get chipAlarm;

  /// No description provided for @chipAlarmLead.
  ///
  /// In en, this message translates to:
  /// **'ALARM −{lead}'**
  String chipAlarmLead(String lead);

  /// No description provided for @leadDays.
  ///
  /// In en, this message translates to:
  /// **'{days}D'**
  String leadDays(int days);

  /// No description provided for @leadHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}H'**
  String leadHours(int hours);

  /// No description provided for @leadMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes}M'**
  String leadMinutes(int minutes);

  /// No description provided for @lessonStamp.
  ///
  /// In en, this message translates to:
  /// **'L{number}'**
  String lessonStamp(String number);

  /// No description provided for @lessonReminderEyebrow.
  ///
  /// In en, this message translates to:
  /// **'LESSON REMINDER'**
  String get lessonReminderEyebrow;

  /// No description provided for @startingNow.
  ///
  /// In en, this message translates to:
  /// **'Starting now'**
  String get startingNow;

  /// No description provided for @startsInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Starts in {minutes} min'**
  String startsInMinutes(int minutes);

  /// No description provided for @startsInHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'Starts in {hours} h {minutes} min'**
  String startsInHoursMinutes(int hours, int minutes);

  /// No description provided for @startsInDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Starts in 1 day} other{Starts in {days} days}}'**
  String startsInDays(int days);

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @notificationBody.
  ///
  /// In en, this message translates to:
  /// **'Lesson at {time}'**
  String notificationBody(String time);

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'Lesson alarms'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Full-screen alarms for lesson reminders'**
  String get notificationChannelDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ro', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
