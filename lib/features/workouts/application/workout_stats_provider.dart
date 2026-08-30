import 'package:coachly/features/workouts/domain/models/workout_stats_model.dart';
import 'package:coachly/features/workouts/data/repositories/workout_page_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_stats_provider.g.dart';

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

@riverpod
class WorkoutStatsNotifier extends _$WorkoutStatsNotifier {
  @override
  WorkoutStatsState build() {
    Future.microtask(loadStats);
    return const WorkoutStatsState(isLoading: true);
  }

  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(workoutPageRepositoryProvider);
      final response = await repository.getWorkoutStats();

      if (response.isOk && response.valueOrNull != null) {
        state = state.copyWith(stats: response.valueOrNull, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              response.failureOrNull?.message ?? 'Error loading stats',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refresh() => loadStats();
}
