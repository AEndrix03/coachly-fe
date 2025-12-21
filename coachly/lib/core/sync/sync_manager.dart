import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'local_database_service.dart';

/// Modello per rappresentare un'operazione di sincronizzazione
class SyncOperation {
  final String id;
  final String entityType; // 'workout', 'exercise', etc
  final String operationType; // 'create', 'update', 'delete'
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final int retryCount;

  SyncOperation({
    required this.id,
    required this.entityType,
    required this.operationType,
    required this.data,
    required this.timestamp,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'entityType': entityType,
    'operationType': operationType,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'retryCount': retryCount,
  };

  factory SyncOperation.fromJson(Map<String, dynamic> json) => SyncOperation(
    id: json['id'],
    entityType: json['entityType'],
    operationType: json['operationType'],
    data: Map<String, dynamic>.from(json['data']),
    timestamp: DateTime.parse(json['timestamp']),
    retryCount: json['retryCount'] ?? 0,
  );

  SyncOperation copyWith({int? retryCount}) => SyncOperation(
    id: id,
    entityType: entityType,
    operationType: operationType,
    data: data,
    timestamp: timestamp,
    retryCount: retryCount ?? this.retryCount,
  );
}

/// Enhanced Sync Manager con storage locale e sincronizzazione intelligente
class EnhancedSyncManager {
  final LocalDatabaseService _db;
  final Duration syncInterval;
  final int maxRetries;

  Timer? _periodicSyncTimer;
  bool _isSyncing = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  EnhancedSyncManager({
    required LocalDatabaseService db,
    this.syncInterval = const Duration(minutes: 5),
    this.maxRetries = 3,
  }) : _db = db;

  /// Initialize sync manager
  Future<void> initialize() async {
    await _db.initialize();

    // Start periodic sync if enabled
    if (_db.isSyncEnabled) {
      startPeriodicSync();
    }

    // Listen to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      final isConnected =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);
      if (isConnected && _db.isSyncEnabled) {
        print('🌐 Connectivity restored - triggering sync');
        syncAll();
      }
    });

    print('🔄 Enhanced Sync Manager initialized');
  }

  /// Start periodic sync
  void startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(syncInterval, (_) {
      if (_db.isSyncEnabled) {
        print('⏰ Periodic sync triggered');
        syncAll();
      }
    });
    print('⏰ Periodic sync started (every ${syncInterval.inMinutes} minutes)');
  }

  /// Stop periodic sync
  void stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
    print('⏰ Periodic sync stopped');
  }

  /// Enable/disable sync
  Future<void> setSyncEnabled(bool enabled) async {
    await _db.setSyncEnabled(enabled);
    if (enabled) {
      startPeriodicSync();
      await syncAll();
    } else {
      stopPeriodicSync();
    }
  }

  /// Check if sync is enabled
  bool get isSyncEnabled => _db.isSyncEnabled;

  /// Sync all dirty items
  Future<SyncResult> syncAll() async {
    if (_isSyncing) {
      print('⚠️  Sync already in progress, skipping');
      return SyncResult(success: false, message: 'Sync already in progress');
    }

    if (!_db.isSyncEnabled) {
      print('⚠️  Sync disabled, skipping');
      return SyncResult(success: false, message: 'Sync is disabled');
    }

    _isSyncing = true;
    print('🔄 Starting sync...');

    try {
      int totalSynced = 0;
      int totalFailed = 0;

      // Sync workouts
      final workoutResult = await _syncEntityType('workouts');
      totalSynced += workoutResult.synced;
      totalFailed += workoutResult.failed;

      // Sync exercises
      final exerciseResult = await _syncEntityType('exercises');
      totalSynced += exerciseResult.synced;
      totalFailed += exerciseResult.failed;

      await _db.updateLastSyncTime();

      print('✅ Sync completed: $totalSynced synced, $totalFailed failed');

      return SyncResult(
        success: totalFailed == 0,
        message:
            'Synced $totalSynced items${totalFailed > 0 ? ', $totalFailed failed' : ''}',
        syncedCount: totalSynced,
        failedCount: totalFailed,
      );
    } catch (e) {
      print('❌ Sync error: $e');
      return SyncResult(success: false, message: 'Sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync specific entity type
  Future<_EntitySyncResult> _syncEntityType(String boxName) async {
    final dirtyItems = await _db.getDirtyItems(boxName);

    if (dirtyItems.isEmpty) {
      print('✓ No dirty items in $boxName');
      return _EntitySyncResult(synced: 0, failed: 0);
    }

    print('📤 Syncing ${dirtyItems.length} items from $boxName');

    int synced = 0;
    int failed = 0;

    for (final item in dirtyItems) {
      try {
        // TODO: Replace with actual API call
        final success = await _syncSingleItem(boxName, item);

        if (success) {
          await _db.markAsSynced(boxName: boxName, key: item['localId']);
          synced++;
        } else {
          failed++;
        }
      } catch (e) {
        print('❌ Failed to sync ${item['localId']}: $e');
        failed++;
      }
    }

    return _EntitySyncResult(synced: synced, failed: failed);
  }

  /// Sync single item to server
  /// TODO: Implement actual API calls here
  Future<bool> _syncSingleItem(
    String entityType,
    Map<String, dynamic> item,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    print('📤 Syncing $entityType: ${item['localId']}');

    // TODO: Call actual API based on entity type
    // Example:
    // if (entityType == 'workouts') {
    //   final response = await workoutRepository.syncWorkout(item);
    //   return response.isSuccess;
    // }

    // For now, simulate success
    return true;
  }

  /// Save item locally and queue for sync
  Future<void> saveItem({
    required String entityType,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await _db.saveWithDirtyFlag(boxName: entityType, key: id, data: data);

    // Trigger immediate sync if online and enabled
    if (_db.isSyncEnabled) {
      syncAll();
    }
  }

  /// Delete item locally and queue deletion for sync
  Future<void> deleteItem({
    required String entityType,
    required String id,
  }) async {
    // Mark as deleted instead of actually deleting
    // This allows us to sync the deletion to server
    await _db.saveWithDirtyFlag(
      boxName: entityType,
      key: id,
      data: {'id': id, 'deleted': true},
    );

    if (_db.isSyncEnabled) {
      syncAll();
    }
  }

  /// Get all items of a type (always from local)
  Future<List<Map<String, dynamic>>> getItems(String entityType) async {
    final items = await _db.getAllItems(entityType);
    // Filter out deleted items
    return items.where((item) => item['deleted'] != true).toList();
  }

  /// Get sync statistics
  Future<SyncStats> getStats() async {
    final workoutsDirty = (await _db.getDirtyItems('workouts')).length;
    final exercisesDirty = (await _db.getDirtyItems('exercises')).length;

    return SyncStats(
      pendingWorkouts: workoutsDirty,
      pendingExercises: exercisesDirty,
      lastSyncTime: _db.lastSyncTime,
      isSyncEnabled: _db.isSyncEnabled,
      isSyncing: _isSyncing,
    );
  }

  /// Force sync now (manually triggered)
  Future<SyncResult> forceSyncNow() async {
    print('🔄 Force sync triggered by user');
    return await syncAll();
  }

  /// Dispose
  void dispose() {
    _periodicSyncTimer?.cancel();
    _connectivitySubscription?.cancel();
    print('🛑 Sync Manager disposed');
  }
}

/// Result of a sync operation
class SyncResult {
  final bool success;
  final String message;
  final int syncedCount;
  final int failedCount;

  SyncResult({
    required this.success,
    required this.message,
    this.syncedCount = 0,
    this.failedCount = 0,
  });
}

/// Internal class for entity sync results
class _EntitySyncResult {
  final int synced;
  final int failed;

  _EntitySyncResult({required this.synced, required this.failed});
}

/// Sync statistics
class SyncStats {
  final int pendingWorkouts;
  final int pendingExercises;
  final DateTime? lastSyncTime;
  final bool isSyncEnabled;
  final bool isSyncing;

  int get totalPending => pendingWorkouts + pendingExercises;

  SyncStats({
    required this.pendingWorkouts,
    required this.pendingExercises,
    required this.lastSyncTime,
    required this.isSyncEnabled,
    required this.isSyncing,
  });
}
