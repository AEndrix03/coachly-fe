import 'dart:convert';

import 'package:coachly/features/workout/workout_page/data/models/tag_dto/tag_dto.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/shared/json_converters/map_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_model.freezed.dart';
part 'workout_model.g.dart';

@freezed
abstract class WorkoutModel with _$WorkoutModel {
  const factory WorkoutModel({
    required String id,
    @MapConverter() required Map<String, String>? titleI18n,
    @MapConverter() required Map<String, String>? descriptionI18n,
    String? coachId,
    String? coachName,
    @Default(0.0) double progress,
    @Default(0) int durationMinutes,
    required String goal,
    required DateTime lastUsed,
    @Default([]) List<TagDto> muscleTags,
    @Default(0) int exercises,
    @Default(0) int sessionsCount,
    @Default(0) int lastSessionDays,
    required String type,
    @Default([]) List<WorkoutExerciseModel> workoutExercises,
    @Default(true) bool active,
    @Default(false) bool dirty,
    @Default(false) bool delete,
  }) = _WorkoutModel;

  factory WorkoutModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutModelFromJson(json);

  static WorkoutModel fromJsonSafe(Map<String, dynamic> json) {
    try {
      return WorkoutModel.fromJson(json);
    } catch (_) {
      return WorkoutModel.fromJson(_sanitizeWorkoutJson(json));
    }
  }
}

Map<String, dynamic> _sanitizeWorkoutJson(Map<String, dynamic> rawJson) {
  final normalized = Map<String, dynamic>.from(rawJson);
  final workoutId =
      _asString(rawJson['id']) ??
      'workout_${DateTime.now().microsecondsSinceEpoch}';
  final status = _asString(rawJson['status'])?.toLowerCase();
  final isArchived = status == 'archived';

  final type =
      _firstNonEmptyString([
        _asString(rawJson['type']),
        _asString(rawJson['goal']),
        _extractFirstBlockLabel(rawJson['blocks']),
      ]) ??
      'Generale';
  final goal =
      _firstNonEmptyString([
        _asString(rawJson['goal']),
        _asString(rawJson['objective']),
        type,
      ]) ??
      'Generale';

  final titleI18n =
      _toStringMap(rawJson['titleI18n']) ??
      _extractTranslatedField(rawJson, field: 'title') ??
      _localizedFallback(_asString(rawJson['name']) ?? workoutId);
  final descriptionI18n =
      _toStringMap(rawJson['descriptionI18n']) ??
      _extractTranslatedField(rawJson, field: 'description') ??
      _localizedFallback(_asString(rawJson['description']));

  final workoutExercises = _sanitizeWorkoutExercises(
    rawJson: rawJson,
    workoutId: workoutId,
  );

  normalized['id'] = workoutId;
  normalized['titleI18n'] = titleI18n;
  normalized['descriptionI18n'] = descriptionI18n;
  normalized['goal'] = goal;
  normalized['type'] = type;
  normalized['lastUsed'] =
      _normalizeDateString(rawJson['lastUsed']) ??
      _normalizeDateString(rawJson['updatedAt']) ??
      _normalizeDateString(rawJson['createdAt']) ??
      DateTime.now().toIso8601String();
  normalized['durationMinutes'] =
      _asInt(rawJson['durationMinutes']) ?? _asInt(rawJson['duration']) ?? 0;
  normalized['progress'] = _normalizeProgress(
    _asNum(rawJson['progress'])?.toDouble(),
  );
  normalized['exercises'] =
      _asInt(rawJson['exercises']) ?? workoutExercises.length;
  normalized['sessionsCount'] = _asInt(rawJson['sessionsCount']) ?? 0;
  normalized['lastSessionDays'] = _asInt(rawJson['lastSessionDays']) ?? 0;
  normalized['active'] =
      _asBool(rawJson['active']) ??
      (status == null ? true : status == 'active');
  normalized['dirty'] = _asBool(rawJson['dirty']) ?? false;
  normalized['delete'] = _asBool(rawJson['delete']) ?? isArchived;
  normalized['muscleTags'] = _sanitizeMuscleTags(rawJson['muscleTags']);
  normalized['workoutExercises'] = workoutExercises;

  return normalized;
}

List<Map<String, dynamic>> _sanitizeWorkoutExercises({
  required Map<String, dynamic> rawJson,
  required String workoutId,
}) {
  final rawWorkoutExercises = rawJson['workoutExercises'];
  if (rawWorkoutExercises is List && rawWorkoutExercises.isNotEmpty) {
    final mappedExercises = <Map<String, dynamic>>[];
    for (var i = 0; i < rawWorkoutExercises.length; i += 1) {
      final rawExercise = _toJsonMap(rawWorkoutExercises[i]);
      if (rawExercise == null) {
        continue;
      }
      mappedExercises.add(
        _sanitizeWorkoutExerciseJson(
          rawExercise: rawExercise,
          workoutId: workoutId,
          index: i,
        ),
      );
    }
    if (mappedExercises.isNotEmpty) {
      return mappedExercises;
    }
  }

  final rawBlocks = rawJson['blocks'];
  if (rawBlocks is! List) {
    return const [];
  }

  final mappedFromBlocks = <Map<String, dynamic>>[];
  var entryIndex = 0;
  for (final rawBlock in rawBlocks) {
    final block = _toJsonMap(rawBlock);
    if (block == null) {
      continue;
    }

    final rawEntries = block['entries'];
    if (rawEntries is! List) {
      continue;
    }

    for (final rawEntry in rawEntries) {
      final entry = _toJsonMap(rawEntry);
      if (entry == null) {
        continue;
      }

      final exerciseId = _asString(entry['exerciseId']);
      if (exerciseId == null) {
        continue;
      }

      final rawSets = entry['sets'];
      final sets = rawSets is List ? rawSets : const <dynamic>[];
      final firstSet = sets.isEmpty ? null : _toJsonMap(sets.first);
      final setCount = sets.isEmpty ? 1 : sets.length;
      final reps = _asInt(firstSet?['reps']);
      final restSeconds =
          _asInt(firstSet?['restSeconds']) ?? _asInt(entry['restSeconds']);
      final load = _asNum(firstSet?['load']) ?? _asNum(entry['load']);
      final loadUnit =
          _asString(firstSet?['loadUnit']) ?? _asString(entry['loadUnit']);

      mappedFromBlocks.add({
        'id': _asString(entry['id']) ?? '${workoutId}_entry_$entryIndex',
        'exercise': {
          'id': exerciseId,
          'nameI18n': {'it': exerciseId, 'en': exerciseId},
        },
        'sets': reps != null ? '${setCount}x$reps' : '${setCount}x',
        'rest': restSeconds != null ? '${restSeconds}s' : '-',
        'weight': load != null ? '$load${loadUnit ?? ''}' : '-',
        'progress': _normalizeProgress(_asNum(entry['progress'])?.toDouble()),
      });
      entryIndex += 1;
    }
  }

  return mappedFromBlocks;
}

Map<String, dynamic> _sanitizeWorkoutExerciseJson({
  required Map<String, dynamic> rawExercise,
  required String workoutId,
  required int index,
}) {
  final exercise = _toJsonMap(rawExercise['exercise']) ?? <String, dynamic>{};
  final exerciseId =
      _asString(rawExercise['exerciseId']) ??
      _asString(exercise['id']) ??
      'exercise_${index + 1}';
  final exerciseNameI18n = _toStringMap(exercise['nameI18n']);
  final exerciseName = _asString(exercise['name']) ?? exerciseId;

  return {
    'id': _asString(rawExercise['id']) ?? '${workoutId}_entry_${index + 1}',
    'exercise': {
      ...exercise,
      'id': exerciseId,
      'nameI18n': exerciseNameI18n ?? {'it': exerciseName, 'en': exerciseName},
    },
    'sets': _asString(rawExercise['sets']) ?? '1x',
    'rest': _asString(rawExercise['rest']) ?? '-',
    'weight': _asString(rawExercise['weight']) ?? '-',
    'progress': _normalizeProgress(_asNum(rawExercise['progress'])?.toDouble()),
  };
}

List<Map<String, dynamic>> _sanitizeMuscleTags(dynamic rawMuscleTags) {
  if (rawMuscleTags is! List) {
    return const [];
  }

  final tags = <Map<String, dynamic>>[];
  for (final rawTag in rawMuscleTags) {
    final tag = _toJsonMap(rawTag);
    if (tag == null) {
      continue;
    }

    final id = _asString(tag['id']);
    final nameI18n = _toStringMap(tag['nameI18n']);
    if (id == null || nameI18n == null || nameI18n.isEmpty) {
      continue;
    }

    tags.add({'id': id, 'nameI18n': nameI18n});
  }

  return tags;
}

Map<String, String>? _extractTranslatedField(
  Map<String, dynamic> rawJson, {
  required String field,
}) {
  final rawTranslations = rawJson['translations'];
  Map<String, dynamic>? translations;

  if (rawTranslations is String && rawTranslations.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(rawTranslations);
      translations = _toJsonMap(decoded);
    } catch (_) {
      translations = null;
    }
  } else {
    translations = _toJsonMap(rawTranslations);
  }

  if (translations == null || translations.isEmpty) {
    return null;
  }

  final mapped = <String, String>{};
  for (final entry in translations.entries) {
    final value = _toJsonMap(entry.value);
    if (value == null) {
      continue;
    }

    final translated = _asString(value[field]);
    if (translated != null) {
      mapped[entry.key] = translated;
    }
  }

  return mapped.isEmpty ? null : mapped;
}

String? _extractFirstBlockLabel(dynamic rawBlocks) {
  if (rawBlocks is! List || rawBlocks.isEmpty) {
    return null;
  }
  final firstBlock = _toJsonMap(rawBlocks.first);
  return _asString(firstBlock?['label']);
}

Map<String, String>? _localizedFallback(String? value) {
  if (value == null) {
    return null;
  }
  return {'it': value, 'en': value};
}

String? _normalizeDateString(Object? rawDate) {
  final dateString = _asString(rawDate);
  if (dateString == null) {
    return null;
  }

  final parsed = DateTime.tryParse(dateString);
  if (parsed == null) {
    return null;
  }
  return parsed.toIso8601String();
}

String? _firstNonEmptyString(List<String?> candidates) {
  for (final candidate in candidates) {
    if (candidate != null && candidate.isNotEmpty) {
      return candidate;
    }
  }
  return null;
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

Map<String, String>? _toStringMap(Object? value) {
  final rawMap = _toJsonMap(value);
  if (rawMap == null) {
    return null;
  }

  final mapped = <String, String>{};
  for (final entry in rawMap.entries) {
    final mappedValue = _asString(entry.value);
    if (mappedValue != null) {
      mapped[entry.key] = mappedValue;
    }
  }
  return mapped.isEmpty ? null : mapped;
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

int? _asInt(Object? value) {
  return _asNum(value)?.toInt();
}

bool? _asBool(Object? value) {
  if (value is bool) {
    return value;
  }
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true') {
      return true;
    }
    if (normalized == 'false') {
      return false;
    }
  }
  return null;
}

double _normalizeProgress(double? rawProgress) {
  if (rawProgress == null) {
    return 0;
  }

  final normalized = rawProgress > 0 && rawProgress <= 1
      ? rawProgress * 100
      : rawProgress;
  return normalized.clamp(0, 100).toDouble();
}
