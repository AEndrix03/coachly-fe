---
livello: Standard
stato: active
---

# 25 — Release e ambienti

## Stato attuale

Nessun flavor: `android/app/build.gradle` ha solo `buildTypes`. Un'unica app, un
unico id, la configurazione passa da quattro `dart-define` sciolti. Non è
possibile avere dev e produzione installate insieme sullo stesso telefono.

## Ambienti

| Ambiente | `ENV` | Backend | Application id |
|---|---|---|---|
| Sviluppo | `dev` | dev.aredegalli.it | `it.coachly.coachly.dev` |
| Staging | `stage` | staging | `it.coachly.coachly.stage` |
| Produzione | `prod` | produzione | `it.coachly.coachly` |

Flavor Android e scheme iOS, con `applicationIdSuffix` distinti: le tre app
convivono sul dispositivo, con nome e icona diversi. Sbagliare ambiente diventa
visibile invece che silenzioso.

Le build non-`prod` mostrano un banner con ambiente e versione, e hanno la debug
screen di `17-config-and-flags.md`.

## Script di build

Nessun `dart-define` scritto a mano da riga di comando: un file di configurazione
per ambiente.

```bash
flutter build apk --flavor prod --dart-define-from-file=config/prod.json
```

Elimina la classe di errore più comune: una build di produzione con l'URL di dev,
o viceversa.

I file `config/*.json` **non contengono segreti** e sono versionati.

## Versioning

`major.minor.patch+build` in `pubspec.yaml`.

| Parte | Quando |
|---|---|
| `major` | cambio che rompe la compatibilità con il backend |
| `minor` | funzionalità |
| `patch` | correzioni |
| `build` | monotono, assegnato dalla CI |

`AppConfig` espone versione e build, mostrate nel profilo e allegate a ogni
crash e a ogni evento.

## Versione minima supportata

Serve fin da subito, anche senza utenti: appena la app è su uno store, esistono
installazioni vecchie che non aggiornano.

```
GET /app/requirements  →  { minSupportedVersion, recommendedVersion, message }
```

- versione < `minSupportedVersion` → schermata bloccante di aggiornamento;
- versione < `recommendedVersion` → avviso non bloccante, ignorabile.

Il controllo avviene all'avvio e all'aggiornamento del catalogo, ed è una guard
di routing (`08-routing-navigation.md`). Deve degradare bene: **senza rete la app
funziona lo stesso**, il controllo si rimanda.

## Compatibilità del contratto

Con più versioni client in produzione simultanea:

1. Il backend non rompe mai un campo esistente: si aggiunge, non si cambia.
2. Il client ignora i campi che non conosce.
3. Un campo nuovo obbligatorio richiede un `minSupportedVersion` più alto.
4. Il catalogo dichiara la propria `schemaVersion`: un client vecchio che riceve
   un delta con versione superiore lo rifiuta e resta al catalogo che ha, invece
   di corrompersi.

Il punto 4 è quello che si dimentica e che fa danni: un client che applica un
delta che non capisce ha un database in uno stato che nessuno ha previsto.

## Pipeline

```
PR              analyze · custom_lint · test · format
merge su main   build dev + stage, artefatti conservati
tag             build prod firmata, upload store, note di rilascio
```

Requisiti bloccanti prima di un tag: suite verde, nessuna dipendenza inutilizzata,
budget di dimensione del bundle rispettato, golden aggiornati intenzionalmente.

## Rollout

Store: rollout graduale (10% → 50% → 100%), con osservazione del crash-free rate
fra uno scaglione e l'altro.

Un rollback dello store è lento. Il meccanismo di emergenza sono i **kill switch**
lato feature flag (`17-config-and-flags.md`), che spengono una funzione senza una
nuova release — ed è il motivo pratico per cui l'astrazione dei flag serve prima
del provider remoto.

## Migrazioni di schema in release

Ogni release che cambia lo schema Drift:

- ha lo snapshot esportato e committato;
- ha un test di migrazione dallo snapshot precedente;
- dichiara nelle note di rilascio se la migrazione è lunga.

Una migrazione all'avvio non deve lasciare l'utente su uno splash muto: serve
uno stato dedicato con avanzamento.

## Pre-release checklist

- [ ] versione e build incrementate
- [ ] `ENV=prod` e configurazione corretta verificate nella debug screen
- [ ] catalogo pre-seeded rigenerato e allineato al backend
- [ ] `minSupportedVersion` aggiornata lato backend se necessario
- [ ] test di migrazione verdi
- [ ] test a11y verdi
- [ ] dimensione del bundle entro il budget
- [ ] flag di debug (`CACHE_MODE`, mock) inerti in release
