/// Lifecycle of a single scheduled lesson.
enum LessonStatus {
  /// On the calendar, hasn't happened yet.
  scheduled,

  /// Attended — counts toward the current round's progress.
  completed,

  /// Did not happen. Doesn't count toward progress until it is either
  /// rescheduled to a new date, or merged into another already-scheduled
  /// lesson.
  missed,
}
