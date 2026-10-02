/// An alarm attached to a [Lesson]: rings [minutesBefore] the lesson starts
/// and shows [title] full-screen.
class LessonReminder {
  const LessonReminder({required this.title, this.minutesBefore = 0});

  final String title;
  final int minutesBefore;

  DateTime fireTimeFor(DateTime lessonDate) =>
      lessonDate.subtract(Duration(minutes: minutesBefore));

  Map<String, dynamic> toJson() => {'title': title, 'minutesBefore': minutesBefore};

  factory LessonReminder.fromJson(Map<String, dynamic> json) => LessonReminder(
        title: json['title'] as String,
        minutesBefore: json['minutesBefore'] as int? ?? 0,
      );
}
