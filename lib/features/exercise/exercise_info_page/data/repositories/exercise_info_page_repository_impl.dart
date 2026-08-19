import 'package:coachly/core/config/app_cache_policy.dart';
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
      final cachedExercise = AppCachePolicy.isEnabled
          ? await _hiveService.getExercise(exerciseId)
          : null;
      if (cachedExercise != null) {
        return ApiResponse.success(data: cachedExercise);
      }
      final remoteResponse = await _service.fetchExerciseDetails(exerciseId);

      if (remoteResponse.success && remoteResponse.data != null) {
        if (AppCachePolicy.isEnabled) {
          await _hiveService.saveExerciseDetail(remoteResponse.data!);
        }
        return ApiResponse.success(data: remoteResponse.data!);
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
      if (!AppCachePolicy.isEnabled) {
        return _service.fetchAllExercises();
      }

      await _ensureLocalCache();
      final exercises = await _hiveService.getExerciseSummaries();
      return ApiResponse.success(data: exercises);
    } catch (e) {
      return ApiResponse.error(message: 'Failed to load exercises: $e');
    }
  }

  @override
  Future<ApiResponse<List<ExerciseModel>>> getExerciseSummaries() async {
    try {
      if (!AppCachePolicy.isEnabled) {
        // Debug/network-only mode deliberately does not write Hive, but the
        // provider still fetches this unfiltered catalogue only once.
        return _service.fetchAllExercises();
      }
      await _ensureLocalCache();
      return ApiResponse.success(
        data: await _hiveService.getExerciseSummaries(),
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to load exercise summaries: $e',
      );
    }
  }

  @override
  Future<ApiResponse<List<ExerciseDetailModel>>> getFilteredExercises(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  }) async {
    try {
      if (!AppCachePolicy.isEnabled) {
        final response = await _service.fetchFilteredExercises(filter);
        if (!response.success || response.data == null) {
          return response;
        }
        return ApiResponse.success(
          data: response.data!
              .where((exercise) => !excludedExerciseIds.contains(exercise.id))
              .toList(),
        );
      }

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
  Future<ApiResponse<List<ExerciseModel>>> getFilteredExerciseSummaries(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  }) async {
    try {
      if (!AppCachePolicy.isEnabled) {
        final response = await _service.fetchFilteredExercises(filter);
        if (!response.success || response.data == null) {
          return ApiResponse.error(
            message: response.message ?? 'Failed to load exercise summaries',
            statusCode: response.statusCode,
            errors: response.errors,
          );
        }
        return ApiResponse.success(
          data: response.data!
              .where((exercise) => !excludedExerciseIds.contains(exercise.id))
              .map(
                (exercise) => ExerciseModel(
                  id: exercise.id,
                  createdBy: exercise.createdBy,
                  isPersonal: exercise.isPersonal,
                  nameI18n: exercise.nameI18n,
                  difficultyLevel: exercise.difficultyLevel,
                  mechanicsType: exercise.mechanicsType,
                  forceType: exercise.forceType,
                  isUnilateral: exercise.isUnilateral,
                  isBodyweight: exercise.isBodyweight,
                ),
              )
              .toList(),
        );
      }
      await _ensureLocalCache();
      return ApiResponse.success(
        data: await _hiveService.getFilteredExerciseSummaries(
          filter,
          excludedExerciseIds: excludedExerciseIds,
        ),
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to load exercise summaries: $e',
      );
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
    final response = await _service.fetchAllExercises();
    if (!response.success || response.data == null) {
      return ApiResponse.error(
        message: response.message ?? 'Failed to refresh exercises from remote',
        statusCode: response.statusCode,
        errors: response.errors,
      );
    }
    if (!AppCachePolicy.isEnabled) {
      return ApiResponse.success(data: const []);
    }

    await _hiveService.saveExerciseSummaries(response.data!);
    // Details are deliberately fetched lazily, one exercise at a time.
    return ApiResponse.success(data: const []);
  }

  Future<void> _ensureLocalCache() async {
    if (!AppCachePolicy.isEnabled) {
      return;
    }

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
