import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/features/workout/workout_active_page/presentation/widgets/hold_to_complete_workout_button.dart';
import 'package:flutter/gestures.dart' show kPressTimeout;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// La chiusura di un allenamento è irreversibile, quindi è protetta da una
/// pressione continua invece che da un dialog di conferma
/// (`.claude/rules/development.md`, punto 8: undo, non conferma — e dove
/// l'undo non esiste, un gesto che non si fa per sbaglio).
///
/// ## Perché i test pompano in tre tempi
///
/// `startGesture` non basta a far partire la pressione. Servono tre cose, in
/// quest'ordine, ed è stato verificato una per una:
///
/// 1. un `pump()` a vuoto, che consegna il pointer down all'arena dei gesti;
/// 2. un `pump(kPressTimeout)`, perché `InkWell.onTapDown` non scatta al down
///    ma quando il riconoscitore del tap si dichiara, dopo il deadline;
/// 3. solo allora il tempo scorre sulla pressione vera.
///
/// Saltare il primo o il secondo passo lascia il contatore a zero e fa
/// sembrare rotto il widget, che invece funziona.
void main() {
  const holdDuration = Duration(seconds: 2);
  const target = Key('hold-to-complete-workout');

  Widget subject(VoidCallback onCompleted) => MaterialApp(
    theme: ThemeData.dark().copyWith(extensions: [CoachlyThemeData.dark]),
    home: Scaffold(
      body: HoldToCompleteWorkoutButton(
        label: 'Complete workout',
        holdHint: 'Hold for two seconds',
        releasedHint: 'Keep holding',
        onCompleted: onCompleted,
      ),
    ),
  );

  /// Preme e attende che la pressione sia **davvero** iniziata.
  Future<TestGesture> beginHold(WidgetTester tester) async {
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(target)),
    );
    await tester.pump();
    await tester.pump(kPressTimeout);
    return gesture;
  }

  testWidgets('una pressione breve non chiude e spiega perché', (tester) async {
    var completions = 0;
    await tester.pumpWidget(subject(() => completions++));

    final gesture = await beginHold(tester);
    await tester.pump(const Duration(milliseconds: 500));
    await gesture.up();
    await tester.pump();

    expect(completions, 0);
    expect(
      find.byKey(const Key('hold-to-complete-workout-hint')),
      findsOneWidget,
    );
  });

  testWidgets('la chiusura scatta solo a pressione completa, una volta sola', (
    tester,
  ) async {
    var completions = 0;
    await tester.pumpWidget(subject(() => completions++));

    final gesture = await beginHold(tester);

    // Margine invece dell'istante esatto. Il confine al millisecondo dipende
    // da quando cade il frame rispetto al deadline del tap, non dal widget:
    // asserirlo produce un test che si rompe per ragioni che non riguardano
    // il prodotto. Era il difetto della versione precedente, che pretendeva
    // il completamento fra 1199ms e 1200ms.
    await tester.pump(const Duration(milliseconds: 1700));
    expect(
      completions,
      0,
      reason: 'a ~1,8s la pressione non è ancora completa',
    );

    await tester.pump(const Duration(milliseconds: 400));
    expect(completions, 1, reason: 'entro ~2,2s deve aver chiuso');

    // Il rilascio dopo il completamento non deve rifare partire niente.
    await gesture.up();
    await tester.pump(holdDuration);
    expect(completions, 1);
  });

  testWidgets('dopo un rilascio la pressione riprende dal punto raggiunto', (
    tester,
  ) async {
    var completions = 0;
    await tester.pumpWidget(subject(() => completions++));

    // Più di metà strada, poi rilascio e un rientro parziale.
    final first = await beginHold(tester);
    await tester.pump(const Duration(milliseconds: 1200));
    await first.up();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(completions, 0);

    await beginHold(tester);

    // L'asserzione è una forbice, non un istante: quanto esattamente rientri
    // dipende da dettagli del ticker, mentre ciò che il prodotto promette è
    // che la seconda pressione **riprenda** invece di ripartire da zero.
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      completions,
      0,
      reason: 'mezzo secondo non basta: il progresso è rientrato in parte',
    );

    await tester.pump(const Duration(milliseconds: 1000));
    expect(
      completions,
      1,
      reason:
          'ma nemmeno servono i 2s pieni: riprende dal punto raggiunto, '
          'altrimenti a 1,5s totali non avrebbe ancora chiuso',
    );
  });
}
