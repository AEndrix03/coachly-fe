import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/workout_model.dart';

class WorkoutController extends Notifier<List<Workout>> {
  @override
  List<Workout> build() {
    // Mock iniziale (potrebbe arrivare da un'API in futuro)
    return [
      const Workout(
        title: 'PETTO & TRICIPITI FORTISSIMI FORTISSIMI FORTISSIMI',
        coach: 'Luca Bianchi',
        progress: 80,
        exercises: 12,
        durationMinutes: 45,
        goal: 'Ipertrofia',
        lastUsed: '2 giorni fa',
      ),
      const Workout(
        title: 'GAMBE',
        coach: 'Marco Rossi',
        progress: 40,
        exercises: 10,
        durationMinutes: 50,
        goal: 'Volume',
        lastUsed: 'Ieri',
      ),
      const Workout(
        title: 'GAMBE',
        coach: 'Marco Rossi',
        progress: 40,
        exercises: 10,
        durationMinutes: 50,
        goal: 'Volume',
        lastUsed: 'Ieri',
      ),
      const Workout(
        title: 'GAMBE',
        coach: 'Marco Rossi',
        progress: 40,
        exercises: 10,
        durationMinutes: 50,
        goal: 'Volume',
        lastUsed: 'Ieri',
      ),
      const Workout(
        title: 'GAMBE',
        coach: 'Marco Rossi',
        progress: 40,
        exercises: 10,
        durationMinutes: 50,
        goal: 'Volume',
        lastUsed: 'Ieri',
      ),
      const Workout(
        title: 'GAMBE',
        coach: 'Marco Rossi',
        progress: 40,
        exercises: 10,
        durationMinutes: 50,
        goal: 'Volume',
        lastUsed: 'Ieri',
      ),
      const Workout(
        title: 'GAMBE',
        coach: 'Marco Rossi',
        progress: 40,
        exercises: 10,
        durationMinutes: 50,
        goal: 'Volume',
        lastUsed: 'Ieri',
      ),
    ];
  }

  void addWorkout(Workout workout) {
    state = [...state, workout];
  }
}
