import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository_impl.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_info_page_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exercise_info_provider.g.dart';

// Service Provider
@riverpod
ExerciseInfoPageService exerciseInfoPageService(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ExerciseInfoPageService(apiClient);
}

// Repository Provider
@riverpod
IExerciseInfoPageRepository exerciseInfoPageRepository(Ref ref) {
  final service = ref.watch(exerciseInfoPageServiceProvider);
  return ExerciseInfoPageRepositoryImpl(service);
}

// State Class
class ExerciseInfoState {
  final List<ExerciseModel> exercises;
  final ExerciseDetailModel? selectedExercise;
  final bool isLoading;
  final bool isLoadingDetail;
  final String? errorMessage;

  const ExerciseInfoState({
    this.exercises = const [],
    this.selectedExercise,
    this.isLoading = false,
    this.isLoadingDetail = false,
    this.errorMessage,
  });

  ExerciseInfoState copyWith({
    List<ExerciseModel>? exercises,
    ExerciseDetailModel? selectedExercise,
    bool clearSelectedExercise = false,
    bool? isLoading,
    bool? isLoadingDetail,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ExerciseInfoState(
      exercises: exercises ?? this.exercises,
      selectedExercise: clearSelectedExercise
          ? null
          : selectedExercise ?? this.selectedExercise,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  // Helper getters
  bool get hasError => errorMessage != null;

  bool get isEmpty => exercises.isEmpty && !isLoading;

  bool get hasData => exercises.isNotEmpty;

  bool get hasSelectedExercise => selectedExercise != null;
}

// Notifier
@riverpod
class ExerciseInfoNotifier extends _$ExerciseInfoNotifier {
  @override
  ExerciseInfoState build() {
    return const ExerciseInfoState();
  }

  Future<void> loadAllExercises() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final repository = ref.read(exerciseInfoPageRepositoryProvider);
      final response = await repository.getAllExercises();

      if (response.success && response.data != null) {
        state = state.copyWith(exercises: response.data!, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message ?? 'Error loading exercises',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadExerciseDetail(String exerciseId) async {
    state = state.copyWith(isLoadingDetail: true, clearErrorMessage: true);

    try {
      final repository = ref.read(exerciseInfoPageRepositoryProvider);
      final response = await repository.getExerciseDetail(exerciseId);

      if (response.success && response.data != null) {
        state = state.copyWith(
          selectedExercise: response.data!,
          isLoadingDetail: false,
        );
      } else {
        state = state.copyWith(
          isLoadingDetail: false,
          errorMessage: response.message ?? 'Error loading exercise detail',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingDetail: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() => loadAllExercises();

  void clearSelectedExercise() {
    state = state.copyWith(clearSelectedExercise: true);
  }
}
