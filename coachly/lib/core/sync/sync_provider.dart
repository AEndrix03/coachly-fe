import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'local_database_service.dart';
import 'sync_manager.dart';

part 'sync_provider.g.dart';

/// Provider per LocalDatabaseService (Singleton)
@Riverpod(keepAlive: true)
LocalDatabaseService localDatabase(Ref ref) {
  final db = LocalDatabaseService();
  return db;
}

/// Provider per EnhancedSyncManager (Singleton)
@Riverpod(keepAlive: true)
EnhancedSyncManager syncManager(Ref ref) {
  final db = ref.watch(localDatabaseProvider);
  final syncManager = EnhancedSyncManager(
    db: db,
    syncInterval: const Duration(minutes: 5),
  );

  // Initialize on first access
  syncManager.initialize();

  // Dispose quando l'app chiude
  ref.onDispose(() {
    syncManager.dispose();
  });

  return syncManager;
}

/// Provider per stato sync enabled/disabled
@riverpod
class SyncEnabled extends _$SyncEnabled {
  @override
  bool build() {
    final db = ref.watch(localDatabaseProvider);
    return db.isSyncEnabled;
  }

  /// Toggle sync on/off
  Future<void> toggle() async {
    final syncManager = ref.read(syncManagerProvider);
    await syncManager.setSyncEnabled(!state);
    state = !state;
  }

  /// Enable sync
  Future<void> enable() async {
    final syncManager = ref.read(syncManagerProvider);
    await syncManager.setSyncEnabled(true);
    state = true;
  }

  /// Disable sync
  Future<void> disable() async {
    final syncManager = ref.read(syncManagerProvider);
    await syncManager.setSyncEnabled(false);
    state = false;
  }
}

/// Provider per sync stats (stream che aggiorna ogni 10 secondi)
@riverpod
Stream<SyncStats> syncStats(Ref ref) async* {
  final syncManager = ref.watch(syncManagerProvider);

  // Emetti stats iniziali
  yield await syncManager.getStats();

  // Poi aggiorna ogni 10 secondi
  await for (final _ in Stream.periodic(const Duration(seconds: 10))) {
    yield await syncManager.getStats();
  }
}
