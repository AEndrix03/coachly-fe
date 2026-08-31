import 'package:coachly/features/active_workout/application/active_workout_state.dart';
import 'package:coachly/features/active_workout/presentation/widgets/workspace/number_input_sheet.dart';
import 'package:coachly/shared/design_system/coachly_athlete_theme.dart';
import 'package:flutter/material.dart';

/// Le formattazioni e le costanti condivise dal piano di lavoro.
///
/// Sono qui perche' le usano piu' componenti: i nomi dei ruoli e dei
/// blocchi, la conversione fra peso mostrato e peso salvato, il
/// cronometro. Lasciarle accanto all'orchestratore le avrebbe rese
/// irraggiungibili dai componenti appena divisi.
const disclosureSpring = SpringDescription(
  mass: 1,
  stiffness: 280,
  damping: 32,
);

/// The active-workout presentation is deliberately a workspace: the full
/// session stays visible while only the active exercise and set expand.

const labelStyle = TextStyle(
  // ignore: no_literal_text_style
  fontSize: 10,
  fontWeight: FontWeight.w800,
  color: CoachlyAthleteTheme.textSecondary,
  letterSpacing: .7,
);

String clock(int seconds) =>
    '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

void showNumberInput(
  BuildContext context,
  double initial,
  ValueChanged<double> onChanged, {
  required String label,
  required double step,
  String? unit,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => NumberInputSheet(
      initial: initial,
      label: label,
      unit: unit,
      step: step,
      onChanged: onChanged,
    ),
  );
}

String number(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(1);

double displayWeight(double kilograms, String unit) =>
    unit == 'lbs' ? kilograms * 2.2046226218 : kilograms;

double storedWeight(double displayed, String unit) =>
    unit == 'lbs' ? displayed / 2.2046226218 : displayed;

String setPrefix(ActiveSetState set) => switch (set.role) {
  SetRole.warmup => 'W${set.position + 1}',
  SetRole.topSet => 'T${set.position + 1}',
  SetRole.backoff => 'B${set.position + 1}',
  SetRole.working => '${set.position + 1}',
};

String roleName(SetRole role) => switch (role) {
  SetRole.working => 'Working set',
  SetRole.warmup => 'Warm-up',
  SetRole.topSet => 'Top set',
  SetRole.backoff => 'Back-off',
};

(String, IconData) noteTagPresentation(SetNoteTag tag) => switch (tag) {
  SetNoteTag.goodSet => ('Good set', Icons.check_circle_outline_rounded),
  SetNoteTag.feltStrong => ('Felt strong', Icons.bolt_rounded),
  SetNoteTag.formOff => ('Form off', Icons.warning_amber_rounded),
  SetNoteTag.greatPump => ('Great pump', Icons.favorite_outline_rounded),
  SetNoteTag.lostPosition => ('Lost position', Icons.swap_vert_rounded),
  SetNoteTag.romIssue => ('ROM issue', Icons.open_in_full_rounded),
  SetNoteTag.lowEnergy => ('Low energy', Icons.battery_2_bar_rounded),
  SetNoteTag.gripIssue => ('Grip issue', Icons.pan_tool_alt_rounded),
  SetNoteTag.equipment => ('Equipment', Icons.build_outlined),
};

String blockTitle(ExerciseGroupType type) => switch (type) {
  ExerciseGroupType.superset => 'Superset',
  ExerciseGroupType.triset => 'Triset',
  ExerciseGroupType.giantSet => 'Giant set',
  ExerciseGroupType.circuit => 'Circuit',
  ExerciseGroupType.preparation => 'Preparation',
  ExerciseGroupType.mobility => 'Mobility',
};

String blockSubtitle(ExerciseGroupType type) => switch (type) {
  ExerciseGroupType.superset => '2 exercises',
  ExerciseGroupType.triset => '3 exercises',
  ExerciseGroupType.giantSet => '4+ exercises',
  ExerciseGroupType.circuit => 'Repeat loop',
  ExerciseGroupType.preparation => 'Prepare',
  ExerciseGroupType.mobility => 'Mobility',
};

String blockBuilderInstruction(ExerciseGroupType type) => switch (type) {
  ExerciseGroupType.superset => 'Choose exactly 2 exercises',
  ExerciseGroupType.triset => 'Choose exactly 3 exercises',
  ExerciseGroupType.giantSet => 'Choose at least 4 exercises',
  ExerciseGroupType.circuit => 'Choose 2 or more exercises to repeat',
  ExerciseGroupType.preparation => 'Choose preparation exercises',
  ExerciseGroupType.mobility => 'Choose mobility exercises',
};

String groupName(ExerciseGroupType type) => switch (type) {
  ExerciseGroupType.superset => 'SUPERSET',
  ExerciseGroupType.triset => 'TRISET',
  ExerciseGroupType.giantSet => 'GIANT SET',
  ExerciseGroupType.circuit => 'CIRCUIT',
  ExerciseGroupType.preparation => 'PREPARATION',
  ExerciseGroupType.mobility => 'MOBILITY',
};

String programmingBlockLabel(String? label, String? groupType) {
  final normalizedLabel = label?.trim();
  if (normalizedLabel != null && normalizedLabel.isNotEmpty) {
    return normalizedLabel;
  }
  return switch (groupType?.toLowerCase()) {
    'superset' => 'Superset',
    'triset' => 'Triset',
    'giant_set' || 'giantset' => 'Giant set',
    'circuit' => 'Circuit',
    _ => 'Exercise block',
  };
}
