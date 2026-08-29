# Coachly — Regole di sviluppo (VINCOLANTI)

Queste regole hanno precedenza su qualsiasi convenzione generale Flutter/Dart e
su qualsiasi tua abitudine. Se contraddicono il tuo default, vince questa regola.

---

## 1. DIVIETI ASSOLUTI — nessuna eccezione, nessun "per ora"

Non scrivere **MAI** queste cose nel codice, nemmeno come soluzione temporanea,
nemmeno se il resto del file le contiene già, nemmeno etichettandole come
"debito tecnico". Se stai per scriverne una, **FERMATI** e applica il
protocollo della sezione 3.

| # | VIETATO | Al suo posto |
|---|---|---|
| 1 | `Color(0x…)`, `Colors.*` | token di colore |
| 2 | `TextStyle(...)` a mano, `fontSize:` | token tipografici |
| 3 | numeri in `SizedBox`, `EdgeInsets`, `BorderRadius` | token di spazio e raggio |
| 4 | stringhe visibili all'utente scritte nel codice | ARB |
| 5 | nomi di mesi/giorni scritti a mano | `intl` |
| 6 | `DateTime.now()` | `Clock` iniettabile |
| 7 | `print`, `debugPrint` | `AppLogger` |
| 8 | rete chiamata da un widget o da un provider | repository |
| 9 | `throw` che esce dal data layer | `Result<T, Failure>` |
| 10 | `setState` per dati dal repository | Riverpod |
| 11 | `Future.microtask(...)` nel `build()` di un Notifier | `AsyncNotifier` |
| 12 | target interattivi sotto 48×48 dp | ≥ 48 dp |
| 13 | UUID generati a mano | `core/ids` |
| 14 | `context.go` per cambiare tab | `navigationShell.goBranch` |
| 15 | Hive, `package:http`, `equatable`, Ionicons, Lucide, Cupertino Icons, `flutter_hooks` | rimossi per decisione architetturale |
| 16 | dipendenze nuove in `pubspec.yaml` | fermati e chiedi: serve un ADR |

**Il fatto che il codice esistente violi queste regole non ti autorizza a
imitarlo.** Gran parte del repository è precedente a queste regole.

---

## 2. GATE DI LETTURA — obbligatorio

**PRIMA di scrivere, modificare o proporre codice devi leggere i documenti
pertinenti in `docs/development/`.**

1. **LEGGI SEMPRE** `docs/development/01-principles.md`. Nessuna eccezione.
2. **CONSULTA** la tabella di instradamento (sezione 5) e individua i documenti
   pertinenti.
3. **LEGGI** quei documenti con lo strumento di lettura file. Non indovinare dal
   nome, non dedurre, non fidarti della memoria.
4. **SOLO ORA** scrivi codice.

Se non riesci a leggere i documenti, **FERMATI** e dichiaralo. Non procedere a
intuito.

---

## 3. ⚠️ IL CODICE È INDIETRO RISPETTO AI DOCUMENTI

**Questo è il punto in cui si sbaglia più spesso. Leggilo due volte.**

`docs/development/` descrive l'architettura **target**. Il repository è in
migrazione (vedi `docs/development/26-migration-plan.md`). Molte cose che i
documenti danno per esistenti **NON esistono ancora nel codice**.

Lo stato aggiornato di cosa esiste e cosa no sta in `CLAUDE.md`, sezione
"Stato noto del repository". **Leggilo**: molte cose che questa sezione dava
per mancanti sono state costruite (Drift, Dio, `Clock`, `core/ids`, `Result`,
`AppLogger`, il request coalescer, l'outbox, ARB e `context.l10n`), e
affermare che mancano è oggi l'errore B, non l'errore A.

Restano da costruire: `context.colors` e i token di colore in uso, il catalogo
pre-seeded, l'event log delle sessioni.

Da questo derivano due errori opposti, **entrambi gravi**:

### ❌ Errore A — violare "temporaneamente"

> *"Il token `feedbackWarning` non esiste, uso `Color(0xFFFFA500)` per ora."*

**VIETATO.** Aggiunge debito esattamente dove stiamo cercando di rimuoverlo.

### ❌ Errore B — allucinare che il target esista

> *"Il colore lo prendo da `context.colors.warning`"* — i token di colore
> semantici non ci sono ancora.
> *"Il catalogo arriva dall'asset pre-installato"* — l'asset non esiste.

**VIETATO.** Produce codice che non compila e affermazioni false.

### ✅ Protocollo corretto

Quando ti serve qualcosa che i documenti prevedono ma il codice non ha ancora:

1. **VERIFICA** con una ricerca nel codice che davvero non esista. Non
   presumerlo in nessuna delle due direzioni.
2. **NON inventare** che esista. **NON violare** il divieto.
3. **SCEGLI** l'opzione meno dannosa, in quest'ordine:
   - a. crea il pezzo mancante, se è piccolo e circoscritto (es. aggiungere un
     token al design system esistente);
   - b. usa il meccanismo attuale più vicino, dichiarando che è provvisorio
     (es. `AppStrings` finché ARB non c'è);
   - c. se non c'è nessuna opzione accettabile, **fermati e chiedi**.
4. **DICHIARA** ogni scelta di questo tipo nella sezione `Attriti` della tua
   risposta (sezione 4).

Il punto 4 non è opzionale: è il modo in cui il piano di migrazione si aggiorna.

---

## 4. FORMATO DELLA RISPOSTA — obbligatorio

Ogni risposta che produce o modifica codice ha **questa struttura**:

```
Docs consultati: 01-principles.md, <altri file effettivamente letti>

<la risposta>

Attriti:
- <ogni punto in cui il target non esiste ancora e cosa hai fatto>
- <"nessuno" se non ce ne sono>

Autocontrollo:
- [ ] nessun colore, dimensione o stile letterale
- [ ] nessuna stringa utente scritta nel codice
- [ ] nessuna chiamata di rete fuori da un repository
- [ ] target interattivi ≥ 48 dp
- [ ] non ho affermato che esista codice che non ho verificato
```

**Rileggi il tuo codice e spunta le caselle una per una prima di rispondere.**
Se una casella non è spuntabile, **correggi il codice — non la casella**.

Spuntare una casella e poi ammettere nella stessa frase che non è vera
(es. *"[x] target ≥ 48 dp — il badge è 32 dp, se serve interattivo avvolgilo"*)
è **peggio** che lasciarla vuota: rende inutile l'autocontrollo. Se non è vero,
scrivi `- [ ]` e spiega sotto cosa manca.

Una risposta senza la riga `Docs consultati:` e senza l'`Autocontrollo` è
incompleta e va rifatta.

---

## 5. Tabella di instradamento

| Se il task riguarda… | LEGGI in `docs/development/` |
|---|---|
| Qualsiasi cosa | `01-principles.md` |
| Dove mettere un file, come chiamarlo | `02-project-structure.md` |
| Provider, controller, stato, Riverpod | `03-state-riverpod.md` |
| **Leggere o salvare qualsiasi dato** | `04-data-layer.md` **e** `05-sync-and-offline.md` |
| Chiamate HTTP, API, endpoint | `04-data-layer.md`, `05-sync-and-offline.md`, `06-networking.md` |
| Errori, toast, messaggi, stati di caricamento | `07-errors-and-feedback.md` |
| Rotte, navigazione, navbar, deep link | `08-routing-navigation.md` |
| Colori, temi, spaziature, font, ombre | `09-design-tokens.md` |
| Creare o modificare un widget | `10-components.md` |
| Animazioni, transizioni, durate | `11-motion.md` |
| Icone | `12-iconography.md` |
| Testi, traduzioni, date, numeri, unità | `13-i18n.md` |
| Accessibilità, dimensioni tap, screen reader | `14-accessibility.md` |
| Liste, prestazioni, rebuild, avvio | `15-performance.md` |
| Immagini, video, download | `16-media.md` |
| Configurazione, `dart-define`, feature flag | `17-config-and-flags.md` |
| Log, crash, metriche | `18-observability.md` |
| Test | `19-testing.md` |
| Lint, CI, definition of done | `20-conventions-and-enforcement.md` |
| Aggiungere una feature completa | `21-golden-path.md` |
| Eventi analytics | `22-analytics-events.md` |
| Riconoscimento vocale | `23-voice.md` |
| Token, segreti, dati personali, GDPR | `24-security-and-privacy.md` |
| Build, ambienti, versioni | `25-release-and-environments.md` |
| Cosa esiste già e cosa no | `26-migration-plan.md` |

Nel dubbio, leggi **più** documenti, non meno.

> **Attenzione.** Un task che *sembra* solo di interfaccia quasi sempre tocca
> anche dati, testi e accessibilità. Un task che *sembra* solo una chiamata API
> è quasi sempre prima di tutto una domanda sul data layer.

---

## 6. OBBLIGHI

1. **Coachly è local-first.** La UI legge dal database locale e **non aspetta
   mai** una chiamata HTTP. Prima di scrivere una `GET`, chiediti a quale delle
   tre classi di dati appartiene (`04-data-layer.md`): catalogo, dato utente, o
   dato assegnato. La risposta determina tutto il resto.
2. **Il dato e la riga di outbox si scrivono nella stessa transazione.**
3. **Dichiara i cinque stati** di una schermata che carica dati: loading, empty,
   error, offline, stale.
4. **Usa `.select()`** quando osservi un pezzo di stato in un widget foglia.
5. **`keepAlive: true`** su repository e stream globali.
6. **Chiavi di testo in entrambe le lingue** (`en` e `it`).
7. **Proponi i test insieme al codice**, non dopo.
8. **Azioni distruttive: undo, non conferma.**

---

## 7. Se deleghi a un altro agente

**I subagent NON ricevono i file di memoria del progetto** (`CLAUDE.md`,
`AGENTS.md`, questa rule). Verificato sperimentalmente: un subagent avviato senza
istruzioni esplicite non conosce nessuna di queste regole e le viola tutte.

Quindi, se deleghi lavoro su questo repository a un subagent:

**DEVI copiare nel suo prompt il blocco prodotto da
`.claude/hooks/inject-gate.sh`.** Senza quello, l'output andrà buttato.

---

## 8. Quando non sei sicuro

- Il documento non risponde alla tua domanda → dillo, proponi la soluzione
  coerente con `01-principles.md`, segnala che serve un ADR.
- La richiesta dell'utente contraddice i documenti → segnalalo in una frase, poi
  fai quello che l'utente ha chiesto. L'utente decide, ma con cognizione.
- Stai per aggiungere una dipendenza → **fermati e chiedi**.
