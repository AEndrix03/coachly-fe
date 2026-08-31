import 'package:coachly/core/error/failures.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/workouts/application/workout_access_controller.dart';
import 'package:coachly/features/workouts/data/repositories/workout_page_repository.dart';
import 'package:coachly/features/workouts/domain/models/workout_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// La distinzione che questo controller deve preservare: `Ok(null)` significa
/// "la scheda non c'e'", `Err` significa "non sono riuscito a guardare".
/// Sono due schermate diverse — un vuoto e un errore riprovabile — e
/// collassarle e' il modo piu' facile per mostrare "nessuna scheda" a chi ne
/// ha venti e solo la rete giu' (docs/development/07-errors-and-feedback.md).
void main() {
  test('Ok(null) resta Ok(null): scheda assente non e\' un errore', () async {
    final controller = WorkoutAccessController(
      _StubRepository(const Ok<WorkoutModel?, Failure>(null)),
    );

    final result = await controller.workout('mancante');

    expect(result, isA<Ok<WorkoutModel?, Failure>>());
    expect(result.valueOrNull, isNull);
  });

  test('il Failure arriva alla schermata come Failure', () async {
    final controller = WorkoutAccessController(
      _StubRepository(const Err<WorkoutModel?, Failure>(NetworkFailure())),
    );

    expect(await controller.workout('x'), isA<Err<WorkoutModel?, Failure>>());
  });
}

class _StubRepository implements IWorkoutPageRepository {
  _StubRepository(this._workout);

  final Result<WorkoutModel?, Failure> _workout;

  @override
  Future<Result<WorkoutModel?, Failure>> getWorkout(String workoutId) async =>
      _workout;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
