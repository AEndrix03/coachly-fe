import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/features/workout/workout_detail_page/data/repositories/workout_detail_page_repository.dart';
import 'package:coachly/features/workout/workout_detail_page/data/repositories/workout_detail_page_repository_impl.dart';
import 'package:coachly/features/workout/workout_detail_page/data/services/workout_detail_page_service.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_detail_provider.g.dart';

// Service Provider
@riverpod
WorkoutDetailPageService workoutDetailPageService(ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkoutDetailPageService(apiClient);
}

// Repository Provider
@riverpod
IWorkoutDetailPageRepository workoutDetailPageRepository(ref) {
  final service = ref.watch(workoutDetailPageServiceProvider);
  return WorkoutDetailPageRepositoryImpl(service);
}

// State Class
class WorkoutDetailPageState {
  final WorkoutModel? workout;
  final bool isLoading;
  final String? error;

  const WorkoutDetailPageState({
    this.workout,
    this.isLoading = false,
    this.error,
  });

  WorkoutDetailPageState copyWith({
    WorkoutModel? workout,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return WorkoutDetailPageState(
      workout: workout ?? this.workout,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  bool get hasError => error != null;

  bool get hasData => workout != null;

  bool get isEmpty => workout == null && !isLoading && !hasError;
}

// Notifier with Code Generation
@riverpod
class WorkoutDetailPageNotifier extends _$WorkoutDetailPageNotifier {
  late final IWorkoutDetailPageRepository _repository;

  @override
  WorkoutDetailPageState build() {
    _repository = ref.watch(workoutDetailPageRepositoryProvider);
    return const WorkoutDetailPageState();
  }

  Future<void> loadWorkoutDetail(String workoutId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _repository.getWorkout(workoutId);

      if (response.success && response.data != null) {
        state = state.copyWith(workout: response.data!, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Errore caricamento dettagli allenamento',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh(String workoutId) => loadWorkoutDetail(workoutId);
}
