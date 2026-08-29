import 'package:coachly/features/workout/workout_active_page/presentation/main_area_scroll_assist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MainAreaScrollPolicy', () {
    const viewport = 800.0;
    const tolerance = 8.0;

    test('assiste quando il MAIN è vicino nella direzione di avanzamento', () {
      expect(
        MainAreaScrollPolicy.shouldAssist(
          currentOffset: 500,
          targetOffset: 760,
          viewportExtent: viewport,
          settleTolerance: tolerance,
        ),
        isTrue,
      );
    });

    test('non forza lo scroll quando il MAIN è ancora lontano', () {
      expect(
        MainAreaScrollPolicy.shouldAssist(
          currentOffset: 400,
          targetOffset: 900,
          viewportExtent: viewport,
          settleTolerance: tolerance,
        ),
        isFalse,
      );
    });

    test('corregge solo un piccolo superamento del MAIN', () {
      expect(
        MainAreaScrollPolicy.shouldAssist(
          currentOffset: 850,
          targetOffset: 760,
          viewportExtent: viewport,
          settleTolerance: tolerance,
        ),
        isTrue,
      );
    });

    test('non riporta indietro chi sta esplorando dentro il logger', () {
      expect(
        MainAreaScrollPolicy.shouldAssist(
          currentOffset: 1000,
          targetOffset: 760,
          viewportExtent: viewport,
          settleTolerance: tolerance,
        ),
        isFalse,
      );
    });

    test('non interviene quando lo scroll è già assestato', () {
      expect(
        MainAreaScrollPolicy.shouldAssist(
          currentOffset: 756,
          targetOffset: 760,
          viewportExtent: viewport,
          settleTolerance: tolerance,
        ),
        isFalse,
      );
    });
  });
}
