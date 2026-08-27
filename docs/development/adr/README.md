# Architecture Decision Records

Una decisione presa e non registrata verrà rimessa in discussione fra sei mesi
senza memoria del perché.

## Quando serve un ADR

- si sceglie o si sostituisce una tecnologia;
- si cambia una regola dichiarata "Costituzione" in `00-index.md`;
- si accetta consapevolmente un compromesso che qualcuno leggerà come un errore.

Non serve per: convenzioni di naming, scelte di implementazione locali, refactor
che non cambiano un confine.

## Formato

```markdown
# ADR-00N — Titolo

Stato: proposto | accettato | sostituito da ADR-00M
Data: YYYY-MM-DD

## Contesto
## Decisione
## Conseguenze
## Alternative scartate
```

Un ADR non si modifica dopo essere stato accettato: si sostituisce con uno nuovo
che lo dichiara superato. La storia delle decisioni vale quanto le decisioni.

## Indice

| ADR | Titolo | Stato |
|---|---|---|
| [001](001-design-tokens-da-zero.md) | Layer di design token nuovo | accettato |
| [002](002-arb-gen-l10n.md) | ARB + gen_l10n per la localizzazione | accettato |
| [003](003-solo-material-icons.md) | Solo Material Icons | accettato |
| [004](004-drift-al-posto-di-hive.md) | Drift/SQLite al posto di Hive | accettato |
| [005](005-nessuna-migrazione-dati.md) | Nessuna migrazione dati | accettato |
| [006](006-dio-al-posto-di-http.md) | Dio al posto di package:http | accettato |
