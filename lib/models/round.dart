/// A "round" is one paid batch of lessons (e.g. "8 lessons for $X").
///
/// [lessonsRequired] starts as a snapshot of the configured threshold at the
/// time the round started (so changing the global setting later never
/// rewrites other rounds' history), but can be edited per round — e.g. if
/// the tailor's pricing changes mid-cycle.
class Round {
  const Round({
    required this.id,
    required this.number,
    required this.lessonsRequired,
    required this.startDate,
    this.paid = false,
    this.completedAt,
  });

  final String id;
  final int number;
  final int lessonsRequired;
  final DateTime startDate;
  final bool paid;
  final DateTime? completedAt;

  Round copyWith({bool? paid, DateTime? completedAt, int? lessonsRequired}) => Round(
        id: id,
        number: number,
        lessonsRequired: lessonsRequired ?? this.lessonsRequired,
        startDate: startDate,
        paid: paid ?? this.paid,
        completedAt: completedAt ?? this.completedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'lessonsRequired': lessonsRequired,
        'startDate': startDate.toIso8601String(),
        'paid': paid,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory Round.fromJson(Map<String, dynamic> json) => Round(
        id: json['id'] as String,
        number: json['number'] as int,
        lessonsRequired: json['lessonsRequired'] as int,
        startDate: DateTime.parse(json['startDate'] as String),
        paid: json['paid'] as bool? ?? false,
        completedAt:
            json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      );
}
