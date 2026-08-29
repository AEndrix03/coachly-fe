#!/usr/bin/env bash
#
# Esegue la suite e fallisce solo sulle **regressioni**.
#
# `docs/development/20-conventions-and-enforcement.md`: la CI va attivata
# accettando come baseline nota i test rossi per deriva fra UI e asserzioni
# (`26-migration-plan.md`, residuo della Fase 0), non aspettando che siano
# zero. Aspettare significherebbe non avere CI, che è la condizione da cui
# tutto il debito di questo repository è nato.
#
# Il file `tool/test_baseline.txt` elenca i test rossi accettati. Lo script
# fallisce se:
#   - fallisce un test che NON è in baseline  -> regressione;
#   - passa un test che È in baseline         -> baseline da stringere.
#
# La seconda condizione è la parte che impedisce alla baseline di diventare
# una discarica: ogni test riparato deve uscirne nello stesso PR.
set -uo pipefail

cd "$(dirname "$0")/.." || exit 1
BASELINE="tool/test_baseline.txt"

# Gli argomenti in piu' passano a `flutter test` (es. --exclude-tags golden).
EXTRA=("$@")

JSON=$(mktemp)
trap 'rm -f "$JSON"' EXIT
flutter test --reporter json "${EXTRA[@]}" > "$JSON" 2>/dev/null
echo "Suite eseguita."

FAILED=$(dart run tool/test_report.dart "$JSON" failed)
KNOWN=$(grep -v '^\s*#' "$BASELINE" 2>/dev/null | grep -v '^\s*$' | sort -u)

REGRESSIONS=$(comm -23 <(echo "$FAILED" | sort -u | grep -v '^$') <(echo "$KNOWN"))
FIXED=$(comm -13 <(echo "$FAILED" | sort -u | grep -v '^$') <(echo "$KNOWN"))

STATUS=0
if [ -n "$REGRESSIONS" ]; then
  echo
  echo "REGRESSIONI — test rossi non presenti in $BASELINE:"
  echo "$REGRESSIONS" | sed 's/^/  /'
  STATUS=1
fi
if [ -n "$FIXED" ]; then
  echo
  echo "Baseline da aggiornare — questi test ora passano, toglili da $BASELINE:"
  echo "$FIXED" | sed 's/^/  /'
  STATUS=1
fi

if [ "$STATUS" -eq 0 ]; then
  echo "Nessuna regressione. Baseline: $(echo "$KNOWN" | grep -c . || true) test rossi noti."
fi
exit "$STATUS"
