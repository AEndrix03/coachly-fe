import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_stats_model.dart';
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
  Future<ApiResponse<List<Workout>>> getWorkouts() async {
    if (useMockData) return _getMockWorkouts();
    return await _service.fetchWorkouts();
  }

  @override
  Future<ApiResponse<List<Workout>>> getRecentWorkouts() async {
    if (useMockData) return _getMockRecentWorkouts();
    return await _service.fetchRecentWorkouts();
  }

  @override
  Future<ApiResponse<WorkoutStats>> getWorkoutStats() async {
    if (useMockData) return _getMockStats();
    return await _service.fetchWorkoutStats();
  }

  // Mock Data Helpers
  ApiResponse<List<Workout>> _getMockWorkouts() {
    return ApiResponse.success(
      data: [
        Workout(
          id: '1',
          title: 'Full Body Strength',
          coach: 'Marco',
          exercises: 8,
          durationMinutes: 45,
          goal: 'Forza',
          progress: 75,
          lastUsed: '2 ore fa',
        ),
        Workout(
          id: '2',
          title: 'Upper Body Push',
          coach: 'Laura',
          exercises: 6,
          durationMinutes: 35,
          goal: 'Ipertrofia',
          progress: 50,
          lastUsed: 'Ieri',
        ),
        Workout(
          id: '3',
          title: 'Leg Day',
          coach: 'Marco',
          exercises: 7,
          durationMinutes: 50,
          goal: 'Forza',
          progress: 30,
          lastUsed: '3 giorni fa',
        ),
        Workout(
          id: '4',
          title: 'Core & Cardio',
          coach: 'Sofia',
          exercises: 5,
          durationMinutes: 30,
          goal: 'Conditioning',
          progress: 90,
          lastUsed: '1 settimana fa',
        ),
      ],
    );
  }

  ApiResponse<List<Workout>> _getMockRecentWorkouts() {
    final all = _getMockWorkouts().data ?? [];
    return ApiResponse.success(data: all.take(3).toList());
  }

  ApiResponse<WorkoutStats> _getMockStats() {
    return ApiResponse.success(
      data: const WorkoutStats(
        activeWorkouts: 4,
        completedWorkouts: 24,
        progressPercentage: 12.0,
        currentStreak: 7,
        weeklyWorkouts: 3,
      ),
    );
  }
}
