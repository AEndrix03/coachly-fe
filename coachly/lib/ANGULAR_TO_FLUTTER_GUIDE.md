# 🔄 Flutter/Riverpod vs Angular - Guida Completa per Angular Developers

## 📋 Indice

1. [State Management](#state-management)
2. [Dependency Injection](#dependency-injection)
3. [Component Architecture](#component-architecture)
4. [Lifecycle Hooks](#lifecycle-hooks)
5. [Reactive Programming](#reactive-programming)
6. [Routing & Navigation](#routing--navigation)
7. [Forms & Validation](#forms--validation)
8. [HTTP & API](#http--api)
9. [Testing](#testing)
10. [Project Structure](#project-structure)

---

## 1. State Management

### Angular: Services + RxJS + NgRx (opzionale)

```typescript
// workout.service.ts
@Injectable({ providedIn: 'root' })
export class WorkoutService {
  private workoutSubject = new BehaviorSubject<Workout | null>(null);
  workout$ = this.workoutSubject.asObservable();
  
  constructor(private http: HttpClient) {}
  
  loadWorkout(id: string): Observable<Workout> {
    return this.http.get<Workout>(`/api/workouts/${id}`).pipe(
      tap(workout => this.workoutSubject.next(workout)),
      catchError(error => {
        console.error(error);
        return throwError(() => error);
      })
    );
  }
  
  completeSet(exerciseId: string, setIndex: number): void {
    const current = this.workoutSubject.value;
    if (current) {
      const updated = this.updateSetInWorkout(current, exerciseId, setIndex);
      this.workoutSubject.next(updated);
    }
  }
}

// workout.component.ts
@Component({
  selector: 'app-workout',
  template: `
    <div *ngIf="workout$ | async as workout">
      <h2>{{ workout.name }}</h2>
      <app-exercise 
        *ngFor="let exercise of workout.exercises"
        [exercise]="exercise"
        (setCompleted)="onSetCompleted($event)">
      </app-exercise>
    </div>
  `
})
export class WorkoutComponent implements OnInit, OnDestroy {
  workout$!: Observable<Workout>;
  private destroy$ = new Subject<void>();
  
  constructor(private workoutService: WorkoutService) {}
  
  ngOnInit(): void {
    this.workout$ = this.workoutService.workout$.pipe(
      takeUntil(this.destroy$)
    );
    
    this.workoutService.loadWorkout('123').subscribe();
  }
  
  onSetCompleted(event: SetCompletedEvent): void {
    this.workoutService.completeSet(event.exerciseId, event.setIndex);
  }
  
  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }
}
```

### Flutter: Riverpod StateNotifier

```dart
// workout_provider.dart
class WorkoutState {
  final WorkoutSessionModel? session;
  final bool isLoading;
  final String? errorMessage;

  const WorkoutState({
    this.session,
    this.isLoading = false,
    this.errorMessage,
  });

  WorkoutState copyWith({
    WorkoutSessionModel? session,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WorkoutState(
      session: session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class WorkoutNotifier extends Notifier<WorkoutState> {
  @override
  WorkoutState build() => const WorkoutState();

  // Equivalente a loadWorkout() in Angular
  Future<void> loadWorkout(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final response = await ref.read(workoutRepositoryProvider)
        .getWorkout(id);

    if (response.success && response.data != null) {
      state = WorkoutState(session: response.data);
    } else {
      state = WorkoutState(
        isLoading: false,
        errorMessage: response.message ?? 'Error',
      );
    }
  }

  // Equivalente a completeSet() in Angular
  void completeSet(String exerciseId, int setIndex) {
    final session = state.session;
    if (session == null) return;

    // Immutable update (come in Redux/NgRx)
    final updatedSession = updateSetInSession(session, exerciseId, setIndex);
    state = state.copyWith(session: updatedSession);
  }
}

// Provider (equivalente @Injectable)
final workoutProvider = NotifierProvider<WorkoutNotifier, WorkoutState>(
  WorkoutNotifier.new,
);

// workout_page.dart
class WorkoutPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Equivalente a (workout$ | async)
    final workoutState = ref.watch(workoutProvider);

    // Equivalente a ngOnInit
    ref.listen(workoutProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    if (workoutState.isLoading) {
      return CircularProgressIndicator();
    }

    final session = workoutState.session;
    if (session == null) return SizedBox.shrink();

    return Column(
      children: [
        Text(session.name),
        ...session.exercises.map((exercise) =>
            ExerciseCard(
              exercise: exercise,
              onSetCompleted: (setIndex) {
                // Equivalente a chiamare service
                ref.read(workoutProvider.notifier)
                    .completeSet(exercise.id, setIndex);
              },
            )),
      ],
    );
  }
}
```

### 🎯 Best Practices Comparison

| Aspetto                  | Angular                       | Flutter/Riverpod             |
|--------------------------|-------------------------------|------------------------------|
| **Stato globale**        | `BehaviorSubject` in Service  | `StateNotifier` con Provider |
| **Immutabilità**         | Manuale (spread operator)     | `copyWith()` pattern         |
| **Subscription cleanup** | `takeUntil` + `ngOnDestroy`   | Automatico con Riverpod      |
| **Error handling**       | `catchError` in pipe          | Try-catch + state            |
| **Loading states**       | Manuale con flag              | Integrato nello state        |
| **Reactive**             | `Observable` con `async` pipe | `ref.watch()`                |
| **Side effects**         | `tap` operator                | `ref.listen()`               |

---

## 2. Dependency Injection

### Angular: @Injectable + Constructor Injection

```typescript
// API Service
@Injectable({ providedIn: 'root' })
export class ApiService {
  constructor(
    private http: HttpClient,
    @Inject(API_BASE_URL) private baseUrl: string
  ) {}
  
  get<T>(endpoint: string): Observable<T> {
    return this.http.get<T>(`${this.baseUrl}${endpoint}`);
  }
}

// Workout Service (depends on ApiService)
@Injectable({ providedIn: 'root' })
export class WorkoutService {
  constructor(private apiService: ApiService) {}
  
  getWorkout(id: string): Observable<Workout> {
    return this.apiService.get<Workout>(`/workouts/${id}`);
  }
}

// Component
@Component({
  selector: 'app-workout',
  template: '...'
})
export class WorkoutComponent {
  constructor(
    private workoutService: WorkoutService,
    private router: Router,
    private activatedRoute: ActivatedRoute
  ) {}
}

// Module
@NgModule({
  providers: [
    { provide: API_BASE_URL, useValue: 'https://api.example.com' },
    WorkoutService,
    ApiService
  ]
})
export class AppModule {}
```

### Flutter: Riverpod Providers

```dart
// API Service Provider (singleton)
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(baseUrl: 'https://api.example.com');
});

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<T> get<T>(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    return parseResponse<T>(response);
  }
}

// Workout Service Provider (depends on ApiService)
final workoutServiceProvider = Provider<WorkoutService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return WorkoutService(apiService);
});

class WorkoutService {
  final ApiService _apiService;

  WorkoutService(this._apiService);

  Future<Workout> getWorkout(String id) {
    return _apiService.get<Workout>('/workouts/$id');
  }
}

// Component/Widget
class WorkoutPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dependency injection automatica
    final workoutService = ref.watch(workoutServiceProvider);

    // O accedi direttamente al provider che ti serve
    final workout = ref.watch(workoutProvider);

    return Container();
  }
}

// Main (equivalente @NgModule)
void main() {
  runApp(
    ProviderScope( // ← Come forRoot() in Angular
      overrides: [
        // Override per testing o environment diversi
        apiServiceProvider.overrideWith((ref) =>
            ApiService(baseUrl: 'https://staging.api.com')
        ),
      ],
      child: MyApp(),
    ),
  );
}
```

### 🎯 Best Practices Comparison

| Aspetto          | Angular                          | Flutter/Riverpod               |
|------------------|----------------------------------|--------------------------------|
| **Scope**        | `providedIn: 'root'`             | `Provider` (singleton default) |
| **Dependencies** | Constructor injection            | `ref.watch()` in provider      |
| **Lifecycle**    | Singleton o per component        | Provider auto-dispose          |
| **Testing**      | `TestBed.configureTestingModule` | `ProviderScope` with overrides |
| **Lazy loading** | Con modules                      | `Provider.autoDispose`         |
| **Override**     | Providers in module              | `overrides` in ProviderScope   |

---

## 3. Component Architecture

### Angular: @Component + @Input/@Output

```typescript
// exercise-card.component.ts
@Component({
  selector: 'app-exercise-card',
  template: `
    <div class="exercise-card">
      <h3>{{ exercise.name }}</h3>
      
      <div *ngFor="let set of exercise.sets; let i = index">
        <app-set-row 
          [set]="set"
          [index]="i"
          (completed)="onSetCompleted(i)"
          (weightChanged)="onWeightChanged(i, $event)">
        </app-set-row>
      </div>
      
      <button (click)="addSet()">Add Set</button>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush  // ← Best practice!
})
export class ExerciseCardComponent {
  @Input() exercise!: Exercise;
  @Output() setCompleted = new EventEmitter<number>();
  @Output() setAdded = new EventEmitter<void>();
  
  onSetCompleted(index: number): void {
    this.setCompleted.emit(index);
  }
  
  addSet(): void {
    this.setAdded.emit();
  }
  
  onWeightChanged(index: number, weight: number): void {
    // Update locale o emit evento
  }
}

// Parent component
@Component({
  template: `
    <app-exercise-card
      *ngFor="let exercise of exercises"
      [exercise]="exercise"
      (setCompleted)="handleSetCompleted($event)"
      (setAdded)="handleSetAdded()">
    </app-exercise-card>
  `
})
export class WorkoutComponent {
  exercises: Exercise[] = [];
  
  handleSetCompleted(index: number): void {
    // Handle event
  }
}
```

### Flutter: Widgets + Callbacks

```dart
// exercise_card.dart
class ExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;
  final void Function(int index)? onSetCompleted;
  final VoidCallback? onSetAdded;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    this.onSetCompleted,
    this.onSetAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(exercise.name, style: Theme
              .of(context)
              .textTheme
              .titleLarge),

          ...exercise.sets
              .asMap()
              .entries
              .map((entry) {
            final index = entry.key;
            final set = entry.value;

            return SetRow(
              set: set,
              index: index,
              onCompleted: () => onSetCompleted?.call(index),
              onWeightChanged: (weight) => _handleWeightChanged(index, weight),
            );
          }).toList(),

          ElevatedButton(
            onPressed: onSetAdded,
            child: Text('Add Set'),
          ),
        ],
      ),
    );
  }

  void _handleWeightChanged(int index, double weight) {
    // Update locale o callback
  }
}

// Parent widget
class WorkoutPage extends StatelessWidget {
  final List<ExerciseModel> exercises;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: exercises.map((exercise) =>
          ExerciseCard(
            exercise: exercise,
            onSetCompleted: (index) {
              // Handle event
            },
            onSetAdded: () {
              // Handle event
            },
          )).toList(),
    );
  }
}
```

### 🎯 Best Practices Comparison

| Aspetto              | Angular                  | Flutter                          |
|----------------------|--------------------------|----------------------------------|
| **Input**            | `@Input()` decorator     | Constructor parameter            |
| **Output**           | `@Output() EventEmitter` | `void Function()` callback       |
| **Change Detection** | `OnPush` strategy        | Automatico (rebuild on setState) |
| **Stateless**        | Component senza state    | `StatelessWidget`                |
| **Stateful**         | Component con state      | `StatefulWidget`                 |
| **Template**         | HTML template            | `build()` method                 |
| **Styling**          | CSS/SCSS                 | `BoxDecoration`, Theme           |

---

## 4. Lifecycle Hooks

### Angular Lifecycle

```typescript
@Component({
  selector: 'app-workout',
  template: '...'
})
export class WorkoutComponent implements 
  OnInit, 
  OnDestroy, 
  AfterViewInit,
  OnChanges {
  
  @Input() workoutId!: string;
  private destroy$ = new Subject<void>();
  
  constructor(private workoutService: WorkoutService) {
    // ✅ Constructor: DI only
    console.log('Constructor');
  }
  
  ngOnInit(): void {
    // ✅ Initialization logic
    console.log('ngOnInit');
    
    this.workoutService.loadWorkout(this.workoutId)
      .pipe(takeUntil(this.destroy$))
      .subscribe();
  }
  
  ngOnChanges(changes: SimpleChanges): void {
    // ✅ React to @Input changes
    if (changes['workoutId'] && !changes['workoutId'].firstChange) {
      this.loadNewWorkout(changes['workoutId'].currentValue);
    }
  }
  
  ngAfterViewInit(): void {
    // ✅ After view rendered
    console.log('ngAfterViewInit');
  }
  
  ngOnDestroy(): void {
    // ✅ Cleanup subscriptions
    console.log('ngOnDestroy');
    this.destroy$.next();
    this.destroy$.complete();
  }
}
```

### Flutter Lifecycle

```dart
class WorkoutPage extends StatefulWidget {
  final String workoutId;

  const WorkoutPage({Key? key, required this.workoutId}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  // ✅ Constructor equivalente
  _WorkoutPageState() {
    print('Constructor');
  }

  @override
  void initState() {
    // ✅ Equivalente ngOnInit
    super.initState();
    print('initState');

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWorkout();
    });
  }

  @override
  void didChangeDependencies() {
    // ✅ Quando dependencies cambiano (raro)
    super.didChangeDependencies();
    print('didChangeDependencies');
  }

  @override
  void didUpdateWidget(WorkoutPage oldWidget) {
    // ✅ Equivalente ngOnChanges
    super.didUpdateWidget(oldWidget);

    if (widget.workoutId != oldWidget.workoutId) {
      _loadWorkout();
    }
  }

  void _loadWorkout() {
    // Load workout
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Equivalente template rendering
    // Called ogni volta che setState() viene chiamato
    return Container();
  }

  @override
  void dispose() {
    // ✅ Equivalente ngOnDestroy
    print('dispose');
    super.dispose();
    // Cleanup: cancel streams, dispose controllers, etc.
  }
}
```

### 🎯 Lifecycle Comparison

| Angular             | Flutter                   | Quando                        |
|---------------------|---------------------------|-------------------------------|
| `constructor()`     | Constructor               | DI e inizializzazione fields  |
| `ngOnInit()`        | `initState()`             | Setup iniziale, subscriptions |
| `ngOnChanges()`     | `didUpdateWidget()`       | @Input/@Props cambiano        |
| `ngAfterViewInit()` | `didChangeDependencies()` | Dopo primo build              |
| -                   | `build()`                 | Ogni render (come template)   |
| `ngOnDestroy()`     | `dispose()`               | Cleanup risorse               |

---

## 5. Reactive Programming

### Angular: RxJS Observables

```typescript
// workout.service.ts
@Injectable({ providedIn: 'root' })
export class WorkoutService {
  private workoutSubject = new BehaviorSubject<Workout | null>(null);
  workout$ = this.workoutSubject.asObservable();
  
  // Computed observables (come computed in Vue/Angular signals)
  totalVolume$ = this.workout$.pipe(
    map(workout => {
      if (!workout) return 0;
      return workout.exercises.reduce((sum, ex) => 
        sum + ex.sets.reduce((setSum, set) => 
          setSum + (set.weight * set.reps), 0
        ), 0
      );
    })
  );
  
  // Combine multiple streams
  workoutWithProgress$ = combineLatest([
    this.workout$,
    this.userProgress$
  ]).pipe(
    map(([workout, progress]) => ({
      workout,
      progress,
      completed: this.calculateCompletion(workout, progress)
    }))
  );
  
  // Debounced search
  searchExercises(searchTerm$: Observable<string>): Observable<Exercise[]> {
    return searchTerm$.pipe(
      debounceTime(300),
      distinctUntilChanged(),
      switchMap(term => this.apiService.searchExercises(term))
    );
  }
}

// Component
@Component({
  template: `
    <div *ngIf="totalVolume$ | async as volume">
      Total: {{ volume }} kg
    </div>
    
    <input [formControl]="searchControl">
    <div *ngFor="let exercise of exercises$ | async">
      {{ exercise.name }}
    </div>
  `
})
export class WorkoutComponent implements OnInit {
  searchControl = new FormControl('');
  exercises$!: Observable<Exercise[]>;
  totalVolume$ = this.workoutService.totalVolume$;
  
  ngOnInit(): void {
    this.exercises$ = this.workoutService.searchExercises(
      this.searchControl.valueChanges
    );
  }
}
```

### Flutter: Streams + Riverpod

```dart
// Riverpod Provider con computed values
final totalVolumeProvider = Provider<double>((ref) {
  final workout = ref
      .watch(workoutProvider)
      .session;
  if (workout == null) return 0;

  return workout.exercises.fold(0.0, (sum, ex) =>
  sum + ex.sets.fold(0.0, (setSum, set) =>
  setSum + (set.weight * set.reps)
  )
  );
});

// Combine multiple providers (come combineLatest)
final workoutWithProgressProvider = Provider((ref) {
  final workout = ref
      .watch(workoutProvider)
      .session;
  final progress = ref.watch(userProgressProvider);

  return WorkoutWithProgress(
    workout: workout,
    progress: progress,
    completed: calculateCompletion(workout, progress),
  );
});

// Debounced search con StreamProvider
final searchTermProvider = StateProvider<String>((ref) => '');

final exercisesSearchProvider = StreamProvider<List<Exercise>>((ref) {
  final searchTerm = ref.watch(searchTermProvider);

  // Crea stream con debounce
  return Stream.periodic(Duration(milliseconds: 300))
      .asyncMap((_) =>
      ref.read(apiServiceProvider)
          .searchExercises(searchTerm))
      .distinct();
});

// Widget
class WorkoutPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Automatic subscription (come async pipe)
    final totalVolume = ref.watch(totalVolumeProvider);

    // ✅ Combined providers
    final workoutWithProgress = ref.watch(workoutWithProgressProvider);

    // ✅ Stream provider
    final exercisesAsync = ref.watch(exercisesSearchProvider);

    return Column(
      children: [
        Text('Total: $totalVolume kg'),

        TextField(
          onChanged: (value) {
            ref
                .read(searchTermProvider.notifier)
                .state = value;
          },
        ),

        exercisesAsync.when(
          data: (exercises) =>
              ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (ctx, i) => Text(exercises[i].name),
              ),
          loading: () => CircularProgressIndicator(),
          error: (e, s) => Text('Error: $e'),
        ),
      ],
    );
  }
}
```

### 🎯 Best Practices Comparison

| Aspetto               | Angular (RxJS)              | Flutter (Riverpod)       |
|-----------------------|-----------------------------|--------------------------|
| **Stream**            | `Observable<T>`             | `Stream<T>`              |
| **State holder**      | `BehaviorSubject<T>`        | `StateProvider<T>`       |
| **Computed**          | `map()` operator            | `Provider` dependency    |
| **Combine**           | `combineLatest()`           | Multiple `ref.watch()`   |
| **Subscribe**         | `.subscribe()`              | `ref.watch()`            |
| **Async in template** | `                           | async` pipe              | `.when()` or direct watch |
| **Cleanup**           | `takeUntil()` + unsubscribe | Automatico               |
| **Debounce**          | `debounceTime()`            | `StreamProvider` + Timer |

---

## 6. Routing & Navigation

### Angular Router

```typescript
// app-routing.module.ts
const routes: Routes = [
  {
    path: '',
    redirectTo: '/home',
    pathMatch: 'full'
  },
  {
    path: 'home',
    component: HomeComponent
  },
  {
    path: 'workout/:id',
    component: WorkoutDetailComponent,
    canActivate: [AuthGuard],
    resolve: {
      workout: WorkoutResolver
    }
  },
  {
    path: 'workouts',
    loadChildren: () => import('./workouts/workouts.module')
      .then(m => m.WorkoutsModule)  // Lazy loading
  }
];

// Navigation in component
@Component({...})
export class HomeComponent {
  constructor(
    private router: Router,
    private route: ActivatedRoute
  ) {}
  
  goToWorkout(id: string): void {
    this.router.navigate(['/workout', id], {
      queryParams: { from: 'home' }
    });
  }
  
  ngOnInit(): void {
    // Read params
    this.route.params.subscribe(params => {
      const id = params['id'];
    });
    
    // Read query params
    this.route.queryParams.subscribe(query => {
      const from = query['from'];
    });
  }
}

// Guard
@Injectable({ providedIn: 'root' })
export class AuthGuard implements CanActivate {
  constructor(private authService: AuthService) {}
  
  canActivate(): boolean {
    if (this.authService.isAuthenticated()) {
      return true;
    }
    this.router.navigate(['/login']);
    return false;
  }
}
```

### Flutter: go_router (Best Practice!)

```dart
// app_router.dart
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      // ✅ Guard-like logic
      final isAuth = ref
          .read(authProvider)
          .isAuthenticated;

      if (!isAuth && state.location != '/login') {
        return '/login';
      }
      return null; // Allow navigation
    },
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/workout/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final from = state.uri.queryParameters['from'];

          return WorkoutDetailPage(
            workoutId: id,
            from: from,
          );
        },
      ),
      // Nested routes
      GoRoute(
        path: '/workouts',
        builder: (context, state) => WorkoutsPage(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => NewWorkoutPage(),
          ),
        ],
      ),
    ],
  );
});

// Navigation in widget
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // ✅ Navigate with params
        context.go('/workout/123?from=home');

        // ✅ Or with named params
        context.goNamed('workout',
          pathParameters: {'id': '123'},
          queryParameters: {'from': 'home'},
        );

        // ✅ Push (can go back)
        context.push('/workout/123');

        // ✅ Replace (no back)
        context.replace('/workout/123');

        // ✅ Go back
        context.pop();
      },
      child: Text('Go to Workout'),
    );
  }
}

// Access params in widget
class WorkoutDetailPage extends ConsumerWidget {
  final String workoutId;
  final String? from;

  const WorkoutDetailPage({
    required this.workoutId,
    this.from,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('Workout: $workoutId, from: $from');
  }
}
```

### 🎯 Best Practices Comparison

| Aspetto          | Angular                      | Flutter (go_router)         |
|------------------|------------------------------|-----------------------------|
| **Navigate**     | `router.navigate(['/path'])` | `context.go('/path')`       |
| **Params**       | `route.params`               | `state.pathParameters`      |
| **Query**        | `route.queryParams`          | `state.uri.queryParameters` |
| **Guards**       | `CanActivate`                | `redirect` callback         |
| **Resolver**     | `Resolve<T>`                 | Load data in builder        |
| **Lazy loading** | `loadChildren`               | Automatico con builder      |
| **Back**         | `location.back()`            | `context.pop()`             |

---

## 7. Forms & Validation

### Angular: Reactive Forms

```typescript
// workout-form.component.ts
@Component({
  selector: 'app-workout-form',
  template: `
    <form [formGroup]="workoutForm" (ngSubmit)="onSubmit()">
      <input 
        formControlName="name"
        [class.error]="name.invalid && name.touched">
      <span *ngIf="name.errors?.['required']">
        Name is required
      </span>
      
      <div formArrayName="exercises">
        <div *ngFor="let exercise of exercises.controls; let i = index">
          <div [formGroupName]="i">
            <input formControlName="name">
            <input formControlName="sets" type="number">
          </div>
        </div>
      </div>
      
      <button type="submit" [disabled]="workoutForm.invalid">
        Save
      </button>
    </form>
  `
})
export class WorkoutFormComponent implements OnInit {
  workoutForm!: FormGroup;
  
  constructor(private fb: FormBuilder) {}
  
  ngOnInit(): void {
    this.workoutForm = this.fb.group({
      name: ['', [Validators.required, Validators.minLength(3)]],
      description: [''],
      exercises: this.fb.array([
        this.createExerciseGroup()
      ])
    });
    
    // React to changes
    this.workoutForm.valueChanges.subscribe(value => {
      console.log('Form changed:', value);
    });
  }
  
  get name() {
    return this.workoutForm.get('name')!;
  }
  
  get exercises() {
    return this.workoutForm.get('exercises') as FormArray;
  }
  
  createExerciseGroup(): FormGroup {
    return this.fb.group({
      name: ['', Validators.required],
      sets: [3, [Validators.required, Validators.min(1)]]
    });
  }
  
  addExercise(): void {
    this.exercises.push(this.createExerciseGroup());
  }
  
  onSubmit(): void {
    if (this.workoutForm.valid) {
      const workout = this.workoutForm.value;
      this.workoutService.create(workout).subscribe();
    }
  }
}
```

### Flutter: Form + TextEditingController

```dart
// workout_form_page.dart
class WorkoutFormPage extends StatefulWidget {
  @override
  State<WorkoutFormPage> createState() => _WorkoutFormPageState();
}

class _WorkoutFormPageState extends State<WorkoutFormPage> {
  final _formKey = GlobalKey<FormState>();

  // ✅ Controllers (come FormControl)
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  List<ExerciseFormData> _exercises = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();

    // ✅ Listen to changes
    _nameController.addListener(() {
      print('Name changed: ${_nameController.text}');
    });

    _addExercise();
  }

  @override
  void dispose() {
    // ✅ Cleanup (importante!)
    _nameController.dispose();
    _descriptionController.dispose();
    _exercises.forEach((e) => e.dispose());
    super.dispose();
  }

  void _addExercise() {
    setState(() {
      _exercises.add(ExerciseFormData());
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final workout = WorkoutModel(
        name: _nameController.text,
        description: _descriptionController.text,
        exercises: _exercises.map((e) => e.toModel()).toList(),
      );

      // Save workout
      context.read(workoutServiceProvider).createWorkout(workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ✅ Text field with validation
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              if (value.length < 3) {
                return 'Name must be at least 3 characters';
              }
              return null;
            },
          ),

          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),

          // ✅ Dynamic list (come FormArray)
          ..._exercises
              .asMap()
              .entries
              .map((entry) {
            final index = entry.key;
            final exercise = entry.value;

            return ExerciseFormField(
              exercise: exercise,
              onRemove: () {
                setState(() {
                  _exercises.removeAt(index);
                });
              },
            );
          }).toList(),

          ElevatedButton(
            onPressed: _addExercise,
            child: Text('Add Exercise'),
          ),

          ElevatedButton(
            onPressed: _submit,
            child: Text('Save Workout'),
          ),
        ],
      ),
    );
  }
}

// Helper class per gestire workout_exercise_page form
class ExerciseFormData {
  final TextEditingController nameController;
  final TextEditingController setsController;

  ExerciseFormData()
      : nameController = TextEditingController(),
        setsController = TextEditingController(text: '3');

  void dispose() {
    nameController.dispose();
    setsController.dispose();
  }

  ExerciseModel toModel() {
    return ExerciseModel(
      name: nameController.text,
      sets: int.tryParse(setsController.text) ?? 0,
    );
  }
}
```

### 🎯 Best Practices Comparison

| Aspetto            | Angular               | Flutter                   |
|--------------------|-----------------------|---------------------------|
| **Form instance**  | `FormGroup`           | `Form` + `GlobalKey`      |
| **Fields**         | `FormControl`         | `TextEditingController`   |
| **Validation**     | `Validators.required` | `validator` parameter     |
| **Dynamic fields** | `FormArray`           | `List<Widget>` + setState |
| **Submit**         | `(ngSubmit)`          | Button `onPressed`        |
| **Value access**   | `form.value`          | `controller.text`         |
| **Cleanup**        | Automatico            | **Manuale** (dispose)     |

---

## 8. HTTP & API

### Angular: HttpClient

```typescript
// api.service.ts
@Injectable({ providedIn: 'root' })
export class ApiService {
  private baseUrl = environment.apiUrl;
  
  constructor(private http: HttpClient) {}
  
  get<T>(endpoint: string, params?: HttpParams): Observable<T> {
    return this.http.get<T>(`${this.baseUrl}${endpoint}`, { params }).pipe(
      catchError(this.handleError)
    );
  }
  
  post<T>(endpoint: string, body: any): Observable<T> {
    return this.http.post<T>(`${this.baseUrl}${endpoint}`, body).pipe(
      catchError(this.handleError)
    );
  }
  
  private handleError(error: HttpErrorResponse): Observable<never> {
    let errorMessage = 'Unknown error';
    
    if (error.error instanceof ErrorEvent) {
      // Client-side error
      errorMessage = `Error: ${error.error.message}`;
    } else {
      // Server-side error
      errorMessage = `Error Code: ${error.status}\nMessage: ${error.message}`;
    }
    
    return throwError(() => new Error(errorMessage));
  }
}

// workout.service.ts (usa ApiService)
@Injectable({ providedIn: 'root' })
export class WorkoutService {
  constructor(private apiService: ApiService) {}
  
  getWorkouts(): Observable<Workout[]> {
    return this.apiService.get<Workout[]>('/workouts');
  }
  
  getWorkout(id: string): Observable<Workout> {
    return this.apiService.get<Workout>(`/workouts/${id}`);
  }
  
  createWorkout(workout: Workout): Observable<Workout> {
    return this.apiService.post<Workout>('/workouts', workout);
  }
}
```

### Flutter: http + ApiClient

```dart
// api_client.dart (già creato nella rifattorizzazione)
class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({required this.baseUrl}) : _client = http.Client();

  Future<ApiResponse<T>> get<T>(String endpoint, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client.get(uri)
          .timeout(Duration(seconds: 30));

      return _handleResponse<T>(response, fromJson);
    } on TimeoutException {
      return ApiResponse.error(message: 'Request timeout');
    } on SocketException {
      return ApiResponse.error(message: 'No internet connection');
    } catch (e) {
      return ApiResponse.error(message: 'Unexpected error: $e');
    }
  }

  Future<ApiResponse<T>> post<T>(String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(Duration(seconds: 30));

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(message: 'Error: $e');
    }
  }

  ApiResponse<T> _handleResponse<T>(http.Response response,
      T Function(dynamic)? fromJson,) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = jsonDecode(response.body);
      return ApiResponse.success(
        data: fromJson != null ? fromJson(jsonData) : jsonData as T?,
      );
    } else {
      return ApiResponse.error(
        message: 'Error ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}

// workout_service.dart (usa ApiClient)
class WorkoutService {
  final ApiClient _apiClient;

  WorkoutService(this._apiClient);

  Future<ApiResponse<List<Workout>>> getWorkouts() {
    return _apiClient.get(
      '/workouts',
      fromJson: (json) =>
          (json as List)
              .map((e) => Workout.fromJson(e))
              .toList(),
    );
  }

  Future<ApiResponse<Workout>> getWorkout(String id) {
    return _apiClient.get(
      '/workouts/$id',
      fromJson: (json) => Workout.fromJson(json),
    );
  }

  Future<ApiResponse<Workout>> createWorkout(Workout workout) {
    return _apiClient.post(
      '/workouts',
      body: workout.toJson(),
      fromJson: (json) => Workout.fromJson(json),
    );
  }
}
```

### 🎯 Best Practices Comparison

| Aspetto            | Angular                 | Flutter                     |
|--------------------|-------------------------|-----------------------------|
| **HTTP Client**    | `HttpClient` (built-in) | `http` package              |
| **Return type**    | `Observable<T>`         | `Future<ApiResponse<T>>`    |
| **Error handling** | `catchError` operator   | Try-catch + custom response |
| **Timeout**        | `timeout` operator      | `.timeout()` on Future      |
| **Interceptors**   | `HttpInterceptor`       | Custom in ApiClient         |
| **Cancellation**   | `takeUntil`             | CancelToken (dio package)   |
| **Typing**         | Automatico con generics | Manuale con `fromJson`      |

---

## 9. Testing

### Angular Testing

```typescript
// workout.service.spec.ts
describe('WorkoutService', () => {
  let service: WorkoutService;
  let httpMock: HttpTestingController;
  
  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [WorkoutService]
    });
    
    service = TestBed.inject(WorkoutService);
    httpMock = TestBed.inject(HttpTestingController);
  });
  
  afterEach(() => {
    httpMock.verify();
  });
  
  it('should fetch workouts', () => {
    const mockWorkouts: Workout[] = [
      { id: '1', name: 'Push Day' },
      { id: '2', name: 'Pull Day' }
    ];
    
    service.getWorkouts().subscribe(workouts => {
      expect(workouts.length).toBe(2);
      expect(workouts).toEqual(mockWorkouts);
    });
    
    const req = httpMock.expectOne('/api/workouts');
    expect(req.request.method).toBe('GET');
    req.flush(mockWorkouts);
  });
});

// workout.component.spec.ts
describe('WorkoutComponent', () => {
  let component: WorkoutComponent;
  let fixture: ComponentFixture<WorkoutComponent>;
  let workoutService: jasmine.SpyObj<WorkoutService>;
  
  beforeEach(() => {
    const spy = jasmine.createSpyObj('WorkoutService', ['getWorkouts']);
    
    TestBed.configureTestingModule({
      declarations: [WorkoutComponent],
      providers: [
        { provide: WorkoutService, useValue: spy }
      ]
    });
    
    fixture = TestBed.createComponent(WorkoutComponent);
    component = fixture.componentInstance;
    workoutService = TestBed.inject(WorkoutService) as jasmine.SpyObj<WorkoutService>;
  });
  
  it('should load workouts on init', () => {
    const mockWorkouts = [{ id: '1', name: 'Push Day' }];
    workoutService.getWorkouts.and.returnValue(of(mockWorkouts));
    
    component.ngOnInit();
    
    expect(workoutService.getWorkouts).toHaveBeenCalled();
    expect(component.workouts).toEqual(mockWorkouts);
  });
});
```

### Flutter Testing

```dart
// workout_service_test.dart
void main() {
  late MockApiClient mockApiClient;
  late WorkoutService workoutService;

  setUp(() {
    mockApiClient = MockApiClient();
    workoutService = WorkoutService(mockApiClient);
  });

  group('WorkoutService', () {
    test('should fetch workouts', () async {
      // Arrange
      final mockWorkouts = [
        Workout(id: '1', name: 'Push Day'),
        Workout(id: '2', name: 'Pull Day'),
      ];

      when(mockApiClient.get<List<Workout>>(
        any,
        fromJson: anyNamed('fromJson'),
      )).thenAnswer((_) async =>
          ApiResponse.success(
            data: mockWorkouts,
          ));

      // Act
      final response = await workoutService.getWorkouts();

      // Assert
      expect(response.success, true);
      expect(response.data, mockWorkouts);
      expect(response.data!.length, 2);

      verify(mockApiClient.get(
        '/workouts',
        fromJson: anyNamed('fromJson'),
      )).called(1);
    });
  });
}

// workout_provider_test.dart
void main() {
  group('WorkoutProvider', () {
    test('should load workout successfully', () async {
      // Arrange
      final mockWorkout = Workout(id: '1', name: 'Push Day');
      final mockRepository = MockWorkoutRepository();

      when(mockRepository.getWorkout(any))
          .thenAnswer((_) async => ApiResponse.success(data: mockWorkout));

      final container = ProviderContainer(
        overrides: [
          workoutRepositoryProvider.overrideWith((ref) => mockRepository),
        ],
      );

      // Act
      await container.read(workoutProvider.notifier).loadWorkout('1');

      // Assert
      final state = container.read(workoutProvider);
      expect(state.hasData, true);
      expect(state.session, mockWorkout);
      expect(state.isLoading, false);

      verify(mockRepository.getWorkout('1')).called(1);
    });
  });
}

// Widget test
void main() {
  testWidgets('WorkoutPage should show workout name', (tester) async {
    // Arrange
    final mockWorkout = Workout(id: '1', name: 'Push Day');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutProvider.overrideWith((ref) =>
              WorkoutState(
                session: mockWorkout,
              )),
        ],
        child: MaterialApp(
          home: WorkoutPage(workoutId: '1'),
        ),
      ),
    );

    // Act
    await tester.pump();

    // Assert
    expect(find.text('Push Day'), findsOneWidget);
  });
}
```

### 🎯 Best Practices Comparison

| Aspetto            | Angular                 | Flutter                   |
|--------------------|-------------------------|---------------------------|
| **Test framework** | Jasmine/Karma           | test package              |
| **HTTP mocking**   | `HttpTestingController` | Mockito                   |
| **DI mocking**     | `TestBed` providers     | `ProviderScope` overrides |
| **Component test** | `ComponentFixture`      | `testWidgets`             |
| **Assertions**     | `expect().toBe()`       | `expect(actual, matcher)` |
| **Setup**          | `beforeEach`            | `setUp`                   |
| **Teardown**       | `afterEach`             | `tearDown`                |
| **Mock creation**  | `jasmine.createSpyObj`  | `Mock*` classes (Mockito) |

---

## 10. Project Structure

### Angular Structure (Feature Modules)

```
src/
├── app/
│   ├── core/                    # Singleton services
│   │   ├── services/
│   │   │   ├── api.service.ts
│   │   │   └── auth.service.ts
│   │   ├── guards/
│   │   │   └── auth.guard.ts
│   │   ├── interceptors/
│   │   │   └── auth.interceptor.ts
│   │   └── core.module.ts
│   │
│   ├── shared/                  # Shared components/pipes
│   │   ├── components/
│   │   │   ├── button/
│   │   │   └── card/
│   │   ├── directives/
│   │   ├── pipes/
│   │   └── shared.module.ts
│   │
│   ├── features/                # Feature modules
│   │   ├── workout/
│   │   │   ├── components/
│   │   │   │   ├── workout-list/
│   │   │   │   └── workout-detail/
│   │   │   ├── services/
│   │   │   │   └── workout.service.ts
│   │   │   ├── models/
│   │   │   │   └── workout.model.ts
│   │   │   └── workout.module.ts
│   │   │
│   │   └── nutrition/
│   │       └── ...
│   │
│   ├── app.component.ts
│   ├── app.module.ts
│   └── app-routing.module.ts
│
└── environments/
    ├── environment.ts
    └── environment.prod.ts
```

### Flutter Structure (Feature-first)

```
lib/
├── core/                        # Core infrastructure
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── api_exception.dart
│   │   └── api_response.dart
│   ├── constants/
│   │   └── api_endpoints.dart
│   └── utils/
│       └── validators.dart
│
├── shared/                      # Shared widgets/utils
│   ├── widgets/
│   │   ├── buttons/
│   │   │   └── primary_button.dart
│   │   └── cards/
│   │       └── workout_card.dart
│   └── extensions/
│       └── string_extensions.dart
│
├── features/                    # Features (come Angular modules)
│   ├── workout/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── workout_model.dart
│   │   │   ├── services/
│   │   │   │   └── workout_service.dart
│   │   │   └── repositories/
│   │   │       └── workout_repository.dart
│   │   │
│   │   ├── providers/
│   │   │   └── workout_provider.dart
│   │   │
│   │   └── ui/
│   │       ├── pages/
│   │       │   ├── workout_list_page.dart
│   │       │   └── workout_detail_page.dart
│   │       └── widgets/
│   │           └── exercise_card.dart
│   │
│   └── nutrition/
│       └── ...
│
├── routes/
│   └── app_router.dart
│
└── main.dart
```

### 🎯 Best Practices Comparison

| Aspetto            | Angular             | Flutter           |
|--------------------|---------------------|-------------------|
| **Organizzazione** | Module-based        | Feature-first     |
| **Core services**  | `core/` module      | `core/` folder    |
| **Shared code**    | `shared/` module    | `shared/` folder  |
| **Features**       | Feature modules     | Feature folders   |
| **Constants**      | `environment.ts`    | `constants/`      |
| **Models**         | Per feature         | In `data/models/` |
| **State**          | Services in feature | `providers/`      |

---

## 🎯 RIEPILOGO BEST PRACTICES

### ✅ Angular Best Practices

1. **OnPush Change Detection** - Performance
2. **Reactive Forms** - Type-safe forms
3. **NgRx** (per app grandi) - State management
4. **Lazy Loading** - Modules caricati on-demand
5. **TrackBy** in ngFor - Performance liste
6. **takeUntil** pattern - Cleanup subscriptions
7. **Smart/Dumb Components** - Separation of concerns
8. **Standalone Components** (Angular 14+) - Semplifica architettura

### ✅ Flutter/Riverpod Best Practices

1. **Riverpod** over Provider - Migliore DI e type safety
2. **Immutable Models** - Con `copyWith()`
3. **const Constructors** - Performance
4. **Keys** quando necessario - Gestione state
5. **Dispose Controllers** - Cleanup manuale
6. **StatelessWidget** quando possibile - Performance
7. **Repository Pattern** - Astrazione dati
8. **go_router** - Routing type-safe

---

## 🚀 Prossimi Step per Te

### 1. Setup Riverpod

```bash
flutter pub add flutter_riverpod
```

### 2. Converti uno Service Angular → Provider Flutter

Prendi un tuo service Angular esistente e convertilo!

### 3. Pratica con Widget

Crea widget come componenti Angular (input/output pattern)

### 4. Master Testing

Testing in Flutter è simile ad Angular, ma con sintassi diversa

---

## 📚 Risorse

- [Riverpod Docs](https://riverpod.dev)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [go_router](https://pub.dev/packages/go_router)
- [Flutter Best Practices](https://docs.flutter.dev/perf/best-practices)

---

**Hai Angular nel sangue? Flutter sarà facile! 💙**

La mentalità è la stessa:

- ✅ Separazione dei concern
- ✅ Dependency Injection
- ✅ Reactive programming
- ✅ Type safety
- ✅ Testing first

**Solo la sintassi cambia!** 🎯
