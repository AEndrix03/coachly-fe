# Task Completion Checklist

Quando si completa un task di sviluppo, seguire questa checklist per assicurare qualità e coerenza del codice.

## 🔍 Pre-Commit Checklist

### 1. Code Generation
```cmd
# Se hai modificato file con annotations (@riverpod, @freezed, ecc.)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Code Formatting
```cmd
# Formatta tutto il codice
dart format lib

# Verifica che non ci siano modifiche necessarie
dart format --output=none lib
```

### 3. Static Analysis
```cmd
# Esegui linting
flutter analyze

# Non dovrebbero esserci errori o warning
```

### 4. Testing
```cmd
# Esegui tutti i test
flutter test

# Verifica coverage se necessario
flutter test --coverage
```

### 5. Build Verification
```cmd
# Verifica che l'app compili senza errori
flutter build apk --debug

# O per iOS (se su Mac)
flutter build ios --debug
```

## ✅ Code Quality Checks

### Naming Conventions
- [ ] File names sono `snake_case`
- [ ] Class names sono `PascalCase`
- [ ] Variables/functions sono `camelCase`
- [ ] Constants sono `SCREAMING_SNAKE_CASE` o `_privateCamelCase`

### Code Style
- [ ] Usato `const` dove possibile
- [ ] Import ordinati (dart → flutter → packages → local)
- [ ] Nessun import inutilizzato
- [ ] Widget complessi estratti in componenti separati
- [ ] Evitate funzioni/widget troppo lunghi (>100 righe)

### Documentation
- [ ] Commenti per logica complessa
- [ ] TODO comments per lavoro futuro
- [ ] API public documentation (se necessario)

### Performance
- [ ] Evitato rebuild inutili (usato const, memoization)
- [ ] Caricamento immagini ottimizzato
- [ ] Liste con `ListView.builder` per grandi dataset

## 📝 Documentation Updates

### Quando aggiungere/modificare features
- [ ] Aggiornare README se necessario
- [ ] Documentare nuove API/endpoints
- [ ] Aggiornare CHANGELOG (se presente)

### Per nuove features importanti
- [ ] Creare memory file in Serena se necessario
- [ ] Documentare pattern/convenzioni usate

## 🧪 Testing Requirements

### Per ogni nuova feature
- [ ] Unit tests per business logic (controllers)
- [ ] Widget tests per componenti UI critici
- [ ] Integration tests per flussi completi (opzionale)

### Coverage Target
- Minimo **70%** code coverage per nuove features
- 100% per critical business logic

## 🔄 Git Workflow

### Commit
```cmd
# Stage changes
git add .

# Commit con messaggio descrittivo
git commit -m "feat: add workout detail page with exercise list"

# Push
git push origin feature/workout-detail
```

### Commit Message Convention
```
feat: nuova feature
fix: bug fix
refactor: refactoring senza cambi funzionali
style: formatting, missing semicolons, ecc.
docs: documentazione
test: aggiunta/modifica test
chore: build, dependencies, ecc.
```

### Branch Naming
```
feature/nome-feature
bugfix/nome-bug
refactor/nome-refactor
```

## 🚀 Before Pull Request

### Final Checks
- [ ] Branch aggiornato con main/develop
- [ ] Tutti i test passano
- [ ] Flutter analyze senza errori
- [ ] Code formattato
- [ ] Build funziona su almeno un device/emulator
- [ ] Screenshots/GIF per cambi UI (se rilevante)

### PR Description Template
```markdown
## Descrizione
Breve descrizione del cambiamento

## Tipo di Cambiamento
- [ ] Bug fix
- [ ] Nuova feature
- [ ] Breaking change
- [ ] Documentazione

## Testing
Come è stato testato?

## Screenshots (se UI)
[Aggiungi screenshots]

## Checklist
- [ ] Codice formattato
- [ ] Test aggiunti
- [ ] Documentazione aggiornata
```

## 📱 Device Testing

### Test su Multiple Devices (prima di release)
- [ ] Android phone (diversi screen size)
- [ ] iOS phone (se disponibile)
- [ ] Tablet (opzionale)
- [ ] Diversi Android versions (min SDK - latest)

### Orientation Testing
- [ ] Portrait mode
- [ ] Landscape mode (se supportato)

## 🔐 Security Checks

### Prima di commit
- [ ] Nessun API key hardcoded
- [ ] Nessuna password/secret in chiaro
- [ ] Sensitive data in .env o secure storage
- [ ] .gitignore aggiornato per file sensibili

## 📊 Performance Checks

### Quando modifichi UI complesse
```cmd
# Profila performance
flutter run --profile

# Apri DevTools per analisi dettagliata
```

### Checklist Performance
- [ ] 60 FPS su device target
- [ ] Nessun jank nelle animazioni
- [ ] Tempi di caricamento accettabili (<2s per schermata)

## 🎨 UI/UX Checks

### Prima di completare UI
- [ ] Rispetta design system (colori, spacing, typography)
- [ ] Accessible (contrast ratio, tap targets)
- [ ] Responsive su diversi screen size
- [ ] Loading states implementati
- [ ] Error states gestiti
- [ ] Empty states implementati

## 🔔 Notifiche

### Se il task è completato
- [ ] Spostare ticket su board (TODO → In Review → Done)
- [ ] Notificare team se necessario
- [ ] Aggiornare documentazione di progetto

## 🐛 Bug Fixing Checklist

### Quando fixo un bug
- [ ] Identificata root cause
- [ ] Aggiunto test che riproduce il bug
- [ ] Fix implementato
- [ ] Test passa
- [ ] Regressione verificata (bug non si ripresenta)
- [ ] Log/error handling migliorato se necessario

## 🎯 Final Command Sequence

Sequenza tipica prima di commit:

```cmd
# 1. Rigenera codice se necessario
flutter pub run build_runner build -d

# 2. Formatta
dart format lib

# 3. Analizza
flutter analyze

# 4. Test
flutter test

# 5. Verifica build
flutter build apk --debug

# 6. Se tutto OK, commit
git add .
git commit -m "feat: descrizione"
git push
```

## 🚨 Quick Fixes per Errori Comuni

### Build Runner Errors
```cmd
flutter pub run build_runner clean
flutter pub run build_runner build -d
```

### Dependency Conflicts
```cmd
flutter clean
del pubspec.lock
flutter pub get
```

### Gradle Errors (Android)
```cmd
cd android
gradlew clean
cd ..
flutter clean
flutter pub get
```

## 📚 Resources

- Flutter DevTools: `flutter pub global run devtools`
- Documentation: https://flutter.dev/docs
- Riverpod: https://riverpod.dev/docs/introduction/getting_started
