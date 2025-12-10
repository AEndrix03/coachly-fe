import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/features/workout/workout_detail_page/data/models/exercise_info_model/exercise_info_model.dart';
import 'package:coachly/features/workout/workout_detail_page/data/repositories/workout_detail_page_repository.dart';
import 'package:coachly/features/workout/workout_detail_page/data/repositories/workout_detail_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_detail_page/data/services/workout_detail_page_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/workout_detail_model/workout_detail_model.dart';

part 'workout_detail_provider.g.dart';

// Service Provider
@riverpod
WorkoutDetailPageService workoutDetailPageService(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkoutDetailPageService(apiClient);
}

// Repository Provider
@riverpod
IWorkoutDetailPageRepository workoutDetailPageRepository(Ref ref) {
  final service = ref.watch(workoutDetailPageServiceProvider);
  return WorkoutDetailPageRepositoryImpl(service, useMockData: true);
}

// State Class
class WorkoutDetailPageState {
  final WorkoutDetailModel? workout;
  final List<ExerciseInfoModel> exercises;
  final bool isLoading;
  final String? error;

  const WorkoutDetailPageState({
    this.workout,
    this.exercises = const [],
    this.isLoading = false,
    this.error,
  });

  WorkoutDetailPageState copyWith({
    WorkoutDetailModel? workout,
    List<ExerciseInfoModel>? exercises,
    bool? isLoading,
    String? error,
  }) {
    return WorkoutDetailPageState(
      workout: workout ?? this.workout,
      exercises: exercises ?? this.exercises,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get hasError => error != null;

  bool get hasData => workout != null;

  bool get isEmpty => workout == null && !isLoading;
}

// Notifier with Code Generation
@riverpod
class WorkoutDetailPageNotifier extends _$WorkoutDetailPageNotifier {
  @override
  WorkoutDetailPageState build() {
    return const WorkoutDetailPageState();
  }

  Future<void> loadWorkoutDetail(String workoutId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(workoutDetailPageRepositoryProvider);
      final workoutResponse = await repository.getWorkoutDetail(workoutId);
      final exercisesResponse = await repository.getWorkoutExercises(workoutId);

      if (workoutResponse.success &&
          workoutResponse.data != null &&
          exercisesResponse.success &&
          exercisesResponse.data != null) {
        state = state.copyWith(
          workout: workoutResponse.data!,
          exercises: exercisesResponse.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error:
              workoutResponse.message ??
              exercisesResponse.message ??
              'Errore caricamento dettagli allenamento',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh(String workoutId) => loadWorkoutDetail(workoutId);
}
