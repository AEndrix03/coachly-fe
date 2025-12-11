import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model/workout_stats_model.dart';
import 'package:coachly/features/workout/workout_page/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_page_service.dart';

class WorkoutPageRepositoryImpl implements IWorkoutPageRepository {
  final WorkoutPageService _service;
  final bool useMockData;

  WorkoutPageRepositoryImpl(
    this._service, {
    this.useMockData = true, // Toggle per development
  });

  @override
  Future<ApiResponse<List<WorkoutModel>>> getWorkouts() async {
    if (useMockData) return _getMockWorkouts();
    return await _service.fetchWorkouts();
  }

  @override
  Future<ApiResponse<List<WorkoutModel>>> getRecentWorkouts() async {
    if (useMockData) return _getMockRecentWorkouts();
    return await _service.fetchRecentWorkouts();
  }

  @override
  Future<ApiResponse<WorkoutStatsModel>> getWorkoutStats() async {
    if (useMockData) return _getMockStats();
    return await _service.fetchWorkoutStats();
  }

  @override
  Future<ApiResponse<String>> enableWorkout(String workoutId) async {
    if (useMockData) return ApiResponse.success(data: workoutId); // Simulate success
    return await _service.enableWorkoutApi(workoutId);
  }

  @override
  Future<ApiResponse<String>> disableWorkout(String workoutId) async {
    if (useMockData) return ApiResponse.success(data: workoutId); // Simulate success
    return await _service.disableWorkoutApi(workoutId);
  }

  @override
  Future<ApiResponse<String>> deleteWorkout(String workoutId) async {
    if (useMockData) return ApiResponse.success(data: workoutId); // Simulate success
    return await _service.deleteWorkoutApi(workoutId);
  }

  @override
  Future<ApiResponse<String>> updateWorkout(WorkoutModel updatedWorkout) async {
    if (useMockData) {
      // Simulate updating the mock data
      final mockWorkouts = _getMockWorkouts().data ?? [];
      final index = mockWorkouts.indexWhere((w) => w.id == updatedWorkout.id);
      if (index != -1) {
        mockWorkouts[index] = updatedWorkout; // This won't actually update the list returned by _getMockWorkouts
      }
      return ApiResponse.success(data: updatedWorkout.id); // Simulate success
    }
    return await _service.updateWorkoutApi(updatedWorkout);
  }

  // Mock Data Helpers
  ApiResponse<List<WorkoutModel>> _getMockWorkouts() {
    return ApiResponse.success(
      data: [
        WorkoutModel(
          id: '1',
          title: 'Full Body Strength',
          coach: 'Marco',
          exercises: 8,
          durationMinutes: 45,
          goal: 'Forza',
          progress: 75,
          lastUsed: '2 ore fa',
          active: true,
        ),
        WorkoutModel(
          id: '2',
          title: 'Upper Body Push',
          coach: 'Laura',
          exercises: 6,
          durationMinutes: 35,
          goal: 'Ipertrofia',
          progress: 50,
          lastUsed: 'Ieri',
          active: true,
        ),
        WorkoutModel(
          id: '3',
          title: 'Leg Day',
          coach: 'Marco',
          exercises: 7,
          durationMinutes: 50,
          goal: 'Forza',
          progress: 30,
          lastUsed: '3 giorni fa',
          active: true,
        ),
        WorkoutModel(
          id: '4',
          title: 'Core & Cardio',
          coach: 'Sofia',
          exercises: 5,
          durationMinutes: 30,
          goal: 'Conditioning',
          progress: 90,
          lastUsed: '1 settimana fa',
          active: true,
        ),
      ],
    );
  }

  ApiResponse<List<WorkoutModel>> _getMockRecentWorkouts() {
    final all = _getMockWorkouts().data ?? [];
    return ApiResponse.success(data: all.take(3).toList());
  }

  ApiResponse<WorkoutStatsModel> _getMockStats() {
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
}
