import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/workout/workout_page/data/models/workout_model/workout_model.dart';

class WorkoutController extends Notifier<List<WorkoutModel>> {
  @override
  List<WorkoutModel> build() {
    return [
      WorkoutModel(
        id: '1',
        titleI18n: {'it': 'PETTO & TRICIPITI POWER', 'en': 'CHEST & TRICEPS POWER'},
        coachName: 'Luca Bianchi',
        progress: 80.0,
        exercises: 12,
        durationMinutes: 45,
        goal: 'Ipertrofia',
        lastUsed: DateTime.now().subtract(const Duration(days: 2)),
        active: true,
      ),
      WorkoutModel(
        id: '2',
        titleI18n: {'it': 'LEG DAY VOLUME', 'en': 'LEG DAY VOLUME'},
        coachName: 'Marco Rossi',
        progress: 40.0,
        exercises: 10,
        durationMinutes: 50,
        goal: 'Volume',
        lastUsed: DateTime.now().subtract(const Duration(days: 1)),
        active: true,
      ),
      WorkoutModel(
        id: '3',
        titleI18n: {'it': 'DORSO E BICIPITI', 'en': 'BACK AND BICEPS'},
        coachName: 'Sara Verdi',
        progress: 65.0,
        exercises: 14,
        durationMinutes: 55,
        goal: 'Forza',
        lastUsed: DateTime.now().subtract(const Duration(days: 3)),
        active: true,
      ),
      WorkoutModel(
        id: '4',
        titleI18n: {'it': 'SPALLE E ADDOME', 'en': 'SHOULDERS AND ABS'},
        coachName: 'Andrea Neri',
        progress: 30.0,
        exercises: 8,
        durationMinutes: 35,
        goal: 'Definizione',
        lastUsed: DateTime.now().subtract(const Duration(days: 7)),
        active: true,
      ),
      WorkoutModel(
        id: '5',
        titleI18n: {'it': 'FULL BODY STRENGTH', 'en': 'FULL BODY STRENGTH'},
        coachName: 'Luca Bianchi',
        progress: 90.0,
        exercises: 15,
        durationMinutes: 60,
        goal: 'Forza',
        lastUsed: DateTime.now(),
        active: true,
      ),
      WorkoutModel(
        id: '6',
        titleI18n: {'it': 'HIIT CARDIO', 'en': 'HIIT CARDIO'},
        coachName: 'Elena Gialli',
        progress: 55.0,
        exercises: 6,
        durationMinutes: 25,
        goal: 'Resistenza',
        lastUsed: DateTime.now().subtract(const Duration(days: 4)),
        active: true,
      ),
      WorkoutModel(
        id: '7',
        titleI18n: {'it': 'UPPER BODY HYPERTROPHY', 'en': 'UPPER BODY HYPERTROPHY'},
        coachName: 'Marco Rossi',
        progress: 20.0,
        exercises: 11,
        durationMinutes: 48,
        goal: 'Ipertrofia',
        lastUsed: DateTime.now().subtract(const Duration(days: 14)),
        active: true,
      ),
      WorkoutModel(
        id: '8',
        titleI18n: {'it': 'CORE & STABILITÀ', 'en': 'CORE & STABILITY'},
        coachName: 'Sara Verdi',
        progress: 75.0,
        exercises: 9,
        durationMinutes: 30,
        goal: 'Funzionale',
        lastUsed: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  void addWorkout(WorkoutModel workout) {
    state = [...state, workout];
  }
}
