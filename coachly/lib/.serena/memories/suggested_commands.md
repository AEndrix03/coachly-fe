# Suggested Commands - Coachly Frontend

## ⚠️ Nota su Windows

Il progetto è sviluppato su **Windows**. I comandi seguenti sono per Command Prompt / PowerShell.

## Setup Iniziale

### Verifica Installazione Flutter
```cmd
flutter doctor
```

### Installa Dipendenze
```cmd
cd C:\Users\redeg\Documents\Progetti\Coachly\coachly-fe\coachly
flutter pub get
```

### Genera Codice (Riverpod, Freezed, ecc.)
```cmd
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch Mode per Codegen (auto-regenera)
```cmd
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Sviluppo

### Avvia App su Emulatore/Device
```cmd
flutter run
```

### Avvia su device specifico
```cmd
# Lista devices disponibili
flutter devices

# Run su device specifico
flutter run -d <device_id>

# Run su Chrome (web)
flutter run -d chrome
```

### Hot Reload
Quando l'app è in esecuzione:
- **r**: Hot reload (aggiorna UI)
- **R**: Hot restart (restart completo)
- **q**: Quit

### Pulisci Build Cache
```cmd
flutter clean
flutter pub get
```

## Testing

### Esegui Tutti i Test
```cmd
flutter test
```

### Test Specifico
```cmd
flutter test test/widgets/workout_card_test.dart
```

### Test con Coverage
```cmd
flutter test --coverage
```

## Code Quality

### Analizza Codice (Linting)
```cmd
flutter analyze
```

### Formatta Codice
```cmd
# Formatta tutti i file
dart format lib

# Formatta file specifico
dart format lib/pages/workout/ui/workout_page.dart

# Check senza modificare
dart format --output=none lib
```

### Fix Automatici
```cmd
dart fix --apply
```

## Build

### Build APK (Android Debug)
```cmd
flutter build apk --debug
```

### Build APK (Android Release)
```cmd
flutter build apk --release
```

### Build App Bundle (per Play Store)
```cmd
flutter build appbundle --release
```

### Build iOS (solo su Mac)
```cmd
flutter build ios --release
```

### Build Web
```cmd
flutter build web --release
```

## Debugging

### Esegui in Profile Mode (performance)
```cmd
flutter run --profile
```

### Esegui in Release Mode
```cmd
flutter run --release
```

### DevTools
```cmd
flutter pub global activate devtools
flutter pub global run devtools
```

## Dependency Management

### Aggiungi Package
```cmd
flutter pub add <package_name>

# Esempi
flutter pub add dio
flutter pub add shared_preferences
```

### Aggiungi Dev Dependency
```cmd
flutter pub add --dev <package_name>

# Esempio
flutter pub add --dev mockito
```

### Aggiorna Dipendenze
```cmd
# Mostra outdated packages
flutter pub outdated

# Aggiorna tutto (rispettando constraints)
flutter pub upgrade

# Aggiorna specifico package
flutter pub upgrade <package_name>
```

### Rimuovi Unused Dependencies
```cmd
flutter pub deps
```

## Git (Windows)

### Common Commands
```cmd
git status
git add .
git commit -m "messaggio"
git push origin main

# Branch
git checkout -b feature/nome-feature
git branch
git merge feature/nome-feature
```

## Utility Commands (Windows)

### Navigazione Directory
```cmd
cd <directory>        # Cambia directory
dir                   # Lista files
cd ..                 # Vai su
cd \                  # Vai alla root
```

### File Operations
```cmd
type <file>           # Mostra contenuto file (cat su Unix)
copy <src> <dest>     # Copia file
del <file>            # Elimina file
mkdir <dir>           # Crea directory
rmdir /s <dir>        # Elimina directory ricorsivamente
```

### Search
```cmd
findstr /s "pattern" *.dart       # Cerca in tutti i .dart
dir /s /b *.dart                  # Trova tutti i file .dart
```

### Process Management
```cmd
tasklist | findstr "flutter"      # Trova processi flutter
taskkill /F /PID <pid>            # Killa processo
```

## Project-Specific

### Rigenera Routes (se uso di auto_route)
```cmd
flutter pub run build_runner build --delete-conflicting-outputs
```

### Reset Completo Progetto
```cmd
flutter clean
del pubspec.lock
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Controlla Dimensione App
```cmd
flutter build apk --analyze-size
```

## Troubleshooting

### Problemi con Build Runner
```cmd
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Problemi con Gradle (Android)
```cmd
cd android
gradlew clean
cd ..
flutter clean
flutter pub get
```

### Problemi con Pods (iOS, solo Mac)
```cmd
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
```

## CI/CD (Future)

### Build per CI
```cmd
flutter test --machine
flutter build apk --release --no-tree-shake-icons
```

## Documentation

### Genera Documentazione API
```cmd
dart doc .
```

## Performance

### Build con Tree Shaking (size optimization)
```cmd
flutter build apk --release --tree-shake-icons
```

### Analizza Performance
```cmd
flutter run --profile
# Poi apri DevTools
```

## Quick Reference

| Azione | Comando |
|--------|---------|
| Installa dipendenze | `flutter pub get` |
| Genera codice | `flutter pub run build_runner build -d` |
| Formatta codice | `dart format lib` |
| Analizza codice | `flutter analyze` |
| Esegui test | `flutter test` |
| Pulisci cache | `flutter clean` |
| Avvia app | `flutter run` |
| Build release APK | `flutter build apk --release` |

## Note Importanti

1. **Sempre** eseguire `flutter pub get` dopo modifiche a `pubspec.yaml`
2. **Sempre** rigenerare codice dopo modifiche a file con annotations (`@riverpod`, `@freezed`, ecc.)
3. Su Windows, alcuni comandi potrebbero richiedere **Run as Administrator**
4. Per performance migliori in sviluppo, usa **hot reload** (r) invece di restart completo
