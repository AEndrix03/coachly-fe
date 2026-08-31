import 'package:coachly/design_system/components/product/coachly_loading.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Il valore di questo componente sta nelle due soglie, non nel disegno.
///
/// Sono la parte che, replicata a mano in tredici schermate, diverge al primo
/// che ha fretta — quindi sono la parte che va provata.
void main() {
  Widget host({required bool isLoading, Key? gateKey}) => MaterialApp(
    theme: ThemeData.dark().copyWith(extensions: const [CoachlyThemeData.dark]),
    home: Scaffold(
      body: CoachlyLoadingGate(
        key: gateKey,
        isLoading: isLoading,
        loading: const Text('attesa'),
        child: const Text('contenuto'),
      ),
    ),
  );

  testWidgets('sotto la soglia non mostra niente: il lampo non parte', (
    tester,
  ) async {
    await tester.pumpWidget(host(isLoading: true));

    // 299 ms: il dato di una lettura locale e' gia' arrivato da un pezzo.
    await tester.pump(const Duration(milliseconds: 299));
    expect(find.text('attesa'), findsNothing);
    expect(find.text('contenuto'), findsOneWidget);

    await tester.pumpWidget(host(isLoading: false));
    await tester.pumpAndSettle();
    expect(find.text('attesa'), findsNothing);
  });

  testWidgets('oltre la soglia compare', (tester) async {
    await tester.pumpWidget(host(isLoading: true));
    await tester.pump(const Duration(milliseconds: 301));
    expect(find.text('attesa'), findsOneWidget);

    await tester.pumpWidget(host(isLoading: false));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('contenuto'), findsOneWidget);
  });

  testWidgets('una volta comparso resta: niente lampo spostato piu\' in la\'', (
    tester,
  ) async {
    await tester.pumpWidget(host(isLoading: true));
    await tester.pump(const Duration(milliseconds: 301));
    expect(find.text('attesa'), findsOneWidget);

    // Il caricamento finisce 10 ms dopo la comparsa. Senza permanenza minima
    // l'immagine sarebbe visibile per 10 ms, che e' esattamente il difetto che
    // la soglia di comparsa serviva a evitare.
    await tester.pumpWidget(host(isLoading: false));
    await tester.pump(const Duration(milliseconds: 10));
    expect(find.text('attesa'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 450));
    expect(find.text('contenuto'), findsOneWidget);
  });

  test('la scena scelta e\' stabile per la stessa chiave', () {
    // Un widget si ricostruisce molte volte durante la stessa attesa: con una
    // scelta casuale l'immagine cambierebbe sotto gli occhi dell'utente.
    final first = CoachlyLoadingScenes.forKey('catalog');
    final second = CoachlyLoadingScenes.forKey('catalog');
    expect(identical(first, second), isTrue);
    expect(CoachlyLoadingScenes.all, isNotEmpty);
  });

  testWidgets('l\'attesa e\' annunciata al lettore di schermo', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark().copyWith(
          extensions: const [CoachlyThemeData.dark],
        ),
        home: const CoachlyLoadingSection(sceneKey: 'test', message: 'Carico'),
      ),
    );
    // La sezione aspetta `loadingDelay` da sola: prima della soglia non c'e'
    // niente da annunciare, ed e' il comportamento voluto.
    await tester.pump(const Duration(milliseconds: 301));

    expect(
      tester.getSemantics(find.bySemanticsLabel('Carico')),
      matchesSemantics(label: 'Carico', isLiveRegion: true),
    );
    handle.dispose();
  });
}
