/// API Endpoints Constants
class ApiEndpoints {
  // Base URL - in produzione andrebbe in un file .env
  static const String baseUrl = 'http://localhost:8080/api';

  // Workout endpoints
  static const String workouts = '/workouts';
  static String workoutById(String id) => '/workouts/$id';
  static String activeWorkout(String id) => '/workouts/$id/active';
  static String completeSet(String workoutId, String exerciseId) =>
      '/workouts/$workoutId/exercises/$exerciseId/sets';

  // Exercise endpoints
  static const String exercises = '/exercises';
  static String exerciseById(String id) => '/exercises/$id';

  // User endpoints
  static const String users = '/users';
  static const String profile = '/users/profile';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
}
