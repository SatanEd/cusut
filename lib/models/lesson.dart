import 'lesson_reminder.dart';
import 'lesson_status.dart';

/// A single tailoring lesson: a date/time, which payment [Round] it belongs
/// to, and whether it was attended.
class Lesson {
  const Lesson({
    required this.id,
    required this.roundId,
    required this.date,
    this.status = LessonStatus.scheduled,
    this.note,
    this.scheduleId,
    this.reminder,
  });

  final String id;
  final String roundId;
  final DateTime date;
  final LessonStatus status;
  final String? note;

  /// The [RecurringSchedule] that generated this lesson, if any. Cleared
  /// whenever the lesson is manually moved (reschedule/merge), so it becomes
  /// a one-off exception the series no longer tracks or cleans up.
  final String? scheduleId;

  /// Optional full-screen alarm before the lesson. Moves with the lesson
  /// when it is rescheduled.
  final LessonReminder? reminder;

  Lesson copyWith({
    DateTime? date,
    LessonStatus? status,
    String? note,
    bool detachSchedule = false,
    LessonReminder? reminder,
    bool clearReminder = false,
  }) {
    return Lesson(
      id: id,
      roundId: roundId,
      date: date ?? this.date,
      status: status ?? this.status,
      note: note ?? this.note,
      scheduleId: detachSchedule ? null : scheduleId,
      reminder: clearReminder ? null : reminder ?? this.reminder,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'roundId': roundId,
        'date': date.toIso8601String(),
        'status': status.name,
        'note': note,
        'scheduleId': scheduleId,
        'reminder': reminder?.toJson(),
      };

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'] as String,
        roundId: json['roundId'] as String,
        date: DateTime.parse(json['date'] as String),
        status: LessonStatus.values.byName(json['status'] as String),
        note: json['note'] as String?,
        scheduleId: json['scheduleId'] as String?,
        reminder: json['reminder'] != null
            ? LessonReminder.fromJson(json['reminder'] as Map<String, dynamic>)
            : null,
      );
}
