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
}
