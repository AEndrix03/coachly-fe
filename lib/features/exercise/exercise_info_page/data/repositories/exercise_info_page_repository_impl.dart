import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/repositories/exercise_info_page_repository.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_hive_service.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_info_page_service.dart';

class ExerciseInfoPageRepositoryImpl implements IExerciseInfoPageRepository {
  final ExerciseInfoPageService _service;
  final ExerciseHiveService _hiveService;

  const ExerciseInfoPageRepositoryImpl(this._service, this._hiveService);

  @override
  Future<ApiResponse<ExerciseDetailModel>> getExerciseDetail(
    String exerciseId,
  ) async {
    try {
      await _ensureLocalCache();
      var exercise = await _hiveService.getExercise(exerciseId);

      if (exercise == null) {
        final syncResponse = await refreshFromRemote();
        if (!syncResponse.success) {
          return ApiResponse.error(
            message: syncResponse.message ?? 'Failed to sync exercise cache',
            statusCode: syncResponse.statusCode,
            errors: syncResponse.errors,
          );
        }
        exercise = await _hiveService.getExercise(exerciseId);
      }

      if (exercise == null) {
        return ApiResponse.error(message: 'Exercise not found in local cache');
      }

      return ApiResponse.success(data: exercise);
    } catch (e) {
      return ApiResponse.error(message: 'Failed to load exercise: $e');
    }
  }

  @override
  Future<ApiResponse<List<ExerciseModel>>> getAllExercises() async {
    try {
      await _ensureLocalCache();
      final exercises = await _hiveService.getExerciseSummaries();
      return ApiResponse.success(data: exercises);
    } catch (e) {
      return ApiResponse.error(message: 'Failed to load exercises: $e');
    }
  }

  @override
  Future<ApiResponse<List<ExerciseDetailModel>>> getFilteredExercises(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  }) async {
    try {
      await _ensureLocalCache();
      final exercises = await _hiveService.getFilteredExercises(
        filter,
        excludedExerciseIds: excludedExerciseIds,
      );
      return ApiResponse.success(data: exercises);
    } catch (e) {
      return ApiResponse.error(message: 'Failed to filter exercises: $e');
    }
  }

  @override
  Future<ApiResponse<List<ExerciseDetailModel>>> refreshFromRemote() async {
    final response = await _service.fetchFilteredExercises(
      const ExerciseFilterModel(),
    );

    if (!response.success || response.data == null) {
      return ApiResponse.error(
        message: response.message ?? 'Failed to refresh exercises from remote',
        statusCode: response.statusCode,
        errors: response.errors,
      );
    }

    await _hiveService.saveExercises(response.data!);
    final localExercises = await _hiveService.getExercises();
    return ApiResponse.success(data: localExercises);
  }

  Future<void> _ensureLocalCache() async {
    final isEmpty = await _hiveService.isEmpty();
    if (!isEmpty) {
      return;
    }

    final response = await refreshFromRemote();
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to populate exercise cache');
    }
  }
}
