# 🎯 Flutter Best Practices & Anti-Patterns (per Angular Developers)

## 📋 Indice
1. [State Management Patterns](#state-management-patterns)
2. [Widget Patterns](#widget-patterns)
3. [Performance Patterns](#performance-patterns)
4. [Common Anti-Patterns](#common-anti-patterns)
5. [Migration Tips](#migration-tips)

---

## 1. State Management Patterns

### ✅ PATTERN: Provider Family per Parametri Dinamici

```dart
// ✅ GOOD - Come @Input() in Angular
final workoutProvider = FutureProvider.family<Workout, String>(
  (ref, workoutId) async {
    return ref.read(workoutRepositoryProvider).getWorkout(workoutId);
  },
);

// Usage
class WorkoutPage extends ConsumerWidget {
  final String workoutId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutAsync = ref.watch(workoutProvider(workoutId));
    
    return workoutAsync.when(
      data: (workout) => Text(workout.name),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }
}
```

```typescript
// Equivalente Angular
@Component({
  template: `
    <div *ngIf="workout$ | async as workout">
      {{ workout.name }}
    </div>
  `
})
export class WorkoutComponent implements OnInit {
  @Input() workoutId!: string;
  workout$!: Observable<Workout>;
  
  ngOnInit(): void {
    this.workout$ = this.workoutService.getWorkout(this.workoutId);
  }
}
```

### ❌ ANTI-PATTERN: ref.read() nel build()

```dart
// ❌ BAD - Widget non si ricostruisce quando state cambia
@override
Widget build(BuildContext context) {
  final count = ref.read(counterProvider);  // ❌ NO!
  return Text('$count');
}

// ✅ GOOD - Widget si ricostruisce automaticamente
@override
Widget build(BuildContext context) {
  final count = ref.watch(counterProvider);  // ✅ YES!
  return Text('$count');
}
```

**Regola:** 
- `ref.watch()` → nel `build()` (come `| async` in Angular)
- `ref.read()` → nei callbacks (come chiamare method in Angular)

### ✅ PATTERN: StateNotifier per Logica Complessa

```dart
// ✅ GOOD - Come Service + BehaviorSubject in Angular
class WorkoutState {
  final List<Exercise> exercises;
  final bool isLoading;
  final String? error;
  
  const WorkoutState({
    this.exercises = const [],
    this.isLoading = false,
    this.error,
  });
  
  WorkoutState copyWith({
    List<Exercise>? exercises,
    bool? isLoading,
    String? error,
  }) {
    return WorkoutState(
      exercises: exercises ?? this.exercises,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class WorkoutNotifier extends StateNotifier<WorkoutState> {
  WorkoutNotifier(this._repository) : super(const WorkoutState());
  
  final WorkoutRepository _repository;
  
  Future<void> loadWorkouts() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final exercises = await _repository.getExercises();
      state = state.copyWith(exercises: exercises, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  
  void addExercise(Exercise exercise) {
    state = state.copyWith(
      exercises: [...state.exercises, exercise],
    );
  }
}

final workoutProvider = StateNotifierProvider<WorkoutNotifier, WorkoutState>(
  (ref) => WorkoutNotifier(ref.read(workoutRepositoryProvider)),
);
```

```typescript
// Equivalente Angular
interface WorkoutState {
  exercises: Exercise[];
  isLoading: boolean;
  error: string | null;
}

@Injectable({ providedIn: 'root' })
export class WorkoutService {
  private state = new BehaviorSubject<WorkoutState>({
    exercises: [],
    isLoading: false,
    error: null
  });
  
  state$ = this.state.asObservable();
  
  async loadWorkouts(): Promise<void> {
    this.state.next({ ...this.state.value, isLoading: true, error: null });
    
    try {
      const exercises = await this.repository.getExercises();
      this.state.next({ exercises, isLoading: false, error: null });
    } catch (e) {
      this.state.next({ 
        ...this.state.value, 
        error: e.message, 
        isLoading: false 
      });
    }
  }
  
  addExercise(exercise: Exercise): void {
    this.state.next({
      ...this.state.value,
      exercises: [...this.state.value.exercises, exercise]
    });
  }
}
```

---

## 2. Widget Patterns

### ✅ PATTERN: Extract Widget (come Component in Angular)

```dart
// ❌ BAD - Widget monolitico
class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, i) => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.fitness_center),
                  SizedBox(width: 8),
                  Text('Exercise $i'),
                ],
              ),
              // ... 100 linee di codice qui
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ GOOD - Estratto in widget separato
class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, i) => ExerciseCard(exerciseIndex: i),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final int exerciseIndex;
  
  const ExerciseCard({Key? key, required this.exerciseIndex}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader(),
          _buildBody(),
          _buildFooter(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() => Row(...);
  Widget _buildBody() => Column(...);
  Widget _buildFooter() => Row(...);
}
```

**Regola:** Se un pezzo di UI supera 50 righe → Estrai in widget separato (come component Angular)

### ✅ PATTERN: Builder Method per Codice Riutilizzabile

```dart
// ✅ GOOD - Come metodi helper in Angular component
class WorkoutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildHeader(context),
          _buildContent(context),
          _buildFooter(context),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        'Workout',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
  
  Widget _buildContent(BuildContext context) {
    return Container(...);
  }
  
  Widget _buildFooter(BuildContext context) {
    return Row(...);
  }
}
```

### ❌ ANTI-PATTERN: setState() Pesante

```dart
// ❌ BAD - setState ricostruisce TUTTO il widget
class WorkoutPage extends StatefulWidget {
  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  int counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Questo viene ricostruito ad ogni setState
        ExpensiveWidget(),
        ExpensiveWidget(),
        ExpensiveWidget(),
        
        Text('$counter'),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: Text('+'),
        ),
      ],
    );
  }
}

// ✅ GOOD - Isola stato e ricostruzione
class WorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Questi NON vengono ricostruiti
        ExpensiveWidget(),
        ExpensiveWidget(),
        ExpensiveWidget(),
        
        // Solo questo viene ricostruito
        CounterWidget(),
      ],
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$counter'),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: Text('+'),
        ),
      ],
    );
  }
}
```

**Regola:** Spingi `StatefulWidget` più in basso nell'albero possibile (come OnPush in Angular)

---

## 3. Performance Patterns

### ✅ PATTERN: const Constructor

```dart
// ❌ BAD - Widget ricreato ad ogni build
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),  // ❌ Nuovo widget ogni volta
    );
  }
}

// ✅ GOOD - Widget riusato
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),  // ✅ Stesso widget sempre
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);  // ✅ const constructor
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(  // ✅ const dove possibile
      body: Center(
        child: Text('Home'),  // ✅ const anche qui
      ),
    );
  }
}
```

**Regola:** Usa `const` ovunque possibile = performance gratis!

### ✅ PATTERN: ListView.builder per Liste Lunghe

```dart
// ❌ BAD - Crea TUTTI i widget subito (come *ngFor senza virtual scroll)
class WorkoutList extends StatelessWidget {
  final List<Workout> workouts;
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: workouts.map((w) => WorkoutCard(workout: w)).toList(),
    );
  }
}

// ✅ GOOD - Crea solo widget visibili (come virtual scroll Angular)
class WorkoutList extends StatelessWidget {
  final List<Workout> workouts;
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (ctx, index) => WorkoutCard(workout: workouts[index]),
    );
  }
}
```

**Regola:** Liste > 20 elementi → `ListView.builder()` sempre!

### ✅ PATTERN: RepaintBoundary per Widget Pesanti

```dart
// ✅ GOOD - Isola repaint (come ChangeDetectionStrategy.OnPush)
class ExpensiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: ComplexPainter(),
        size: Size(300, 300),
      ),
    );
  }
}
```

---

## 4. Common Anti-Patterns

### ❌ ANTI-PATTERN: BuildContext in Async senza check

```dart
// ❌ BAD - Context potrebbe non essere più valido
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();  // ❌ CRASH se widget disposed!
  }
}

// ✅ GOOD - Check mounted
class _MyWidgetState extends State<MyWidget> {
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return;  // ✅ Safe check
    Navigator.of(context).pop();
  }
}
```

### ❌ ANTI-PATTERN: Dimenticare dispose()

```dart
// ❌ BAD - Memory leak!
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late TextEditingController _controller;
  late StreamSubscription _subscription;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _subscription = someStream.listen(...);
  }
  
  // ❌ NO dispose() = MEMORY LEAK!
}

// ✅ GOOD - Always dispose
class _MyWidgetState extends State<MyWidget> {
  late TextEditingController _controller;
  late StreamSubscription _subscription;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _subscription = someStream.listen(...);
  }
  
  @override
  void dispose() {
    _controller.dispose();  // ✅ Clean up
    _subscription.cancel();  // ✅ Clean up
    super.dispose();
  }
}
```

**Regola:** Tutto ciò che ha `dispose()` DEVE essere chiamato in `dispose()`!

### ❌ ANTI-PATTERN: Creare oggetti nel build()

```dart
// ❌ BAD - Crea nuovo controller ad ogni build!
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();  // ❌ NO!
    
    return TextField(controller: controller);
  }
}

// ✅ GOOD - Usa StatefulWidget per oggetti con stato
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();  // ✅ Una volta sola
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}
```

### ❌ ANTI-PATTERN: Nested Callbacks Hell

```dart
// ❌ BAD - Callback hell (come Promises senza async/await)
onPressed: () {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            showDialog(
              context: context,
              builder: (ctx2) => AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx2);
                      // ... ancora più nesting
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

// ✅ GOOD - Extract methods con async/await
Future<void> _showFirstDialog() async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text('Next'),
        ),
      ],
    ),
  );
  
  if (result == true) {
    await _showSecondDialog();
  }
}

Future<void> _showSecondDialog() async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('Done'),
        ),
      ],
    ),
  );
}

// Usage
ElevatedButton(
  onPressed: _showFirstDialog,
  child: Text('Open'),
)
```

---

## 5. Migration Tips (da Angular a Flutter)

### Pattern 1: Observable Subscribe → ref.watch

```typescript
// Angular
ngOnInit(): void {
  this.workoutService.workout$.subscribe(workout => {
    this.workout = workout;
  });
}
```

```dart
// Flutter - No subscription manuale!
@override
Widget build(BuildContext context, WidgetRef ref) {
  final workout = ref.watch(workoutProvider);  // ✅ Auto-subscribe!
  return Text(workout.name);
}
```

### Pattern 2: Service Method Call → Provider Method

```typescript
// Angular
onCompleteSet(index: number): void {
  this.workoutService.completeSet(index);
}
```

```dart
// Flutter
void _onCompleteSet(int index) {
  ref.read(workoutProvider.notifier).completeSet(index);
}
```

### Pattern 3: @Input/@Output → Constructor + Callback

```typescript
// Angular
@Component({
  selector: 'app-exercise-card',
  template: '...'
})
export class ExerciseCardComponent {
  @Input() exercise!: Exercise;
  @Output() completed = new EventEmitter<number>();
  
  onComplete(index: number): void {
    this.completed.emit(index);
  }
}
```

```dart
// Flutter
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final void Function(int index)? onCompleted;
  
  const ExerciseCard({
    Key? key,
    required this.exercise,
    this.onCompleted,
  }) : super(key: key);
  
  void _onComplete(int index) {
    onCompleted?.call(index);
  }
}
```

### Pattern 4: Reactive Forms → Form + Controllers

```typescript
// Angular
this.form = this.fb.group({
  name: ['', Validators.required],
  email: ['', [Validators.required, Validators.email]]
});

<form [formGroup]="form" (ngSubmit)="onSubmit()">
  <input formControlName="name">
  <input formControlName="email">
</form>
```

```dart
// Flutter
class _FormState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            validator: (v) => v?.isEmpty == true ? 'Required' : null,
          ),
          TextFormField(
            controller: _emailController,
            validator: (v) {
              if (v?.isEmpty == true) return 'Required';
              if (!v!.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _onSubmit();
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🎯 Checklist Migrazione

### Prima di Scrivere Codice

- [ ] Ho letto la documentazione Riverpod?
- [ ] Capisco la differenza tra `ref.watch()` e `ref.read()`?
- [ ] So quando usare `StatelessWidget` vs `StatefulWidget`?
- [ ] Conosco il lifecycle di widget?

### Durante lo Sviluppo

- [ ] Uso `const` ovunque possibile?
- [ ] Estraggo widget quando superano 50 righe?
- [ ] Uso `ListView.builder()` per liste lunghe?
- [ ] Faccio `dispose()` di tutti i controller?
- [ ] Check `mounted` prima di usare context in async?

### Best Practices

- [ ] Provider per DI (non singleton static!)
- [ ] Immutabilità con `copyWith()`
- [ ] Testing fin dal giorno 1
- [ ] Hot Reload durante sviluppo
- [ ] DevTools per debug

---

## 📚 Risorse

- [Riverpod Best Practices](https://riverpod.dev/docs/concepts/best_practices)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

---

**Remember: Angular experience = 80% del lavoro fatto! 🎯**

Solo la sintassi è diversa, i concetti sono gli stessi! 💙
