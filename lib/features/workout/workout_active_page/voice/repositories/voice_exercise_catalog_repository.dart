import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_hive_service.dart';
import 'package:coachly/features/workout/workout_active_page/voice/models/voice_resolution_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final voiceExerciseCatalogRepositoryProvider =
    Provider<VoiceExerciseCatalogRepository>((ref) {
      final exerciseHiveService = ref.watch(exerciseHiveServiceProvider);
      return VoiceExerciseCatalogRepository(exerciseHiveService);
    });

class VoiceExerciseCatalogRepository {
  VoiceExerciseCatalogRepository(this._exerciseHiveService);

  final ExerciseHiveService _exerciseHiveService;

  List<VoiceExerciseCatalogEntry>? _cache;

  Future<List<VoiceExerciseCatalogEntry>> getCatalog() async {
    if (_cache != null) {
      return _cache!;
    }

    final exercises = await _exerciseHiveService.getExercises();
    final catalog = exercises.map((exercise) {
      final exerciseId = exercise.id ?? '';
      final names = exercise.nameI18n?.values.where((name) => name.trim().isNotEmpty);
      final canonicalName = _firstOrNull(names) ?? _fromId(exerciseId);

      final aliases = <String>{
        canonicalName,
        _fromId(exerciseId),
      };

      aliases.addAll(exercise.nameI18n?.values ?? const <String>[]);

      for (final variant in exercise.variants ?? const []) {
        aliases.addAll(variant.nameI18n?.values ?? const <String>[]);
      }

      final primaryEquipmentCandidates = exercise.equipments
              ?.where((entry) => entry.isPrimary)
              .map((entry) => _firstOrNull(entry.equipment.nameI18n.values))
              .whereType<String>()
              .toList(growable: false) ??
          const <String>[];
      final resolvedPrimaryEquipment = _firstOrNull(primaryEquipmentCandidates);

      final muscles = exercise.muscles
          ?.map((muscle) => _firstOrNull(muscle.muscle?.nameI18n.values))
          .whereType<String>()
          .toList(growable: false) ??
          const <String>[];

      return VoiceExerciseCatalogEntry(
        exerciseId: exerciseId,
        canonicalName: canonicalName,
        aliases: aliases.where((alias) => alias.trim().isNotEmpty).toList(),
        equipment: resolvedPrimaryEquipment,
        muscleGroups: muscles,
        isActive: true,
      );
    }).where((entry) => entry.exerciseId.trim().isNotEmpty).toList(growable: false);

    _cache = catalog;
    return catalog;
  }

  List<VoiceExerciseCatalogEntry> mergeWithContext({
    required List<VoiceExerciseCatalogEntry> catalog,
    required VoiceResolutionContext context,
  }) {
    final mergedById = <String, VoiceExerciseCatalogEntry>{
      for (final exercise in catalog) exercise.exerciseId: exercise,
    };

    for (final workoutExercise in context.workoutExercises) {
      final existing = mergedById[workoutExercise.exerciseId];
      if (existing == null) {
        mergedById[workoutExercise.exerciseId] = VoiceExerciseCatalogEntry(
          exerciseId: workoutExercise.exerciseId,
          canonicalName: workoutExercise.displayName,
          aliases: workoutExercise.aliases,
          equipment: null,
          muscleGroups: const <String>[],
          isActive: true,
        );
        continue;
      }

      final aliases = <String>{...existing.aliases, ...workoutExercise.aliases};
      mergedById[workoutExercise.exerciseId] = VoiceExerciseCatalogEntry(
        exerciseId: existing.exerciseId,
        canonicalName: existing.canonicalName,
        aliases: aliases.toList(),
        equipment: existing.equipment,
        muscleGroups: existing.muscleGroups,
        isActive: existing.isActive,
      );
    }

    return mergedById.values.toList(growable: false);
  }

  String _fromId(String id) {
    return id.replaceAll(RegExp(r'[_-]+'), ' ').trim();
  }

  String? _firstOrNull(Iterable<String>? values) {
    if (values == null) {
      return null;
    }
    for (final value in values) {
      if (value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}
