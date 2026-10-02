/// A repeating lesson pattern: one or more days of the week at a fixed
/// time, e.g. "every Tuesday and Thursday at 18:00". Used to auto-generate
/// individual [Lesson] entries ahead of time so you don't have to add each
/// occurrence by hand.
class RecurringSchedule {
  const RecurringSchedule({
    required this.id,
    required this.daysOfWeek,
    required this.hour,
    required this.minute,
    this.active = true,
  });

  final String id;

  /// [DateTime.monday]..[DateTime.sunday] (1..7).
  final Set<int> daysOfWeek;
  final int hour;
  final int minute;

  /// Inactive schedules stop generating new lessons; toggling back on
  /// resumes from today.
  final bool active;

  RecurringSchedule copyWith({
    Set<int>? daysOfWeek,
    int? hour,
    int? minute,
    bool? active,
  }) =>
      RecurringSchedule(
        id: id,
        daysOfWeek: daysOfWeek ?? this.daysOfWeek,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        active: active ?? this.active,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'daysOfWeek': (daysOfWeek.toList()..sort()),
        'hour': hour,
        'minute': minute,
        'active': active,
      };

  factory RecurringSchedule.fromJson(Map<String, dynamic> json) => RecurringSchedule(
        id: json['id'] as String,
        daysOfWeek: (json['daysOfWeek'] as List<dynamic>).map((e) => e as int).toSet(),
        hour: json['hour'] as int,
        minute: json['minute'] as int,
        active: json['active'] as bool? ?? true,
      );
}
