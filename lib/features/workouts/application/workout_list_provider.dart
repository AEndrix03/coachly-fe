import 'package:coachly/features/workouts/domain/models/workout_model.dart';
import 'package:coachly/features/workouts/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workouts/data/repositories/workout_page_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La lista delle schede, proiettata dal database.
///
/// E' uno `Stream`, non una lettura una-tantum, e la differenza non e'
/// stilistica. Con una lettura una-tantum ogni scrittura deve *ricordarsi* di
/// invalidare il provider: chi salva una scheda dalla pagina di modifica, chi
/// la disattiva dalla card, chi la tocca durante la sync in background. Erano
/// quattordici punti sparsi in otto file, e la regola che li teneva allineati
/// non era verificabile da nessuna parte — bastava dimenticarne uno per
/// mostrare all'utente una lista vecchia senza che niente segnalasse l'errore.
///
/// Con lo stream Drift la lista si aggiorna perche' il database e' cambiato.
/// Chi scrive non deve sapere chi legge, ed e' esattamente cio' che chiede
/// `docs/development/03-state-riverpod.md`: «la UI si aggiorna perche' il
/// database lo dice, non perche' qualcuno ha chiamato `invalidate`».
/// Scritto a mano invece che generato: il provider e' un `StreamNotifier`
/// senza argomenti, cioe' l'unico caso in cui il generatore non toglie niente
/// di scomodo. Vedere la firma qui accanto al metodo che la produce vale piu'
/// del `part` (`docs/development/03-state-riverpod.md`).
final workoutListProvider =
    StreamNotifierProvider<WorkoutList, List<WorkoutModel>>(WorkoutList.new);

class WorkoutList extends StreamNotifier<List<WorkoutModel>> {
  IWorkoutPageRepository get _repository =>
      ref.read(workoutPageRepositoryProvider);

  @override
  Stream<List<WorkoutModel>> build() => _repository.watchWorkouts();

  // I metodi sotto scrivono e basta: non invalidano nulla. La riemissione
  // arriva dal `watch()` di Drift sulla tabella toccata.

  Future<void> enableWorkout(String workoutId) =>
      _repository.enableWorkout(workoutId);

  Future<void> disableWorkout(String workoutId) =>
      _repository.disableWorkout(workoutId);

  Future<void> deleteWorkout(String workoutId) async {
    final response = await _repository.deleteWorkout(workoutId);
    if (!response.isOk) {
      throw Exception(
        response.failureOrNull?.message ?? 'Failed to delete workout',
      );
    }
  }

  Future<void> updateWorkout(WorkoutModel workout) =>
      _repository.updateWorkout(workout);
}

final recentWorkoutsProvider = FutureProvider.autoDispose<List<WorkoutModel>>((
  ref,
) async {
  final allWorkouts = await ref.watch(workoutListProvider.future);
  final sortedWorkouts = allWorkouts.where((workout) => workout.active).toList()
    ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
  return sortedWorkouts.take(3).toList();
});
