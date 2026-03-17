import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_exercise_model.freezed.dart';
part 'workout_exercise_model.g.dart';

@freezed
abstract class WorkoutExerciseModel with _$WorkoutExerciseModel {
  const factory WorkoutExerciseModel({
    required String id,
    required ExerciseDetailModel exercise,
    required String sets,
    required String rest,
    required String weight,
    required double progress,
  }) = _WorkoutExerciseModel;

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$WorkoutExerciseModelFromJson(json);
    } catch (_) {
      final exerciseJson = _toJsonMap(json['exercise']);
      final exerciseId =
          _asString(json['exerciseId']) ?? _asString(exerciseJson?['id']);
      final fallbackExercise = _parseFallbackExercise(
        exerciseJson,
        fallbackExerciseId: exerciseId,
      );
      final fallbackSetCount = _asInt(json['setCount']) ?? 1;
      final fallbackReps = _asInt(json['reps']);
      final fallbackRest = _asInt(json['restSeconds']);
      final fallbackLoad = _asNum(json['load']);
      final fallbackLoadUnit = _asString(json['loadUnit']) ?? 'kg';

      return WorkoutExerciseModel(
        id:
            _asString(json['id']) ??
            'entry_${DateTime.now().microsecondsSinceEpoch}',
        exercise: fallbackExercise,
        sets:
            _asString(json['sets']) ??
            (fallbackReps != null
                ? '${fallbackSetCount}x$fallbackReps'
                : '${fallbackSetCount}x'),
        rest:
            _asString(json['rest']) ??
            (fallbackRest != null ? '${fallbackRest}s' : '-'),
        weight:
            _asString(json['weight']) ??
            (fallbackLoad != null ? '$fallbackLoad$fallbackLoadUnit' : '-'),
        progress: _asNum(json['progress'])?.toDouble() ?? 0.0,
      );
    }
  }
}

ExerciseDetailModel _parseFallbackExercise(
  Map<String, dynamic>? exerciseJson, {
  required String? fallbackExerciseId,
}) {
  if (exerciseJson == null) {
    return ExerciseDetailModel(id: fallbackExerciseId);
  }

  try {
    return ExerciseDetailModel.fromJson(exerciseJson);
  } catch (_) {
    final exerciseId = _asString(exerciseJson['id']) ?? fallbackExerciseId;
    final exerciseName = _asString(exerciseJson['name']);
    final fallbackName = exerciseName ?? exerciseId;

    return ExerciseDetailModel(
      id: exerciseId,
      nameI18n: fallbackName == null
          ? null
          : {'it': fallbackName, 'en': fallbackName},
    );
  }
}

Map<String, dynamic>? _toJsonMap(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}

String? _asString(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  final asString = value.toString().trim();
  return asString.isEmpty ? null : asString;
}

int? _asInt(Object? value) {
  return _asNum(value)?.toInt();
}

num? _asNum(Object? value) {
  if (value is num) {
    return value;
  }
  if (value is String) {
    final normalized = value.trim().replaceAll(',', '.');
    return num.tryParse(normalized);
  }
  return null;
}
