# Development Guidelines - Coachly Frontend

## 🎯 Principi Fondamentali

### 1. Clean Code
- Scrivi codice **leggibile** e **manutenibile**
- Preferisci **semplicità** a complessità
- **DRY** (Don't Repeat Yourself) - evita duplicazione
- **KISS** (Keep It Simple, Stupid)

### 2. Flutter Best Practices
- Usa **const** ovunque possibile (performance)
- Preferisci **StatelessWidget** quando non serve stato mutabile
- **Estrai widget** quando diventano complessi (>50 righe)
- Usa **composition** over inheritance

### 3. State Management con Riverpod
- Usa **NotifierProvider** per stato complesso con business logic
- Usa **Provider** per valori semplici read-only
- **Evita** `ref.read()` in build methods, usa `ref.watch()`
- Mantieni la logica nei **Controller**, non nei Widget

## 🏗️ Architettura

### Feature-Based Structure
Ogni feature deve essere **auto-contenuta** e organizzata in:
```
pages/feature_name/
  ├── data/          # Models, repositories implementations
  ├── domain/        # Business logic, controllers
  ├── providers/     # Riverpod providers
  └── ui/            # Pages and widgets
      ├── widgets/   # Feature-specific widgets
      └── detail/    # Sub-pages
```

### Separation of Concerns
- **UI**: Presentation logic, layout, styling
- **Controllers**: Business logic, state management
- **Models**: Data structures
- **Repositories**: Data fetching/persistence
- **Services**: External integrations (API, storage)

## 📐 Design Patterns

### Repository Pattern
```dart
// Interface (opzionale per progetti piccoli)
abstract class WorkoutRepository {
  Future<List<Workout>> getWorkouts();
  Future<Workout> getWorkoutById(String id);
}

// Implementation
class WorkoutRepositoryImpl implements WorkoutRepository {
  final ApiClient _api;
  
  @override
  Future<List<Workout>> getWorkouts() async {
    final response = await _api.get('/workouts');
    return response.map((json) => Workout.fromJson(json)).toList();
  }
}
```

### Controller Pattern (Riverpod)
```dart
@riverpod
class WorkoutList extends _$WorkoutList {
  @override
  FutureOr<List<Workout>> build() async {
    // Load initial data
    return _loadWorkouts();
  }
  
  Future<void> addWorkout(Workout workout) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.addWorkout(workout);
      return _loadWorkouts();
    });
  }
  
  Future<List<Workout>> _loadWorkouts() async {
    final repo = ref.read(workoutRepositoryProvider);
    return repo.getWorkouts();
  }
}
```

### Dependency Injection (Riverpod)
```dart
// Provider per dependencies
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://api.coachly.io');
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepositoryImpl(ref.watch(apiClientProvider));
});

// Usage in controller
@riverpod
class WorkoutList extends _$WorkoutList {
  late final WorkoutRepository _repository;
  
  @override
  FutureOr<List<Workout>> build() {
    _repository = ref.watch(workoutRepositoryProvider);
    return _repository.getWorkouts();
  }
}
```

## 🎨 UI/UX Guidelines

### Responsive Design
```dart
// Usa MediaQuery per dimensioni schermo
final screenWidth = MediaQuery.of(context).size.width;
final isTablet = screenWidth > 600;

// Usa LayoutBuilder per layout adattivi
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return TabletLayout();
    }
    return PhoneLayout();
  },
)
```

### Theme Usage
```dart
// Usa sempre theme per colori e stili
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Title',
    style: Theme.of(context).textTheme.titleLarge,
  ),
)

// Non hardcodare colori
// ❌ Bad
color: Color(0xFF3B82F6)

// ✅ Good
color: Theme.of(context).colorScheme.primary
```

### Accessibility
```dart
// Usa Semantics per screen readers
Semantics(
  label: 'Workout card for chest day',
  button: true,
  child: WorkoutCard(...),
)

// Tap targets minimo 48x48
SizedBox(
  width: 48,
  height: 48,
  child: IconButton(...),
)
```

## 🔄 Async Patterns

### Gestione AsyncValue (Riverpod)
```dart
class WorkoutListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutListProvider);
    
    return workoutsAsync.when(
      data: (workouts) => ListView.builder(...),
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => ErrorWidget(error: err),
    );
  }
}
```

### Error Handling
```dart
// Gestisci errori gracefully
try {
  final result = await apiCall();
  return result;
} on NetworkException catch (e) {
  // Show network error message
  showSnackBar('Connection error');
  rethrow;
} on ApiException catch (e) {
  // Show API-specific error
  showSnackBar(e.message);
  rethrow;
} catch (e) {
  // Generic error
  showSnackBar('Something went wrong');
  debugPrint('Error: $e');
  rethrow;
}
```

## 📦 Dependencies

### Quando Aggiungere una Nuova Dependency
1. **Verifica necessità reale**: è davvero necessaria?
2. **Check popularity**: package con buon numero di likes/pub points
3. **Check maintenance**: ultimo update recente
4. **Check license**: compatibile con progetto
5. **Valuta bundle size**: impatto su dimensione app

### Minimizza Dependencies
- Preferisci soluzioni native Flutter quando possibile
- Valuta se puoi implementare la funzionalità in-house
- Evita package con molte sub-dependencies

## 🧪 Testing Strategy

### Test Pyramid
```
        /\
       /  \    E2E Tests (5%)
      /____\
     /      \  Integration Tests (15%)
    /________\
   /          \ Unit Tests (80%)
  /__________\
```

### Unit Tests
```dart
// Test business logic
void main() {
  group('WorkoutController', () {
    test('addWorkout should add workout to state', () async {
      final container = ProviderContainer();
      final controller = container.read(workoutListProvider.notifier);
      
      await controller.addWorkout(testWorkout);
      
      final state = container.read(workoutListProvider);
      expect(state.value, contains(testWorkout));
    });
  });
}
```

### Widget Tests
```dart
// Test UI components
testWidgets('WorkoutCard shows title', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: WorkoutCard(workout: testWorkout),
      ),
    ),
  );
  
  expect(find.text('Chest Day'), findsOneWidget);
});
```

## 🔐 Security Best Practices

### 1. Never Hardcode Secrets
```dart
// ❌ Bad
const apiKey = 'sk_live_1234567890';

// ✅ Good
final apiKey = dotenv.env['API_KEY']!;
```

### 2. Secure Storage for Tokens
```dart
// Use flutter_secure_storage
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
```

### 3. Validate User Input
```dart
// Sanitize input prima di inviare al backend
final sanitizedInput = input.trim();
if (sanitizedInput.isEmpty) {
  throw ValidationException('Input cannot be empty');
}
```

## 🚀 Performance Optimization

### 1. Lazy Loading
```dart
// Use ListView.builder per liste lunghe
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### 2. Image Optimization
```dart
// Cache immagini di rete
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)

// Dimensioni appropriate
Image.network(
  url,
  width: 200,
  height: 200,
  fit: BoxFit.cover,
)
```

### 3. Avoid Expensive Operations in Build
```dart
// ❌ Bad - computazione pesante in build
@override
Widget build(BuildContext context) {
  final sortedList = heavyComputation(data); // Called every build!
  return ListView(children: sortedList);
}

// ✅ Good - memoization
@override
Widget build(BuildContext context) {
  final sortedList = ref.watch(sortedDataProvider); // Computed once
  return ListView(children: sortedList);
}
```

## 📝 Documentation

### Code Comments
```dart
/// Calculates the total volume lifted in a workout.
///
/// Volume is calculated as: sets × reps × weight for each exercise.
/// 
/// Returns the total volume in kg.
int calculateTotalVolume(List<Exercise> exercises) {
  // Implementation
}
```

### TODO Comments
```dart
// TODO(username): Implementare cache per migliorare performance
// FIXME: Bug con navigazione su iOS
// NOTE: Questa logica cambierà quando avremo l'API reale
```

## 🎯 Code Review Checklist

### Per Reviewer
- [ ] Codice leggibile e comprensibile
- [ ] Naming chiaro e consistente
- [ ] Nessuna duplicazione
- [ ] Error handling appropriato
- [ ] Test adeguati
- [ ] Performance considerations
- [ ] Security issues
- [ ] Documentazione sufficiente

### Per Author
Prima di richiedere review:
- [ ] Self-review del codice
- [ ] Test locali passano
- [ ] Formattazione corretta
- [ ] Nessun debug code / console.log
- [ ] Commit messages chiari

## 🌐 Internationalization (Future)

### Preparazione per i18n
```dart
// Usa sempre Text widgets per testi
Text(context.l10n.welcomeMessage)

// Non hardcodare testi
// ❌ Bad
Text('Welcome to Coachly')

// ✅ Good (quando implementato i18n)
Text(AppLocalizations.of(context).welcome)
```

## 🔄 Version Control

### Branching Strategy
- `main`: Production-ready code
- `develop`: Development branch
- `feature/*`: Feature branches
- `bugfix/*`: Bug fixes
- `hotfix/*`: Urgent production fixes

### Commit Frequency
- Commit **piccoli e frequenti**
- Un commit = una modifica logica
- Push almeno una volta al giorno

## 🎓 Learning Resources

### Consigliati
- Flutter Documentation: https://flutter.dev/docs
- Riverpod: https://riverpod.dev
- Dart Language Tour: https://dart.dev/guides/language/language-tour
- Flutter Cookbook: https://docs.flutter.dev/cookbook

### Community
- Flutter Discord
- r/FlutterDev
- Stack Overflow (tag: flutter)

## 💡 Tips & Tricks

### Hot Reload Best Practices
- Use `const` constructors - non vengono ricostruiti
- Evita logica pesante in constructors
- Non modificare campi `final` durante hot reload

### VS Code Extensions Utili
- Flutter
- Dart
- Error Lens
- Awesome Flutter Snippets
- Pubspec Assist

### Android Studio Shortcuts
- `Ctrl+Alt+L`: Format code
- `Alt+Enter`: Quick fixes
- `Ctrl+Space`: Code completion
- `Shift+F6`: Rename

## ⚠️ Common Pitfalls

### 1. Non usare setState in StatelessWidget
```dart
// ❌ Non ha senso
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() {}), // ERROR!
    );
  }
}
```

### 2. Memory Leaks con StreamSubscription
```dart
// ✅ Cancella sempre subscriptions
@override
void dispose() {
  _subscription.cancel();
  super.dispose();
}
```

### 3. Non await in didChangeDependencies
```dart
// ❌ Bad - causes issues
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  await loadData(); // Don't await here!
}

// ✅ Good - use initState or providers
```
