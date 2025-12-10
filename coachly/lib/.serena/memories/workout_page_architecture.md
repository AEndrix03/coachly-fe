# Workout Page - Architettura e Struttura

## 📁 Struttura Cartelle

```
features/workout/workout_page/
├── presentation/
│   ├── workout_page.dart                 # Main page (ConsumerStatefulWidget)
│   └── widgets/
│       ├── workout_card.dart            # Card lista completa
│       ├── workout_recent_card.dart     # Card workout recenti (più grande)
│       ├── workout_header.dart          # Header con gradient
│       └── workout_stats_overview.dart  # Stats overview (commentato)
├── providers/
│   ├── workout_list_provider/
│   │   ├── workout_list_provider.dart   # Provider lista workout (@riverpod)
│   │   └── workout_list_provider.g.dart # Generated
│   └── workout_stats_provider/
│       ├── workout_stats_provider.dart  # Provider statistiche (@riverpod)
│       └── workout_stats_provider.g.dart
├── data/
│   ├── services/
│   │   └── workout_page_service.dart    # API service
│   ├── repositories/
│   │   ├── workout_page_repository.dart      # Interface
│   │   └── workout_page_repository_impl.dart # Implementation (con mock)
│   └── models/
│       ├── workout_model/
│       │   ├── workout_model.dart
│       │   ├── workout_model.freezed.dart
│       │   └── workout_model.g.dart
│       ├── workout_stats_model/
│       │   ├── workout_stats_model.dart
│       │   ├── workout_stats_model.freezed.dart
│       │   └── workout_stats_model.g.dart
│       └── workout_filter_model/
           ├── workout_filter_model.dart
           ├── workout_filter_model.freezed.dart
           └── workout_filter_model.g.dart
```

## 🏗️ Architettura

### Clean Architecture Pattern

**Presentation Layer**
- Widget: `WorkoutPage` (ConsumerStatefulWidget)
- State Management: Riverpod con code generation (@riverpod)
- UI Components: Widgets riutilizzabili (cards, header)

**Domain Layer**
- Repository Interface: `IWorkoutPageRepository`
- Models: Freezed immutable models

**Data Layer**
- Service: `WorkoutPageService` (chiamate API tramite ApiClient)
- Repository Implementation: `WorkoutPageRepositoryImpl`
- Mock data support per sviluppo

### State Management (Riverpod)

**WorkoutListProvider**
```dart
@riverpod
class WorkoutListNotifier extends _$WorkoutListNotifier {
  @override
  WorkoutListState build() => const WorkoutListState();
  
  Future<void> loadWorkouts() async { ... }
  Future<void> refresh() => loadWorkouts();
}
```

**State Class Pattern**
```dart
class WorkoutListState {
  final List<WorkoutModel> workouts;
  final List<WorkoutModel> recentWorkouts;
  final bool isLoading;
  final String? errorMessage;
  
  bool get hasError => errorMessage != null;
  bool get isEmpty => workouts.isEmpty && !isLoading;
}
```

## 🎨 UI Components

### WorkoutPage (Main)
- **Gradient Header** con SafeArea
- **Stats Overview** (attualmente commentato)
- **Recent Workouts** (horizontal ListView)
- **All Workouts** (vertical ListView)
- **FAB** per creazione workout
- **RefreshIndicator** per pull-to-refresh
- **Shimmer loading** durante caricamento

### WorkoutCard (Lista completa)
- Glassmorphism effect (BackdropFilter blur)
- AnimatedScale per tap feedback
- SparkleTapAnimation
- Info chips: esercizi, coach
- Coach badge
- Navigazione con GoRouter

### WorkoutRecentCard (Card recenti)
- Design più elaborato e grande
- Progress indicator con percentuale
- Stats chips (esercizi, durata, goal)
- "Inizia Workout" button
- Last used info
- Coach info

### WorkoutHeader
- Gradient background (3 colori)
- Glass icon buttons (settings, notifications)
- Quick stats: streak, weekly workouts
- Rounded bottom corners

## 📦 Models (Freezed)

### WorkoutModel
```dart
@freezed
class WorkoutModel with _$WorkoutModel {
  final String id;
  final String title;
  final String coach;
  final int progress;
  final int exercises;
  final int durationMinutes;
  final String goal;
  final String lastUsed;
}
```

### WorkoutStatsModel
```dart
@freezed
class WorkoutStatsModel with _$WorkoutStatsModel {
  final int activeWorkouts;
  final int completedWorkouts;
  final double progressPercentage;
  final int currentStreak;
  final int weeklyWorkouts;
}
```

### WorkoutFilterModel
```dart
enum WorkoutSortBy { name, date, duration, difficulty }

@freezed
class WorkoutFilterModel with _$WorkoutFilterModel {
  final WorkoutSortBy sortBy;
  final bool ascending;
  final String? searchQuery;
  final List<String>? coachIds;
}
```

## 🔄 Data Flow

```
UI (WorkoutPage)
  ↓ ref.read/watch
Provider (WorkoutListNotifier)
  ↓ ref.read
Repository (IWorkoutPageRepository)
  ↓
Service (WorkoutPageService)
  ↓
ApiClient
  ↓
Backend API / Mock Data
```

## 🛠️ Service Layer

### WorkoutPageService
```dart
class WorkoutPageService {
  final ApiClient _apiClient;
  
  Future<ApiResponse<List<WorkoutModel>>> fetchWorkouts() async {
    return await _apiClient.get<List<WorkoutModel>>(
      '/workouts',
      fromJson: (data) => data.map((json) => WorkoutModel.fromJson(json)).toList(),
    );
  }
  
  Future<ApiResponse<WorkoutStatsModel>> fetchWorkoutStats() async { ... }
  Future<ApiResponse<List<WorkoutModel>>> fetchRecentWorkouts() async { ... }
}
```

### Repository Pattern
```dart
abstract class IWorkoutPageRepository {
  Future<ApiResponse<List<WorkoutModel>>> getWorkouts();
  Future<ApiResponse<List<WorkoutModel>>> getRecentWorkouts();
  Future<ApiResponse<WorkoutStatsModel>> getWorkoutStats();
}

class WorkoutPageRepositoryImpl implements IWorkoutPageRepository {
  final WorkoutPageService _service;
  final bool useMockData;
  
  // Implementazione con supporto mock data
}
```

## 🎭 UI Patterns & Animations

### Tap Feedback
- **AnimatedScale**: 1.0 → 0.92 on tap
- **SparkleTapAnimation**: sparkle effect sulla posizione tap
- **Duration**: 120ms per responsività

### Loading States
- **Shimmer effect** durante caricamento iniziale
- **CircularProgressIndicator** per stats
- **isLoading check** prima di mostrare contenuto

### Error Handling
- **ShadAlert** per errori
- **errorMessage** nello state
- **hasError getter** per controllo

### Color Scheme
- **Primary gradient**: #2196F3 → #1976D2 → #7B4BC1
- **Glassmorphism**: backdrop blur + opacity
- **Dynamic theming**: usa ColorScheme di Material

## 🔗 Navigation

- **GoRouter** per navigazione
- Route: `/workouts/workout/{id}` per dettaglio workout
- `context.go()` per navigazione programmatica

## ⚡ Performance Optimizations

- **ListView.builder** per liste grandi
- **shrinkWrap + physics** per nested scroll
- **Shimmer base/highlight colors** dal theme
- **Const constructors** dove possibile
- **Separate widgets** per riusabilità

## 🚀 Future Enhancements

Attualmente commentati/TODO:
- Stats loading e display (WorkoutStatsOverview)
- Sort functionality (bottone sort presente ma non implementato)
- Filtri avanzati (WorkoutFilterModel pronto ma non usato)
- Creazione workout (FAB presente, funzionalità da implementare)

## 📝 Convenzioni Utilizzate

- **Naming**: snake_case per file, PascalCase per classi
- **State pattern**: isLoading, errorMessage, hasError getter
- **Dependency injection**: tramite Riverpod providers
- **Immutability**: Freezed per models
- **Code generation**: Riverpod + Freezed + JsonSerializable
- **Separation of concerns**: strict layer separation

## 🔧 Dependencies

- `flutter_riverpod` - State management
- `riverpod_annotation` - Code generation
- `freezed_annotation` - Immutable models
- `go_router` - Navigation
- `shadcn_ui` - UI components
- `shimmer` - Loading effects
- `gap` - Spacing
