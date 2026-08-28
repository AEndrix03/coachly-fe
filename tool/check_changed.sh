#!/usr/bin/env bash
#
# Verifica i lint Coachly sui soli file toccati dal branch corrente.
#
# È il meccanismo di adozione descritto in
# `docs/development/20-conventions-and-enforcement.md`: le regole restano
# `warning` su tutto il repository, ma sono **bloccanti** sui file che stai
# modificando. Così il debito smette di crescere mentre lo si ripaga, senza che
# il primo giorno finisca in un `ignore_for_file` generalizzato.
#
# Uso:
#   tool/check_changed.sh            # confronto con origin/master
#   tool/check_changed.sh develop    # confronto con un'altra base
set -uo pipefail

BASE="${1:-origin/master}"
cd "$(dirname "$0")/.." || exit 1

CHANGED=$(git diff --name-only "$BASE"...HEAD -- 'lib/*.dart' 'test/*.dart' 2>/dev/null)
CHANGED="$CHANGED
$(git diff --name-only -- 'lib/*.dart' 'test/*.dart' 2>/dev/null)"
CHANGED=$(echo "$CHANGED" | grep -v '\.g\.dart$' | grep -v '\.freezed\.dart$' | sort -u | grep -v '^$')

if [ -z "$CHANGED" ]; then
  echo "Nessun file Dart modificato rispetto a $BASE."
  exit 0
fi

echo "File modificati rispetto a $BASE:"
echo "$CHANGED" | sed 's/^/  /'
echo

REPORT=$(mktemp)
trap 'rm -f "$REPORT"' EXIT
dart run custom_lint --no-fatal-infos > "$REPORT" 2>&1

FAILED=0
while IFS= read -r file; do
  # custom_lint stampa i percorsi con i separatori di piattaforma
  pattern=$(echo "$file" | sed 's|/|[/\\\\]|g')
  hits=$(grep -E "^\s+$pattern:" "$REPORT" || true)
  if [ -n "$hits" ]; then
    echo "$hits"
    FAILED=1
  fi
done <<< "$CHANGED"

if [ "$FAILED" -eq 1 ]; then
  echo
  echo "Violazioni nei file che hai modificato. Vedi docs/development/20-conventions-and-enforcement.md."
  exit 1
fi

echo "Nessuna violazione nei file modificati."
