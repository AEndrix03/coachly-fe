---
livello: Standard
stato: active
---

# 19 — Testing

## Prerequisito

**La suite oggi non compila.** `workout_builder_widgets_test.dart` ha dieci
argomenti obbligatori mancanti e `workout_detail_golden_test.dart` usa un
parametro che non esiste più.

Una CI che non gira non impone niente, e tutti i lint e i test descritti negli
altri documenti dipendono da questo. È il lavoro numero zero.

## Cosa si testa, e cosa no

| Livello | Copertura attesa | Perché |
|---|---|---|
| Motori di dominio | **alta** | progressioni, Plan Guard, risoluzione vocale: sono le regole che valgono |
| Repository | alta | il confine dei dati, con DB in-memory |
| Controller | media | i comandi e le transizioni di stato |
| Componenti del design system | golden | evitano regressioni visive silenziose |
| Pagine | uno smoke test per stato | loading, empty, error, contenuto |
| Widget di layout | **no** | costano manutenzione e non trovano bug |

Non si insegue una percentuale di copertura complessiva. Si insegue copertura
alta dove un errore costa dati dell'utente o correttezza dell'allenamento.

## Fake, non mock

Si scrivono **fake**: implementazioni vere e semplici dell'interfaccia.

```dart
class FakeWorkoutRepository implements WorkoutRepository {
  final _workouts = <String, Workout>{};
  @override
  Stream<List<Workout>> watchWorkouts() => …;
}
```

I mock con verifica delle chiamate accoppiano il test all'implementazione: un
refactor corretto li fa fallire. I fake verificano il comportamento.

## Drift in memoria

Il vantaggio più grande della migrazione da Hive: i repository diventano
testabili davvero, senza filesystem e senza mock.

```dart
late AppDatabase db;
setUp(() => db = AppDatabase(NativeDatabase.memory()));
tearDown(() => db.close());
```

Ogni test parte da uno schema pulito. Quello che oggi richiede di simulare box
Hive diventa un test normale su dati veri.

## Il tempo si inietta

60 chiamate a `DateTime.now()` sparse nel codice rendono impossibile testare
streak, conteggi settimanali e backoff.

```dart
abstract interface class Clock { DateTime now(); }
class FixedClock implements Clock { … }
```

Un `Clock` iniettabile in `core/time/` è un prerequisito, non un miglioramento.
Il lint `no_raw_datetime_now` lo impone.

Casi che vanno testati e che oggi non lo sono: allenamento a cavallo della
mezzanotte, cambio di fuso orario, ora legale, streak interrotto.

## Controller

```dart
final container = ProviderContainer(overrides: [
  workoutRepositoryProvider.overrideWithValue(FakeWorkoutRepository()),
  clockProvider.overrideWithValue(FixedClock(...)),
]);
addTearDown(container.dispose);
```

Si verificano: transizioni di stato, che i comandi producano gli effetti attesi
sul repository, e che gli errori diventino `Failure` tipizzati — mai eccezioni.

## Golden

Per ogni componente del design system: varianti rilevanti, tema scuro,
`textScaler` 2.0, reduce motion.

I golden si rigenerano solo con un flag esplicito
(`--dart-define=UPDATE_COACHLY_GOLDENS=true`), mai per far passare la CI.
Un golden che cambia senza una modifica intenzionale è un bug segnalato
correttamente.

## Accessibilità

I test descritti in `14-accessibility.md` sono parte della suite, non una
categoria a parte: target, label, contrasto, overflow a scaling 2.0.

## Test che valgono come regole

Ripresi da `20-conventions-and-enforcement.md`:

- parità delle chiavi ARB fra lingue;
- nessuna chiave ARB orfana;
- ogni migrazione Drift parte dallo snapshot precedente;
- nessuna dipendenza dichiarata e non usata;
- il prefetch dei media non parte su rete cellulare.

Sono test che verificano decisioni architetturali, non comportamento di codice.

## Nomi e struttura

`test/` rispecchia `lib/`. I file finiscono in `_test.dart`. I nomi dei test
descrivono un comportamento, non un metodo:

```
✓ "una serie completata offline resta visibile dopo il riavvio"
✗ "testCompleteSet"
```

## Integrazione

Un numero ridotto di test end-to-end sui percorsi che, se si rompono, rendono la
app inutile:

1. login → catalogo pronto → lista schede;
2. avvio allenamento → completamento serie → chiusura app → riapertura: i dati
   sono ancora lì;
3. sessione completata offline → connessione ripristinata → outbox svuotata.

Il terzo è il test più importante dell'intera suite: verifica la promessa
centrale del prodotto.
