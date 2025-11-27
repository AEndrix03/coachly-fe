class Workout {
  final String id;
  final String title;
  final String coach;
  final int progress;
  final int exercises;
  final int durationMinutes;
  final String goal;
  final String lastUsed;

  const Workout({
    required this.id,
    required this.title,
    required this.coach,
    required this.progress,
    required this.exercises,
    required this.durationMinutes,
    required this.goal,
    required this.lastUsed,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] ?? "",
      title: json['title'] ?? "",
      coach: json['coach'] ?? "",
      progress: json['progress'] ?? 0,
      exercises: json['exercises'] ?? 0,
      durationMinutes: json['durationMinutes'] ?? 0,
      goal: json['goal'] ?? "",
      lastUsed: json['lastUsed'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'coach': coach,
    'progress': progress,
    'exercises': exercises,
    'durationMinutes': durationMinutes,
    'goal': goal,
    'lastUsed': lastUsed,
  };

  Workout copyWith({
    String? id,
    String? title,
    String? coach,
    int? progress,
    int? exercises,
    int? durationMinutes,
    String? goal,
    String? lastUsed,
  }) {
    return Workout(
      id: id ?? this.id,
      title: title ?? this.title,
      coach: coach ?? this.coach,
      progress: progress ?? this.progress,
      exercises: exercises ?? this.exercises,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      goal: goal ?? this.goal,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    coach,
    progress,
    exercises,
    durationMinutes,
    goal,
    lastUsed,
  ];
}
