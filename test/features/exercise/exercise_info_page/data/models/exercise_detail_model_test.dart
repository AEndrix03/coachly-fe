import 'package:coachly/features/exercise/exercise_info_page/data/models/new/exercise_detail_model/exercise_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses the exercises API boolean property names', () {
    final exercise = ExerciseDetailModel.fromJson({
      'id': '02e7c672-80c7-4614-b524-2ef69d0e5f72',
      'personal': false,
      'unilateral': true,
      'bodyweight': false,
      'categories': [
        {
          'id': 'category-1',
          'code': 'hamstrings',
          'primary': true,
          'children': [],
        },
      ],
      'equipments': [
        {
          'equipment': {
            'id': 'equipment-1',
            'code': 'barbell',
            'nameI18n': {'en': 'Barbell'},
            'descriptionI18n': {'en': 'A barbell'},
          },
          'required': true,
          'primary': false,
          'quantityNeeded': 1,
        },
      ],
      'media': [
        {
          'id': 'media-1',
          'mediaType': 'video',
          'mediaUrl': 'https://example.com/demo.mp4',
          'primary': true,
          'public': true,
        },
      ],
    });

    expect(exercise.isPersonal, isFalse);
    expect(exercise.isUnilateral, isTrue);
    expect(exercise.isBodyweight, isFalse);
    expect(exercise.categories!.single.isPrimary, isTrue);
    expect(exercise.equipments!.single.isRequired, isTrue);
    expect(exercise.equipments!.single.isPrimary, isFalse);
    expect(exercise.media!.single.isPrimary, isTrue);
    expect(exercise.media!.single.isPublic, isTrue);
  });

  test(
    'normalizes a single relation object returned by legacy API responses',
    () {
      final exercise = ExerciseDetailModel.fromJson({
        'id': '02e7c672-80c7-4614-b524-2ef69d0e5f72',
        'safety': {
          'id': 'safety-1',
          'overallRiskLevel': 'low',
          'spotterRequired': false,
          'safetyNotesI18n': {'it': 'Mantieni il controllo del movimento.'},
        },
      });

      expect(exercise.safety, hasLength(1));
      expect(exercise.safety!.single.overallRiskLevel, 'low');
    },
  );

  test('parses the V2 safety object returned by the details endpoint', () {
    final exercise = ExerciseDetailModel.fromJson({
      'id': '02e7c672-80c7-4614-b524-2ef69d0e5f72',
      'safety': {
        'spotterPolicy': 'not_required',
        'notesI18n': {'it': 'Mantieni il controllo del movimento.'},
      },
    });

    expect(exercise.safety, hasLength(1));
    expect(exercise.safety!.single.overallRiskLevel, 'not_required');
    expect(
      exercise.safety!.single.safetyNotesI18n['it'],
      'Mantieni il controllo del movimento.',
    );
  });
}
