import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/sessions/domain/models/local_workout_session_model.dart';
import 'package:coachly/features/workouts/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workouts/data/repositories/workout_page_repository_impl.dart'
    show workoutPageRepositoryProvider;
import 'package:coachly/features/workouts/domain/models/workout_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Le letture puntuali di schede e sessioni fatte da una schermata.
///
/// Stessa ragione di `ExerciseCatalogController`: senza, la pagina di modifica
/// e il picker importano `workout_page_repository_impl.dart` per raggiungere
/// il provider, e la presentation entra nel data layer (dependency rule D2,
/// `docs/development/01-principles.md`).
///
/// Copre solo le letture *una tantum*. I flussi continui — la lista, le
/// statistiche — restano dove sono: sono gia' provider in `application/`, e
/// duplicarli qui creerebbe due sorgenti di verita' per lo stesso dato.
class WorkoutAccessController {
  WorkoutAccessController(this._repository);

  final IWorkoutPageRepository _repository;

  /// La scheda singola, per chi arriva su una rotta con solo l'id in mano
  /// (deep link, ripresa dopo un kill) e non ha l'oggetto gia' caricato.
  Future<Result<WorkoutModel?, Failure>> workout(String workoutId) =>
      _repository.getWorkout(workoutId);

  /// Lo storico delle sessioni locali: serve al picker per dire quanto tempo
  /// fa un esercizio e' stato eseguito l'ultima volta.
  Future<List<LocalWorkoutSession>> sessions() => _repository.getAllSessions();
}

final workoutAccessControllerProvider = Provider<WorkoutAccessController>(
  (ref) => WorkoutAccessController(ref.watch(workoutPageRepositoryProvider)),
);
