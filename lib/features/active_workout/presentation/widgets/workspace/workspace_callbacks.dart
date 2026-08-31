import 'dart:async';
import 'package:coachly/features/active_workout/application/active_workout_state.dart';

/// I callback con cui il piano di lavoro parla al controller.
///
/// Stanno da soli perche' li condividono orchestratore, scheda
/// dell'esercizio ed editor della serie: sono il contratto fra i tre.
typedef SetValueChanged = void Function(ActiveSetState set, num value);

typedef DropWeightChanged =
    void Function(String setId, String dropId, double weight);

typedef DropRepsChanged = void Function(String setId, String dropId, int reps);

typedef DropRemoved = void Function(String setId, String dropId);

typedef SetNoteChanged =
    void Function(String setId, String text, Set<SetNoteTag> tags);

typedef BlockCreate =
    void Function(List<String> exerciseIds, ExerciseGroupType type);

typedef BlockExerciseAdd = Future<({String id, String name})?> Function();
