# Piano di Refactor Dettagliato per File - Coachly Flutter

## Analisi Completa e Piano Specifico per File

---

## 📁 CORE LAYER

### `core/constants/api_endpoints.dart`

**Status**: ✅ OK
**Simboli**: ApiEndpoints class con endpoints statici
**Pattern**: Static class pattern
**Problemi**: Nessuno - ben strutturato
**Azione**: Mantieni

---

### `core/network/api_client.dart`

**Status**: ⚠️ Migliorare
**Simboli**: ApiClient class con metodi HTTP (get, post, put, delete)
**Pattern**: HTTP client wrapper con error handling
**Problemi Identificati**:

1. Error handling non standardizzato (usa ApiException ma non Either pattern)
2. No retry logic per network failures
3. No request/response interceptors
4. Timeout hardcoded (dovrebbe essere configurabile)
5. No logging strutturato delle richieste

**Refactor**:

```dart
// Prima
class ApiClient {
  Future<Map<String, dynamic>> get(String path) async {
    // ... direct error throw
  }
}

// Dopo
class ApiClient {
  final List<Interceptor> interceptors;
  final RetryPolicy retryPolicy;
  final Logger logger;

  Future<Either<Failure, T>> get<T>(String path, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      // ... with retry + logging + interceptors
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}
```

**Azioni Specifiche**:

1. Aggiungere Either<Failure, T> return type
2. Implementare interceptor pattern per logging/auth
3. Aggiungere retry policy (exponential backoff)
4. Estrarre timeout in config
5. Aggiungere structured logging (logger package)

---

### `core/network/api_exception.dart`

**Status**: ⚠️ Refactor
**Simboli**: ApiException, NetworkException, ServerException, UnauthorizedException,
NotFoundException, ValidationException
**Pattern**: Exception classes per error types
**Problemi Identificati**:

1. Exception invece di Failure pattern (non type-safe)
2. Mix di exceptions e non c'è gerarchia chiara
3. No error codes standardizzati
4. No i18n per messaggi errore

**Refactor**:

```dart
// Creare core/error/failures.dart
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure(this.message, [this.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error'])
      : super(message, 1001);
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error', int? code])
      : super(message, code ?? 5000);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('Unauthorized', 401);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure() : super('Not found', 404);
}

class ValidationFailure extends Failure {
  final Map<String, String> errors;

  const ValidationFailure(this.errors) : super('Validation failed', 422);
}
```

**Azioni Specifiche**:

1. Creare core/error/ folder
2. Implementare Failure classes con Equatable
3. Sostituire exceptions con Either<Failure, T>
4. Aggiungere error codes standardizzati
5. Preparare per i18n (usare keys invece di strings)

---

### `core/network/api_response.dart`

**Status**: ⚠️ Migliorare
**Simboli**: ApiResponse<T> class con success/error factory
**Pattern**: Response wrapper
**Problemi Identificati**:

1. Non type-safe (può avere data e errors insieme)
2. No discriminated union (success vs error)
3. fromJson usa dynamic
4. No null-safety checks

**Refactor**:

```dart
// Usare Freezed per type-safe response
@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success({
    required T data,
    String? message,
  }) = SuccessResponse<T>;

  const factory ApiResponse.error({
    required String message,
    int? statusCode,
    Map<String, dynamic>? errors,
  }) = ErrorResponse<T>;

  factory ApiResponse.fromJson(Map<String, dynamic> json,
      T Function(Object?) fromJsonT,) => _$ApiResponseFromJson(json, fromJsonT);
}
```

**Azioni Specifiche**:

1. Convertire a Freezed sealed class
2. Rimuovere campi nullable ambigui
3. Type-safe fromJson con generic parser
4. Aggiungere when/map methods per pattern matching

---

## 📁 FEATURES / WORKOUT

### `pages/workout/data/models/exercise_model.dart`

**Status**: ⚠️ Refactor con Freezed
**Simboli**: ExerciseModel class con 11 fields + 7 computed properties
**Pattern**: Manual immutable model con copyWith
**Problemi Identificati**:

1. Manual copyWith implementation (error-prone)
2. No @immutable annotation
3. Manual fromJson/toJson (verbose)
4. Computed properties potrebbero essere extension methods
5. Business logic (addSet, removeSetAt) dentro model

**Refactor**:

```dart
@freezed
class ExerciseModel with _$ExerciseModel {
  const ExerciseModel._(); // Private constructor per extensions

  const factory ExerciseModel({
    required String id,
    required String exerciseId,
    required String name,
    required int order,
    required String targetSetsRange,
    required String targetRepsRange,
    required List<SetModel> sets,
    @Default(90) int restSeconds,
    String? notes,
    @Default(false) bool isSuperset,
    List<String>? supersetWith,
  }) = _ExerciseModel;

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);
}

// Spostare logic in extension
extension ExerciseModelX on ExerciseModel {
  int get completedSetsCount =>
      sets
          .where((s) => s.completed)
          .length;

  int get totalSets => sets.length;

  bool get isCompleted => completedSetsCount == totalSets && totalSets > 0;

  double get totalVolume => sets.fold(0.0, (sum, set) => sum + (set.weight * set.reps));

  double get progressPercentage => totalSets > 0 ? (completedSetsCount / totalSets) * 100 : 0;
}

// Spostare mutations in controller
class ExerciseController {
  ExerciseModel addSet(ExerciseModel exercise, SetModel set) {
    return exercise.copyWith(sets: [...exercise.sets, set]);
  }

  ExerciseModel removeSetAt(ExerciseModel exercise, int index) {
    final newSets = List<SetModel>.from(exercise.sets);
    newSets.removeAt(index);
    return exercise.copyWith(sets: newSets);
  }
}
```

**Azioni Specifiche**:

1. Convertire a Freezed model
2. Estrarre computed properties in extension
3. Spostare mutations (addSet, etc) in controller/notifier
4. Rimuovere business logic dal model
5. Aggiungere @Default per valori di default
6. Auto-generare fromJson/toJson

---

### `pages/workout/data/models/set_model.dart`

**Status**: ⚠️ Refactor con Freezed
**Simboli**: SetType enum + SetModel class
**Pattern**: Manual model con enum
**Problemi Identificati**:

1. Manual copyWith implementation
2. Enum extension per displayName (OK ma potrebbe usare enhanced enums)
3. No @immutable
4. Manual fromJson/toJson
5. Factory constructors (empty, duplicate) potrebbero essere extension methods

**Refactor**:

```dart
// Enhanced enum (Dart 2.17+)
enum SetType {
  normal('Normal'),
  warmup('Warmup'),
  dropset('Dropset'),
  failure('Failure');

  final String displayName;

  const SetType(this.displayName);

  static SetType fromString(String value) {
    return SetType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => SetType.normal,
    );
  }
}

@freezed
class SetModel with _$SetModel {
  const SetModel._();

  const factory SetModel({
    required String id,
    @Default(SetType.normal) SetType type,
    @Default(0) double weight,
    @Default(0) int reps,
    @Default(false) bool completed,
    int? rpe,
    String? notes,
    DateTime? completedAt,
  }) = _SetModel;

  factory SetModel.fromJson(Map<String, dynamic> json) =>
      _$SetModelFromJson(json);

  factory SetModel.empty() =>
      SetModel(
        id: const Uuid().v4(),
      );
}

extension SetModelX on SetModel {
  SetModel duplicate() =>
      copyWith(
        id: const Uuid().v4(),
        completed: false,
        completedAt: null,
      );
}
```

**Azioni Specifiche**:

1. Convertire a Freezed
2. Usare enhanced enum per SetType
3. Spostare factory constructors in extension
4. Aggiungere @Default annotations
5. Auto-generare serialization

---

### `pages/workout/data/models/workout_session_model.dart`

**Status**: ⚠️ Refactor con Freezed
**Simboli**: WorkoutSessionStatus enum + WorkoutSessionModel class
**Pattern**: Manual model con complex computed properties
**Problemi Identificati**:

1. Manual copyWith (molto complesso)
2. Troppi computed properties (7) dentro model
3. Business logic (updateExercise, markAsCompleted) nel model
4. No enum enhancement
5. No type-safe status transitions

**Refactor**:

```dart
enum WorkoutSessionStatus {
  notStarted,
  inProgress,
  paused,
  completed,
  cancelled;

  bool get canStart => this == notStarted;

  bool get canPause => this == inProgress;

  bool get canResume => this == paused;

  bool get canComplete => this == inProgress || this == paused;
}

@freezed
class WorkoutSessionModel with _$WorkoutSessionModel {
  const WorkoutSessionModel._();

  const factory WorkoutSessionModel({
    required String id,
    required String workoutPlanId,
    required String workoutPlanName,
    DateTime? startedAt,
    DateTime? completedAt,
    @Default(WorkoutSessionStatus.notStarted) WorkoutSessionStatus status,
    @Default([]) List<ExerciseModel> exercises,
    String? notes,
    int? rating,
  }) = _WorkoutSessionModel;

  factory WorkoutSessionModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSessionModelFromJson(json);
}

// Extension per computed properties
extension WorkoutSessionModelX on WorkoutSessionModel {
  int? get durationMinutes {
    if (startedAt == null) return null;
    final endTime = completedAt ?? DateTime.now();
    return endTime
        .difference(startedAt!)
        .inMinutes;
  }

  int get completedExercisesCount =>
      exercises
          .where((e) => e.isCompleted)
          .length;

  ExerciseModel? get currentExercise =>
      exercises.firstWhereOrNull((e) => !e.isCompleted);

  int get currentExerciseIndex {
    final current = currentExercise;
    return current != null ? exercises.indexOf(current) : -1;
  }

  double get overallProgress {
    if (exercises.isEmpty) return 0;
    final totalSets = exercises.fold<int>(0, (sum, e) => sum + e.totalSets);
    final completedSets = exercises.fold<int>(
        0, (sum, e) => sum + e.completedSetsCount
    );
    return totalSets > 0 ? (completedSets / totalSets) * 100 : 0;
  }

  double get totalVolume =>
      exercises.fold(0.0, (sum, e) => sum + e.totalVolume);

  int get totalReps =>
      exercises.fold(0, (sum, e) => sum + e.sets.fold(0, (s, set) => s + set.reps));
}

// Spostare mutations in controller/notifier
class WorkoutSessionNotifier extends _$WorkoutSessionNotifier {
  WorkoutSessionModel updateExercise(WorkoutSessionModel session,
      String exerciseId,
      ExerciseModel updatedExercise,) {
    final exercises = session.exercises.map((e) {
      return e.id == exerciseId ? updatedExercise : e;
    }).toList();

    return session.copyWith(exercises: exercises);
  }

  WorkoutSessionModel markAsCompleted(WorkoutSessionModel session) {
    return session.copyWith(
      status: WorkoutSessionStatus.completed,
      completedAt: DateTime.now(),
    );
  }
}
```

**Azioni Specifiche**:

1. Convertire a Freezed
2. Enhanced enum per status con business rules
3. Estrarre computed properties in extension
4. Spostare mutations in notifier
5. Type-safe status transitions
6. Aggiungere validation logic per status changes

---

### `pages/workout/data/repositories/workout_repository.dart`

**Status**: ⚠️ Completare interface
**Simboli**: Abstract class WorkoutRepository con 6 metodi
**Pattern**: Repository pattern interface
**Problemi Identificati**:

1. Metodi non return Either<Failure, T> (no error handling standard)
2. Missing methods (getWorkouts, createWorkout, updateWorkout, deleteWorkout)
3. No pagination support
4. No filtering/sorting options
5. No caching strategy defined

**Refactor**:

```dart
abstract class IWorkoutRepository {
  // Read operations
  Future<Either<Failure, List<WorkoutModel>>> getWorkouts({
    int page = 1,
    int limit = 20,
    WorkoutFilter? filter,
    WorkoutSort? sort,
  });

  Future<Either<Failure, WorkoutModel>> getWorkoutById(String id);

  Future<Either<Failure, WorkoutSessionModel>> getActiveWorkoutSession();

  Future<Either<Failure, List<WorkoutSessionModel>>> getWorkoutHistory({
    int page = 1,
    int limit = 20,
    DateTime? from,
    DateTime? to,
  });

  // Write operations
  Future<Either<Failure, WorkoutModel>> createWorkout(CreateWorkoutDto dto,);

  Future<Either<Failure, WorkoutModel>> updateWorkout(String id,
      UpdateWorkoutDto dto,);

  Future<Either<Failure, Unit>> deleteWorkout(String id);

  // Session operations
  Future<Either<Failure, WorkoutSessionModel>> startWorkoutSession(String workoutId,);

  Future<Either<Failure, WorkoutSessionModel>> completeSet(String sessionId,
      String exerciseId,
      String setId,);

  Future<Either<Failure, WorkoutSessionModel>> updateExercise(String sessionId,
      String exerciseId,
      UpdateExerciseDto dto,);

  Future<Either<Failure, WorkoutSessionModel>> completeWorkout(String sessionId,
      CompleteWorkoutDto dto,);

  Future<Either<Failure, Unit>> cancelWorkout(String sessionId);

  // Cache operations
  Future<Either<Failure, Unit>> clearCache();
}

// DTOs per type-safe operations
@freezed
class CreateWorkoutDto with _$CreateWorkoutDto {
  const factory CreateWorkoutDto({
    required String name,
    String? description,
    required List<ExerciseDto> exercises,
  }) = _CreateWorkoutDto;
}

@freezed
class WorkoutFilter with _$WorkoutFilter {
  const factory WorkoutFilter({
    String? searchQuery,
    List<String>? muscleGroups,
    WorkoutDifficulty? difficulty,
    bool? hasCoach,
  }) = _WorkoutFilter;
}

enum WorkoutSort {
  nameAsc,
  nameDesc,
  recentlyUsed,
  popularity,
  difficulty,
}
```

**Azioni Specifiche**:

1. Rename a IWorkoutRepository (interface convention)
2. Aggiungere Either<Failure, T> per tutti i metodi
3. Implementare missing CRUD operations
4. Aggiungere pagination support
5. Creare DTOs per operations
6. Aggiungere filtering/sorting
7. Definire cache strategy

---

### `pages/workout/data/repositories/workout_repository_impl.dart`

**Status**: ⚠️ Refactor completo
**Simboli**: WorkoutRepositoryImpl con useMockData flag
**Pattern**: Repository implementation con mock data
**Problemi Identificati**:

1. useMockData hardcoded (dovrebbe essere injectable)
2. No caching layer
3. Direct service calls (no error mapping)
4. Missing implementations per nuovi metodi
5. No retry logic
6. No offline support

**Refactor**:

```dart
class WorkoutRepositoryImpl implements IWorkoutRepository {
  final WorkoutService _service;
  final CacheManager _cache;
  final NetworkInfo _networkInfo;
  final bool _useMockData;

  WorkoutRepositoryImpl({
    required WorkoutService service,
    required CacheManager cache,
    required NetworkInfo networkInfo,
    bool useMockData = false,
  })
      : _service = service,
        _cache = cache,
        _networkInfo = networkInfo,
        _useMockData = useMockData;

  @override
  Future<Either<Failure, List<WorkoutModel>>> getWorkouts({
    int page = 1,
    int limit = 20,
    WorkoutFilter? filter,
    WorkoutSort? sort,
  }) async {
    try {
      // Check cache first
      final cacheKey = 'workouts_${page}_${limit}_${filter}_${sort}';
      final cached = await _cache.get<List<WorkoutModel>>(cacheKey);
      if (cached != null) return Right(cached);

      // Check network
      if (!await _networkInfo.isConnected) {
        return Left(NetworkFailure('No internet connection'));
      }

      // Fetch from API
      final result = _useMockData
          ? await _service.getMockWorkouts()
          : await _service.getWorkouts(
        page: page,
        limit: limit,
        filter: filter,
        sort: sort,
      );

      // Cache result
      await _cache.set(cacheKey, result);

      return Right(result);
    } on ApiException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutSessionModel>> getActiveWorkoutSession() async {
    try {
      final result = _useMockData
          ? await _service.getMockActiveWorkoutSession()
          : await _service.getActiveWorkoutSession();

      return Right(result);
    } on ApiException catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  // Implement all other methods...

  Failure _mapExceptionToFailure(ApiException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is ServerException) {
      return ServerFailure(exception.message, exception.statusCode);
    } else if (exception is UnauthorizedException) {
      return UnauthorizedFailure();
    } else if (exception is NotFoundException) {
      return NotFoundFailure();
    } else if (exception is ValidationException) {
      return ValidationFailure(exception.data as Map<String, String>);
    } else {
      return UnexpectedFailure(exception.message);
    }
  }
}
```

**Azioni Specifiche**:

1. Iniettare useMockData tramite constructor
2. Implementare caching layer
3. Aggiungere network check
4. Implementare error mapping to Failures
5. Completare tutti i metodi dell'interface
6. Aggiungere retry logic per failed requests
7. Implementare offline-first pattern

---

### `pages/workout/data/services/workout_service.dart`

**Status**: ⚠️ Refactor
**Simboli**: WorkoutService con API calls + mock method
**Pattern**: Service layer per API communication
**Problemi Identificati**:

1. Mock data mixed con real API calls
2. No request/response logging
3. Direct ApiClient usage (coupling)
4. No request cancellation support
5. Hardcoded endpoints (dovrebbero venire da ApiEndpoints)
6. No timeout configuration per request

**Refactor**:

```dart
class WorkoutService {
  final ApiClient _client;
  final Logger _logger;

  WorkoutService({
    required ApiClient client,
    Logger? logger,
  })
      : _client = client,
        _logger = logger ?? Logger('WorkoutService');

  Future<List<WorkoutModel>> getWorkouts({
    int page = 1,
    int limit = 20,
    WorkoutFilter? filter,
    WorkoutSort? sort,
  }) async {
    _logger.info('Fetching workouts: page=$page, limit=$limit');

    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (filter?.searchQuery != null) 'search': filter!.searchQuery!,
      if (sort != null) 'sort': sort.name,
    };

    final response = await _client.get(
      ApiEndpoints.workouts,
      queryParameters: queryParams,
    );

    _logger.info('Fetched ${response.length} workouts');

    return (response as List)
        .map((json) => WorkoutModel.fromJson(json))
        .toList();
  }

  Future<WorkoutSessionModel> getActiveWorkoutSession() async {
    _logger.info('Fetching active workout session');

    final response = await _client.get(
      ApiEndpoints.activeWorkout,
    );

    return WorkoutSessionModel.fromJson(response);
  }

  Future<WorkoutSessionModel> startWorkoutSession(String workoutId) async {
    _logger.info('Starting workout session: workoutId=$workoutId');

    final response = await _client.post(
      ApiEndpoints.workouts,
      body: {'workoutId': workoutId},
    );

    return WorkoutSessionModel.fromJson(response);
  }

  Future<WorkoutSessionModel> completeSet({
    required String sessionId,
    required String exerciseId,
    required String setId,
  }) async {
    _logger.info('Completing set: sessionId=$sessionId, setId=$setId');

    final response = await _client.post(
      ApiEndpoints.completeSet(sessionId),
      body: {
        'exerciseId': exerciseId,
        'setId': setId,
      },
    );

    return WorkoutSessionModel.fromJson(response);
  }

  Future<WorkoutSessionModel> updateExercise({
    required String sessionId,
    required String exerciseId,
    required UpdateExerciseDto dto,
  }) async {
    _logger.info('Updating workout_exercise_page: sessionId=$sessionId, exerciseId=$exerciseId');

    final response = await _client.put(
      '${ApiEndpoints.activeWorkout}/$sessionId/exercises/$exerciseId',
      body: dto.toJson(),
    );

    return WorkoutSessionModel.fromJson(response);
  }

  Future<WorkoutSessionModel> completeWorkout({
    required String sessionId,
    required CompleteWorkoutDto dto,
  }) async {
    _logger.info('Completing workout: sessionId=$sessionId');

    final response = await _client.post(
      '${ApiEndpoints.activeWorkout}/$sessionId/complete',
      body: dto.toJson(),
    );

    return WorkoutSessionModel.fromJson(response);
  }

  Future<void> cancelWorkout(String sessionId) async {
    _logger.info('Cancelling workout: sessionId=$sessionId');

    await _client.delete(
      '${ApiEndpoints.activeWorkout}/$sessionId',
    );
  }
}

// Spostare mock data in separate class
class MockWorkoutService implements WorkoutService {
  @override
  Future<WorkoutSessionModel> getActiveWorkoutSession() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return WorkoutSessionModel(/* mock data */);
  }

// ... other mock implementations
}
```

**Azioni Specifiche**:

1. Separare mock data in MockWorkoutService
2. Aggiungere logging strutturato
3. Usare ApiEndpoints per tutti gli endpoints
4. Aggiungere request cancellation support (CancelToken)
5. Implementare timeout per request specifici
6. Dependency injection per logger

---

### `pages/workout/domain/workout_controller.dart`

**Status**: ❌ Incompleto
**Simboli**: WorkoutController con solo 2 metodi (build, addWorkout)
**Pattern**: Riverpod Notifier
**Problemi Identificati**:

1. Implementazione vuota/stub
2. No state management
3. No business logic
4. Dovrebbe coordinare repository operations

**Refactor Completo**:

```dart
@freezed
class WorkoutState with _$WorkoutState {
  const factory WorkoutState({
    @Default([]) List<WorkoutModel> workouts,
    @Default(false) bool isLoading,
    String? errorMessage,
    WorkoutFilter? currentFilter,
    WorkoutSort? currentSort,
    @Default(1) int currentPage,
    @Default(false) bool hasMore,
  }) = _WorkoutState;
}

@riverpod
class WorkoutController extends _$WorkoutController {
  IWorkoutRepository get _repository => ref.read(workoutRepositoryProvider);

  @override
  Future<WorkoutState> build() async {
    return await loadWorkouts();
  }

  Future<WorkoutState> loadWorkouts({
    bool refresh = false,
  }) async {
    if (refresh) {
      state = const AsyncValue.loading();
    } else {
      state = AsyncValue.data(
        state.value?.copyWith(isLoading: true) ?? const WorkoutState(isLoading: true),
      );
    }

    final result = await _repository.getWorkouts(
      page: 1,
      limit: 20,
      filter: state.value?.currentFilter,
      sort: state.value?.currentSort,
    );

    return result.fold(
          (failure) {
        state = AsyncValue.data(
          state.value?.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ) ?? WorkoutState(isLoading: false, errorMessage: failure.message),
        );
        return state.value!;
      },
          (workouts) {
        state = AsyncValue.data(
          WorkoutState(
            workouts: workouts,
            isLoading: false,
            currentPage: 1,
            hasMore: workouts.length >= 20,
          ),
        );
        return state.value!;
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null || currentState.isLoading || !currentState.hasMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoading: true));

    final result = await _repository.getWorkouts(
      page: currentState.currentPage + 1,
      limit: 20,
      filter: currentState.currentFilter,
      sort: currentState.currentSort,
    );

    result.fold(
          (failure) {
        state = AsyncValue.data(
          currentState.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
          (workouts) {
        state = AsyncValue.data(
          currentState.copyWith(
            workouts: [...currentState.workouts, ...workouts],
            isLoading: false,
            currentPage: currentState.currentPage + 1,
            hasMore: workouts.length >= 20,
          ),
        );
      },
    );
  }

  Future<void> applyFilter(WorkoutFilter filter) async {
    state = AsyncValue.data(
      state.value?.copyWith(currentFilter: filter) ?? WorkoutState(currentFilter: filter),
    );
    await loadWorkouts(refresh: true);
  }

  Future<void> applySort(WorkoutSort sort) async {
    state = AsyncValue.data(
      state.value?.copyWith(currentSort: sort) ?? WorkoutState(currentSort: sort),
    );
    await loadWorkouts(refresh: true);
  }

  Future<void> createWorkout(CreateWorkoutDto dto) async {
    final result = await _repository.createWorkout(dto);

    result.fold(
          (failure) {
        // Handle error (show snackbar, etc.)
        state = AsyncValue.data(
          state.value?.copyWith(errorMessage: failure.message) ??
              WorkoutState(errorMessage: failure.message),
        );
      },
          (workout) {
        // Add to list
        state = AsyncValue.data(
          state.value?.copyWith(
            workouts: [workout, ...state.value!.workouts],
            errorMessage: null,
          ) ?? WorkoutState(workouts: [workout]),
        );
      },
    );
  }

  Future<void> deleteWorkout(String id) async {
    final result = await _repository.deleteWorkout(id);

    result.fold(
          (failure) {
        state = AsyncValue.data(
          state.value?.copyWith(errorMessage: failure.message) ??
              WorkoutState(errorMessage: failure.message),
        );
      },
          (_) {
        // Remove from list
        final currentState = state.value;
        if (currentState != null) {
          state = AsyncValue.data(
            currentState.copyWith(
              workouts: currentState.workouts.where((w) => w.id != id).toList(),
              errorMessage: null,
            ),
          );
        }
      },
    );
  }
}
```

**Azioni Specifiche**:

1. Implementare WorkoutState con Freezed
2. Completare tutti i metodi CRUD
3. Aggiungere pagination logic
4. Implementare filtering/sorting
5. Error handling con user feedback
6. Loading states management
7. Optimistic updates dove appropriato

---

### `pages/workout/providers/workout_provider.dart`

**Status**: ❌ Solo dichiarazione
**Simboli**: Solo `workoutProvider` variable
**Problemi Identificati**:

1. Provider vuoto/stub
2. No implementation

**Azione**: Eliminare file - provider sarà generato da workout_controller.dart con @riverpod
annotation

---

### `pages/workout/providers/workout_session_provider.dart`

**Status**: ✅ Buono ma migliorare
**Simboli**: WorkoutSessionState, WorkoutSessionNotifier, providers
**Pattern**: Riverpod Notifier con state management
**Problemi Identificati**:

1. State non usa Freezed (manual copyWith)
2. Error handling non type-safe
3. Alcune logiche potrebbero essere estratte
4. No optimistic updates
5. No undo/redo functionality

**Refactor**:

```dart
@freezed
class WorkoutSessionState with _$WorkoutSessionState {
  const factory WorkoutSessionState({
    WorkoutSessionModel? session,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default([]) List<String> completedSetIds, // per animations
  }) = _WorkoutSessionState;

  bool get hasError => errorMessage != null;

  bool get hasData => session != null;
}

@riverpod
class WorkoutSessionNotifier extends _$WorkoutSessionNotifier {
  IWorkoutRepository get _repository => ref.read(workoutRepositoryProvider);

  @override
  WorkoutSessionState build() {
    return const WorkoutSessionState();
  }

  Future<void> loadWorkoutSession(String sessionId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repository.getActiveWorkoutSession();

    result.fold(
          (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
          (session) {
        state = state.copyWith(
          session: session,
          isLoading: false,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> toggleSetCompletion(String exerciseId, String setId) async {
    final session = state.session;
    if (session == null) return;

    // Optimistic update
    final updatedSession = _toggleSetCompletionLocally(session, exerciseId, setId);
    state = state.copyWith(
      session: updatedSession,
      completedSetIds: [...state.completedSetIds, setId],
    );

    // API call
    final result = await _repository.completeSet(
      session.id,
      exerciseId,
      setId,
    );

    result.fold(
          (failure) {
        // Revert optimistic update
        state = state.copyWith(
          session: session,
          errorMessage: failure.message,
          completedSetIds: state.completedSetIds.where((id) => id != setId).toList(),
        );
      },
          (updatedSession) {
        state = state.copyWith(
          session: updatedSession,
          errorMessage: null,
        );

        // Clear completed animation after delay
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            state = state.copyWith(
              completedSetIds: state.completedSetIds.where((id) => id != setId).toList(),
            );
          }
        });
      },
    );
  }

  WorkoutSessionModel _toggleSetCompletionLocally(WorkoutSessionModel session,
      String exerciseId,
      String setId,) {
    final exercises = session.exercises.map((exercise) {
      if (exercise.id != exerciseId) return exercise;

      final sets = exercise.sets.map((set) {
        if (set.id != setId) return set;
        return set.copyWith(
          completed: !set.completed,
          completedAt: set.completed ? null : DateTime.now(),
        );
      }).toList();

      return exercise.copyWith(sets: sets);
    }).toList();

    return session.copyWith(exercises: exercises);
  }

  Future<void> updateSetWeight(String exerciseId,
      String setId,
      double weight,) async {
    final session = state.session;
    if (session == null) return;

    // Optimistic update
    final updatedSession = _updateSetLocally(
      session,
      exerciseId,
      setId,
          (set) => set.copyWith(weight: weight),
    );
    state = state.copyWith(session: updatedSession);

    // Debounce API call
    _debounceUpdateSet(exerciseId, setId);
  }

  Timer? _updateTimer;

  void _debounceUpdateSet(String exerciseId, String setId) {
    _updateTimer?.cancel();
    _updateTimer = Timer(const Duration(milliseconds: 500), () {
      _performSetUpdate(exerciseId, setId);
    });
  }

  Future<void> _performSetUpdate(String exerciseId, String setId) async {
    final session = state.session;
    if (session == null) return;

    final result = await _repository.updateExercise(
      session.id,
      exerciseId,
      UpdateExerciseDto(/* ... */),
    );

    result.fold(
          (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
          (updatedSession) {
        state = state.copyWith(
          session: updatedSession,
          errorMessage: null,
        );
      },
    );
  }

  // ... altri metodi simili

  Future<void> completeWorkout({
    required int rating,
    String? notes,
  }) async {
    final session = state.session;
    if (session == null) return;

    state = state.copyWith(isLoading: true);

    final result = await _repository.completeWorkout(
      session.id,
      CompleteWorkoutDto(
        rating: rating,
        notes: notes,
      ),
    );

    result.fold(
          (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
          (completedSession) {
        state = state.copyWith(
          session: completedSession,
          isLoading: false,
          errorMessage: null,
        );

        // Navigate away or show success
        ref.read(navigationProvider.notifier).set(0); // Home
      },
    );
  }
}

// Helper per update locale
WorkoutSessionModel _updateSetLocally(WorkoutSessionModel session,
    String exerciseId,
    String setId,
    SetModel Function(SetModel) update,) {
  final exercises = session.exercises.map((exercise) {
    if (exercise.id != exerciseId) return exercise;

    final sets = exercise.sets.map((set) {
      if (set.id != setId) return set;
      return update(set);
    }).toList();

    return exercise.copyWith(sets: sets);
  }).toList();

  return session.copyWith(exercises: exercises);
}
```

**Azioni Specifiche**:

1. Convertire state a Freezed
2. Implementare optimistic updates per UX immediata
3. Aggiungere debouncing per updates frequenti
4. Implementare animations tracking (completedSetIds)
5. Error recovery con revert di optimistic updates
6. Migliorare type-safety con Either pattern

---

## 📁 PRESENTATION LAYER - WORKOUT

### `pages/workout/ui/workout_page.dart`

**Status**: ⚠️ Refactor
**Simboli**: WorkoutPage con StatefulWidget + private methods
**Pattern**: StatefulWidget (vecchio pattern)
**Problemi Identificati**:

1. Usa StatefulWidget invece di ConsumerWidget
2. Hardcoded data (lista workouts)
3. No provider integration
4. Builder methods privati (va bene ma potrebbero essere widget separati)
5. No loading/error states
6. No pull-to-refresh
7. FAB posizione fissa (dovrebbe essere context-aware)

**Refactor**:

```dart
class WorkoutPage extends ConsumerWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: workoutState.when(
          data: (state) => _buildContent(context, ref, state),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildError(context, ref, error),
        ),
      ),
      floatingActionButton: _buildFAB(context, ref),
    );
  }

  Widget _buildContent(BuildContext context,
      WidgetRef ref,
      WorkoutState state,) {
    if (state.workouts.isEmpty && !state.isLoading) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(workoutControllerProvider.notifier).loadWorkouts(refresh: true);
      },
      child: CustomScrollView(
        slivers: [
          _buildHeader(context),
          _buildActiveWorkoutsSection(context, ref, state),
          _buildAllWorkoutsSection(context, ref, state),
          if (state.hasMore && !state.isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(workoutControllerProvider.notifier).loadMore();
                  },
                  child: const Text('Load More'),
                ),
              ),
            ),
          if (state.isLoading && state.workouts.isNotEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: WorkoutHeader(),
    );
  }

  Widget _buildActiveWorkoutsSection(BuildContext context,
      WidgetRef ref,
      WorkoutState state,) {
    final activeWorkouts = state.workouts.where((w) => w.isActive).toList();

    if (activeWorkouts.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Allenamenti Attivi',
            subtitle: _buildActiveSubtitle(activeWorkouts.length),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: activeWorkouts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return WorkoutRecentCard(workout: activeWorkouts[index]);
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAllWorkoutsSection(BuildContext context,
      WidgetRef ref,
      WorkoutState state,) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  _SectionHeader(
                    title: 'Tutti gli Allenamenti',
                    trailing: _buildFilterButton(context, ref),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }

            final workout = state.workouts[index - 1];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: WorkoutCard(workout: workout),
            );
          },
          childCount: state.workouts.length + 1,
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        // Show filter bottom sheet
        _showFilterSheet(context, ref);
      },
      icon: const Icon(Icons.filter_list),
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFF1A1A2E),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => WorkoutFilterSheet(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Nessun allenamento',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inizia creando il tuo primo allenamento',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Si è verificato un errore',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(workoutControllerProvider);
            },
            child: const Text('Riprova'),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () {
        // Navigate to create workout
        context.push('/workout/create');
      },
      icon: const Icon(Icons.add),
      label: const Text('Nuovo Allenamento'),
      backgroundColor: const Color(0xFF7C3AED),
    );
  }

  String _buildActiveSubtitle(int count) {
    if (count == 1) return '1 allenamento in corso';
    return '$count allenamenti in corso';
  }
}

// Estrarre in widget separato
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
```

**Azioni Specifiche**:

1. Convertire a ConsumerWidget
2. Integrare con workoutControllerProvider
3. Implementare loading/error/empty states
4. Aggiungere pull-to-refresh
5. Implementare pagination con "Load More"
6. Estrarre _SectionHeader in widget riusabile
7. Aggiungere filter functionality
8. Implementare search
9. Animations per list items

---

### `pages/workout/ui/active/workout_active_page.dart`

**Status**: ⚠️ Refactor pesante
**Simboli**: WorkoutActivePage con ConsumerStatefulWidget
**Pattern**: ConsumerStatefulWidget con listener
**Problemi Identificati**:

1. ConsumerStatefulWidget quando potrebbe essere ConsumerWidget
2. Listener in build method (non ideale)
3. TODO comments non risolti
4. _startRestTimer method non collegato a UI
5. Hardcoded timer duration (90 seconds)
6. Helper methods (_getExerciseTitle, etc.) potrebbero essere extensions
7. No gestione back button (workout in progress)
8. No auto-save functionality

**Refactor**:

```dart
class WorkoutActivePage extends ConsumerWidget {
  final String workoutId;

  const WorkoutActivePage({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(workoutSessionProvider(workoutId));
    final restTimerState = ref.watch(restTimerProvider);

    // Listen per rest complete dialog
    ref.listen<RestTimerState>(
      restTimerProvider,
          (previous, next) {
        if (_shouldShowRestCompleteDialog(previous, next)) {
          _showRestCompleteDialog(context);
        }
      },
    );

    return WillPopScope(
      onWillPop: () async {
        return await _confirmExit(context, sessionState);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: sessionState.when(
          data: (state) => _buildContent(context, ref, state, restTimerState),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _buildError(context, error),
        ),
      ),
    );
  }

  bool _shouldShowRestCompleteDialog(RestTimerState? previous,
      RestTimerState next,) {
    return previous != null &&
        previous.isActive &&
        previous.remainingSeconds > 0 &&
        next.remainingSeconds == 0 &&
        !next.isActive;
  }

  void _showRestCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const RestCompleteDialog(),
    );
  }

  Future<bool> _confirmExit(BuildContext context,
      AsyncValue<WorkoutSessionState> sessionState,) async {
    final session = sessionState.value?.session;
    if (session == null || session.status == WorkoutSessionStatus.completed) {
      return true;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Uscire dall\'allenamento?'),
            content: const Text(
              'I tuoi progressi verranno salvati. Vuoi uscire?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annulla'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Esci'),
              ),
            ],
          ),
    );

    return confirm ?? false;
  }

  Widget _buildContent(BuildContext context,
      WidgetRef ref,
      WorkoutSessionState state,
      RestTimerState restTimerState,) {
    final session = state.session;
    if (session == null) {
      return const Center(child: Text('Sessione non trovata'));
    }

    return SafeArea(
      child: Stack(
        children: [
          // Main content
          Column(
            children: [
              ActiveAppBar(
                workoutName: session.workoutPlanName,
                duration: _formatDuration(session.durationMinutes ?? 0),
                onBack: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: session.exercises.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final exercise = session.exercises[index];
                    return ExerciseCard(
                      key: ValueKey(exercise.id),
                      exercise: exercise,
                      onSetCompleted: (setId) {
                        _handleSetCompleted(ref, session, exercise, setId);
                      },
                      onWeightChanged: (setId, weight) {
                        ref
                            .read(workoutSessionProvider(workoutId).notifier)
                            .updateSetWeight(exercise.id, setId, weight);
                      },
                      onRepsChanged: (setId, reps) {
                        ref
                            .read(workoutSessionProvider(workoutId).notifier)
                            .updateSetReps(exercise.id, setId, reps);
                      },
                    );
                  },
                ),
              ),
              ActiveBottomBar(
                completedSets: session.completedSetsCount,
                totalSets: session.totalSets,
                onComplete: () => _handleCompleteWorkout(context, ref, session),
              ),
            ],
          ),

          // Rest timer overlay (se attivo)
          if (restTimerState.isActive)
            RestTimerOverlay(
              remainingSeconds: restTimerState.remainingSeconds,
              totalSeconds: restTimerState.totalSeconds,
              onSkip: () {
                ref.read(restTimerProvider.notifier).cancelTimer();
              },
              onAddTime: () {
                ref.read(restTimerProvider.notifier).addTime(30);
              },
            ),
        ],
      ),
    );
  }

  void _handleSetCompleted(WidgetRef ref,
      WorkoutSessionModel session,
      ExerciseModel exercise,
      String setId,) {
    // Toggle set completion
    ref
        .read(workoutSessionProvider(workoutId).notifier)
        .toggleSetCompletion(exercise.id, setId);

    // Start rest timer se set è ora completato
    final set = exercise.sets.firstWhereOrNull((s) => s.id == setId);
    if (set != null && !set.completed) {
      ref
          .read(restTimerProvider.notifier)
          .startTimer(exercise.restSeconds);
    }
  }

  Future<void> _handleCompleteWorkout(BuildContext context,
      WidgetRef ref,
      WorkoutSessionModel session,) async {
    // Show rating dialog
    final result = await showDialog<CompleteWorkoutResult>(
      context: context,
      builder: (context) =>
          CompleteWorkoutDialog(
            session: session,
          ),
    );

    if (result != null) {
      await ref
          .read(workoutSessionProvider(workoutId).notifier)
          .completeWorkout(
        rating: result.rating,
        notes: result.notes,
      );

      if (context.mounted) {
        // Navigate to summary or home
        context.go('/workout/summary/${session.id}');
      }
    }
  }

  Widget _buildError(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Errore nel caricamento dell\'allenamento',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }
}

// Dialogs separati
class CompleteWorkoutDialog extends StatefulWidget {
  final WorkoutSessionModel session;

  const CompleteWorkoutDialog({super.key, required this.session});

  @override
  State<CompleteWorkoutDialog> createState() => _CompleteWorkoutDialogState();
}

class _CompleteWorkoutDialogState extends State<CompleteWorkoutDialog> {
  int _rating = 3;
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Completa Allenamento'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Come è andato l\'allenamento?'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() => _rating = index + 1);
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Note (opzionale)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              CompleteWorkoutResult(
                rating: _rating,
                notes: _notesController.text.isEmpty
                    ? null
                    : _notesController.text,
              ),
            );
          },
          child: const Text('Completa'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}

class CompleteWorkoutResult {
  final int rating;
  final String? notes;

  CompleteWorkoutResult({required this.rating, this.notes});
}
```

**Azioni Specifiche**:

1. Convertire a ConsumerWidget (rimuovere State)
2. Implementare WillPopScope per conferma uscita
3. Collegare rest timer a set completion
4. Estrarre dialogs in widget separati
5. Aggiungere complete workout flow con rating
6. Auto-save progressi periodicamente
7. Migliorare error handling
8. Aggiungere animations per transitions

---

Continuo con analisi dettagliata di TUTTI gli altri file nei prossimi messaggi per completezza come
richiesto...

**File analizzati finora**: 20/60+
**Prossimi**: widgets, providers, routes, config, utils

