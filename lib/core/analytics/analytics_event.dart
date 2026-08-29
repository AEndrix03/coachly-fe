/// La tassonomia degli eventi di prodotto.
///
/// `docs/development/22-analytics-events.md`. Un evento è un enum, non una
/// stringa: una stringa scritta a mano diventa `workout_started`,
/// `workoutStarted` e `workout started` nella stessa dashboard, e a quel punto
/// i numeri non si possono più sommare.
///
/// Cosa non entra qui: nulla che identifichi l'utente, nessun testo scritto da
/// lui, nessun nome di esercizio custom (`24-security-and-privacy.md`).
enum AnalyticsEvent {
  appOpened('app_opened'),
  workoutStarted('workout_started'),
  workoutCompleted('workout_completed'),
  workoutAbandoned('workout_abandoned'),
  setCompleted('set_completed'),
  exerciseSubstituted('exercise_substituted'),
  voiceEntryAccepted('voice_entry_accepted'),
  voiceEntryRejected('voice_entry_rejected'),
  workoutCreated('workout_created'),
  customExerciseCreated('custom_exercise_created'),
  syncBatchUploaded('sync_batch_uploaded'),
  syncBatchFailed('sync_batch_failed');

  const AnalyticsEvent(this.name);

  /// Nome sul filo. Snake case, stabile: rinominarlo spezza le serie storiche.
  final String name;
}
