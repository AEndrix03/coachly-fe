import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/tag_dto/tag_dto.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_exercise_model/workout_exercise_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';

class WorkoutRemoteMapper {
  const WorkoutRemoteMapper._();

  static WorkoutModel fromApiJson(Map<String, dynamic> json) {
    final workoutExercises = _parseWorkoutExercises(json);
    final titleI18n = _parseTitleI18n(json);
    final descriptionI18n = _parseDescriptionI18n(json);
    final type =
        _firstNonEmptyString([
          _asString(json['type']),
          _asString(json['goal']),
          _asString(json['focus']),
          _asString(_firstBlock(json)?['label']),
        ]) ??
        'Generale';
    final goal =
        _firstNonEmptyString([
          _asString(json['goal']),
          _asString(json['objective']),
          type,
        ]) ??
        'Generale';

    final status = _asString(json['status'])?.toLowerCase();
    final isArchived = status == 'archived';
    final isActive =
        _asBool(json['active']) ?? (status == null ? true : status == 'active');

    return WorkoutModel(
      id:
          _asString(json['id']) ??
          'workout_${DateTime.now().microsecondsSinceEpoch}',
      titleI18n: titleI18n,
      descriptionI18n: descriptionI18n,
      coachId:
          _asString(json['coachId']) ?? _asString(_asMap(json['coach'])?['id']),
      coachName:
          _asString(json['coachName']) ??
          _asString(_asMap(json['coach'])?['name']),
      progress: _normalizeProgress(_asNum(json['progress'])?.toDouble()),
      durationMinutes:
          _asInt(json['durationMinutes']) ?? _estimateDurationMinutes(json),
      goal: goal,
      lastUsed:
          _parseDateTime(_asString(json['lastUsed'])) ??
          _parseDateTime(_asString(json['updatedAt'])) ??
          _parseDateTime(_asString(json['createdAt'])) ??
          DateTime.now(),
      muscleTags: _parseMuscleTags(json),
      exercises: _asInt(json['exercises']) ?? workoutExercises.length,
      sessionsCount: _asInt(json['sessionsCount']) ?? 0,
      lastSessionDays: _asInt(json['lastSessionDays']) ?? 0,
      type: type,
      workoutExercises: workoutExercises,
      active: isActive && !isArchived,
      dirty: false,
      delete: isArchived,
    );
  }

  static List<WorkoutExerciseModel> _parseWorkoutExercises(
    Map<String, dynamic> json,
  ) {
    final rawLegacyExercises = json['workoutExercises'];
    if (rawLegacyExercises is List && rawLegacyExercises.isNotEmpty) {
      final parsedLegacyExercises = <WorkoutExerciseModel>[];
      var index = 0;
      for (final rawExercise in rawLegacyExercises) {
        final exerciseMap = _asMap(rawExercise);
        if (exerciseMap == null) {
          continue;
        }

        parsedLegacyExercises.add(
          WorkoutExerciseModel.fromJsonSafe(exerciseMap),
        );
        index += 1;
      }

      if (parsedLegacyExercises.isNotEmpty) {
        return parsedLegacyExercises;
      }
    }

    final rawBlocks = json['blocks'];
    if (rawBlocks is! List) {
      return const [];
    }

    final parsedExercises = <WorkoutExerciseModel>[];
    var position = 0;
    for (final rawBlock in rawBlocks) {
      final block = _asMap(rawBlock);
      if (block == null) {
        continue;
      }

      final rawEntries = block['entries'];
      if (rawEntries is! List) {
        continue;
      }

      for (final rawEntry in rawEntries) {
        final entry = _asMap(rawEntry);
        if (entry == null) {
          continue;
        }

        final mappedExercise = _mapBlockEntryToWorkoutExercise(
          workoutId: _asString(json['id']) ?? 'workout',
          block: block,
          entry: entry,
          position: position,
        );
        if (mappedExercise != null) {
          parsedExercises.add(mappedExercise);
          position += 1;
        }
      }
    }

    return parsedExercises;
  }

  static WorkoutExerciseModel? _mapBlockEntryToWorkoutExercise({
    required String workoutId,
    required Map<String, dynamic> block,
    required Map<String, dynamic> entry,
    required int position,
  }) {
    final exerciseMap = _asMap(entry['exercise']);
    final exerciseId = _firstNonEmptyString([
      _asString(entry['exerciseId']),
      _asString(exerciseMap?['id']),
    ]);
    if (exerciseId == null) {
      return null;
    }

    final rawSets = entry['sets'];
    final sets = rawSets is List ? rawSets : const <dynamic>[];
    final firstSet = sets.isEmpty ? null : _asMap(sets.first);

    final setCount = sets.isNotEmpty
        ? sets.length
        : (_asInt(entry['setCount']) ?? 1);
    final reps = _asInt(firstSet?['reps']) ?? _asInt(entry['reps']);
    final restSeconds =
        _asInt(firstSet?['restSeconds']) ??
        _asInt(entry['restSeconds']) ??
        _asInt(block['restSeconds']);
    final load = _asNum(firstSet?['load']) ?? _asNum(entry['load']);
    final loadUnit =
        _asString(firstSet?['loadUnit']) ??
        _asString(entry['loadUnit']) ??
        (load != null ? 'kg' : null);

    final setsLabel = reps != null ? '${setCount}x$reps' : '${setCount}x';
    final restLabel = restSeconds != null ? '${restSeconds}s' : '-';
    final weightLabel = load != null
        ? '${_formatNum(load)}${loadUnit ?? ''}'
        : '-';

    final exerciseNameI18n = _toStringMap(exerciseMap?['nameI18n']);
    final exerciseName =
        _asString(entry['exerciseName']) ?? _asString(exerciseMap?['name']);

    return WorkoutExerciseModel(
      id: _asString(entry['id']) ?? '${workoutId}_entry_$position',
      exercise: ExerciseDetailModel(
        id: exerciseId,
        nameI18n:
            exerciseNameI18n ??
            (exerciseName != null
                ? {'it': exerciseName, 'en': exerciseName}
                : {'it': exerciseId, 'en': exerciseId}),
        difficultyLevel: _asString(exerciseMap?['difficultyLevel']),
      ),
      sets: setsLabel,
      rest: restLabel,
      weight: weightLabel,
      progress: _normalizeProgress(_asNum(entry['progress'])?.toDouble()),
    );
  }

  static Map<String, String>? _parseTitleI18n(Map<String, dynamic> json) {
    final rawTitleI18n = _toStringMap(json['titleI18n']);
    if (rawTitleI18n != null && rawTitleI18n.isNotEmpty) {
      return rawTitleI18n;
    }

    final translatedTitleI18n = _extractTranslatedField(json, field: 'title');
    if (translatedTitleI18n.isNotEmpty) {
      return translatedTitleI18n;
    }

    final name = _asString(json['name']);
    if (name != null) {
      return {'it': name, 'en': name};
    }

    return null;
  }

  static Map<String, String>? _parseDescriptionI18n(Map<String, dynamic> json) {
    final rawDescriptionI18n = _toStringMap(json['descriptionI18n']);
    if (rawDescriptionI18n != null && rawDescriptionI18n.isNotEmpty) {
      return rawDescriptionI18n;
    }

    final translatedDescriptionI18n = _extractTranslatedField(
      json,
      field: 'description',
    );
    if (translatedDescriptionI18n.isNotEmpty) {
      return translatedDescriptionI18n;
    }

    final description = _asString(json['description']);
    if (description != null) {
      return {'it': description, 'en': description};
    }

    return null;
  }

  static Map<String, String> _extractTranslatedField(
    Map<String, dynamic> json, {
    required String field,
  }) {
    final translations = _asMap(json['translations']);
    if (translations == null || translations.isEmpty) {
      return const {};
    }

    final mappedTranslations = <String, String>{};
    for (final entry in translations.entries) {
      final locale = entry.key;
      final translationPayload = _asMap(entry.value);
      if (translationPayload == null) {
        continue;
      }

      final value = _asString(translationPayload[field]);
      if (value != null) {
        mappedTranslations[locale] = value;
      }
    }
    return mappedTranslations;
  }

  static List<TagDto> _parseMuscleTags(Map<String, dynamic> json) {
    final rawMuscleTags = json['muscleTags'];
    if (rawMuscleTags is! List) {
      return const [];
    }

    final tags = <TagDto>[];
    for (final rawTag in rawMuscleTags) {
      final tag = _asMap(rawTag);
      if (tag == null) {
        continue;
      }

      final id = _asString(tag['id']);
      final nameI18n = _toStringMap(tag['nameI18n']);
      if (id == null || nameI18n == null || nameI18n.isEmpty) {
        continue;
      }

      tags.add(TagDto(id: id, nameI18n: nameI18n));
    }

    return tags;
  }

  static int _estimateDurationMinutes(Map<String, dynamic> json) {
    final explicitDuration =
        _asInt(json['estimatedDurationMinutes']) ??
        _asInt(json['duration']) ??
        _asInt(json['durationMin']);
    if (explicitDuration != null) {
      return explicitDuration;
    }

    final rawBlocks = json['blocks'];
    if (rawBlocks is! List) {
      return 0;
    }

    var totalEntries = 0;
    for (final rawBlock in rawBlocks) {
      final block = _asMap(rawBlock);
      if (block == null) {
        continue;
      }

      final rawEntries = block['entries'];
      if (rawEntries is List) {
        totalEntries += rawEntries.length;
      }
    }

    return totalEntries * 5;
  }

  static Map<String, dynamic>? _firstBlock(Map<String, dynamic> json) {
    final rawBlocks = json['blocks'];
    if (rawBlocks is! List || rawBlocks.isEmpty) {
      return null;
    }
    return _asMap(rawBlocks.first);
  }

  static Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }

  static Map<String, String>? _toStringMap(Object? value) {
    final rawMap = _asMap(value);
    if (rawMap == null) {
      return null;
    }

    final stringMap = <String, String>{};
    for (final entry in rawMap.entries) {
      final mappedValue = _asString(entry.value);
      if (mappedValue != null) {
        stringMap[entry.key] = mappedValue;
      }
    }
    return stringMap.isEmpty ? null : stringMap;
  }

  static String? _asString(Object? value) {
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

  static num? _asNum(Object? value) {
    if (value is num) {
      return value;
    }
    if (value is String) {
      final normalized = value.trim().replaceAll(',', '.');
      return num.tryParse(normalized);
    }
    return null;
  }

  static int? _asInt(Object? value) {
    return _asNum(value)?.toInt();
  }

  static bool? _asBool(Object? value) {
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

  static DateTime? _parseDateTime(String? rawDateTime) {
    if (rawDateTime == null) {
      return null;
    }
    final parsed = DateTime.tryParse(rawDateTime);
    if (parsed == null) {
      return null;
    }
    return parsed.isUtc ? parsed.toLocal() : parsed;
  }

  static String? _firstNonEmptyString(List<String?> candidates) {
    for (final candidate in candidates) {
      if (candidate != null && candidate.isNotEmpty) {
        return candidate;
      }
    }
    return null;
  }

  static double _normalizeProgress(double? rawProgress) {
    if (rawProgress == null) {
      return 0;
    }

    final normalized = rawProgress > 0 && rawProgress <= 1
        ? rawProgress * 100
        : rawProgress;
    return normalized.clamp(0, 100).toDouble();
  }

  static String _formatNum(num value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    return value
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}
