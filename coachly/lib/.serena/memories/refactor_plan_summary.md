# Refactor Plan Summary

## Documento Dettagliato
`REFACTOR_PLAN.md` - Piano completo di refactoring del progetto Flutter Coachly

## Problemi Principali Identificati

### 1. Architettura Inconsistente
- Workout: Clean Architecture ✅
- Home: singolo file ❌
- Features mancanti: auth, nutrition, community, coach

### 2. Naming Non Standard
- `pages/` invece di `features/`
- File duplicati (refactored versions)
- Models root vuoto

### 3. State Management
- Mix StatefulWidget + ConsumerWidget
- Provider non sempre usati correttamente
- Logica UI mescolata con business logic

### 4. Best Practices Mancanti
- No Freezed per models
- No error handling centralizzato
- No dependency injection
- Testing infrastructure assente

## Priorità Refactor

### 🔴 ALTA (Fase 1)
1. Ristrutturazione folders: `pages/` → `features/`
2. Rename `ui/` → `presentation/`
3. Pulizia file ridondanti
4. Standardizzazione naming

### 🟡 MEDIA (Fase 2)
1. Freezed per models
2. Separazione presentation logic
3. Componentizzazione widgets
4. Error handling centralizzato

### 🟢 BASSA (Fase 3)
1. Dependency injection
2. Testing infrastructure
3. Documentation
4. CI/CD

## Key Points
- Non rompere grafica esistente
- Preservare: color scheme, animations, glassmorphism
- Refactor logico/strutturale, UI identica o migliorata
- Test prima, deploy dopo

## Ordine Implementazione
1. Sprint 1: Foundation (folders, naming, core)
2. Sprint 2: Workout refactor completo
3. Sprint 3: Altri features + shared widgets
4. Sprint 4: Testing & polish
