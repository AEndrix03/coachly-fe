import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/workout_page_repository.dart';
import '../../data/repositories/workout_page_repository_impl.dart';
import '../../data/services/workout_page_service.dart';

part 'workout_list_provider.g.dart';

// Service Provider
@riverpod
WorkoutPageService workoutPageService(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkoutPageService(apiClient);
}

// Repository Provider
@riverpod
IWorkoutPageRepository workoutPageRepository(Ref ref) {
  final service = ref.watch(workoutPageServiceProvider);
  return WorkoutPageRepositoryImpl(service, useMockData: true);
}

// State Class
class WorkoutListState {
  final List<WorkoutModel> workouts;
  final List<WorkoutModel> recentWorkouts;
  final bool isLoading;
  final String? errorMessage;

  const WorkoutListState({
    this.workouts = const [],
    this.recentWorkouts = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  WorkoutListState copyWith({
    List<WorkoutModel>? workouts,
    List<WorkoutModel>? recentWorkouts,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WorkoutListState(
      workouts: workouts ?? this.workouts,
      recentWorkouts: recentWorkouts ?? this.recentWorkouts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasError => errorMessage != null;

  bool get isEmpty => workouts.isEmpty && !isLoading;
}

// Notifier with Code Generation
@riverpod
class WorkoutListNotifier extends _$WorkoutListNotifier {
  @override
  WorkoutListState build() {
    return const WorkoutListState();
  }

  Future<void> loadWorkouts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(workoutPageRepositoryProvider);
      final workoutsResponse = await repository.getWorkouts();
      final recentResponse = await repository.getRecentWorkouts();

      if (workoutsResponse.success && recentResponse.success) {
        state = state.copyWith(
          workouts: workoutsResponse.data ?? [],
          recentWorkouts: recentResponse.data ?? [],
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: workoutsResponse.message ?? 'Errore caricamento',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refresh() => loadWorkouts();

  Future<void> deleteWorkout(String workoutId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repository = ref.read(workoutPageRepositoryProvider);
      final response = await repository.deleteWorkout(workoutId);
      if (response.success) {
        state = state.copyWith(
          workouts: state.workouts.where((w) => w.id != workoutId).toList(),
          recentWorkouts: state.recentWorkouts
              .where((w) => w.id != workoutId)
              .toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateWorkoutActiveStatus(
    String workoutId,
    bool isActive,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repository = ref.read(workoutPageRepositoryProvider);
      final response = isActive
          ? await repository.enableWorkout(workoutId)
          : await repository.disableWorkout(workoutId);

      if (response.success) {
        state = state.copyWith(
          workouts: state.workouts.map((w) {
            return w.id == workoutId ? w.copyWith(active: isActive) : w;
          }).toList(),
          recentWorkouts: state.recentWorkouts.map((w) {
            return w.id == workoutId ? w.copyWith(active: isActive) : w;
          }).toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message,
        );
        // Revert the local UI state if API call fails (optional, but good UX)
        // You might want to pass a callback to the UI to handle this.
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateWorkout(WorkoutModel updatedWorkout) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repository = ref.read(workoutPageRepositoryProvider);
      final response = await repository.updateWorkout(updatedWorkout);

      if (response.success) {
        state = state.copyWith(
          workouts: state.workouts.map((w) {
            return w.id == updatedWorkout.id ? updatedWorkout : w;
          }).toList(),
          recentWorkouts: state.recentWorkouts.map((w) {
            return w.id == updatedWorkout.id ? updatedWorkout : w;
          }).toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
