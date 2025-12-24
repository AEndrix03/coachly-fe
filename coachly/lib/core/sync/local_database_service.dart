import 'package:coachly/core/sync/adapters/workout_adapter.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service per gestire il database locale con Hive
/// Fornisce API type-safe per storage locale di entità
class LocalDatabaseService {
  // Box version
  static const int _dbVersion = 1;
  static const bool devMode = true;

  // Box names
  static String get workoutsBox => 'workouts_v$_dbVersion';
  static const String _exercisesBox = 'exercises';
  static const String _settingsBox = 'settings';

  // Singleton
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();

  factory LocalDatabaseService() => _instance;

  LocalDatabaseService._internal();

  bool _initialized = false;

  /// Initialize Hive database
  Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Registra adapter
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WorkoutAdapter());
    }

    // Pulisci vecchi box
    await _cleanOldBoxes();

    // Apri box con versione nel nome
    await Hive.openBox<WorkoutModel>(workoutsBox);
    await Hive.openBox<Map>(_exercisesBox);
    await Hive.openBox<dynamic>(_settingsBox);

    _initialized = true;
    print('📦 Local database initialized (v$_dbVersion)');
  }

  Future<void> _cleanOldBoxes() async {
    if (!devMode) {
      for (int v = 1; v < _dbVersion; v++) {
        try {
          await Hive.deleteBoxFromDisk('workouts_v$v');
          print('🧹 Cleaned old box: workouts_v$v');
        } catch (_) {}
      }
    } else {
      print('⚠️ Dev mode active: Old box cleanup');
      Hive.deleteFromDisk();
    }
  }

  /// Get workouts box
  Box<WorkoutModel> get workouts => Hive.box<WorkoutModel>(workoutsBox);

  /// Get exercises box
  Box<Map> get exercises => Hive.box<Map>(_exercisesBox);

  /// Get settings box
  Box<dynamic> get settings => Hive.box<dynamic>(_settingsBox);

  /// Save entity with dirty flag
  Future<void> saveWithDirtyFlag<T>({
    required String boxName,
    required String key,
    required Map<String, dynamic> data,
  }) async {
    final box = await Hive.openBox<Map>(boxName);
    final enrichedData = {
      ...data,
      'localId': key,
      'isDirty': true,
      'lastModified': DateTime.now().toIso8601String(),
    };
    await box.put(key, enrichedData);
    print('💾 Saved $key to $boxName (dirty=true)');
  }

  /// Mark entity as synced (not dirty)
  Future<void> markAsSynced({
    required String boxName,
    required String key,
  }) async {
    final box = await Hive.openBox<Map>(boxName);
    final data = box.get(key);
    if (data != null) {
      data['isDirty'] = false;
      data['lastSynced'] = DateTime.now().toIso8601String();
      await box.put(key, data);
      print('✓ Marked $key as synced');
    }
  }

  /// Get all dirty (unsynced) items from a box
  Future<List<Map<String, dynamic>>> getDirtyItems(String boxName) async {
    final box = await Hive.openBox<Map>(boxName);
    final dirtyItems = <Map<String, dynamic>>[];

    for (var key in box.keys) {
      final item = box.get(key);
      if (item != null && item['isDirty'] == true) {
        dirtyItems.add(Map<String, dynamic>.from(item));
      }
    }

    print('🔍 Found ${dirtyItems.length} dirty items in $boxName');
    return dirtyItems;
  }

  /// Get all items from a box
  Future<List<Map<String, dynamic>>> getAllItems(String boxName) async {
    final box = await Hive.openBox<Map>(boxName);
    return box.values.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  /// Delete item
  Future<void> deleteItem({
    required String boxName,
    required String key,
  }) async {
    final box = await Hive.openBox<Map>(boxName);
    await box.delete(key);
    print('🗑️ Deleted $key from $boxName');
  }

  /// Clear all data (use with caution!)
  Future<void> clearAll() async {
    await Hive.box<WorkoutModel>(workoutsBox).clear();
    await Hive.box<Map>(_exercisesBox).clear();
    await Hive.box<dynamic>(_settingsBox).clear();
    print('🧹 Cleared all local data');
  }

  /// Get sync settings
  bool get isSyncEnabled => settings.get('syncEnabled', defaultValue: true);

  Future<void> setSyncEnabled(bool enabled) async {
    await settings.put('syncEnabled', enabled);
    print('⚙️ Sync ${enabled ? 'enabled' : 'disabled'}');
  }

  DateTime? get lastSyncTime {
    final timestamp = settings.get('lastSyncTime');
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  Future<void> updateLastSyncTime() async {
    await settings.put('lastSyncTime', DateTime.now().toIso8601String());
  }
}

final localDatabaseServiceProvider = Provider<LocalDatabaseService>((ref) {
  return LocalDatabaseService();
});
