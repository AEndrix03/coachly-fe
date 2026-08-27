#!/usr/bin/env bash
# Inietta il gate di lettura nel contesto a ogni prompt.
# I file di memoria di progetto non raggiungono i subagent: questo hook sì.
set -euo pipefail

RULE="$CLAUDE_PROJECT_DIR/.claude/rules/development.md"
[ -f "$RULE" ] || exit 0

cat <<'GATE'
=== REGOLE VINCOLANTI COACHLY (iniettate dall'harness, non ignorabili) ===

PRIMA di scrivere o proporre codice per questo repository DEVI:
1. leggere .claude/rules/development.md
2. leggere docs/development/01-principles.md
3. leggere i documenti indicati dalla tabella di instradamento della rule

IL CODICE È INDIETRO RISPETTO AI DOCUMENTI. docs/development/ descrive il TARGET.
NON esistono ancora: token di design, ARB/context.l10n, Clock, core/ids,
Result<T,Failure>, AppLogger, Drift, Dio, coalescer, outbox.
Non affermare che esistano. Non violare le regole "per ora". Vedi sezione 3 della rule.

MAI, nemmeno temporaneamente: Color(0x…) o Colors.* · TextStyle/fontSize a mano ·
numeri magici in SizedBox/EdgeInsets/BorderRadius · stringhe utente nel codice ·
DateTime.now() · print/debugPrint · rete da widget o provider · target < 48dp ·
dipendenze nuove senza chiedere.

SEMPRE: Coachly è local-first, la UI legge dal DB locale e non aspetta mai HTTP.

Se generi o modifichi codice, la risposta DEVE contenere:
  Docs consultati: <file letti>
  Attriti: <dove il target non esiste e cosa hai fatto>
  Autocontrollo: <checklist sezione 4 della rule. Non spuntare cio che non e vero.>

Se deleghi a un subagent, COPIA questo blocco nel suo prompt: i subagent non
ricevono i file di memoria del progetto.
=== FINE REGOLE VINCOLANTI ===
GATE
