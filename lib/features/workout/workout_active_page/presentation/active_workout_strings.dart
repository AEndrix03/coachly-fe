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
  'add': {'en': 'Add', 'it': 'Aggiungi'},
  'addSet': {'en': 'Add set', 'it': 'Aggiungi serie'},
  'addExercise': {'en': 'Add exercise', 'it': 'Aggiungi esercizio'},
  'quickNote': {'en': 'Quick note', 'it': 'Nota rapida'},
  'createGroup': {'en': 'Create group', 'it': 'Crea gruppo'},
  'createSuperset': {'en': 'Create superset', 'it': 'Crea superset'},
  'ungroup': {'en': 'Ungroup', 'it': 'Separa gruppo'},
  'addDrop': {'en': 'Add drop', 'it': 'Aggiungi drop'},
  'structure': {'en': 'Structure', 'it': 'Struttura'},
  'confirm': {'en': 'Confirm', 'it': 'Conferma'},
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
  'completion.title': {
    'en': 'Workout complete!',
    'it': 'Allenamento completato!',
  },
  'completion.subtitle': {
    'en': 'Great work. Here is a preview of your session insights.',
    'it': 'Ottimo lavoro. Ecco un’anteprima dei risultati della sessione.',
  },
  'completion.mockBadge': {'en': 'PREVIEW INSIGHTS', 'it': 'ANTEPRIMA INSIGHT'},
  'completion.duration': {'en': 'Duration', 'it': 'Durata'},
  'completion.durationValue': {'en': '54 min', 'it': '54 min'},
  'completion.sets': {'en': 'Working sets', 'it': 'Serie allenanti'},
  'completion.setsValue': {'en': '18', 'it': '18'},
  'completion.volume': {'en': 'Total volume', 'it': 'Volume totale'},
  'completion.volumeValue': {'en': '7,420 kg', 'it': '7.420 kg'},
  'completion.performanceTitle': {
    'en': 'Performance trend',
    'it': 'Andamento performance',
  },
  'completion.performanceBody': {
    'en': '+8% estimated volume compared with your recent baseline.',
    'it': '+8% di volume stimato rispetto alla baseline recente.',
  },
  'completion.improvementTitle': {
    'en': 'Strongest improvement',
    'it': 'Miglioramento principale',
  },
  'completion.improvementBody': {
    'en': 'More repetitions at the same load on your main movement.',
    'it': 'Più ripetizioni allo stesso carico sul movimento principale.',
  },
  'completion.qualityTitle': {
    'en': 'Session quality',
    'it': 'Qualità della sessione',
  },
  'completion.qualityBody': {
    'en': 'Excellent effort control · 9.1 / 10',
    'it': 'Ottima gestione dello sforzo · 9,1 / 10',
  },
  'completion.home': {'en': 'Back to Homepage', 'it': 'Torna alla Homepage'},
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
