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
