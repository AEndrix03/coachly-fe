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
      final cachedExercise = await _hiveService.getExercise(exerciseId);
      final remoteResponse = await _service.fetchExerciseDetails(exerciseId);

      if (remoteResponse.success && remoteResponse.data != null) {
        await _hiveService.saveExerciseDetail(remoteResponse.data!);
        return ApiResponse.success(data: remoteResponse.data!);
      }

      // The catalogue cache contains summaries, while this entry can be a full
      // detail previously fetched from the API. It is used only as an offline
      // fallback; online access must always use the detail endpoint.
      if (cachedExercise != null) {
        return ApiResponse.success(data: cachedExercise);
      }

      return ApiResponse.error(
        message: remoteResponse.message ?? 'Failed to load exercise detail',
        statusCode: remoteResponse.statusCode,
        errors: remoteResponse.errors,
      );
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
  Future<ApiResponse<List<ExerciseModel>>> getMyExercises() async {
    try {
      final response = await _service.fetchMyExercises();
      return response;
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to load personal exercises: $e',
      );
    }
  }

  @override
  Future<ApiResponse<ExerciseDetailModel>> createPersonalExercise({
    required Map<String, String> nameI18n,
    Map<String, String>? descriptionI18n,
    Map<String, String>? tipsI18n,
    String? difficultyLevel,
    String? mechanicsType,
    String? forceType,
    bool? isUnilateral,
    bool? isBodyweight,
  }) async {
    final response = await _service.createPersonalExercise({
      'nameI18n': nameI18n,
      'descriptionI18n': descriptionI18n,
      'tipsI18n': tipsI18n,
      'difficultyLevel': difficultyLevel,
      'mechanicsType': mechanicsType,
      'forceType': forceType,
      'isUnilateral': isUnilateral,
      'isBodyweight': isBodyweight,
    });
    if (response.success) {
      await refreshFromRemote();
    }
    return response;
  }

  @override
  Future<ApiResponse<ExerciseDetailModel>> updatePersonalExercise(
    String exerciseId, {
    required Map<String, String> nameI18n,
    Map<String, String>? descriptionI18n,
    Map<String, String>? tipsI18n,
    String? difficultyLevel,
    String? mechanicsType,
    String? forceType,
    bool? isUnilateral,
    bool? isBodyweight,
  }) async {
    final response = await _service.updatePersonalExercise(exerciseId, {
      'nameI18n': nameI18n,
      'descriptionI18n': descriptionI18n,
      'tipsI18n': tipsI18n,
      'difficultyLevel': difficultyLevel,
      'mechanicsType': mechanicsType,
      'forceType': forceType,
      'isUnilateral': isUnilateral,
      'isBodyweight': isBodyweight,
    });
    if (response.success) {
      await refreshFromRemote();
    }
    return response;
  }

  @override
  Future<ApiResponse<void>> deletePersonalExercise(String exerciseId) async {
    final response = await _service.deletePersonalExercise(exerciseId);
    if (response.success) {
      await refreshFromRemote();
    }
    return response;
  }

  @override
  Future<ApiResponse<List<ExerciseDetailModel>>> refreshFromRemote() async {
    final response = await _service.fetchFilteredExercises(
      const ExerciseFilterModel(scope: 'community'),
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
