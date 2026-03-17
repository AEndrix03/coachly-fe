import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/mappers/workout_remote_mapper.dart';
import 'package:coachly/features/workout/workout_page/data/mappers/workout_write_command_mapper.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';
import 'package:flutter/foundation.dart';
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
          final workouts = <WorkoutModel>[];
          for (final item in json) {
            if (item is! Map) {
              continue;
            }

            try {
              final payload = item.map(
                (key, value) => MapEntry(key.toString(), value),
              );
              workouts.add(WorkoutRemoteMapper.fromApiJson(payload));
            } catch (error) {
              debugPrint(
                'Skipping invalid workout payload in fetchWorkouts: $error',
              );
            }
          }
          return workouts;
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

  Future<ApiResponse<void>> saveWorkoutSession(
    String workoutId,
    WorkoutSessionWriteCommand command,
  ) async {
    return await _apiClient.post<void>(
      '/workouts/$workoutId/sessions',
      body: command.toJson(),
      fromJson: (_) {},
    );
  }
}
