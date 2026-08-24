import 'package:flutter/widgets.dart';

const _activeWorkoutStrings = <String, Map<String, String>>{
  'completeSet': {'en': 'COMPLETE SET', 'it': 'COMPLETA SERIE'},
  'completeWorkout': {'en': 'COMPLETE WORKOUT', 'it': 'COMPLETA ALLENAMENTO'},
  'previous': {'en': 'PREVIOUS', 'it': 'PRECEDENTE'},
  'target': {'en': 'TARGET', 'it': 'OBIETTIVO'},
  'newBaseline': {'en': 'New baseline', 'it': 'Nuova baseline'},
  'sets': {'en': 'SETS', 'it': 'SERIE'},
  'current': {'en': 'Current', 'it': 'Corrente'},
  'setProgress': {
    'en': 'Set {current} / {total}',
    'it': 'Serie {current} / {total}',
  },
  'exerciseProgress': {
    'en': '{done} / {total} exercises',
    'it': '{done} / {total} esercizi',
  },
  'rest': {'en': 'REST', 'it': 'RECUPERO'},
  'skip': {'en': 'Skip', 'it': 'Salta'},
  'coachly': {'en': 'COACHLY', 'it': 'COACHLY'},
  'why': {'en': 'Why', 'it': 'Perché'},
  'whyTitle': {'en': 'WHY THIS TARGET?', 'it': 'PERCHÉ QUESTO OBIETTIVO?'},
  'because': {'en': 'Because', 'it': 'Motivazione'},
  'noEvidence': {
    'en': 'More comparable data is needed.',
    'it': 'Servono più dati comparabili.',
  },
  'undoCompleted': {'en': 'Set completed', 'it': 'Serie completata'},
  'overview': {'en': 'Workout overview', 'it': 'Panoramica allenamento'},
  'weight': {'en': 'Weight', 'it': 'Peso'},
  'reps': {'en': 'Reps', 'it': 'Ripetizioni'},
  'rir': {'en': 'Reps in reserve', 'it': 'Ripetizioni in riserva'},
  'left': {'en': 'LEFT', 'it': 'SINISTRA'},
  'right': {'en': 'RIGHT', 'it': 'DESTRA'},
  'mirror': {'en': 'Mirror values', 'it': 'Copia valori'},
  'superset': {'en': 'SUPERSET', 'it': 'SUPERSET'},
  'next': {'en': 'Next: {exercise}', 'it': 'Prossimo: {exercise}'},
  'finishEarly': {'en': 'Finish workout', 'it': 'Termina allenamento'},
  'finishEarlyTitle': {'en': 'Finish workout early?', 'it': 'Terminare prima?'},
  'finishEarlyBody': {
    'en': '{sets} sets are still incomplete.',
    'it': '{sets} serie non sono ancora completate.',
  },
  'keepTraining': {'en': 'Keep training', 'it': 'Continua allenamento'},
  'coach.progress_reps.title': {
    'en': 'Progress reps on the next set',
    'it': 'Aumenta le ripetizioni nella prossima serie',
  },
  'coach.progress_reps.reason': {
    'en': 'The comparable set met the effort target.',
    'it': 'La serie comparabile ha rispettato il target di sforzo.',
  },
  'coach.observe.title': {
    'en': 'Keep the current target',
    'it': 'Mantieni il target corrente',
  },
  'coach.observe.reason': {
    'en': 'One result is not enough to confirm a regression.',
    'it': 'Un singolo risultato non conferma una regressione.',
  },
  'coach.comparability.new_baseline': {
    'en': 'New baseline',
    'it': 'Nuova baseline',
  },
  'coach.data_quality.unusual_load_title': {
    'en': 'Load looks unusual',
    'it': 'Il carico sembra insolito',
  },
  'coach.data_quality.unusual_load_reason': {
    'en': 'The load is much higher than recent comparable entries.',
    'it': 'Il carico è molto più alto delle registrazioni comparabili recenti.',
  },
  'coach.guardian.pacing_title': {
    'en': 'Review the remaining session',
    'it': 'Rivedi la sessione rimanente',
  },
  'coach.guardian.pacing_reason': {
    'en': 'The session is taking longer than expected.',
    'it': 'La sessione sta richiedendo più tempo del previsto.',
  },
};

extension ActiveWorkoutStrings on BuildContext {
  String activeTr(String key, {Map<String, String> params = const {}}) {
    final language = Localizations.maybeLocaleOf(this)?.languageCode ?? 'en';
    var value =
        _activeWorkoutStrings[key]?[language] ??
        _activeWorkoutStrings[key]?['en'] ??
        key;
    for (final entry in params.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value);
    }
    return value;
  }
}
