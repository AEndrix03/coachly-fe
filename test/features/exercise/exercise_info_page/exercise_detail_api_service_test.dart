import 'dart:convert';

import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/features/exercise/exercise_info_page/data/services/exercise_detail_view_service.dart';
import 'package:coachly/features/exercise/exercise_info_page/domain/exercise_detail_view_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'maps the exercise detail backend contract into the stable view data',
    () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/exercises/exercise-id/details');
        return http.Response.bytes(
          utf8.encode(jsonEncode(_exerciseDetailJson)),
          200,
          headers: _jsonHeaders,
        );
      });
      final service = ApiExerciseDetailViewService(
        ApiClient(client: client, baseUrl: 'https://coachly.test/api'),
      );

      final data = await service.fetch('exercise-id', const Locale('it'));

      expect(data.name, 'Lat Pulldown');
      expect(data.description, 'Trazione verticale al cavo.');
      expect(data.movementProfile.pattern, 'Trazione verticale');
      expect(data.movementProfile.resistanceSource, 'Cavo');
      expect(data.movementProfile.kineticChain, 'Aperta');
      expect(data.execution.steps, [
        'Blocca le cosce.',
        'Controlla il ritorno.',
      ]);
      expect(data.execution.commonMistakes, ['Non oscillare il busto.']);
      expect(data.muscles.single.role, MuscleRole.primary);
      expect(data.muscles.single.tension.shortened, TensionLevel.moderate);
      expect(data.biomechanics.jointActions.single.joint, 'Gomito');
      expect(data.biomechanics.resistanceProfile, isNotEmpty);
      expect(data.biomechanics.evidenceOrigin, 'Modello biomeccanico');
      expect(data.equipment.single.name, 'Lat Pulldown Machine');
      expect(data.variants.single.relationAxis, 'Presa');
      expect(data.variants.single.similarity, isNull);
      expect(data.media.kind, ExerciseMediaKind.video);
      expect(
        data.safetyNote,
        'Non tirare dietro al collo.\nMantieni il controllo.',
      );
    },
  );

  test('loads the complete catalogue from the filtered endpoint', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/exercises/filtered');
      return http.Response.bytes(
        utf8.encode(
          jsonEncode([
            _exerciseDetailJson,
            {
              ..._exerciseDetailJson,
              'id': 'squat-id',
              'code': 'BACK_SQUAT',
              'nameI18n': {'it': 'Back Squat'},
            },
          ]),
        ),
        200,
        headers: _jsonHeaders,
      );
    });
    final service = ApiExerciseDetailViewService(
      ApiClient(client: client, baseUrl: 'https://coachly.test/api'),
    );

    final catalog = await service.fetchAll(const Locale('it'));

    expect(catalog, hasLength(2));
    expect(catalog.map((exercise) => exercise.id), ['exercise-id', 'squat-id']);
    expect(catalog.map((exercise) => exercise.name), [
      'Lat Pulldown',
      'Back Squat',
    ]);
  });
}

const _exerciseDetailJson = <String, Object?>{
  'id': 'exercise-id',
  'code': 'LAT_PULLDOWN',
  'nameI18n': {'it': 'Lat Pulldown', 'en': 'Lat Pulldown'},
  'descriptionI18n': {'it': 'Trazione verticale al cavo.'},
  'tipsI18n': {'it': 'Blocca le cosce.\n• Controlla il ritorno.'},
  'catalogStatus': 'verified',
  'exerciseKind': 'resistance',
  'technicalDemand': 'moderate',
  'jointClass': 'multi_joint',
  'kineticChain': 'open',
  'unilateral': false,
  'bodyweight': false,
  'commonMistakesI18n': {
    'it': ['Non oscillare il busto.'],
  },
  'movementProfile': {
    'patterns': [
      {
        'code': 'vertical_pull',
        'nameI18n': {'it': 'Trazione verticale'},
        'role': 'primary',
      },
    ],
    'jointActions': [
      {
        'jointCode': 'elbow',
        'actionCode': 'flexion',
        'nameI18n': {'it': 'Flessione'},
        'role': 'primary',
      },
    ],
  },
  'muscles': [
    {
      'muscle': {
        'id': 'lat-id',
        'code': 'latissimus_dorsi',
        'nameI18n': {'it': 'Gran dorsale'},
      },
      'involvement': 'primary',
      'tensionProfile': {
        'lengthened': 'high',
        'midrange': 'high',
        'shortened': 'moderate',
      },
    },
  ],
  'biomechanics': {
    'resistanceSource': 'cable',
    'stabilityDemand': 'moderate',
    'spinalLoading': 'low',
    'externalResistanceProfile': 'mid_rom',
    'evidenceBasis': 'biomechanical_model',
    'confidence': 'modeled',
  },
  'safety': {
    'spotterPolicy': 'none',
    'notesI18n': {'it': 'Nota legacy.'},
    'notesListI18n': {
      'it': ['Non tirare dietro al collo.', 'Mantieni il controllo.'],
    },
  },
  'equipments': [
    {
      'equipment': {
        'id': 'equipment-id',
        'code': 'lat_pulldown_machine',
        'nameI18n': {'it': 'Lat Pulldown Machine'},
      },
      'required': true,
    },
  ],
  'variants': [
    {
      'id': 'variant-id',
      'nameI18n': {'it': 'Close Grip Lat Pulldown'},
      'descriptionI18n': {'it': 'Presa più stretta.'},
      'variationAxis': 'grip',
    },
  ],
  'media': [
    {
      'mediaType': 'video',
      'mediaUrl': 'https://cdn.test/demo.mp4',
      'thumbnailUrl': 'https://cdn.test/demo.webp',
      'primary': true,
      'public': true,
    },
  ],
};

/// Il backend risponde in UTF-8. Senza charset esplicito `http.Response`
/// decodifica in latin1 e i payload che contengono `•` o accenti falliscono.
const _jsonHeaders = {'content-type': 'application/json; charset=utf-8'};
