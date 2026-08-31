import 'package:coachly/features/workouts/domain/workout_detail_view_data.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/widgets.dart';

/// Il nome di un esercizio come lo legge una persona.
///
/// Esiste perché la stessa domanda — «e se il nome non c'è?» — aveva **tre
/// risposte diverse** in tre widget:
///
/// - la card dell'esercizio traduceva il sentinella `'Exercise'`;
/// - la card del gruppo lo mostrava così com'era, in inglese, dentro una app
///   in italiano;
/// - la modifica strutturale mostrava **l'id dell'esercizio**, che per chi
///   legge non è un nome: è rumore che sembra un errore del programma.
///
/// L'ultima è quella che si nota, ed è il motivo per cui questo file c'è. Un
/// id a schermo non è mai la risposta giusta: se il nome non si conosce, si
/// dice che non si conosce (`docs/development/07-errors-and-feedback.md`).
///
/// La risposta ora è una sola, e i widget non decidono più.
String exerciseDisplayName(
  BuildContext context,
  WorkoutExerciseViewData? exercise,
) {
  if (exercise == null) return context.l10n.exerciseNamePlaceholder;
  if (exercise.isMissing) return context.l10n.workoutDetailExerciseUnavailable;
  final name = exercise.name.trim();
  // `'Exercise'` è il sentinella che l'adattatore usa quando il catalogo
  // locale non ha ancora quell'esercizio: è una convenzione interna, non un
  // testo da mostrare (`workout_detail_view_data.dart`).
  if (name.isEmpty || name == 'Exercise') {
    return context.l10n.workoutDetailExerciseFallback;
  }
  return name;
}

/// Lo stesso, per un nome già estratto (bozze e voci in costruzione).
///
/// Le bozze portano il nome come `String`, non come view data: quando il
/// catalogo locale non conosce ancora l'esercizio quel campo è **vuoto**, ed
/// era vuoto per una ragione — l'alternativa che c'era prima era scriverci
/// l'id.
String exerciseNameOrPlaceholder(BuildContext context, String? name) {
  final trimmed = name?.trim() ?? '';
  if (trimmed.isEmpty || trimmed == 'Exercise') {
    return context.l10n.exerciseNamePlaceholder;
  }
  return trimmed;
}
