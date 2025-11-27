import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/workout/workout_page/data/models/workout_model.dart';

class WorkoutController extends Notifier<List<Workout>> {
  @override
  List<Workout> build() {
    return [
      const Workout(
        id: '1',
        title: 'PETTO & TRICIPITI POWER',
        coach: 'Luca Bianchi',
        progress: 80,
        exercises: 12,
        durationMinutes: 45,
        goal: 'Ipertrofia',
        lastUsed: '2 giorni fa',
      ),
      const Workout(
        id: '2',
        title: 'LEG DAY VOLUME',
        coach: 'Marco Rossi',
        progress: 40,
        exercises: 10,
        durationMinutes: 50,
        goal: 'Volume',
        lastUsed: 'Ieri',
      ),
      const Workout(
        id: '3',
        title: 'DORSO E BICIPITI',
        coach: 'Sara Verdi',
        progress: 65,
        exercises: 14,
        durationMinutes: 55,
        goal: 'Forza',
        lastUsed: '3 giorni fa',
      ),
      const Workout(
        id: '4',
        title: 'SPALLE E ADDOME',
        coach: 'Andrea Neri',
        progress: 30,
        exercises: 8,
        durationMinutes: 35,
        goal: 'Definizione',
        lastUsed: '1 settimana fa',
      ),
      const Workout(
        id: '5',
        title: 'FULL BODY STRENGTH',
        coach: 'Luca Bianchi',
        progress: 90,
        exercises: 15,
        durationMinutes: 60,
        goal: 'Forza',
        lastUsed: 'Oggi',
      ),
      const Workout(
        id: '6',
        title: 'HIIT CARDIO',
        coach: 'Elena Gialli',
        progress: 55,
        exercises: 6,
        durationMinutes: 25,
        goal: 'Resistenza',
        lastUsed: '4 giorni fa',
      ),
      const Workout(
        id: '7',
        title: 'UPPER BODY HYPERTROPHY',
        coach: 'Marco Rossi',
        progress: 20,
        exercises: 11,
        durationMinutes: 48,
        goal: 'Ipertrofia',
        lastUsed: '2 settimane fa',
      ),
      const Workout(
        id: '8',
        title: 'CORE & STABILITÀ',
        coach: 'Sara Verdi',
        progress: 75,
        exercises: 9,
        durationMinutes: 30,
        goal: 'Funzionale',
        lastUsed: '5 giorni fa',
      ),
    ];
  }

  void addWorkout(Workout workout) {
    state = [...state, workout];
  }
}
