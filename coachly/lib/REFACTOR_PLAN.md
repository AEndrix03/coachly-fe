# Piano di Refactor - Coachly Flutter

## Stato Attuale

### Struttura Progetto
```
lib/
├── config/          # ✅ OK
├── core/            # ⚠️ Incompleto (solo network)
├── models/          # ❌ Vuoto
├── pages/           # ⚠️ Mix architetture
│   ├── home/        # ❌ Singolo file, no architettura
│   └── workout/     # ✅ Parzialmente Clean Architecture
├── providers/       # ✅ OK (navigation globale)
├── routes/          # ✅ OK
├── services/        # ❌ Vuoto
├── themes/          # ✅ OK
├── utils/           # ✅ OK
└── widgets/         # ⚠️ Mix globale/specifico
```

### Problemi Identificati

#### 1. **Architettura Inconsistente**
- Workout: segue Clean Architecture (data/domain/ui)
- Home: file singolo senza struttura
- Mancano: auth, nutrition, community, coach

#### 2. **State Management Misto**
- WorkoutActivePage: ConsumerStatefulWidget (OK)
- Ma usa ancora StatefulWidget pattern manualmente
- Provider non sempre usati correttamente

#### 3. **Naming Non Standard**
- `pages/` invece di `features/` (convenzione Flutter)
- File duplicati: `workout_active_page.dart` + `workout_active_page_refactored.dart`
- `models/` globale vuoto vs models dentro features

#### 4. **Separazione Components**
- Widget complessi non componentizzati abbastanza
- Logica UI mescolata con business logic in alcuni casi
- Widgets "shared" vs "common" non chiaro

#### 5. **Mancanza Best Practices**
- No Freezed per models immutabili
- No code generation (solo Riverpod basics)
- No dependency injection pattern
- No error handling centralizzato

## Piano di Refactor

### 🔴 PRIORITÀ ALTA (Fase 1)

#### 1.1 Ristrutturazione Folder Architecture
**Target**: Passare da `pages/` a `features/`

```
lib/
├── core/                    # NEW: Core utilities
│   ├── constants/          # API endpoints, configs
│   ├── error/              # Error handling
│   ├── network/            # ✅ Esistente
│   ├── storage/            # Local storage
│   └── utils/              # Helpers globali
│
├── features/               # RENAME da pages/
│   ├── auth/              # NEW
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── services/
│   │   ├── domain/
│   │   │   ├── controllers/
│   │   │   └── entities/
│   │   └── presentation/  # RENAME da ui/
│   │       ├── pages/
│   │       ├── providers/
│   │       └── widgets/
│   │
│   ├── home/              # REFACTOR
│   │   └── ... (stessa struttura)
│   │
│   ├── workout/           # REFACTOR esistente
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── nutrition/         # NEW
│   ├── community/         # NEW
│   └── coach/             # NEW
│
├── shared/                # NEW: Widget condivisi
│   ├── widgets/
│   ├── models/
│   └── extensions/
│
├── config/                # ✅ Mantieni
├── providers/             # Globali (auth, theme)
├── routes/                # ✅ Mantieni
└── themes/                # ✅ Mantieni
```

**Azioni**:
1. Creare struttura `core/` completa
2. Rename `pages/` → `features/`
3. Rename `ui/` → `presentation/` in ogni feature
4. Creare `shared/` per widget riutilizzabili
5. Eliminare `models/` root (spostare in features o shared)

#### 1.2 Pulizia File Ridondanti
**Eliminare**:
- `workout_active_page_refactored.dart` → merge in principale
- `exercise_card_refactored.dart` → merge in principale
- `main_example.dart` → spostare in docs o eliminare
- File MD duplicati (BEFORE_AFTER_COMPARISON, REFACTORING_README)

#### 1.3 Standardizzazione Naming
**Convenzioni**:
```dart
// Files
feature_name_page.dart           // Pages
feature_name_controller.dart     // Controllers
feature_name_provider.dart       // Providers
feature_name_model.dart          // Models
feature_name_repository.dart     // Repositories
feature_name_service.dart        // Services

// Classes
FeatureNamePage                  // Pages
FeatureNameController            // Controllers
featureNameProvider              // Providers (camelCase)
FeatureNameModel                 // Models
IFeatureNameRepository           // Repository interfaces
FeatureNameRepositoryImpl        // Repository implementations

// Widgets
feature_name_widget.dart         // Generic widgets
feature_name_card.dart           // Card components
feature_name_button.dart         // Button components
```

**Azioni**:
1. Rinominare tutti i file secondo convenzione
2. Rinominare classi corrispondenti
3. Update import statements

### 🟡 PRIORITÀ MEDIA (Fase 2)

#### 2.1 Implementazione Freezed per Models
**Target**: Models immutabili type-safe

```dart
// Prima
class WorkoutModel {
  final String id;
  final String name;
  // ... manual implementation
}

// Dopo
@freezed
class WorkoutModel with _$WorkoutModel {
  const factory WorkoutModel({
    required String id,
    required String name,
    // ... auto equality, copyWith, serialization
  }) = _WorkoutModel;
  
  factory WorkoutModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutModelFromJson(json);
}
```

**Azioni**:
1. Aggiungere `freezed` e `json_serializable` a pubspec.yaml
2. Convertire tutti i models esistenti
3. Setup build_runner
4. Generare codice

#### 2.2 Separazione Presentation Logic
**Pattern**: ConsumerWidget + Provider (no StatefulWidget)

```dart
// Prima (WorkoutActivePage)
class WorkoutActivePage extends ConsumerStatefulWidget {
  // ... manual state management
}

// Dopo
class WorkoutActivePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutActiveProvider);
    // ... solo UI rendering
  }
}

// Logica in Provider
@riverpod
class WorkoutActiveNotifier extends _$WorkoutActiveNotifier {
  @override
  WorkoutActiveState build() => WorkoutActiveState.initial();
  
  void startRestTimer() { /* logic */ }
  void completeSet() { /* logic */ }
  // ... tutta la business logic
}
```

**Azioni**:
1. Identificare tutti i StatefulWidget con logica
2. Estrarre logica in Notifier/Controller
3. Convertire a ConsumerWidget
4. Testare funzionalità

#### 2.3 Componentizzazione Widget Complessi
**Target**: Widget riutilizzabili e testabili

Scomporre:
- `ExerciseCard` → ExerciseCard + ExerciseHeader + ExerciseStats + SetsList
- `WorkoutDetailPage` → Header + StatsSection + ExerciseList + DescriptionSection
- `ActiveAppBar` → AppBar + TimerDisplay + Actions

**Pattern**:
```dart
// Atomic Design inspired
widgets/
├── atoms/          # Pulsanti, testi, icone base
├── molecules/      # Combinazione atoms (card, input)
└── organisms/      # Sezioni complesse (header, list)
```

#### 2.4 Error Handling Centralizzato
**Creare**:
```
core/
└── error/
    ├── failures.dart       # Failure classes
    ├── exceptions.dart     # Exception classes
    └── error_handler.dart  # Centralized handler
```

**Implementare Either<Failure, T> pattern**:
```dart
Future<Either<Failure, Workout>> getWorkout(String id) async {
  try {
    final result = await service.fetchWorkout(id);
    return Right(result);
  } on NetworkException {
    return Left(NetworkFailure());
  }
}
```

### 🟢 PRIORITÀ BASSA (Fase 3)

#### 3.1 Dependency Injection
**Setup GetIt o Riverpod DI**:
```dart
// service_locator.dart
final getIt = GetIt.instance;

void setupServiceLocator() {
  // Repositories
  getIt.registerLazySingleton<IWorkoutRepository>(
    () => WorkoutRepositoryImpl(getIt())
  );
  
  // Services
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient()
  );
}
```

#### 3.2 Testing Infrastructure
**Setup**:
- Unit tests per controllers/providers
- Widget tests per components
- Integration tests per flows
- Golden tests per UI consistency

```
test/
├── unit/
│   ├── features/
│   └── core/
├── widget/
└── integration/
```

#### 3.3 Documentation
**Aggiungere**:
- Dart doc per public APIs
- README per ogni feature
- Architecture decision records (ADR)

#### 3.4 CI/CD Setup
- Flutter analyze
- Tests automatici
- Build automation
- Code coverage reports

## Refactor per File Specifico

### Workout Feature

#### `workout_active_page.dart`
**Problemi**:
- Logica timer mista con UI
- `_startRestTimer()` method in State
- TODO comments non risolti
- Listener in build method

**Refactor**:
1. Estrarre logica in `WorkoutActiveController`
2. Creare `WorkoutActiveState` model
3. Spostare timer logic in provider dedicato
4. Scomporre widget in components più piccoli

#### `exercise_card.dart`
**Problemi**:
- Widget troppo grande (>200 LOC)
- Logica set management dentro widget
- Hard-coded strings
- No separation of concerns

**Refactor**:
1. Split in: ExerciseCardHeader + ExerciseSetsList + ExerciseActions
2. Estrarre logica in controller
3. Usare l10n per strings
4. Atomic design pattern

#### `workout_provider.dart`
**Status**: Solo dichiarazione provider, implementare logica

**Aggiungere**:
```dart
@riverpod
class WorkoutNotifier extends _$WorkoutNotifier {
  @override
  Future<List<Workout>> build() async {
    return _fetchWorkouts();
  }
  
  Future<void> createWorkout(CreateWorkoutDto dto) async {
    // Implementation
  }
  
  Future<void> deleteWorkout(String id) async {
    // Implementation
  }
}
```

### Home Feature

#### `home.dart`
**Problemi**:
- File singolo senza architettura
- Tutto hardcoded
- No state management

**Refactor Completo**:
```
features/home/
├── data/
│   ├── models/
│   │   └── dashboard_stats_model.dart
│   └── repositories/
│       └── home_repository.dart
├── domain/
│   └── controllers/
│       └── home_controller.dart
└── presentation/
    ├── pages/
    │   └── home_page.dart
    ├── providers/
    │   └── home_provider.dart
    └── widgets/
        ├── stats_card.dart
        ├── quick_actions.dart
        └── recent_activity.dart
```

### Common Widgets

#### `widgets/common/` vs `widgets/shared/`
**Decisione**: Unificare in `shared/widgets/`

**Riorganizzare**:
```
shared/
└── widgets/
    ├── buttons/
    │   ├── primary_button.dart
    │   └── icon_button.dart
    ├── cards/
    │   ├── base_card.dart
    │   └── stat_card.dart
    ├── inputs/
    ├── navigation/
    └── feedback/
        ├── ai_coach_widget.dart
        └── rest_timer_widget.dart
```

## Checklist Migrazione

### Per Ogni Feature
- [ ] Creare struttura data/domain/presentation
- [ ] Implementare models con Freezed
- [ ] Creare repository interface + implementation
- [ ] Implementare controller con Riverpod
- [ ] Setup provider
- [ ] Convertire pages a ConsumerWidget
- [ ] Scomporre widgets complessi
- [ ] Aggiungere error handling
- [ ] Scrivere tests
- [ ] Documentare

### Globale
- [ ] Ristrutturare folders (pages → features)
- [ ] Setup core/ completo
- [ ] Implementare shared/ widgets
- [ ] Standardizzare naming
- [ ] Rimuovere file ridondanti
- [ ] Setup build_runner per codegen
- [ ] Implementare DI
- [ ] Setup testing infrastructure
- [ ] Aggiungere CI/CD

## Ordine Implementazione Consigliato

### Sprint 1 - Foundation (Settimana 1-2)
1. Ristrutturazione folders
2. Pulizia file ridondanti
3. Standardizzazione naming
4. Setup core/ structure

### Sprint 2 - Workout Refactor (Settimana 3-4)
1. Refactor workout feature completo
2. Implementare Freezed
3. Separare presentation logic
4. Componentizzare widgets

### Sprint 3 - Altri Features (Settimana 5-6)
1. Refactor home
2. Creare struttura auth
3. Setup shared widgets
4. Error handling

### Sprint 4 - Testing & Polish (Settimana 7-8)
1. DI setup
2. Tests infrastructure
3. Documentation
4. CI/CD

## Note Finali

### Non Rompere la Grafica
**Critici da Preservare**:
- Color scheme (theme.dart)
- Layout spacing e padding
- Animazioni esistenti
- Glassmorphism effects
- Gradient designs

**Approach**: Refactor logico e strutturale, UI identica o migliorata

### Alternative Components
Se si vogliono alternative per components:
- `flutter_hooks` per state locale semplice
- `go_router` advanced patterns
- Custom animations con `AnimatedContainer`
- Ma: testare prima, deploy dopo

### Performance
Dopo refactor verificare:
- Build times
- Hot reload speed
- App startup
- Memory usage
- Frame rendering (60fps)
