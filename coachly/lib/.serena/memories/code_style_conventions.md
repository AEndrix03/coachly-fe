# Code Style & Conventions

## File Naming

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE` o `_privateCamelCase` per static final
- **Private members**: Prefisso underscore `_privateMember`

### Esempi

```dart
// File: workout_card.dart
class WorkoutCard extends StatelessWidget {
  final Workout workout;
  static final _badgeDecoration = BoxDecoration(...);
  
  const WorkoutCard({super.key, required this.workout});
}
```

## Code Organization

### Import Order

1. Dart core libraries
2. Flutter libraries
3. Third-party packages
4. Local project imports (relative)

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/workout_model.dart';
import '../../providers/workout_provider.dart';
```

## Widget Style

### Prefer const constructors

```dart
// ✅ Good
const WorkoutCard({super.key, required this.workout});
const SizedBox(height: 16);

// ❌ Avoid
WorkoutCard({Key? key, required this.workout}) : super(key: key);
```

### Use StatelessWidget when possible

```dart
// ✅ Good - no mutable state
class WorkoutCard extends StatelessWidget {
  final Workout workout;
  const WorkoutCard({super.key, required this.workout});
  
  @override
  Widget build(BuildContext context) => Card(...);
}
```

### ConsumerWidget for Riverpod

```dart
// ✅ Good
class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationIndexProvider);
    return NavigationBar(...);
  }
}
```

## State Management

### Riverpod Provider Style

```dart
// Provider definition
@riverpod
class NavigationIndex extends _$NavigationIndex {
  @override
  int build() => 0;
  
  void set(int newIndex) => state = newIndex;
}

// Usage in widget
final index = ref.watch(navigationIndexProvider);
ref.read(navigationIndexProvider.notifier).set(2);
```

### Provider Naming

- **Provider suffix**: `Provider` (es. `workoutProvider`, `navigationIndexProvider`)
- **Notifier**: Use riverpod_annotation with codegen

## Model Classes

### Immutable Data Classes

```dart
class Workout {
  final String id;
  final String title;
  final int progress;
  
  const Workout({
    required this.id,
    required this.title,
    required this.progress,
  });
}
```

### Future: Use freezed for complex models

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
  }) = _User;
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

## Styling

### Inline styles for simple cases

```dart
Text(
  'Title',
  style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
)
```

### Extract to Theme for reusable styles

```dart
// In theme.dart
static ThemeData get dark => ThemeData(
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  ),
);

// Usage
Text('Title', style: Theme.of(context).textTheme.titleLarge)
```

## Navigation

### Use go_router for navigation

```dart
// Navigate
context.go('/workouts/workout/$id');
context.push('/settings');

// Pop
context.pop();
```

## Error Handling

```dart
try {
  final result = await apiCall();
  state = AsyncData(result);
} catch (e, stack) {
  state = AsyncError(e, stack);
  // Log error
  debugPrint('Error: $e');
}
```

## Code Quality Rules

1. **Always use const** when possible for performance
2. **Extract widgets** when they become complex (>50 lines)
3. **Prefer composition** over inheritance
4. **Use named parameters** for constructors with >2 params
5. **Avoid nullable types** unless necessary
6. **Document complex business logic** with comments
7. **Use meaningful names** (avoid abbreviations)

## Testing Style (when implemented)

```dart
void main() {
  group('WorkoutCard', () {
    testWidgets('should display workout title', (tester) async {
      const workout = Workout(id: '1', title: 'Test');
      
      await tester.pumpWidget(
        MaterialApp(home: WorkoutCard(workout: workout)),
      );
      
      expect(find.text('Test'), findsOneWidget);
    });
  });
}
```
