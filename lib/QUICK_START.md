# 🚀 Quick Start Guide - Architettura Rifattorizzata

## 📋 Checklist Setup

### 1️⃣ Dipendenze (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.0
  
  # HTTP
  http: ^1.1.0
  
  # Utils
  equatable: ^2.0.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

**Esegui:**
```bash
flutter pub get
```

---

### 2️⃣ Struttura File Creati

```
lib/
├── core/
│   ├── constants/
│   │   └── api_endpoints.dart          ✅ Creato
│   └── network/
│       ├── api_client.dart              ✅ Creato
│       ├── api_exception.dart           ✅ Creato
│       └── api_response.dart            ✅ Creato
│
├── pages/
│   └── workout/
│       ├── data/
│       │   ├── models/
│       │   │   ├── set_model.dart                    ✅ Creato
│       │   │   ├── exercise_model.dart               ✅ Creato
│       │   │   └── workout_session_model.dart        ✅ Creato
│       │   ├── services/
│       │   │   └── workout_service.dart              ✅ Creato
│       │   └── repositories/
│       │       ├── workout_repository.dart           ✅ Creato
│       │       └── workout_repository_impl.dart      ✅ Creato
│       │
│       ├── providers/
│       │   └── workout_session_provider.dart         ✅ Creato
│       │
│       └── ui/
│           └── active/
│               ├── workout_active_page_refactored.dart    ✅ Creato
│               └── widgets/
│                   └── exercise_card_refactored.dart      ✅ Creato
│
├── main_example.dart                    ✅ Creato
│
└── test/
    └── workout_architecture_test.dart   ✅ Creato
```

---

### 3️⃣ Test Immediato

**Esegui i test:**
```bash
flutter test test/workout_architecture_test.dart
```

**Output atteso:**
```
✓ Models: SetModel should be immutable
✓ Models: ExerciseModel should calculate volume correctly
✓ Repository: Should load mock workout session
✓ Business Logic: Should add set to exercise
... (tutti i test passano)

All tests passed! ✅
```

---

### 4️⃣ Run App con Dati Mock

**Modifica il tuo main.dart:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/workout/ui/active/workout_active_page_refactored.dart';

void main() {
  runApp(
    const ProviderScope(  // ⚠️ IMPORTANTE: Non dimenticare!
      child: CoachlyApp(),
    ),
  );
}

class CoachlyApp extends StatelessWidget {
  const CoachlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WorkoutActivePage(
        workoutId: 'workout_123',  // ID mock
      ),
    );
  }
}
```

**Run:**
```bash
flutter run
```

**Vedrai:**
- ✅ Workout caricato con dati mock
- ✅ 3 esercizi con set
- ✅ Interazioni funzionanti
- ✅ Timer recupero automatico

---

### 5️⃣ Toggle Mock → Real Backend

**Quando il backend è pronto:**

```dart
// In workout_repository_impl.dart
WorkoutRepositoryImpl(
  workoutService,
  useMockData: false,  // 👈 Cambia a false
)
```

**E in api_endpoints.dart:**
```dart
class ApiEndpoints {
  static const String baseUrl = 'https://your-api.com/api';  // 👈 URL reale
  // ...
}
```

---

## 🎯 Come Usare

### Caricare un Workout

```dart
// Nel widget
@override
void initState() {
  super.initState();
  Future.microtask(() {
    ref.read(workoutSessionProvider.notifier)
        .loadWorkoutSession(widget.workoutId);
  });
}
```

### Leggere lo Stato

```dart
// Nel build
final workoutState = ref.watch(workoutSessionProvider);

if (workoutState.isLoading) {
  return CircularProgressIndicator();
}

if (workoutState.hasError) {
  return Text('Error: ${workoutState.errorMessage}');
}

final session = workoutState.session!;
// Usa session.exercises, session.currentExercise, ecc.
```

### Completare un Set

```dart
ref.read(workoutSessionProvider.notifier).toggleSetCompletion(
  exerciseId: 'ex_1',
  setIndex: 0,
  completed: true,
);
```

### Aggiungere un Set

```dart
ref.read(workoutSessionProvider.notifier).addSet('ex_1');
```

---

## 🐛 Troubleshooting

### "Provider not found"

**Problema:** `ProviderScope` non wrappa l'app

**Soluzione:**
```dart
void main() {
  runApp(
    const ProviderScope(  // 👈 Aggiungi questo
      child: MyApp(),
    ),
  );
}
```

---

### "Cannot read properties of null"

**Problema:** Accesso a `session` senza null check

**Soluzione:**
```dart
// ❌ BAD
final exercise = state.session.exercises.first;

// ✅ GOOD
final session = state.session;
if (session == null) return SizedBox.shrink();
final exercise = session.exercises.first;
```

---

### Test falliscono

**Problema:** Dipendenze non installate

**Soluzione:**
```bash
flutter pub get
flutter pub upgrade
flutter clean
flutter test
```

---

### Build errors dopo aggiunta files

**Problema:** IDE cache

**Soluzione:**
```bash
# VS Code / Android Studio
Flutter: Restart Dart Analysis Server

# Terminal
flutter clean
flutter pub get
```

---

## 📚 Next Steps

### 1. Immediate
- [ ] Esegui test
- [ ] Run app con mock data
- [ ] Familiarizza con i Models
- [ ] Prova a modificare un campo

### 2. Questa Settimana
- [ ] Connetti al backend reale
- [ ] Aggiungi error handling UI
- [ ] Implementa loading states
- [ ] Scrivi più test

### 3. Prossime Settimane
- [ ] Offline-first con local storage
- [ ] Analytics integration
- [ ] Performance monitoring
- [ ] CI/CD setup

---

## 💡 Tips

### Development Velocity

1. **Usa Hot Reload** (salva file = aggiorna app istantaneamente)
2. **Usa DevTools** per debuggare state
3. **Scrivi test prima** di codice complesso
4. **Mock data first**, backend dopo

### Best Practices

1. **Sempre null-safe**: Controlla prima di usare
2. **Immutabilità**: Usa `copyWith`, mai mutare diretto
3. **Single Responsibility**: Una classe, una responsabilità
4. **Type-safe**: No `Map<String, dynamic>` mai più!

---

## 🆘 Help

### Documentazione Ufficiale
- [Riverpod](https://riverpod.dev)
- [Flutter](https://flutter.dev)
- [Dart](https://dart.dev)

### Community
- [Flutter Discord](https://discord.gg/flutter)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

### Progetto Coachly
- README principale: `REFACTORING_README.md`
- Comparazione: `BEFORE_AFTER_COMPARISON.md`
- Documentazione API: `core/network/`

---

## ✨ Congratulazioni!

Hai completato il setup dell'architettura professionale Flutter! 🎉

**Ora hai:**
- ✅ Type-safe codebase
- ✅ Testabile al 100%
- ✅ Scalabile per anni
- ✅ Error handling robusto
- ✅ Mock data per sviluppo rapido

**Welcome to Pro Flutter!** 💙

---

## 🚀 Quick Commands

```bash
# Test
flutter test

# Run
flutter run

# Build
flutter build apk --release  # Android
flutter build ios --release  # iOS

# Analyze
flutter analyze

# Format
dart format .

# Clean
flutter clean && flutter pub get
```

**Happy Coding!** 🎯
