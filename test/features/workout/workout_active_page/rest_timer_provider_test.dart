import 'package:coachly/features/workout/workout_active_page/providers/rest_timer_provider.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stops immediately when the rest timer reaches zero', () {
    fakeAsync((async) {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(restTimerProvider.notifier);
      notifier.startTimer(1);

      async.elapse(const Duration(seconds: 1));

      final state = container.read(restTimerProvider);
      expect(state.remainingSeconds, 0);
      expect(state.isActive, isFalse);
    });
  });
}
