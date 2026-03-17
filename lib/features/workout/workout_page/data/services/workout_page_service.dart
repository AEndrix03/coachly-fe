import 'dart:convert';

import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/mappers/workout_write_command_mapper.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutPageServiceProvider = Provider<WorkoutPageService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkoutPageService(apiClient);
});

class WorkoutPageService {
  final ApiClient _apiClient;

  WorkoutPageService(this._apiClient);

  Future<ApiResponse<List<WorkoutModel>>> fetchWorkouts() async {
    return await _apiClient.get<List<WorkoutModel>>(
      '/workouts/user',
      fromJson: (json) {
        if (json is List) {
          return json
              .map(
                (item) => WorkoutModel.fromJson(
                  _normalizeWorkoutJson(item as Map<String, dynamic>),
                ),
              )
              .toList();
        }
        return [];
      },
    );
  }

  Future<ApiResponse<List<WorkoutModel>>> fetchRecentWorkouts() async {
    final allWorkoutsResponse = await fetchWorkouts();
    if (allWorkoutsResponse.success) {
      final allWorkouts = allWorkoutsResponse.data ?? [];
      allWorkouts.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
      return ApiResponse.success(data: allWorkouts.take(3).toList());
    }
    return allWorkoutsResponse;
  }

  Future<ApiResponse<WorkoutStatsModel>> fetchWorkoutStats() async {
    return ApiResponse.success(
      data: const WorkoutStatsModel(
        activeWorkouts: 4,
        completedWorkouts: 24,
        progressPercentage: 12.0,
        currentStreak: 7,
        weeklyWorkouts: 3,
      ),
    );
  }

  // Sincronizza workout dirty con il BE
  Future<ApiResponse<void>> syncDirtyWorkouts(
    List<WorkoutModel> dirtyWorkouts,
  ) async {
    final commands = dirtyWorkouts
        .map(WorkoutWriteCommandMapper.fromWorkoutModel)
        .map((command) => command.toJson())
        .toList();

    return await _apiClient.post<void>(
      '/workouts/sync',
      body: {'workouts': commands},
      fromJson: (_) {},
    );
  }

  Future<ApiResponse<void>> patchWorkout(
    String workoutId,
    WorkoutWriteCommand command,
  ) async {
    final isCreate = workoutId == 'new' || workoutId.trim().isEmpty;

    if (isCreate) {
      return await _apiClient.post<void>(
        '/workouts',
        body: command.toJson(includeId: true),
        fromJson: (_) {},
      );
    }

    return await _apiClient.put<void>(
      '/workouts/$workoutId',
      body: command.toJson(includeId: false),
      fromJson: (_) {},
    );
  }

  Map<String, dynamic> _normalizeWorkoutJson(Map<String, dynamic> rawJson) {
    final normalized = Map<String, dynamic>.from(rawJson);
    final parsedTranslations = _parseTranslations(normalized['translations']);
    final workoutId =
        normalized['id']?.toString() ??
        'wk_${DateTime.now().microsecondsSinceEpoch}';

    Map<String, String>? titleI18n;
    Map<String, String>? descriptionI18n;
    if (parsedTranslations != null) {
      titleI18n = <String, String>{};
      descriptionI18n = <String, String>{};

      for (final entry in parsedTranslations.entries) {
        final locale = entry.key;
        final value = entry.value;
        if (value is! Map) {
          continue;
        }

        final translation = Map<String, dynamic>.from(value);
        final title = (translation['title'] ?? translation['name'])
            ?.toString()
            .trim();
        final description = translation['description']?.toString().trim();

        if (title != null && title.isNotEmpty) {
          titleI18n[locale] = title;
        }
        if (description != null && description.isNotEmpty) {
          descriptionI18n[locale] = description;
        }
      }
    }

    final name = normalized['name']?.toString().trim();
    if ((titleI18n == null || titleI18n.isEmpty) &&
        name != null &&
        name.isNotEmpty) {
      titleI18n = {'it': name, 'en': name};
    }
    if (titleI18n != null && titleI18n.isNotEmpty) {
      normalized['titleI18n'] = titleI18n;
    }
    if (descriptionI18n != null && descriptionI18n.isNotEmpty) {
      normalized['descriptionI18n'] = descriptionI18n;
    }

    normalized['id'] = workoutId;
    normalized['goal'] =
        normalized['goal']?.toString() ??
        normalized['status']?.toString() ??
        'active';
    normalized['type'] = _extractWorkoutType(normalized) ?? 'Generico';
    normalized['lastUsed'] =
        normalized['lastUsed']?.toString() ?? DateTime.now().toIso8601String();
    normalized['durationMinutes'] =
        _toInt(normalized['durationMinutes']) ?? normalized['duration'] ?? 0;
    normalized['active'] =
        (normalized['status']?.toString().toLowerCase() ?? 'active') !=
        'archived';

    if (normalized['workoutExercises'] == null) {
      final mappedExercises = _mapBlocksToWorkoutExercises(
        workoutId: workoutId,
        blocks: normalized['blocks'],
      );
      normalized['workoutExercises'] = mappedExercises;
      normalized['exercises'] =
          _toInt(normalized['exercises']) ?? mappedExercises.length;
    }

    return normalized;
  }

  String? _extractWorkoutType(Map<String, dynamic> normalized) {
    final blocks = normalized['blocks'];
    if (blocks is List && blocks.isNotEmpty) {
      final firstBlock = blocks.first;
      if (firstBlock is Map) {
        final label = firstBlock['label']?.toString().trim();
        if (label != null && label.isNotEmpty) {
          return label;
        }
      }
    }
    return normalized['type']?.toString();
  }

  List<Map<String, dynamic>> _mapBlocksToWorkoutExercises({
    required String workoutId,
    required dynamic blocks,
  }) {
    if (blocks is! List) {
      return const [];
    }

    final exercises = <Map<String, dynamic>>[];
    for (final block in blocks) {
      if (block is! Map) {
        continue;
      }
      final entries = block['entries'];
      if (entries is! List) {
        continue;
      }

      for (final entry in entries) {
        if (entry is! Map) {
          continue;
        }
        final exerciseId = entry['exerciseId']?.toString();
        if (exerciseId == null || exerciseId.isEmpty) {
          continue;
        }

        final sets = entry['sets'] is List ? entry['sets'] as List : const [];
        final setsCount = sets.isEmpty ? 1 : sets.length;
        final firstSet = sets.isNotEmpty && sets.first is Map
            ? sets.first as Map
            : const {};
        final reps = _toInt(firstSet['reps']);
        final restSeconds = _toInt(firstSet['restSeconds']);
        final load = _toNum(firstSet['load']);
        final loadUnit = firstSet['loadUnit']?.toString();

        final setsLabel = reps != null ? '$setsCount x $reps' : '$setsCount';
        final restLabel = restSeconds != null ? '${restSeconds}s' : '';
        final weightLabel = load != null
            ? '$load${loadUnit != null ? ' $loadUnit' : ''}'
            : '';

        exercises.add({
          'id':
              entry['id']?.toString() ??
              '$workoutId-entry-${exercises.length + 1}',
          'exercise': {
            'id': exerciseId,
            'nameI18n': {'it': exerciseId, 'en': exerciseId},
            'muscles': const [],
            'variants': const [],
          },
          'sets': setsLabel,
          'rest': restLabel,
          'weight': weightLabel,
          'progress': 0.0,
        });
      }
    }

    return exercises;
  }

  Map<String, dynamic>? _parseTranslations(dynamic rawTranslations) {
    if (rawTranslations is Map<String, dynamic>) {
      return rawTranslations;
    }

    if (rawTranslations is String && rawTranslations.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(rawTranslations);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {
        return null;
      }
    }

    if (rawTranslations is Map) {
      return Map<String, dynamic>.from(rawTranslations);
    }

    return null;
  }

  int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  num? _toNum(dynamic value) {
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value);
    }
    return null;
  }
}
