# Tech Stack - Coachly Frontend

## Core Framework

- **Flutter**: 3.16+ (cross-platform mobile framework)
- **Dart**: 3.x con null safety
- **IDE**: Android Studio con Flutter plugin / VS Code con Flutter extension

## State Management

- **flutter_riverpod**: ^2.4.0 (state management principale)
- **riverpod_annotation**: code generation per provider
- **build_runner**: per generare codice (*.g.dart files)

## Routing & Navigation

- **go_router**: ^12.0.0
  - Routing dichiarativo
  - Deep linking support
  - StatefulShellRoute per bottom navigation
  - Custom transitions (fade, slide, ecc.)

## UI/UX

- **Material 3**: Design system di base
- **Custom Theme**: Dark theme con colori brand
  - Primary: #3B82F6 (Blue)
  - Secondary: #6366F1 (Indigo)
  - Surface: #121212 (Dark)
  - Cards: #1E1E2A (Darker)

## Networking (da implementare)

- **dio**: HTTP client per API calls
- **retrofit** (opzionale): Type-safe HTTP client
- **json_serializable**: JSON serialization

## Local Storage (previsto)

- **shared_preferences**: Persistent key-value storage
- **hive** / **sqflite**: Database locale
- **secure_storage**: Dati sensibili (tokens)

## AI Integration (previsto)

- **speech_to_text**: Riconoscimento vocale per workout input
- **permission_handler**: Gestione permessi device

## Utilities

- **Custom extensions**: String, DateTime, etc.
- **Constants**: Configurazioni centralizzate

## Development Tools

- **flutter_lints**: Linting rules
- **dart_code_metrics** (opzionale): Code quality
- **flutter_test**: Testing framework

## Backend Communication

- **RESTful API**: Spring Boot backend
- **WebSocket** (futuro): Real-time updates
- **JWT**: Autenticazione

## Build & Deploy

- **Android**: SDK 30+, Gradle
- **iOS**: iOS 15+, Xcode (su Mac)
- **CI/CD**: GitHub Actions (previsto)
