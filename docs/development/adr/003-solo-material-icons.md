# ADR-003 — Solo Material Icons

Stato: accettato
Data: 2026-08-28

## Contesto

Il progetto dichiara quattro pack di icone. L'uso reale:

| Pack | Utilizzi |
|---|---|
| Material `Icons.*` | 269 |
| `ionicons` | 10 |
| `lucide_icons_flutter` | 0 |
| `cupertino_icons` | 0 |

Due dipendenze non sono mai state usate. Una è usata dieci volte, fra cui
l'icona del profilo nella navbar, il che produce incoerenza visiva proprio nel
componente più visibile della app.

## Decisione

**Solo Material Icons.** Si rimuovono `lucide_icons_flutter`, `ionicons` e
`cupertino_icons`. I 10 usi di Ionicons si mappano su equivalenti Material.

Le icone di dominio che Material non copre (tipi di serie, attrezzi, pattern di
movimento) sono SVG in `assets/icons/`, disegnate sulla griglia Material 24 px
tratto 2, esposte da una enum tipizzata.

## Conseguenze

- Tre dipendenze in meno e un bundle più piccolo.
- Coerenza visiva garantita per costruzione.
- Semantica e scaling nativi.
- Se in futuro si volesse un'estetica diversa, la conversione costerebbe 269
  punti: la decisione è di fatto duratura, e va presa sapendolo.

## Alternative scartate

**Lucide.** Estetica più coerente con il look shadcn/athlete, ma è già in
`pubspec` con zero utilizzi: adottarlo significherebbe convertire 269 punti
Material per un beneficio puramente estetico.

**Ionicons.** Stesso costo di conversione, senza un vantaggio chiaro su Material.
