// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Уроки шитья';

  @override
  String get navTracker => 'Прогресс';

  @override
  String get navSchedule => 'Расписание';

  @override
  String get navSettings => 'Настройки';

  @override
  String get sectionRound => 'Цикл';

  @override
  String get editRound => 'Изменить цикл';

  @override
  String get scheduleLesson => 'Запланировать урок';

  @override
  String get comingUpEyebrow => 'Скоро';

  @override
  String get upcomingLessons => 'Предстоящие уроки';

  @override
  String get noUpcomingLessons =>
      'Уроков пока нет. Нажмите «Запланировать урок», чтобы добавить.';

  @override
  String get paymentBannerEyebrow => 'ЦИКЛ ЗАВЕРШЁН • ПОРА ОПЛАТИТЬ';

  @override
  String get paymentBannerTitle => 'Пора оплатить следующий цикл';

  @override
  String paymentBannerBody(int completed, int total, int round, int next) {
    return 'Пройдено уроков: $completed из $total в цикле $round. Оплатите, чтобы начать цикл $next.';
  }

  @override
  String get markPaidAndStartNew => 'Отметить оплату и начать новый цикл';

  @override
  String get activeRoundEyebrow => 'Текущий цикл';

  @override
  String roundTitle(int number) {
    return 'Цикл $number';
  }

  @override
  String roundCompleteTitle(int number) {
    return 'Цикл $number завершён';
  }

  @override
  String get startedLabel => 'НАЧАТ';

  @override
  String get perforationLabel => 'ПЕРФОРАЦИЯ';

  @override
  String lessonsCompletedOf(int completed, int total) {
    return 'Пройдено: $completed из $total';
  }

  @override
  String get roundSizeEyebrow => 'Размер цикла';

  @override
  String get defaultLessonsPerRound => 'Уроков в цикле по умолчанию';

  @override
  String get roundSizeHelp =>
      'Сколько уроков входит в новый цикл. Можно изменить в любой момент — это повлияет только на циклы, начатые после изменения. (Чтобы изменить существующий цикл, откройте его ниже.)';

  @override
  String get lessonsPerRoundLabel => 'Уроков в цикле';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get invalidWholeNumber => 'Введите целое число больше 0';

  @override
  String get savedFromNextRound => 'Сохранено. Применится со следующего цикла.';

  @override
  String get appearanceEyebrow => 'Оформление';

  @override
  String get themeTitle => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get languageEyebrow => 'Язык';

  @override
  String get languageTitle => 'Язык приложения';

  @override
  String get repeatsEyebrow => 'Повторы';

  @override
  String get recurringSchedulesTitle => 'Регулярные расписания';

  @override
  String get addRecurringSchedule => 'Добавить регулярное расписание';

  @override
  String get recurringSchedulesHelp =>
      'Автоматически планирует уроки заранее в выбранные дни и время.';

  @override
  String get noRecurringSchedules => 'Регулярных расписаний пока нет.';

  @override
  String get historyEyebrow => 'История';

  @override
  String get roundsArchive => 'Архив циклов';

  @override
  String get roundsArchiveHelp =>
      'Нажмите на цикл, чтобы изменить число уроков или управлять ими.';

  @override
  String atTime(String time) {
    return 'В $time';
  }

  @override
  String roundShort(int number) {
    return 'Ц$number';
  }

  @override
  String roundArchiveSummary(String date, int completed, int total) {
    return 'Начат $date · уроков: $completed/$total';
  }

  @override
  String paidOnSuffix(String date) {
    return ' · оплачен $date';
  }

  @override
  String get paymentDue => 'ТРЕБУЕТСЯ ОПЛАТА';

  @override
  String get roundUpdated => 'Цикл обновлён.';

  @override
  String get roundNoLongerExists => 'Этот цикл больше не существует.';

  @override
  String get thisRoundEyebrow => 'Этот цикл';

  @override
  String lessonsInRound(int number) {
    return 'Уроков в цикле $number';
  }

  @override
  String get roundPricingHelp =>
      'Измените, если цена у портного поменялась посреди цикла. Касается только этого цикла.';

  @override
  String get lessonsRequiredLabel => 'Нужно уроков';

  @override
  String get markedAsPaid => 'Оплачено';

  @override
  String get notYetPaid => 'Ещё не оплачено';

  @override
  String startedOn(String date) {
    return 'Начат $date';
  }

  @override
  String get lessonsEyebrow => 'Уроки';

  @override
  String get allLessonsInRound => 'Все уроки этого цикла';

  @override
  String get noLessonsInRound => 'В этом цикле пока нет уроков.';

  @override
  String get roundDetailHelp =>
      'Нажмите на урок, чтобы отметить его посещённым/пропущенным, перенести или объединить пропущенный с предстоящим. Удерживайте, чтобы выбрать несколько уроков для удаления или напоминания.';

  @override
  String get reminderAtStart => 'В начале';

  @override
  String reminderMinutesBefore(int minutes) {
    return 'За $minutes мин';
  }

  @override
  String reminderHoursBefore(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'За $hours часа',
      many: 'За $hours часов',
      few: 'За $hours часа',
      one: 'За $hours час',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'За $days дня',
      many: 'За $days дней',
      few: 'За $days дня',
      one: 'За $days день',
    );
    return '$_temp0';
  }

  @override
  String get defaultReminderTitle => 'Урок шитья';

  @override
  String get lessonReminder => 'Напоминание об уроке';

  @override
  String remindForLessons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Напоминание для $count уроков',
      one: 'Напоминание для $count урока',
    );
    return '$_temp0';
  }

  @override
  String get alarmTitleLabel => 'Название будильника';

  @override
  String get ringLabel => 'Звонок';

  @override
  String get remove => 'Удалить';

  @override
  String get removeAll => 'Удалить все';

  @override
  String get newRecurringSchedule => 'Новое регулярное расписание';

  @override
  String get editSchedule => 'Изменить расписание';

  @override
  String get repeatsOn => 'Повторять по';

  @override
  String get scheduleALesson => 'Запланировать урок';

  @override
  String get noteOptional => 'Заметка (необязательно)';

  @override
  String get scheduleAction => 'Запланировать';

  @override
  String get markAsVisited => 'Отметить как посещённый';

  @override
  String get markAsMissed => 'Отметить как пропущенный';

  @override
  String get rescheduleToNewDate => 'Перенести на другую дату';

  @override
  String get setReminder => 'Установить напоминание';

  @override
  String get editReminder => 'Изменить напоминание';

  @override
  String get replaceUpcoming => 'Заменить им предстоящий урок';

  @override
  String get replaceUpcomingHelp =>
      'Объединить пропущенный урок с уже запланированным, не добавляя лишний';

  @override
  String get deleteLesson => 'Удалить урок';

  @override
  String get noMergeCandidates =>
      'Пока нет предстоящих уроков для объединения. Сначала запланируйте урок, затем объедините с ним этот пропущенный.';

  @override
  String get cancelSelection => 'Отменить выбор';

  @override
  String selectedCount(int count) {
    return 'Выбрано: $count';
  }

  @override
  String get selectAll => 'Выбрать все';

  @override
  String get deselectAll => 'Снять выделение';

  @override
  String deleteLessonsTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удалить $count урока?',
      many: 'Удалить $count уроков?',
      few: 'Удалить $count урока?',
      one: 'Удалить $count урок?',
    );
    return '$_temp0';
  }

  @override
  String get cannotBeUndone => 'Это действие нельзя отменить.';

  @override
  String get oneOffLesson => 'Разовый урок';

  @override
  String get oneOffLessonHelp => 'Добавить один урок на конкретную дату';

  @override
  String get recurringSchedule => 'Регулярное расписание';

  @override
  String get recurringScheduleHelp =>
      'Повторяется автоматически в выбранные дни и время';

  @override
  String get selectedDayEyebrow => 'Выбранный день';

  @override
  String get lessonsOnThisDay => 'Уроки в этот день';

  @override
  String get noLessonsOnThisDay => 'В этот день уроков нет.';

  @override
  String get statusScheduled => 'Запланирован';

  @override
  String get statusVisited => 'Посещён';

  @override
  String get statusMissed => 'Пропущен';

  @override
  String get chipRecurring => 'РЕГУЛЯРНЫЙ';

  @override
  String get chipAlarm => 'БУДИЛЬНИК';

  @override
  String chipAlarmLead(String lead) {
    return 'БУДИЛЬНИК −$lead';
  }

  @override
  String leadDays(int days) {
    return '$daysД';
  }

  @override
  String leadHours(int hours) {
    return '$hoursЧ';
  }

  @override
  String leadMinutes(int minutes) {
    return '$minutesМ';
  }

  @override
  String lessonStamp(String number) {
    return 'У$number';
  }

  @override
  String get lessonReminderEyebrow => 'НАПОМИНАНИЕ ОБ УРОКЕ';

  @override
  String get startingNow => 'Начинается сейчас';

  @override
  String startsInMinutes(int minutes) {
    return 'Начнётся через $minutes мин';
  }

  @override
  String startsInHoursMinutes(int hours, int minutes) {
    return 'Начнётся через $hours ч $minutes мин';
  }

  @override
  String startsInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Начнётся через $days дня',
      many: 'Начнётся через $days дней',
      few: 'Начнётся через $days дня',
      one: 'Начнётся через $days день',
    );
    return '$_temp0';
  }

  @override
  String get dismiss => 'Отключить';

  @override
  String notificationBody(String time) {
    return 'Урок в $time';
  }

  @override
  String get notificationChannelName => 'Будильники уроков';

  @override
  String get notificationChannelDescription =>
      'Полноэкранные будильники для напоминаний об уроках';
}
