═══════════════════════════════════════════════════════════════════════
SYNC MANAGER - INTEGRATION GUIDE
═══════════════════════════════════════════════════════════════════════

ARCHITETTURA OFFLINE-FIRST COMPLETA
Questa guida spiega come integrare il Sync Manager nell'app Coachly

═══════════════════════════════════════════════════════════════════════
📦 STEP 1: DIPENDENZE (pubspec.yaml)
═══════════════════════════════════════════════════════════════════════

dependencies:
hive: ^2.2.3
hive_flutter: ^1.1.0
connectivity_plus: ^5.0.2

dev_dependencies:
hive_generator: ^2.0.1
build_runner: ^2.4.0

Poi esegui:
flutter pub get

═══════════════════════════════════════════════════════════════════════
🏗️ STEP 2: INIZIALIZZAZIONE NEL MAIN
═══════════════════════════════════════════════════════════════════════

// main.dart
void main() async {
WidgetsFlutterBinding.ensureInitialized();

// 1. Initialize Hive PRIMA di tutto
final db = LocalDatabaseService();
await db.initialize();

// 2. Initialize Sync Manager
final syncManager = EnhancedSyncManager(db: db);
await syncManager.initialize();

runApp(
ProviderScope(
child: MyApp(),
),
);
}

═══════════════════════════════════════════════════════════════════════
📁 STRUTTURA FILE
═══════════════════════════════════════════════════════════════════════

lib/
├─ core/
│ ├─ sync/
│ │ ├─ local_database_service.dart
│ │ ├─ enhanced_sync_manager.dart
│ │ ├─ sync_providers.dart
│ │ └─ sync_providers.g.dart (generato)
│ │
├─ features/
│ ├─ workout/
│ │ ├─ data/
│ │ │ ├─ repositories/
│ │ │ │ └─ workout_repository_offline.dart
│ │ │
│ │ ├─ presentation/
│ │ │ ├─ pages/
│ │ │ │ ├─ workout_list_page_example.dart
│ │ │ │ └─ sync_settings_page_example.dart

═══════════════════════════════════════════════════════════════════════
🔄 STEP 3: GENERARE CODICE RIVERPOD
═══════════════════════════════════════════════════════════════════════

dart run build_runner build --delete-conflicting-outputs

Questo genera sync_providers.g.dart

═══════════════════════════════════════════════════════════════════════
🎯 COME FUNZIONA L'ARCHITETTURA
═══════════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────────┐
│ UI LAYER │
│  (Workout List Page, Forms, etc)                                    │
│ │
│ - Sempre ISTANTANEA (legge da locale)                              │
│ - Nessun loading spinner per operazioni CRUD │
└──────────────────┬───────────────────────────────────────────────────┘
│ usa
▼
┌─────────────────────────────────────────────────────────────────────┐
│ REPOSITORY LAYER │
│  (WorkoutRepository, ExerciseRepository)                            │
│ │
│ - READ:  Sempre da locale (Hive)                                   │
│ - WRITE: Salva locale + marca "dirty"                              │
│ - DELETE: Marca "deleted" (soft delete)                            │
└──────────────────┬───────────────────────────────────────────────────┘
│ usa
▼
┌─────────────────────────────────────────────────────────────────────┐
│ SYNC MANAGER │
│  (EnhancedSyncManager)                                              │
│ │
│ Background tasks:                                                   │
│ 1. Ogni 5 minuti: controlla items "dirty"                          │
│ 2. Se online: invia batch a server │
│ 3. Se success: marca "synced" (isDirty=false)                      │
│ 4. Se fail: retry fino a 3 volte │
└──────────────────┬───────────────────────────────────────────────────┘
│ usa
▼
┌─────────────────────────────────────────────────────────────────────┐
│ LOCAL DATABASE (Hive)                            │
│  (LocalDatabaseService)                                             │
│ │
│ Boxes:                                                              │
│ - workouts: {id, data, isDirty, lastModified, lastSynced} │
│ - exercises: {id, data, isDirty, lastModified, lastSynced} │
│ - settings: {syncEnabled, lastSyncTime, ...} │
└─────────────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════
💡 ESEMPIO FLUSSO: UTENTE CREA WORKOUT OFFLINE
═══════════════════════════════════════════════════════════════════════

1. User preme "Create Workout"
   └─ UI chiama: repository.createWorkout(workout)

2. Repository salva IMMEDIATAMENTE in Hive
   └─ Dati: {id: "local_123", name: "...", isDirty: true}
   └─ UI si aggiorna SUBITO (reattiva!)

3. Sync Manager (background, ogni 5 min)
   ├─ Trova workout con isDirty=true
   ├─ Controlla connectivity
   └─ Se online:
   ├─ POST /api/workouts {data}
   ├─ Server risponde: {id: "server_456"}
   ├─ Aggiorna locale: {id: "server_456", isDirty: false}
   └─ UI si aggiorna automaticamente

4. Se offline:
   └─ Resta con isDirty=true
   └─ Retry quando torna online

═══════════════════════════════════════════════════════════════════════
⚙️ CONFIGURAZIONE SYNC INTERVAL
═══════════════════════════════════════════════════════════════════════

In sync_providers.dart:

@Riverpod(keepAlive: true)
EnhancedSyncManager syncManager(SyncManagerRef ref) {
return EnhancedSyncManager(
db: db,
syncInterval: const Duration(minutes: 5), // <-- Modifica qui
maxRetries: 3, // <-- Max retry per item
);
}

OPZIONI:

- Duration(minutes: 1)  → Sync frequente (più chiamate API)
- Duration(minutes: 10) → Sync meno frequente (meno batteria)
- Duration(minutes: 30) → Sync molto raro

═══════════════════════════════════════════════════════════════════════
🎛️ COME USARE NEI WIDGET
═══════════════════════════════════════════════════════════════════════

// 1. GET WORKOUTS (sempre da locale, istantaneo)
final workoutsAsync = ref.watch(workoutsProvider);

// 2. CREATE WORKOUT (salva locale, sync background)
final repository = ref.read(workoutRepositoryProvider);
await repository.createWorkout(newWorkout);

// 3. UPDATE WORKOUT (salva locale, sync background)
await repository.updateWorkout(updatedWorkout);

// 4. DELETE WORKOUT (soft delete, sync background)
await repository.deleteWorkout(workoutId);

// 5. FORCE SYNC (manuale, es: pull to refresh)
final result = await repository.syncNow();

// 6. TOGGLE SYNC ON/OFF
ref.read(syncEnabledProvider.notifier).toggle();

// 7. GET SYNC STATS (pending items, last sync, etc)
final stats = ref.watch(syncStatsProvider);

═══════════════════════════════════════════════════════════════════════
🔌 STEP 4: IMPLEMENTARE API SYNC NEL BACKEND
═══════════════════════════════════════════════════════════════════════

Nel tuo enhanced_sync_manager.dart, sostituisci questo TODO:

Future<bool> _syncSingleItem(String entityType, Map<String, dynamic> item) async {
// TODO: Implementa chiamate API vere

if (entityType == 'workouts') {
// Se item ha "deleted" = true
if (item['deleted'] == true) {
// DELETE /api/workouts/{id}
await workoutApiService.deleteWorkout(item['id']);
}
// Se item ha ID server (già esiste)
else if (!item['id'].startsWith('local_')) {
// PUT /api/workouts/{id}
await workoutApiService.updateWorkout(item);
}
// Se item ha ID locale (nuovo)
else {
// POST /api/workouts
final response = await workoutApiService.createWorkout(item);

      // Aggiorna ID locale → server ID
      await _db.deleteItem(boxName: entityType, key: item['localId']);
      await _db.saveWithDirtyFlag(
        boxName: entityType,
        key: response.id,
        data: {...item, 'id': response.id},
      );
      await _db.markAsSynced(boxName: entityType, key: response.id);
    }
    
    return true;

}

return false;
}

═══════════════════════════════════════════════════════════════════════
🎨 STEP 5: AGGIUNGERE SYNC UI
═══════════════════════════════════════════════════════════════════════

1. SETTINGS PAGE con toggle sync
   → Usa sync_settings_page_example.dart

2. SYNC INDICATOR in AppBar
   → Usa SyncStatusIndicator widget

3. PULL TO REFRESH nelle liste
   → Già implementato in workout_list_page_example.dart

═══════════════════════════════════════════════════════════════════════
🧪 TESTING
═══════════════════════════════════════════════════════════════════════

TEST 1: Offline Create
├─ Disabilita WiFi
├─ Crea workout
├─ Verifica: workout appare subito nella lista
├─ Riabilita WiFi
└─ Verifica: dopo 5 min (o force sync) workout sync al server

TEST 2: Offline Update
├─ Disabilita WiFi
├─ Modifica workout
├─ Verifica: modifiche appaiono subito
├─ Riabilita WiFi
└─ Verifica: sync aggiorna server

TEST 3: Sync Disabled
├─ Vai in Settings
├─ Disabilita sync
├─ Modifica dati
└─ Verifica: dati restano locali (no sync)

TEST 4: Force Sync
├─ Crea/modifica dati
├─ Pull-to-refresh nella lista
└─ Verifica: sync immediato

═══════════════════════════════════════════════════════════════════════
🐛 TROUBLESHOOTING
═══════════════════════════════════════════════════════════════════════

PROBLEMA: "Box is already open"
SOLUZIONE: Assicurati di chiamare initialize() UNA SOLA VOLTA

PROBLEMA: Sync non parte mai
SOLUZIONE: Verifica che syncEnabled=true in settings

PROBLEMA: Items restano "dirty" per sempre
SOLUZIONE: Controlla connectivity e implementa API calls

PROBLEMA: Dati duplicati
SOLUZIONE: Gestisci correttamente ID locale → server ID

═══════════════════════════════════════════════════════════════════════
📊 MONITORING & DEBUG
═══════════════════════════════════════════════════════════════════════

LOG DA CERCARE:
├─ 📦 Local database initialized
├─ 🔄 Enhanced Sync Manager initialized
├─ ⏰ Periodic sync started
├─ 🔍 Found X dirty items
├─ 📤 Syncing X items
├─ ✅ Sync completed
└─ ❌ Failed to sync

STATS DISPONIBILI:

- pendingWorkouts: quanti workout da sincronizzare
- pendingExercises: quanti exercise da sincronizzare
- lastSyncTime: quando è avvenuto ultimo sync
- isSyncEnabled: se sync è attivo
- isSyncing: se sync in progress ora

═══════════════════════════════════════════════════════════════════════
🎯 VANTAGGI ARCHITETTURA
═══════════════════════════════════════════════════════════════════════

✅ UI SEMPRE REATTIVA - Nessun loading per CRUD
✅ OFFLINE-FIRST - App funziona senza internet
✅ AUTO-SYNC - Sincronizza automaticamente quando possibile
✅ CONFLICT-FREE - Last-write-wins con timestamp
✅ BATTERY FRIENDLY - Sync periodico configurabile
✅ DEVELOPER-FRIENDLY - Repository pattern semplice

═══════════════════════════════════════════════════════════════════════