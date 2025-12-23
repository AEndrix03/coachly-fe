import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service per gestire il database locale con Hive
/// Fornisce API type-safe per storage locale di entità
class LocalDatabaseService {
  // Box names
  static const String workoutsBox = 'workouts';
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

    // Open boxes
    await Hive.openBox<Map>(workoutsBox);
    await Hive.openBox<Map>(_exercisesBox);
    await Hive.openBox<dynamic>(_settingsBox);

    _initialized = true;
    print('📦 Local database initialized');
  }

  /// Get workouts box
  Box<Map> get workouts => Hive.box<Map>(workoutsBox);

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
    await Hive.box<Map>(workoutsBox).clear();
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
