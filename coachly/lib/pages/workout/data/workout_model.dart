class Workout {
  final String title;
  final String coach;
  final int progress; // percentuale
  final int exercises;
  final int durationMinutes;
  final String goal;
  final String lastUsed;

  const Workout({
    required this.title,
    required this.coach,
    required this.progress,
    required this.exercises,
    required this.durationMinutes,
    required this.goal,
    required this.lastUsed,
  });
}
