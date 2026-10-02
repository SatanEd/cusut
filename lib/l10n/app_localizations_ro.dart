// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Lecții de croitorie';

  @override
  String get navTracker => 'Progres';

  @override
  String get navSchedule => 'Program';

  @override
  String get navSettings => 'Setări';

  @override
  String get sectionRound => 'Ciclu';

  @override
  String get editRound => 'Editează ciclul';

  @override
  String get scheduleLesson => 'Programează lecția';

  @override
  String get comingUpEyebrow => 'Urmează';

  @override
  String get upcomingLessons => 'Lecții viitoare';

  @override
  String get noUpcomingLessons =>
      'Nicio lecție programată încă. Apasă „Programează lecția” pentru a adăuga una.';

  @override
  String get paymentBannerEyebrow => 'CICLU ÎNCHEIAT • PLATA SCADENTĂ';

  @override
  String get paymentBannerTitle => 'E timpul să plătești următorul ciclu';

  @override
  String paymentBannerBody(int completed, int total, int round, int next) {
    return 'Lecții finalizate: $completed din $total în Ciclul $round. Achită pentru a începe Ciclul $next.';
  }

  @override
  String get markPaidAndStartNew => 'Marchează achitat și începe un ciclu nou';

  @override
  String get activeRoundEyebrow => 'Ciclu activ';

  @override
  String roundTitle(int number) {
    return 'Ciclul $number';
  }

  @override
  String roundCompleteTitle(int number) {
    return 'Ciclul $number încheiat';
  }

  @override
  String get startedLabel => 'ÎNCEPUT';

  @override
  String get perforationLabel => 'PERFORAȚIE';

  @override
  String lessonsCompletedOf(int completed, int total) {
    return 'Finalizate: $completed din $total';
  }

  @override
  String get roundSizeEyebrow => 'Mărimea ciclului';

  @override
  String get defaultLessonsPerRound => 'Lecții pe ciclu (implicit)';

  @override
  String get roundSizeHelp =>
      'Câte lecții formează un ciclu nou. Poți schimba oricând — afectează doar ciclurile începute după modificare. (Pentru a edita un ciclu existent, deschide-l mai jos.)';

  @override
  String get lessonsPerRoundLabel => 'Lecții pe ciclu';

  @override
  String get save => 'Salvează';

  @override
  String get cancel => 'Anulează';

  @override
  String get delete => 'Șterge';

  @override
  String get invalidWholeNumber => 'Introdu un număr întreg mai mare ca 0';

  @override
  String get savedFromNextRound =>
      'Salvat. Se aplică începând cu următorul ciclu.';

  @override
  String get appearanceEyebrow => 'Aspect';

  @override
  String get themeTitle => 'Temă';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Luminoasă';

  @override
  String get themeDark => 'Întunecată';

  @override
  String get languageEyebrow => 'Limbă';

  @override
  String get languageTitle => 'Limba aplicației';

  @override
  String get repeatsEyebrow => 'Repetări';

  @override
  String get recurringSchedulesTitle => 'Programe recurente';

  @override
  String get addRecurringSchedule => 'Adaugă un program recurent';

  @override
  String get recurringSchedulesHelp =>
      'Programează automat lecțiile din timp, în zilele și la ora alese.';

  @override
  String get noRecurringSchedules => 'Niciun program recurent încă.';

  @override
  String get historyEyebrow => 'Istoric';

  @override
  String get roundsArchive => 'Arhiva ciclurilor';

  @override
  String get roundsArchiveHelp =>
      'Apasă pe un ciclu pentru a-i edita numărul de lecții sau a-i gestiona lecțiile.';

  @override
  String atTime(String time) {
    return 'La $time';
  }

  @override
  String roundShort(int number) {
    return 'C$number';
  }

  @override
  String roundArchiveSummary(String date, int completed, int total) {
    return 'Început $date · $completed/$total lecții';
  }

  @override
  String paidOnSuffix(String date) {
    return ' · achitat $date';
  }

  @override
  String get paymentDue => 'PLATA SCADENTĂ';

  @override
  String get roundUpdated => 'Ciclu actualizat.';

  @override
  String get roundNoLongerExists => 'Acest ciclu nu mai există.';

  @override
  String get thisRoundEyebrow => 'Acest ciclu';

  @override
  String lessonsInRound(int number) {
    return 'Lecții în Ciclul $number';
  }

  @override
  String get roundPricingHelp =>
      'Schimbă dacă prețul croitorului s-a modificat pe parcurs. Afectează doar acest ciclu.';

  @override
  String get lessonsRequiredLabel => 'Lecții necesare';

  @override
  String get markedAsPaid => 'Marcat ca achitat';

  @override
  String get notYetPaid => 'Încă neachitat';

  @override
  String startedOn(String date) {
    return 'Început $date';
  }

  @override
  String get lessonsEyebrow => 'Lecții';

  @override
  String get allLessonsInRound => 'Toate lecțiile din acest ciclu';

  @override
  String get noLessonsInRound => 'Nicio lecție programată în acest ciclu încă.';

  @override
  String get roundDetailHelp =>
      'Apasă pe o lecție pentru a o marca drept vizitată/ratată, a o reprograma sau a comasa una ratată cu o lecție viitoare. Ține apăsat pentru a selecta mai multe lecții de șters sau pentru a le seta un memento.';

  @override
  String get reminderAtStart => 'La început';

  @override
  String reminderMinutesBefore(int minutes) {
    return 'Cu $minutes min înainte';
  }

  @override
  String reminderHoursBefore(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'Cu $hours de ore înainte',
      few: 'Cu $hours ore înainte',
      one: 'Cu o oră înainte',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Cu $days de zile înainte',
      few: 'Cu $days zile înainte',
      one: 'Cu o zi înainte',
    );
    return '$_temp0';
  }

  @override
  String get defaultReminderTitle => 'Lecție de croitorie';

  @override
  String get lessonReminder => 'Memento pentru lecție';

  @override
  String remindForLessons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Memento pentru $count de lecții',
      few: 'Memento pentru $count lecții',
      one: 'Memento pentru o lecție',
    );
    return '$_temp0';
  }

  @override
  String get alarmTitleLabel => 'Titlul alarmei';

  @override
  String get ringLabel => 'Sună';

  @override
  String get remove => 'Elimină';

  @override
  String get removeAll => 'Elimină tot';

  @override
  String get newRecurringSchedule => 'Program recurent nou';

  @override
  String get editSchedule => 'Editează programul';

  @override
  String get repeatsOn => 'Se repetă în';

  @override
  String get scheduleALesson => 'Programează o lecție';

  @override
  String get noteOptional => 'Notă (opțional)';

  @override
  String get scheduleAction => 'Programează';

  @override
  String get markAsVisited => 'Marchează ca vizitată';

  @override
  String get markAsMissed => 'Marchează ca ratată';

  @override
  String get rescheduleToNewDate => 'Reprogramează la o dată nouă';

  @override
  String get setReminder => 'Setează memento';

  @override
  String get editReminder => 'Editează memento-ul';

  @override
  String get replaceUpcoming => 'Înlocuiește o lecție viitoare cu aceasta';

  @override
  String get replaceUpcomingHelp =>
      'Comasează această lecție ratată cu una deja programată, în loc să adaugi încă o lecție';

  @override
  String get deleteLesson => 'Șterge lecția';

  @override
  String get noMergeCandidates =>
      'Încă nu există lecții viitoare cu care să o comasezi. Programează mai întâi una, apoi comasează această lecție ratată cu ea.';

  @override
  String get cancelSelection => 'Anulează selecția';

  @override
  String selectedCount(int count) {
    return 'Selectate: $count';
  }

  @override
  String get selectAll => 'Selectează tot';

  @override
  String get deselectAll => 'Deselectează tot';

  @override
  String deleteLessonsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ștergi $count de lecții?',
      few: 'Ștergi $count lecții?',
      one: 'Ștergi o lecție?',
    );
    return '$_temp0';
  }

  @override
  String get cannotBeUndone => 'Acțiunea nu poate fi anulată.';

  @override
  String get oneOffLesson => 'Lecție unică';

  @override
  String get oneOffLessonHelp => 'Adaugă o singură lecție la o anumită dată';

  @override
  String get recurringSchedule => 'Program recurent';

  @override
  String get recurringScheduleHelp =>
      'Se repetă automat în zilele și la ora alese';

  @override
  String get selectedDayEyebrow => 'Ziua selectată';

  @override
  String get lessonsOnThisDay => 'Lecțiile din această zi';

  @override
  String get noLessonsOnThisDay => 'Nicio lecție în această zi.';

  @override
  String get statusScheduled => 'Programată';

  @override
  String get statusVisited => 'Vizitată';

  @override
  String get statusMissed => 'Ratată';

  @override
  String get chipRecurring => 'RECURENTĂ';

  @override
  String get chipAlarm => 'ALARMĂ';

  @override
  String chipAlarmLead(String lead) {
    return 'ALARMĂ −$lead';
  }

  @override
  String leadDays(int days) {
    return '${days}Z';
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
  String get lessonReminderEyebrow => 'MEMENTO LECȚIE';

  @override
  String get startingNow => 'Începe acum';

  @override
  String startsInMinutes(int minutes) {
    return 'Începe peste $minutes min';
  }

  @override
  String startsInHoursMinutes(int hours, int minutes) {
    return 'Începe peste $hours h $minutes min';
  }

  @override
  String startsInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Începe peste $days de zile',
      few: 'Începe peste $days zile',
      one: 'Începe peste o zi',
    );
    return '$_temp0';
  }

  @override
  String get dismiss => 'Închide';

  @override
  String notificationBody(String time) {
    return 'Lecție la $time';
  }

  @override
  String get notificationChannelName => 'Alarme pentru lecții';

  @override
  String get notificationChannelDescription =>
      'Alarme pe tot ecranul pentru mementourile lecțiilor';
}
