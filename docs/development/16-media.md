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

## Asset bundled: struttura e naming

Gli asset spediti nel bundle seguono una convenzione unica. Non è estetica: su
Android e iOS il filesystem è case-sensitive mentre su Windows no, quindi un
`Superset.png` referenziato come `superset.png` è un errore che si manifesta
solo sul dispositivo.

### Nome del file

`lowercase_snake_case`, ASCII, estensione minuscola — la stessa regola dei file
Dart (`02-project-structure.md`), così le convenzioni da ricordare restano una.
Vietati kebab-case, PascalCase, spazi, accenti.

Il nome descrive **il concetto, non l'uso**: `gym_dark_background.jpg`, non
`auth_page_background.jpg`. Legare un asset a una schermata significa che il
nome mentirà il giorno in cui lo si riusa altrove.

Varianti come suffisso, in quest'ordine: `<nome>_<variante>_<dimensione>.<ext>`

```
app_logo_dark.png
barbell_thumb_256.webp
```

La variante di tema è `_light` / `_dark`. Mai `_no_bg`: la trasparenza è una
proprietà del file, non del nome.

Nessun numero di versione nel nome: il versioning esiste per gli asset remoti
(vedi *URL immutabili*), non per quelli nel bundle, che sono versionati dalla
release.

### Cartelle: per dominio, non per tipo di file

```
assets/
  brand/                 logo, wordmark, splash
  icons/                 SVG di dominio (vedi 12-iconography.md)
  illustrations/         disegni editoriali, per famiglia
  photos/                fotografie
  exercises/             thumbnail del catalogo nel bundle
```

Una cartella `images/` che contiene insieme fondali, illustrazioni e icone è
la stessa discarica che `02-project-structure.md` vieta per `utils/`.

Le famiglie stanno in sottocartelle: `illustrations/guides/rir.png`,
`illustrations/set_type/superset.png`, `icons/equipment/barbell.svg`.

### Densità

Solo le sottocartelle risolte da Flutter, accanto al file base:

```
assets/brand/app_logo.png
assets/brand/2.0x/app_logo.png
assets/brand/3.0x/app_logo.png
```

Mai `app_logo@2x.png`: Flutter non lo risolve.

### Formati

| Uso | Formato |
|---|---|
| Icone e forme vettoriali | `.svg` |
| Raster nel bundle | `.webp` |
| Raster che richiede alpha lossless | `.png` |
| Fotografie | `.jpg` |

Il default è `.webp`: pesa il 30-50% in meno del PNG equivalente e i media sono
la voce di traffico e di spazio dominante della app.

### Dichiarazione in `pubspec.yaml`

Si dichiarano le cartelle, mai i singoli file. **Le cartelle non sono
ricorsive**: ogni sottocartella nuova va aggiunta a mano, altrimenti l'asset
manca a runtime senza alcun errore in compilazione.

### Accesso dal codice

Nessun percorso di asset scritto a mano in una feature. Tutto passa da un
registro tipizzato, `lib/core/assets/app_assets.dart`:

```dart
Image.asset(AppAssets.logoDark, height: 80)
```

È l'estensione a ogni asset della regola che `12-iconography.md` già impone alle
icone: rinomina sicura, un solo posto in cui il percorso può essere sbagliato.

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
