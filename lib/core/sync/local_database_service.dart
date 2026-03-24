import 'package:coachly/core/sync/adapters/workout_adapter.dart';
import 'package:coachly/features/workout/workout_page/data/models/workout_model/workout_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Local Hive database service.
///
/// Stores workouts cache, exercises cache, app settings and offline-first
/// session/sync state boxes.
class LocalDatabaseService {
  static const int _dbVersion = 1;

  static String get workoutsBox => 'workouts_v$_dbVersion';
  static String get workoutSessionsBox => 'workout_sessions_v$_dbVersion';
  static String get sessionSyncJobsBox => 'session_sync_jobs_v$_dbVersion';
  static String get workoutStructuredBox => 'workout_structured_v$_dbVersion';
  static String get voiceAliasesBox => 'voice_aliases_v$_dbVersion';
  static String get voiceResolutionLogsBox => 'voice_resolution_logs_v$_dbVersion';

  static const String _exercisesBox = 'exercises';
  static const String _settingsBox = 'settings';

  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();

  factory LocalDatabaseService() => _instance;

  LocalDatabaseService._internal();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WorkoutAdapter());
    }

    await _cleanOldBoxes();

    await Hive.openBox<WorkoutModel>(workoutsBox);
    await Hive.openBox<Map>(workoutSessionsBox);
    await Hive.openBox<Map>(sessionSyncJobsBox);
    await Hive.openBox<Map>(workoutStructuredBox);
    await Hive.openBox<Map>(voiceAliasesBox);
    await Hive.openBox<Map>(voiceResolutionLogsBox);
    await Hive.openBox<Map>(_exercisesBox);
    await Hive.openBox<dynamic>(_settingsBox);

    _initialized = true;
    debugPrint('Local database initialized (v$_dbVersion)');
  }

  Future<void> _cleanOldBoxes() async {
    for (int version = 1; version < _dbVersion; version += 1) {
      await _safeDelete('workouts_v$version');
      await _safeDelete('workout_sessions_v$version');
      await _safeDelete('session_sync_jobs_v$version');
      await _safeDelete('workout_structured_v$version');
      await _safeDelete('voice_aliases_v$version');
      await _safeDelete('voice_resolution_logs_v$version');
    }
  }

  Future<void> _safeDelete(String boxName) async {
    try {
      await Hive.deleteBoxFromDisk(boxName);
      debugPrint('Cleaned old box: $boxName');
    } catch (_) {
      // No-op: box might not exist on old installs.
    }
  }

  Box<WorkoutModel> get workouts => Hive.box<WorkoutModel>(workoutsBox);

  Box<Map> get exercises => Hive.box<Map>(_exercisesBox);

  Box<Map> get workoutSessions => Hive.box<Map>(workoutSessionsBox);

  Box<Map> get sessionSyncJobs => Hive.box<Map>(sessionSyncJobsBox);

  Box<Map> get workoutStructured => Hive.box<Map>(workoutStructuredBox);

  Box<Map> get voiceAliases => Hive.box<Map>(voiceAliasesBox);

  Box<Map> get voiceResolutionLogs => Hive.box<Map>(voiceResolutionLogsBox);

  Box<dynamic> get settings => Hive.box<dynamic>(_settingsBox);

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
    debugPrint('Saved $key to $boxName (dirty=true)');
  }

  Future<void> markAsSynced({
    required String boxName,
    required String key,
  }) async {
    final box = await Hive.openBox<Map>(boxName);
    final data = box.get(key);
    if (data == null) {
      return;
    }

    data['isDirty'] = false;
    data['lastSynced'] = DateTime.now().toIso8601String();
    await box.put(key, data);
    debugPrint('Marked $key as synced');
  }

  Future<List<Map<String, dynamic>>> getDirtyItems(String boxName) async {
    final box = await Hive.openBox<Map>(boxName);
    final dirtyItems = <Map<String, dynamic>>[];

    for (final key in box.keys) {
      final item = box.get(key);
      if (item != null && item['isDirty'] == true) {
        dirtyItems.add(Map<String, dynamic>.from(item));
      }
    }

    debugPrint('Found ${dirtyItems.length} dirty items in $boxName');
    return dirtyItems;
  }

  Future<List<Map<String, dynamic>>> getAllItems(String boxName) async {
    final box = await Hive.openBox<Map>(boxName);
    return box.values.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> deleteItem({
    required String boxName,
    required String key,
  }) async {
    final box = await Hive.openBox<Map>(boxName);
    await box.delete(key);
    debugPrint('Deleted $key from $boxName');
  }

  Future<void> clearAll() async {
    await Hive.box<WorkoutModel>(workoutsBox).clear();
    await Hive.box<Map>(workoutSessionsBox).clear();
    await Hive.box<Map>(sessionSyncJobsBox).clear();
    await Hive.box<Map>(workoutStructuredBox).clear();
    await Hive.box<Map>(voiceAliasesBox).clear();
    await Hive.box<Map>(voiceResolutionLogsBox).clear();
    await Hive.box<Map>(_exercisesBox).clear();
    await Hive.box<dynamic>(_settingsBox).clear();
    debugPrint('Cleared all local data');
  }

  bool get isSyncEnabled => settings.get('syncEnabled', defaultValue: true);

  Future<void> setSyncEnabled(bool enabled) async {
    await settings.put('syncEnabled', enabled);
    debugPrint('Sync ${enabled ? 'enabled' : 'disabled'}');
  }

  DateTime? get lastSyncTime {
    final timestamp = settings.get('lastSyncTime');
    if (timestamp is! String) {
      return null;
    }
    return DateTime.tryParse(timestamp);
  }

  Future<void> updateLastSyncTime() async {
    await settings.put('lastSyncTime', DateTime.now().toIso8601String());
  }
}

final localDatabaseServiceProvider = Provider<LocalDatabaseService>((ref) {
  return LocalDatabaseService();
});
