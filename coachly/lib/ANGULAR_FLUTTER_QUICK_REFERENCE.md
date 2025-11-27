# ⚡ Angular → Flutter Quick Reference

## 🔄 Equivalenze Rapide

### State Management

| Angular | Flutter/Riverpod | Esempio |
|---------|------------------|---------|
| `BehaviorSubject<T>` | `StateProvider<T>` | `final counterProvider = StateProvider((ref) => 0);` |
| `Observable<T>` | `Stream<T>` o `Provider<T>` | `final dataProvider = Provider<Data>((ref) => ...);` |
| `service.data$` | `ref.watch(dataProvider)` | In widget: `final data = ref.watch(dataProvider);` |
| `.subscribe()` | `ref.listen()` | Side effects |
| `| async` pipe | `ref.watch()` | Auto-subscription |
| `.next(value)` | `state = value` | In StateProvider |

### Dependency Injection

| Angular | Flutter/Riverpod |
|---------|------------------|
| `@Injectable({ providedIn: 'root' })` | `Provider<T>((ref) => Service())` |
| `constructor(private service: Service)` | `ref.watch(serviceProvider)` |
| `TestBed.configureTestingModule({...})` | `ProviderScope(overrides: [...])` |

### Components

| Angular | Flutter |
|---------|---------|
| `@Component` | `StatelessWidget` o `StatefulWidget` |
| `@Input()` | Constructor parameter |
| `@Output() event = new EventEmitter()` | `void Function()` callback |
| `ngOnInit()` | `initState()` |
| `ngOnDestroy()` | `dispose()` |
| `ngOnChanges()` | `didUpdateWidget()` |
| `*ngIf` | Conditional: `condition ? widget : null` |
| `*ngFor` | `.map()` o `ListView.builder()` |

### Routing

| Angular | Flutter (go_router) |
|---------|---------------------|
| `router.navigate(['/path'])` | `context.go('/path')` |
| `route.params` | `state.pathParameters` |
| `route.queryParams` | `state.uri.queryParameters` |
| `CanActivate` guard | `redirect` callback |
| `location.back()` | `context.pop()` |

### HTTP

| Angular | Flutter |
|---------|---------|
| `http.get<T>(url)` | `apiClient.get<T>(endpoint)` |
| `http.post<T>(url, body)` | `apiClient.post<T>(endpoint, body: {...})` |
| `.pipe(catchError(...))` | `try-catch` + `ApiResponse` |
| `HttpInterceptor` | Custom logic in `ApiClient` |

### Forms

| Angular | Flutter |
|---------|---------|
| `FormGroup` | `Form` + `GlobalKey<FormState>` |
| `FormControl` | `TextEditingController` |
| `Validators.required` | `validator: (v) => v?.isEmpty == true ? 'Required' : null` |
| `form.value` | `controller.text` |
| `formGroup.valid` | `formKey.currentState!.validate()` |

### Testing

| Angular | Flutter |
|---------|---------|
| `describe()` | `group()` |
| `it()` | `test()` |
| `beforeEach()` | `setUp()` |
| `expect().toBe()` | `expect(actual, matcher)` |
| `ComponentFixture` | `testWidgets()` |
| `jasmine.createSpyObj()` | `Mock*` with Mockito |

---

## 🎨 Code Snippets Comparison

### Service con Observable → Provider

```typescript
// Angular
@Injectable({ providedIn: 'root' })
export class CounterService {
  private count = new BehaviorSubject(0);
  count$ = this.count.asObservable();
  
  increment(): void {
    this.count.next(this.count.value + 1);
  }
}
```

```dart
// Flutter/Riverpod
final counterProvider = StateNotifierProvider<CounterNotifier, int>(
  (ref) => CounterNotifier(),
);

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);
  
  void increment() {
    state = state + 1;
  }
}
```

### Component con Subscription → Widget con Watch

```typescript
// Angular Component
@Component({
  template: `
    <div>{{ count$ | async }}</div>
    <button (click)="increment()">+</button>
  `
})
export class CounterComponent {
  count$ = this.counterService.count$;
  
  constructor(private counterService: CounterService) {}
  
  increment(): void {
    this.counterService.increment();
  }
}
```

```dart
// Flutter Widget
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    
    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).increment(),
          child: Text('+'),
        ),
      ],
    );
  }
}
```

### HTTP Call con Error Handling

```typescript
// Angular Service
@Injectable({ providedIn: 'root' })
export class DataService {
  getData(): Observable<Data> {
    return this.http.get<Data>('/api/data').pipe(
      catchError(error => {
        console.error(error);
        return throwError(() => error);
      })
    );
  }
}

// Component
this.dataService.getData().subscribe({
  next: data => this.data = data,
  error: err => this.error = err.message
});
```

```dart
// Flutter Service
class DataService {
  final ApiClient _client;
  
  Future<ApiResponse<Data>> getData() async {
    try {
      return await _client.get('/api/data', 
        fromJson: (json) => Data.fromJson(json)
      );
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}

// Widget
final response = await ref.read(dataServiceProvider).getData();
if (response.success && response.data != null) {
  setState(() => data = response.data);
} else {
  setState(() => error = response.message);
}
```

### Form Validation

```typescript
// Angular
this.form = this.fb.group({
  email: ['', [Validators.required, Validators.email]],
  password: ['', [Validators.required, Validators.minLength(8)]]
});

<input formControlName="email">
<span *ngIf="form.get('email')?.invalid">Invalid email</span>
```

```dart
// Flutter
final _emailController = TextEditingController();
final _passwordController = TextEditingController();

TextFormField(
  controller: _emailController,
  validator: (value) {
    if (value == null || value.isEmpty) return 'Required';
    if (!value.contains('@')) return 'Invalid email';
    return null;
  },
)

TextFormField(
  controller: _passwordController,
  validator: (value) {
    if (value == null || value.isEmpty) return 'Required';
    if (value.length < 8) return 'Min 8 characters';
    return null;
  },
)
```

---

## 💡 Concetti Chiave

### 1. Immutabilità (come NgRx)

```dart
// ❌ BAD (muta stato)
state.name = 'New Name';

// ✅ GOOD (immutabile)
state = state.copyWith(name: 'New Name');
```

### 2. Dispose Controllers (importante!)

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  
  @override
  void dispose() {
    _controller.dispose();  // ⚠️ IMPORTANTE!
    super.dispose();
  }
}
```

### 3. ref.watch vs ref.read

```dart
// ✅ ref.watch - nel build(), auto-rebuild quando cambia
final count = ref.watch(counterProvider);

// ✅ ref.read - in callbacks, NO rebuild
onPressed: () => ref.read(counterProvider.notifier).increment()

// ❌ MAI ref.read nel build()!
final count = ref.read(counterProvider); // ❌ NO!
```

### 4. ProviderScope (come NgModule)

```dart
void main() {
  runApp(
    ProviderScope(  // ⚠️ OBBLIGATORIO per Riverpod
      child: MyApp(),
    ),
  );
}
```

---

## 🎯 Mental Model

### Angular → Flutter Translation

Pensa così:

- **Service** → `Provider` (global state)
- **Component** → `Widget` (UI)
- **@Input** → Constructor parameter
- **@Output** → Callback function
- **Observable** → `Stream` o Provider
- **| async** → `ref.watch()`
- **ngOnInit** → `initState()`
- **ngOnDestroy** → `dispose()`
- **FormGroup** → `Form` + controllers
- **Router** → `go_router`
- **Module** → Feature folder

### Workflow Tipico

**Angular:**
1. Create service con Observable
2. Inject in component
3. Subscribe in ngOnInit
4. Unsubscribe in ngOnDestroy

**Flutter/Riverpod:**
1. Create Provider
2. `ref.watch()` in widget
3. Auto-subscribe (nessun cleanup manuale!)

---

## ⚠️ Gotchas (Attenzione!)

### 1. Dispose Manuale

```dart
// Angular: cleanup automatico
// Flutter: DEVI fare dispose manualmente!

@override
void dispose() {
  _controller.dispose();
  _focusNode.dispose();
  _subscription.cancel();
  super.dispose();
}
```

### 2. Keys quando necessario

```dart
// Se riordini widget, usa Key
ListView(
  children: items.map((item) => 
    ItemWidget(key: ValueKey(item.id), item: item)
  ).toList(),
)
```

### 3. const per Performance

```dart
// ✅ Usa const quando possibile
const Text('Hello');  // Non ricostruito
Text('Hello');        // Ricostruito ogni volta
```

### 4. BuildContext in Async

```dart
// ❌ BAD - context potrebbe non essere valido
Future<void> loadData() async {
  await Future.delayed(Duration(seconds: 1));
  Navigator.of(context).pop();  // ❌ Potrebbe crashare!
}

// ✅ GOOD - check mounted
Future<void> loadData() async {
  await Future.delayed(Duration(seconds: 1));
  if (!mounted) return;
  Navigator.of(context).pop();  // ✅ Safe
}
```

---

## 📦 Packages Essenziali

| Angular | Flutter Package |
|---------|-----------------|
| RxJS | `rxdart` (se serve) |
| NgRx | `flutter_riverpod` ⭐ |
| Angular Router | `go_router` ⭐ |
| HttpClient | `http` + custom `ApiClient` ⭐ |
| Angular Forms | Built-in `Form` + controllers |
| Jasmine/Karma | Built-in `test` package |
| - | `equatable` (per models) ⭐ |
| - | `freezed` (code generation models) |

⭐ = Highly recommended

---

## 🚀 Quick Start Commands

```bash
# Create project
flutter create myapp

# Add Riverpod
flutter pub add flutter_riverpod

# Add other essentials
flutter pub add http equatable go_router

# Run
flutter run

# Test
flutter test

# Build
flutter build apk  # Android
flutter build ios  # iOS
```

---

## 📚 Cheat Sheet Links

- [Riverpod Docs](https://riverpod.dev)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)
- [Dart Language Tour](https://dart.dev/language)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

---

## 💡 Pro Tips

1. **StatelessWidget first** - Come OnPush in Angular
2. **const everywhere** - Performance gratis
3. **Extract widgets** - Come componenti riusabili
4. **Provider per tutto** - DI consistente
5. **Test dal Day 1** - Come in Angular
6. **Hot Reload** - Usa sempre (R in terminal)
7. **DevTools** - Per debug state (come Redux DevTools)

---

**Da Angular Developer a Flutter Pro in 1 settimana! 🚀**

Ricorda: **Stessa mentalità, sintassi diversa!** 💙
