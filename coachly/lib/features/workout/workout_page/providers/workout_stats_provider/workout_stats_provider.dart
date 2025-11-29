import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../workout_list_provider/workout_list_provider.dart';

part 'workout_stats_provider.g.dart';

// State Class
class WorkoutStatsState {
  final WorkoutStatsModel? stats;
  final bool isLoading;
  final String? errorMessage;

  const WorkoutStatsState({
    this.stats,
    this.isLoading = false,
    this.errorMessage,
  });

  WorkoutStatsState copyWith({
    WorkoutStatsModel? stats,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WorkoutStatsState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasError => errorMessage != null;
}

// Notifier with Code Generation
@riverpod
class WorkoutStatsNotifier extends _$WorkoutStatsNotifier {
  @override
  WorkoutStatsState build() {
    // Restituisci solo lo stato iniziale, senza chiamare loadStats()
    return const WorkoutStatsState();
  }

  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(workoutPageRepositoryProvider);
      final response = await repository.getWorkoutStats();

      if (response.success && response.data != null) {
        state = state.copyWith(stats: response.data, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message ?? 'Errore caricamento stats',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refresh() => loadStats();
}
