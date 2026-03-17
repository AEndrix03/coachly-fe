import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/mappers/workout_session_write_command_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkoutSessionWriteCommandMapper.applySessionToWorkoutCommand', () {
    test('updates reps/load row by row and ignores extra session rows', () {
      final plannedWorkout = WorkoutWriteCommand(
        id: 'w-1',
        name: 'Push Day',
        translations: const {
          'it': WorkoutTranslationWritePayload(
            title: 'Push Day',
            description: null,
          ),
        },
        status: 'active',
        blocks: const [
          WorkoutBlockWritePayload(
            id: 'b-1',
            position: 0,
            label: null,
            restSeconds: null,
            notes: null,
            entries: [
              WorkoutEntryWritePayload(
                id: 'e-1',
                exerciseId: 'ex-1',
                position: 0,
                sets: [
                  WorkoutSetWritePayload(
                    id: 's-1',
                    position: 0,
                    setType: 'normal',
                    reps: 8,
                    load: 80,
                    loadUnit: 'kg',
                    restSeconds: 90,
                    notes: null,
                  ),
                  WorkoutSetWritePayload(
                    id: 's-2',
                    position: 1,
                    setType: 'normal',
                    reps: 8,
                    load: 80,
                    loadUnit: 'kg',
                    restSeconds: 90,
                    notes: null,
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      final session = WorkoutSessionWriteCommand(
        startedAt: null,
        completedAt: null,
        notes: null,
        entries: const [
          WorkoutSessionEntryWritePayload(
            exerciseId: 'ex-1',
            position: 0,
            completed: true,
            notes: null,
            sets: [
              WorkoutSessionSetWritePayload(
                position: 0,
                setType: 'normal',
                reps: 10,
                load: 85,
                loadUnit: 'kg',
                completed: true,
                notes: null,
              ),
              WorkoutSessionSetWritePayload(
                position: 1,
                setType: 'normal',
                reps: 9,
                load: 87.5,
                loadUnit: 'kg',
                completed: true,
                notes: null,
              ),
              WorkoutSessionSetWritePayload(
                position: 2,
                setType: 'normal',
                reps: 8,
                load: 90,
                loadUnit: 'kg',
                completed: true,
                notes: null,
              ),
            ],
          ),
        ],
      );

      final patched =
          WorkoutSessionWriteCommandMapper.applySessionToWorkoutCommand(
            workoutCommand: plannedWorkout,
            sessionCommand: session,
          );

      final updatedSets = patched.blocks.first.entries.first.sets;
      expect(updatedSets.length, 2);
      expect(updatedSets[0].reps, 10);
      expect(updatedSets[0].load, 85);
      expect(updatedSets[1].reps, 9);
      expect(updatedSets[1].load, 87.5);
    });

    test(
      'keeps remaining planned rows unchanged when session has fewer rows',
      () {
        final plannedWorkout = WorkoutWriteCommand(
          id: 'w-1',
          name: 'Push Day',
          translations: const {
            'it': WorkoutTranslationWritePayload(
              title: 'Push Day',
              description: null,
            ),
          },
          status: 'active',
          blocks: const [
            WorkoutBlockWritePayload(
              id: 'b-1',
              position: 0,
              label: null,
              restSeconds: null,
              notes: null,
              entries: [
                WorkoutEntryWritePayload(
                  id: 'e-1',
                  exerciseId: 'ex-1',
                  position: 0,
                  sets: [
                    WorkoutSetWritePayload(
                      id: 's-1',
                      position: 0,
                      setType: 'normal',
                      reps: 8,
                      load: 80,
                      loadUnit: 'kg',
                      restSeconds: 90,
                      notes: null,
                    ),
                    WorkoutSetWritePayload(
                      id: 's-2',
                      position: 1,
                      setType: 'normal',
                      reps: 8,
                      load: 80,
                      loadUnit: 'kg',
                      restSeconds: 90,
                      notes: null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        );

        final session = WorkoutSessionWriteCommand(
          startedAt: null,
          completedAt: null,
          notes: null,
          entries: const [
            WorkoutSessionEntryWritePayload(
              exerciseId: 'ex-1',
              position: 0,
              completed: true,
              notes: null,
              sets: [
                WorkoutSessionSetWritePayload(
                  position: 0,
                  setType: 'normal',
                  reps: 10,
                  load: 85,
                  loadUnit: 'kg',
                  completed: true,
                  notes: null,
                ),
              ],
            ),
          ],
        );

        final patched =
            WorkoutSessionWriteCommandMapper.applySessionToWorkoutCommand(
              workoutCommand: plannedWorkout,
              sessionCommand: session,
            );

        final updatedSets = patched.blocks.first.entries.first.sets;
        expect(updatedSets[0].reps, 10);
        expect(updatedSets[0].load, 85);
        expect(updatedSets[1].reps, 8);
        expect(updatedSets[1].load, 80);
      },
    );

    test(
      'matches duplicated exercise ids in FIFO order and ignores extra exercises',
      () {
        final plannedWorkout = WorkoutWriteCommand(
          id: 'w-dup',
          name: 'Leg Day',
          translations: const {
            'it': WorkoutTranslationWritePayload(
              title: 'Leg Day',
              description: null,
            ),
          },
          status: 'active',
          blocks: const [
            WorkoutBlockWritePayload(
              id: 'b-1',
              position: 0,
              label: null,
              restSeconds: null,
              notes: null,
              entries: [
                WorkoutEntryWritePayload(
                  id: 'e-1',
                  exerciseId: 'ex-dup',
                  position: 0,
                  sets: [
                    WorkoutSetWritePayload(
                      id: 's-1',
                      position: 0,
                      setType: 'normal',
                      reps: 8,
                      load: 80,
                      loadUnit: 'kg',
                      restSeconds: 90,
                      notes: null,
                    ),
                  ],
                ),
                WorkoutEntryWritePayload(
                  id: 'e-2',
                  exerciseId: 'ex-dup',
                  position: 1,
                  sets: [
                    WorkoutSetWritePayload(
                      id: 's-2',
                      position: 0,
                      setType: 'normal',
                      reps: 6,
                      load: 90,
                      loadUnit: 'kg',
                      restSeconds: 90,
                      notes: null,
                    ),
                  ],
                ),
                WorkoutEntryWritePayload(
                  id: 'e-3',
                  exerciseId: 'ex-other',
                  position: 2,
                  sets: [
                    WorkoutSetWritePayload(
                      id: 's-3',
                      position: 0,
                      setType: 'normal',
                      reps: 10,
                      load: 40,
                      loadUnit: 'kg',
                      restSeconds: 90,
                      notes: null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        );

        final session = WorkoutSessionWriteCommand(
          startedAt: null,
          completedAt: null,
          notes: null,
          entries: const [
            WorkoutSessionEntryWritePayload(
              exerciseId: 'ex-dup',
              position: 0,
              completed: true,
              notes: null,
              sets: [
                WorkoutSessionSetWritePayload(
                  position: 0,
                  setType: 'normal',
                  reps: 12,
                  load: 82.5,
                  loadUnit: 'kg',
                  completed: true,
                  notes: null,
                ),
              ],
            ),
            WorkoutSessionEntryWritePayload(
              exerciseId: 'ex-dup',
              position: 1,
              completed: true,
              notes: null,
              sets: [
                WorkoutSessionSetWritePayload(
                  position: 0,
                  setType: 'normal',
                  reps: 7,
                  load: 95,
                  loadUnit: 'kg',
                  completed: true,
                  notes: null,
                ),
              ],
            ),
            WorkoutSessionEntryWritePayload(
              exerciseId: 'ex-extra',
              position: 2,
              completed: true,
              notes: null,
              sets: [
                WorkoutSessionSetWritePayload(
                  position: 0,
                  setType: 'normal',
                  reps: 20,
                  load: 20,
                  loadUnit: 'kg',
                  completed: true,
                  notes: null,
                ),
              ],
            ),
          ],
        );

        final patched =
            WorkoutSessionWriteCommandMapper.applySessionToWorkoutCommand(
              workoutCommand: plannedWorkout,
              sessionCommand: session,
            );

        final entries = patched.blocks.first.entries;
        expect(entries[0].sets.first.reps, 12);
        expect(entries[0].sets.first.load, 82.5);
        expect(entries[1].sets.first.reps, 7);
        expect(entries[1].sets.first.load, 95);
        expect(entries[2].sets.first.reps, 10);
        expect(entries[2].sets.first.load, 40);
      },
    );
  });
}
