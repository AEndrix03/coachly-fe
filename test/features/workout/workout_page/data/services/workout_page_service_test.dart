import 'dart:convert';

import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_session_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/dto/workout_write_command.dart';
import 'package:coachly/features/workout/workout_page/data/services/workout_page_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('WorkoutPageService.patchWorkout', () {
    test('create uses POST /api/workouts with payload contract', () async {
      final client = _RecordingHttpClient(
        responder: (_) => http.Response('', 200),
      );
      final service = WorkoutPageService(
        ApiClient(client: client, baseUrl: 'https://localhost:8800/api'),
      );

      await service.patchWorkout('new', _sampleCommand());

      expect(client.lastRequest, isNotNull);
      expect(client.lastRequest!.method, 'POST');
      expect(client.lastRequest!.url.path, '/api/workouts');
      expect(client.lastRequest!.headers['Content-Type'], 'application/json');
      expect(client.lastRequest!.headers['Accept'], 'application/json');
      expect(client.lastRequest!.headers.containsKey('X-User-Id'), isFalse);

      final body = jsonDecode(client.lastBody!) as Map<String, dynamic>;
      expect(body['id'], 'workout-id');
      expect(body['name'], 'Push Day');
      expect(body['status'], 'active');
      expect(body['translations']['it']['title'], 'Push Day');
      expect(body['translations']['it'].containsKey('name'), isFalse);
    });

    test('update uses PUT /api/workouts/{id} without id in body', () async {
      final client = _RecordingHttpClient(
        responder: (_) => http.Response('', 200),
      );
      final service = WorkoutPageService(
        ApiClient(client: client, baseUrl: 'https://localhost:8800/api'),
      );

      await service.patchWorkout('w-123', _sampleCommand());

      expect(client.lastRequest, isNotNull);
      expect(client.lastRequest!.method, 'PUT');
      expect(client.lastRequest!.url.path, '/api/workouts/w-123');
      expect(client.lastRequest!.headers['Content-Type'], 'application/json');
      expect(client.lastRequest!.headers['Accept'], 'application/json');
      expect(client.lastRequest!.headers.containsKey('X-User-Id'), isFalse);

      final body = jsonDecode(client.lastBody!) as Map<String, dynamic>;
      expect(body.containsKey('id'), isFalse);
      expect(body['translations']['en']['title'], 'Push Day');
    });
  });

  group('WorkoutPageService.fetchWorkouts', () {
    test('normalizes translations from JSON string response', () async {
      final client = _RecordingHttpClient(
        responder: (_) => http.Response(
          jsonEncode([
            {
              'id': 'w-1',
              'goal': 'strength',
              'lastUsed': '2026-03-17T10:00:00.000Z',
              'type': 'hypertrophy',
              'titleI18n': null,
              'descriptionI18n': null,
              'translations':
                  '{"it":{"title":"Scheda Petto","description":"Descrizione IT"},"en":{"title":"Chest Day","description":"EN Description"}}',
              'workoutExercises': [],
              'muscleTags': [],
            },
          ]),
          200,
        ),
      );
      final service = WorkoutPageService(
        ApiClient(client: client, baseUrl: 'https://localhost:8800/api'),
      );

      final response = await service.fetchWorkouts();

      expect(response.success, isTrue);
      expect(response.data, isNotNull);
      expect(response.data!.length, 1);
      expect(response.data!.first.titleI18n?['it'], 'Scheda Petto');
      expect(response.data!.first.titleI18n?['en'], 'Chest Day');
      expect(response.data!.first.descriptionI18n?['it'], 'Descrizione IT');
    });

    test(
      'maps gateway blocks payload to legacy workout model without null cast errors',
      () async {
        final client = _RecordingHttpClient(
          responder: (_) => http.Response(
            jsonEncode([
              {
                'id': '0142e601-b8a7-44e8-adff-0e2f24dc4a1b',
                'name': 'Nuova Scheda',
                'status': 'active',
                'translations':
                    '{"it":{"title":"Nuova Scheda","description":"Descrizione"}}',
                'blocks': [
                  {
                    'id': '686de52e-ddba-41d3-afa8-1f1dfe8f908a',
                    'label': 'Ipertrofia',
                    'position': 0,
                    'entries': [
                      {
                        'id': '63302367-33f6-4fd8-b01e-3dfc93733590',
                        'exerciseId': '00b8ff85-f4ec-45fc-a02e-7d143f7457d3',
                        'position': 0,
                        'sets': [
                          {
                            'id': 'fa2a65a0-9bcc-48bd-8cfa-51f39160119a',
                            'position': 0,
                            'setType': null,
                            'reps': 10,
                            'load': 10.0,
                            'loadUnit': 'kg',
                            'restSeconds': 60,
                          },
                        ],
                      },
                    ],
                  },
                ],
              },
            ]),
            200,
          ),
        );

        final service = WorkoutPageService(
          ApiClient(client: client, baseUrl: 'https://localhost:8800/api'),
        );

        final response = await service.fetchWorkouts();

        expect(response.success, isTrue);
        final workout = response.data!.single;
        expect(workout.id, '0142e601-b8a7-44e8-adff-0e2f24dc4a1b');
        expect(workout.type, 'Ipertrofia');
        expect(workout.workoutExercises.length, 1);
        expect(
          workout.workoutExercises.first.exercise.id,
          '00b8ff85-f4ec-45fc-a02e-7d143f7457d3',
        );
      },
    );
  });

  group('WorkoutPageService.saveWorkoutSession', () {
    test(
      'uses POST /api/workouts/{id}/sessions and sends per-set reps/load',
      () async {
        final client = _RecordingHttpClient(
          responder: (_) => http.Response('', 200),
        );
        final service = WorkoutPageService(
          ApiClient(client: client, baseUrl: 'https://localhost:8800/api'),
        );

        await service.saveWorkoutSession('w-123', _sampleSessionCommand());

        expect(client.lastRequest, isNotNull);
        expect(client.lastRequest!.method, 'POST');
        expect(client.lastRequest!.url.path, '/api/workouts/w-123/sessions');
        expect(client.lastRequest!.headers['Content-Type'], 'application/json');
        expect(client.lastRequest!.headers['Accept'], 'application/json');

        final body = jsonDecode(client.lastBody!) as Map<String, dynamic>;
        expect(body['entries'], isA<List<dynamic>>());
        expect(
          body['entries'][0]['exerciseId'],
          '33ab4fac-bf4f-4f4d-b1d2-f2cb6b5674ff',
        );
        expect(body['entries'][0]['sets'][0]['reps'], 10);
        expect(body['entries'][0]['sets'][0]['load'], 85);
        expect(body['entries'][0]['sets'][1]['reps'], 9);
        expect(body['entries'][0]['sets'][1]['load'], 87.5);
      },
    );
  });
}

WorkoutWriteCommand _sampleCommand() {
  return WorkoutWriteCommand(
    id: 'workout-id',
    name: 'Push Day',
    description: 'Descrizione',
    translations: const {
      'it': WorkoutTranslationWritePayload(
        title: 'Push Day',
        description: 'Descrizione',
      ),
      'en': WorkoutTranslationWritePayload(
        title: 'Push Day',
        description: 'Description',
      ),
    },
    status: 'active',
    blocks: const [
      WorkoutBlockWritePayload(
        id: null,
        position: 0,
        label: 'Block A',
        restSeconds: 60,
        notes: null,
        entries: [
          WorkoutEntryWritePayload(
            id: null,
            exerciseId: '33ab4fac-bf4f-4f4d-b1d2-f2cb6b5674ff',
            position: 0,
            sets: [
              WorkoutSetWritePayload(
                id: null,
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
        ],
      ),
    ],
  );
}

WorkoutSessionWriteCommand _sampleSessionCommand() {
  return WorkoutSessionWriteCommand(
    startedAt: DateTime.parse('2026-03-17T10:00:00.000Z'),
    completedAt: DateTime.parse('2026-03-17T10:45:00.000Z'),
    notes: 'Sessione intensa',
    entries: const [
      WorkoutSessionEntryWritePayload(
        exerciseId: '33ab4fac-bf4f-4f4d-b1d2-f2cb6b5674ff',
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
        ],
      ),
    ],
  );
}

class _RecordingHttpClient extends http.BaseClient {
  final http.Response Function(http.BaseRequest request) responder;

  http.BaseRequest? lastRequest;
  String? lastBody;

  _RecordingHttpClient({required this.responder});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    lastRequest = request;
    if (request is http.Request) {
      lastBody = request.body;
    } else {
      lastBody = null;
    }

    final response = responder(request);
    return http.StreamedResponse(
      Stream.value(utf8.encode(response.body)),
      response.statusCode,
      headers: response.headers,
      request: request,
    );
  }
}
