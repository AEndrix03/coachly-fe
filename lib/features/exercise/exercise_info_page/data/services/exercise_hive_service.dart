import 'package:coachly/core/sync/local_database_service.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_filter_model/exercise_filter_model.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_model/exercise_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseHiveServiceProvider = Provider<ExerciseHiveService>((ref) {
  return ExerciseHiveService(LocalDatabaseService());
});

class ExerciseHiveService {
  final LocalDatabaseService _localDbService;

  const ExerciseHiveService(this._localDbService);

  Future<List<ExerciseDetailModel>> getExercises() async {
    final box = _localDbService.exercises;
    return box.values
        .map((raw) => ExerciseDetailModel.fromJson(Map<String, dynamic>.from(raw)))
        .toList();
  }

  Future<ExerciseDetailModel?> getExercise(String exerciseId) async {
    final raw = _localDbService.exercises.get(exerciseId);
    if (raw == null) {
      return null;
    }

    return ExerciseDetailModel.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<void> saveExercises(List<ExerciseDetailModel> exercises) async {
    final box = _localDbService.exercises;
    await box.clear();

    for (final exercise in exercises) {
      final id = exercise.id;
      if (id == null || id.isEmpty) {
        continue;
      }
      await box.put(id, exercise.toJson());
    }
  }

  Future<bool> isEmpty() async {
    return _localDbService.exercises.isEmpty;
  }

  Future<List<ExerciseDetailModel>> getFilteredExercises(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  }) async {
    final exercises = await getExercises();

    return exercises.where((exercise) {
      final id = exercise.id;
      if (id == null || id.isEmpty) {
        return false;
      }

      if (excludedExerciseIds.contains(id)) {
        return false;
      }

      if (!_matchesTextFilter(exercise, filter.textFilter)) {
        return false;
      }

      if (!_matchesStringFilter(exercise.difficultyLevel, filter.difficultyLevel)) {
        return false;
      }

      if (!_matchesStringFilter(exercise.mechanicsType, filter.mechanicsType)) {
        return false;
      }

      if (!_matchesStringFilter(exercise.forceType, filter.forceType)) {
        return false;
      }

      if (!_matchesBoolFilter(exercise.isUnilateral, filter.isUnilateral)) {
        return false;
      }

      if (!_matchesBoolFilter(exercise.isBodyweight, filter.isBodyweight)) {
        return false;
      }

      if (!_matchesIds(
        exercise.categories?.map((category) => category.id).whereType<String>(),
        filter.categoryIds,
      )) {
        return false;
      }

      if (!_matchesIds(
        exercise.muscles
            ?.map((exerciseMuscle) => exerciseMuscle.muscle?.id)
            .whereType<String>(),
        filter.muscleIds,
      )) {
        return false;
      }

      return true;
    }).toList();
  }

  Future<List<ExerciseModel>> getExerciseSummaries() async {
    final exercises = await getExercises();
    return exercises
        .map(
          (exercise) => ExerciseModel(
            id: exercise.id,
            nameI18n: exercise.nameI18n,
            descriptionI18n: exercise.descriptionI18n,
            tipsI18n: exercise.tipsI18n,
            difficultyLevel: exercise.difficultyLevel,
            mechanicsType: exercise.mechanicsType,
            forceType: exercise.forceType,
            isUnilateral: exercise.isUnilateral,
            isBodyweight: exercise.isBodyweight,
          ),
        )
        .toList();
  }

  bool _matchesTextFilter(ExerciseDetailModel exercise, String? textFilter) {
    final normalizedFilter = textFilter?.trim().toLowerCase();
    if (normalizedFilter == null || normalizedFilter.isEmpty) {
      return true;
    }

    final localizedNames = exercise.nameI18n?.values ?? const <String>[];
    return localizedNames.any(
      (name) => name.toLowerCase().contains(normalizedFilter),
    );
  }

  bool _matchesStringFilter(String? value, String? expected) {
    if (expected == null || expected.isEmpty) {
      return true;
    }

    return value == expected;
  }

  bool _matchesBoolFilter(bool? value, bool? expected) {
    if (expected == null) {
      return true;
    }

    return value == expected;
  }

  bool _matchesIds(Iterable<String>? values, List<String>? filterIds) {
    if (filterIds == null || filterIds.isEmpty) {
      return true;
    }

    final currentValues = values?.toSet() ?? const <String>{};
    return filterIds.any(currentValues.contains);
  }
}
