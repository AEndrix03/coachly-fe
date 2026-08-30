import 'package:coachly/core/time/clock.dart';
import 'package:coachly/features/workout/workout_active_page/coach/domain/coach_decision.dart';
import 'package:coachly/features/workout/data/local/active_workout_draft_dao.dart';
import 'package:coachly/features/workout/workout_active_page/providers/active_workout_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeWorkoutDraftServiceProvider = Provider<ActiveWorkoutDraftService>((
  ref,
) {
  return ActiveWorkoutDraftService(
    ref.watch(activeWorkoutDraftDaoProvider),
    ref.watch(clockProvider),
  );
});

/// Serializza lo stato dell'allenamento attivo nella bozza locale.
///
/// La persistenza vive nel DAO Drift: qui resta solo la traduzione fra lo stato
/// applicativo e il documento salvato (`docs/development/04-data-layer.md`).
class ActiveWorkoutDraftService {
  const ActiveWorkoutDraftService(this._dao, this._clock);

  final ActiveWorkoutDraftDao _dao;
  final Clock _clock;

  Future<void> save(String workoutId, ActiveWorkoutState state) async {
    await _dao.save(workoutId, {
      'sessionId': state.sessionId,
      'startedAt': state.startedAt?.toIso8601String(),
      'currentBlockId': state.currentTarget?.blockId,
      'currentExerciseId': state.currentTarget?.exerciseId,
      'currentSetId': state.currentTarget?.setId,
      'phase': state.phase.name,
      'lastSetCompletedAt': state.lastSetCompletedAt?.toIso8601String(),
      'updatedAt': _clock.nowUtc().toIso8601String(),
      'sessionChanges': state.sessionChanges,
      'exerciseEntryIds': [
        for (final exercise in state.exercises) exercise.exercise.id,
      ],
      'sets': [
        for (final exercise in state.exercises)
          for (final set in exercise.sets)
            {
              'exerciseEntryId': exercise.exercise.id,
              'setId': set.id,
              'position': set.position,
              'setType': set.setType,
              'weight': set.weight,
              'reps': set.reps,
              'rir': set.rir,
              'durationSeconds': set.durationSeconds,
              'distance': set.distance,
              'leftReps': set.leftReps,
              'rightReps': set.rightReps,
              'role': set.role.name,
              'technique': set.technique.name,
              'drops': [
                for (final drop in set.drops)
                  {'id': drop.id, 'weight': drop.weight, 'reps': drop.reps},
              ],
              'note': set.note,
              'noteTags':
                  set.noteTags?.map((tag) => tag.name).toList() ?? const [],
              'completed': set.completed,
              'skipped': set.skipped,
            },
      ],
      'groups': [
        for (final group in state.groups)
          {
            'id': group.id,
            'type': group.type.name,
            'exerciseIds': group.exerciseIds,
            'restBetweenExercisesSeconds': group.restBetweenExercisesSeconds,
            'restAfterRoundSeconds': group.restAfterRoundSeconds,
            'rounds': group.rounds,
          },
      ],
    });
  }

  Future<Map<String, dynamic>?> read(String workoutId) => _dao.read(workoutId);

  Future<void> saveRest({
    required String workoutId,
    required DateTime endsAt,
    required int initialSeconds,
  }) async {
    final current = await read(workoutId) ?? <String, dynamic>{};
    await _dao.save(workoutId, {
      ...current,
      'restEndsAt': endsAt.toIso8601String(),
      'restInitialSeconds': initialSeconds,
    });
  }

  Future<void> clearRest(String workoutId) async {
    final current = await read(workoutId);
    if (current == null) return;
    current.remove('restEndsAt');
    current.remove('restInitialSeconds');
    await _dao.save(workoutId, current);
  }

  Future<void> saveCoachDecision(
    String workoutId,
    CoachDecision? decision,
  ) async {
    final current = await read(workoutId) ?? <String, dynamic>{};
    if (decision == null) {
      current.remove('coachDecision');
    } else {
      current['coachDecision'] = _candidateToJson(decision.primary);
    }
    await _dao.save(workoutId, current);
  }

  CoachDecision? readCoachDecision(Map<String, dynamic>? draft) {
    final raw = draft?['coachDecision'];
    if (raw is! Map) return null;
    final json = raw.map((key, value) => MapEntry(key.toString(), value));
    T enumValue<T extends Enum>(List<T> values, String? name, T fallback) =>
        values.where((value) => value.name == name).firstOrNull ?? fallback;
    final rawEvidence = json['evidence'] as List? ?? const [];
    return CoachDecision(
      primary: CoachDecisionCandidate(
        id: json['id'] as String? ?? 'restored-decision',
        type: enumValue(
          CoachDecisionType.values,
          json['type'] as String?,
          CoachDecisionType.observe,
        ),
        scope: enumValue(
          CoachDecisionScope.values,
          json['scope'] as String?,
          CoachDecisionScope.set,
        ),
        severity: enumValue(
          CoachDecisionSeverity.values,
          json['severity'] as String?,
          CoachDecisionSeverity.observation,
        ),
        confidence: enumValue(
          CoachConfidence.values,
          json['confidence'] as String?,
          CoachConfidence.insufficient,
        ),
        titleKey: json['titleKey'] as String? ?? '',
        reasonKey: json['reasonKey'] as String? ?? '',
        evidence: rawEvidence.whereType<Map>().map((item) {
          return CoachEvidence(
            labelKey: item['labelKey'] as String? ?? '',
            value: item['value'] as String? ?? '',
          );
        }).toList(),
        isDismissible: json['isDismissible'] as bool? ?? true,
        isActionable: json['isActionable'] as bool? ?? false,
      ),
    );
  }

  Map<String, dynamic> _candidateToJson(CoachDecisionCandidate candidate) => {
    'id': candidate.id,
    'type': candidate.type.name,
    'scope': candidate.scope.name,
    'severity': candidate.severity.name,
    'confidence': candidate.confidence.name,
    'titleKey': candidate.titleKey,
    'reasonKey': candidate.reasonKey,
    'isDismissible': candidate.isDismissible,
    'isActionable': candidate.isActionable,
    'evidence': [
      for (final evidence in candidate.evidence)
        {'labelKey': evidence.labelKey, 'value': evidence.value},
    ],
  };

  Future<void> delete(String workoutId) => _dao.delete(workoutId);
}
