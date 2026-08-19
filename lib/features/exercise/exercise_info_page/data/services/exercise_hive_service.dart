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
        .map(
          (raw) => ExerciseDetailModel.fromJson(Map<String, dynamic>.from(raw)),
        )
        .toList();
  }

  Future<ExerciseDetailModel?> getExercise(String exerciseId) async {
    final raw = _localDbService.exercises.get(exerciseId);
    if (raw == null) {
      return null;
    }

    return ExerciseDetailModel.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<void> saveExerciseSummaries(List<ExerciseModel> exercises) async {
    final box = _localDbService.exerciseCatalog;
    await box.clear();

    for (final exercise in exercises) {
      final id = exercise.id;
      if (id == null || id.isEmpty) {
        continue;
      }
      await box.put(id, {
        'id': id,
        'personal': exercise.isPersonal,
        'nameI18n': exercise.nameI18n,
      });
    }
  }

  /// Stores a fully populated detail without replacing the cached catalogue.
  Future<void> saveExerciseDetail(ExerciseDetailModel exercise) async {
    final id = exercise.id;
    if (id == null || id.isEmpty) {
      return;
    }

    await _localDbService.exercises.put(id, exercise.toJson());
  }

  Future<bool> isEmpty() async {
    return _localDbService.exerciseCatalog.isEmpty;
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

      if (!_matchesScope(exercise, filter.scope)) {
        return false;
      }

      if (!_matchesStringFilter(
        exercise.difficultyLevel,
        filter.difficultyLevel,
      )) {
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
    return getFilteredExerciseSummaries(const ExerciseFilterModel());
  }

  /// Reads only fields needed by catalogue cards. Avoid deserializing every
  /// detail object: the cache can contain thousands of nested exercise records.
  Future<List<ExerciseModel>> getFilteredExerciseSummaries(
    ExerciseFilterModel filter, {
    Set<String> excludedExerciseIds = const {},
  }) async {
    final summaries = <ExerciseModel>[];
    for (final raw in _localDbService.exerciseCatalog.values) {
      final exercise = Map<String, dynamic>.from(raw);
      final id = exercise['id'] as String?;
      if (id == null || id.isEmpty || excludedExerciseIds.contains(id)) {
        continue;
      }
      if (!_matchesRawExercise(exercise, filter)) continue;
      summaries.add(
        ExerciseModel(
          id: id,
          createdBy: exercise['createdBy'] as String?,
          isPersonal: exercise['personal'] as bool? ?? false,
          nameI18n: _stringMap(exercise['nameI18n']),
          difficultyLevel: exercise['difficultyLevel'] as String?,
          mechanicsType: exercise['mechanicsType'] as String?,
          forceType: exercise['forceType'] as String?,
          isUnilateral: exercise['unilateral'] as bool?,
          isBodyweight: exercise['bodyweight'] as bool?,
        ),
      );
    }
    return summaries;
  }

  bool _matchesRawExercise(
    Map<String, dynamic> exercise,
    ExerciseFilterModel filter,
  ) {
    final names = _stringMap(exercise['nameI18n']);
    final text = filter.textFilter?.trim().toLowerCase();
    if (text != null &&
        text.isNotEmpty &&
        !(names?.values.any((name) => name.toLowerCase().contains(text)) ??
            false)) {
      return false;
    }
    final isPersonal = exercise['personal'] as bool? ?? false;
    if (filter.scope == 'default' && isPersonal) return false;
    if (filter.scope == 'mine' && !isPersonal) return false;
    if (!_matchesRawString(
          exercise['difficultyLevel'] as String?,
          filter.difficultyLevel,
        ) ||
        !_matchesRawString(
          exercise['mechanicsType'] as String?,
          filter.mechanicsType,
        ) ||
        !_matchesRawString(
          exercise['forceType'] as String?,
          filter.forceType,
        ) ||
        !_matchesRawBool(
          exercise['unilateral'] as bool?,
          filter.isUnilateral,
        ) ||
        !_matchesRawBool(
          exercise['bodyweight'] as bool?,
          filter.isBodyweight,
        )) {
      return false;
    }
    return _matchesRawIds(exercise['categories'], filter.categoryIds) &&
        _matchesRawIds(
          exercise['muscles'],
          filter.muscleIds,
          nestedKey: 'muscle',
        );
  }

  Map<String, String>? _stringMap(dynamic value) => value is Map
      ? value.map((key, value) => MapEntry('$key', '$value'))
      : null;

  bool _matchesRawString(String? value, String? expected) =>
      expected == null || expected.isEmpty || value == expected;

  bool _matchesRawBool(bool? value, bool? expected) =>
      expected == null || value == expected;

  bool _matchesRawIds(
    dynamic rawValues,
    List<String>? filterIds, {
    String? nestedKey,
  }) {
    if (filterIds == null || filterIds.isEmpty) return true;
    if (rawValues is! List) return false;
    final ids = rawValues
        .whereType<Map>()
        .map((raw) => nestedKey == null ? raw : raw[nestedKey])
        .whereType<Map>()
        .map((raw) => raw['id'] as String?)
        .whereType<String>()
        .toSet();
    return filterIds.any(ids.contains);
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

  bool _matchesScope(ExerciseDetailModel exercise, String? scope) {
    if (scope == null || scope.isEmpty) {
      return true;
    }

    switch (scope.toLowerCase()) {
      case 'default':
        return !exercise.isPersonal;
      case 'mine':
        return exercise.isPersonal;
      case 'community':
      default:
        return true;
    }
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
