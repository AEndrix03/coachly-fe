---
livello: Standard
stato: active
---

# 16 — Media

Con il catalogo spedito nel bundle e i dati che nascono locali, **i media sono la
voce di traffico dominante della app**. Tutto ciò che riguarda il costo di rete
si decide qui.

## Separazione

```
metadati    →  tabella media_cache in Drift
byte        →  filesystem, cartella cache
sorgente    →  CDN / object storage
```

Mai byte di immagini o video nel database.

## Cosa viaggia con il bundle

| Contenuto | Nel bundle |
|---|---|
| Thumbnail degli esercizi più frequenti | **sì**, insieme al catalogo |
| Immagini di illustrazione della app | sì |
| Video dimostrativi | no, on demand |
| Thumbnail della coda lunga | no, on demand |

Il criterio della "coda corta" è la frequenza d'uso reale misurata (top ~200
esercizi), non un'intuizione. Fino a quando quel dato non esiste, si spedisce
l'insieme degli esercizi presenti nelle schede predefinite.

## Astrazione

```dart
abstract interface class MediaCache {
  Future<File?> get(MediaAsset asset);
  Future<void> prefetch(MediaAsset asset, {required PrefetchReason reason});
  Future<void> evict(MediaAsset asset);
  Future<MediaCacheStats> stats();
}
```

Il dominio non conosce il pacchetto di caching. Un componente che mostra un
esercizio parla con `MediaCache`, non con una libreria: fra due anni
l'implementazione si cambia senza toccare la libreria esercizi né il logger.

## URL immutabili

```
exercise/{id}/v{revision}/preview-540.mp4
exercise/{id}/v{revision}/thumb-256.webp
```

Un asset non cambia mai contenuto a parità di URL: una nuova versione è un nuovo
percorso. Questo rende la cache valida per sempre e rimuove ogni bisogno di
invalidazione.

Sovrascrivere un file mantenendo l'URL è vietato lato backend.

## Policy di rete

Questa è la regola che protegge l'utente in palestra, dove è quasi sempre su rete
cellulare.

| Situazione | Wi-Fi | Cellulare |
|---|---|---|
| Thumbnail visibile a schermo | sì | sì |
| Thumbnail appena fuori dal viewport | sì | no |
| Video, riproduzione richiesta | sì | sì |
| Video, prefetch della sessione | sì | **solo su richiesta esplicita** |
| Prefetch del catalogo | sì, in idle | mai |

Impostazione utente: `Scarica media solo su Wi-Fi`, **attiva di default**.

Nessun download automatico di video su rete cellulare. Mai.

## Prefetch

Un solo caso giustificato: all'apertura di una scheda, si prefetchano le
thumbnail degli esercizi di quella scheda. È prevedibile, limitato e migliora
concretamente l'esperienza.

Vietato: prefetch dell'intera libreria, prefetch speculativo su scroll, prefetch
di video senza intenzione esplicita.

## Budget e eviction

| Parametro | Valore |
|---|---|
| Budget totale | 500 MB, configurabile dall'utente |
| Soglia di allerta | 80% |
| Politica | LRU su `last_used_at`, i video prima delle immagini |
| Protetti | media delle schede attive dell'utente |

L'utente vede quanto spazio occupa la app e può svuotare la cache. Svuotarla non
perde **mai** dati: i media sono rigenerabili per definizione.

L'eviction gira all'avvio e quando si supera la soglia, mai durante una sessione
di allenamento.

## Video

- si scarica su file, poi si dà il file locale al player: nessun accoppiamento
  fra dominio e libreria di streaming;
- un solo player istanziato per volta, disposto all'uscita dalla pagina;
- il download è cancellabile e riprendibile;
- l'anteprima è la thumbnail, non il primo frame del video.

## Errori

Un media mancante non è un errore dell'app: è un placeholder. Nessun toast,
nessuna schermata di errore, nessun log a livello error — la scheda si usa lo
stesso senza il video.

## Test

- che il prefetch **non** parta su rete cellulare;
- che l'eviction rispetti il budget e non tocchi i media protetti;
- che una `MediaCache` fake permetta di testare la UI senza filesystem né rete.
