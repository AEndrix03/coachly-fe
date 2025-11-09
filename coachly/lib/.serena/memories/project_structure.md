# Project Structure

## Directory Layout

```
lib/
├── config/                  # Configurazioni e costanti
│   └── constants.dart       # Costanti globali (URLs, keys, ecc.)
│
├── models/                  # Modelli dati globali (se necessari)
│
├── pages/                   # Features dell'app organizzate per dominio
│   ├── home/
│   │   └── home.dart
│   │
│   ├── workout/            # Feature Workout (esempio completo)
│   │   ├── data/           # Data layer
│   │   │   └── workout_model.dart
│   │   ├── domain/         # Business logic
│   │   │   └── workout_controller.dart
│   │   ├── providers/      # State management
│   │   │   └── workout_provider.dart
│   │   └── ui/             # Presentation layer
│   │       ├── detail/
│   │       │   └── workout_detail_page.dart
│   │       ├── widgets/
│   │       │   ├── workout_card.dart
│   │       │   ├── workout_header.dart
│   │       │   └── workout_recent_card.dart
│   │       └── workout_page.dart
│   │
│   ├── nutrition/          # Feature Nutrizione (da implementare)
│   ├── community/          # Feature Community (da implementare)
│   └── auth/               # Feature Autenticazione (da implementare)
│
├── providers/              # Provider globali
│   └── navigation/
│       ├── navigation_provider.dart
│       └── navigation_provider.g.dart  # Generated
│
├── routes/                 # Routing configuration
│   └── app_router.dart     # go_router setup
│
├── services/               # Servizi esterni (API, storage, ecc.)
│   └── (da implementare)
│
├── themes/                 # Tema e styling
│   └── theme.dart          # AppTheme (dark/light)
│
├── utils/                  # Utilities e helpers
│   └── extensions.dart     # Extensions su tipi base
│
├── widgets/                # Widget riutilizzabili cross-feature
│   ├── navigation/
│   │   └── navigation_bar.dart
│   └── shared/
│       └── card/
│           └── card.dart
│
└── main.dart               # Entry point dell'app
```

## Architettura per Feature

Ogni feature segue una struttura modulare con separazione dei concerns:

### Data Layer (`data/`)
- **Models**: Classi dati immutabili
- **Data Sources**: API clients, local storage
- **Repositories**: Implementazioni concrete

### Domain Layer (`domain/`)
- **Controllers**: Business logic con Riverpod Notifier
- **Entities**: Oggetti business (se diversi da models)
- **Use Cases**: Logica di business complessa (opzionale)

### Presentation Layer (`ui/`)
- **Pages**: Schermate principali
- **Widgets**: Componenti UI specifici della feature
- **Detail pages**: Sotto-pagine della feature

## File Organization Pattern

```dart
// pages/workout/
//
// Data layer
data/workout_model.dart              # Modello Workout
data/workout_repository.dart         # Repository interface
data/workout_repository_impl.dart    # Implementazione con API

// Domain layer
domain/workout_controller.dart       # Business logic + state

// Providers
providers/workout_provider.dart      # Provider Riverpod

// UI layer
ui/workout_page.dart                 # Pagina principale
ui/detail/workout_detail_page.dart   # Dettaglio workout
ui/widgets/workout_card.dart         # Card widget
```

## Naming Conventions per Files

- **Pages**: `*_page.dart` o semplicemente nome feature
- **Widgets**: Nome descrittivo snake_case
- **Models**: `*_model.dart`
- **Controllers**: `*_controller.dart`
- **Providers**: `*_provider.dart`
- **Repositories**: `*_repository.dart`

## Generated Files

File generati da build_runner (non editare manualmente):
- `*.g.dart` - Riverpod codegen
- `*.freezed.dart` - Freezed models (futuro)
- `*.gr.dart` - AutoRoute (se usato)

## Global vs Feature-specific

### Global (root level)
- Routes configuration
- App theme
- Shared widgets usati in multiple features
- Global providers (auth, settings, ecc.)
- Constants e configs

### Feature-specific (dentro pages/)
- Tutto ciò che è specifico di una feature
- Models della feature
- UI components della feature
- Business logic della feature

## Best Practices

1. **Ogni feature è auto-contenuta**: Minimizza dipendenze tra features
2. **Shared code**: Va in `widgets/`, `utils/`, o crea un package separato
3. **Generated files**: Mai in version control (aggiungi a .gitignore)
4. **Import relativi**: Usa per file nella stessa feature
5. **Import assoluti**: Usa per codice shared o altre features

## Future Structure (quando il progetto cresce)

```
lib/
├── core/                   # Funzionalità core
│   ├── network/           # HTTP client, interceptors
│   ├── storage/           # Local storage abstractions
│   ├── error/             # Error handling
│   └── utils/             # Utilities globali
│
├── features/              # Alias di 'pages' (se si vuole)
│   ├── auth/
│   ├── workout/
│   ├── nutrition/
│   └── ...
│
└── shared/                # Codice condiviso
    ├── widgets/
    ├── models/
    └── extensions/
```
