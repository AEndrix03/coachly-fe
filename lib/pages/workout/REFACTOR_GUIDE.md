# 🏗️ Workout Module Refactor - Istruzioni

## ⚡ Quick Start

### 1. Aggiorna pubspec.yaml

```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  equatable: ^2.0.5
  go_router: ^13.0.0

dev_dependencies:
  build_runner: ^2.4.6
  freezed: ^2.4.5
  json_serializable: ^6.7.1
```

```bash
flutter pub get
```

### 2. Genera codice Freezed

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Files da aggiornare

#### Imports mancanti
Alcuni widget potrebbero avere import mancanti. Aggiorna:

```dart
// Prima
import '../models/exercise_model.dart';

// Dopo
import '../../../data/models/exercise_model.dart';
```

#### Widget che usano ExerciseModel
Aggiorna signature:

```dart
// Prima
final List<Map<String, dynamic>> sets;

// Dopo
final ExerciseModel exercise;
```

## 📋 Checklist Completamento

- [x] Core error layer (failures, either)
- [x] Models Freezed (set, exercise, session)
- [x] Repository Either pattern
- [x] Shared widgets (buttons, cards, dialogs)
- [x] workout_active_page refactored
- [x] Debouncer utility
- [ ] Run build_runner
- [ ] Fix imports
- [ ] Test app
- [ ] Aggiorna altri widget per ExerciseModel
- [ ] Implementa debounce per weight/reps
- [ ] Test error handling

## 🔧 Common Fixes

### Build Runner Errors

```bash
# Clean
flutter clean
flutter pub get

# Build
flutter pub run build_runner build --delete-conflicting-outputs
```

### Import Errors

Usa import relativi per files nella stessa feature:
```dart
import '../data/models/exercise_model.dart';
```

Usa import assoluti per shared code:
```dart
import 'package:coachly/widgets/shared/shared_widgets.dart';
```

### Freezed Not Generating

Verifica che i file abbiano:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_name.freezed.dart';
part 'file_name.g.dart';
```

## 🎯 Pattern Usage

### Either Pattern

```dart
final result = await repository.getWorkoutSession(id);

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (data) => print('Success: $data'),
);
```

### Provider Usage

```dart
final sessionState = ref.watch(workoutSessionProvider(workoutId));

if (sessionState.isLoading) return LoadingWidget();
if (sessionState.hasError) return ErrorWidget(sessionState.errorMessage!);
if (!sessionState.hasData) return EmptyWidget();

final session = sessionState.session!;
// Use session
```

### Shared Widgets

```dart
PrimaryButton(
  text: 'Complete',
  icon: Icons.check,
  onPressed: () {},
)

SecondaryButton(
  text: 'Cancel',
  onPressed: () {},
)

ConfirmationDialog.show(
  context,
  title: 'Exit?',
  message: 'Progress will be saved',
)

StatsCard(
  label: 'Volume',
  value: '5,240 kg',
  icon: Icons.fitness_center,
)
```

## 🚀 Next Features

1. **Debounced Input**: Weight/reps changes con 500ms delay
2. **Offline Support**: Cache workout sessioni
3. **Error Retry**: Auto-retry failed requests
4. **Optimistic Updates**: UI update immediato, sync async
5. **Analytics**: Track user actions
6. **Tests**: Unit + integration tests

## 📚 References

- [Freezed Docs](https://pub.dev/packages/freezed)
- [Riverpod Docs](https://riverpod.dev)
- [Either Pattern](https://dev.to/rxlabz/functional-error-handling-in-flutter-with-dartz-2n3e)
