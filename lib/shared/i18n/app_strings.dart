import 'package:flutter/material.dart';

class AppStrings {
  static const Locale defaultLocale = Locale('en');
  static const List<Locale> supportedLocales = [Locale('en'), Locale('it')];
  static const List<Locale> languageOptions = supportedLocales;

  static const Map<String, Map<String, String>> _values = {
    'common.app_name': {'en': 'Coachly', 'it': 'Coachly'},
    'common.settings': {'en': 'Settings', 'it': 'Impostazioni'},
    'common.language': {'en': 'Language', 'it': 'Lingua'},
    'common.select_language': {
      'en': 'Select a language',
      'it': 'Seleziona una lingua',
    },
    'common.english': {'en': 'English', 'it': 'English'},
    'common.italian': {'en': 'Italian', 'it': 'Italiano'},
    'common.version': {'en': 'Version', 'it': 'Versione'},
    'common.build': {'en': 'Build', 'it': 'Build'},
    'common.error': {'en': 'Error', 'it': 'Errore'},
    'common.go_back': {'en': 'Go back', 'it': 'Torna indietro'},
    'common.confirm': {'en': 'Confirm', 'it': 'Conferma'},
    'common.cancel': {'en': 'Cancel', 'it': 'Annulla'},
    'common.edit': {'en': 'Edit', 'it': 'Modifica'},
    'common.duplicate': {'en': 'Duplicate', 'it': 'Duplica'},
    'common.delete': {'en': 'Delete', 'it': 'Elimina'},
    'common.activate': {'en': 'Activate', 'it': 'Attiva'},
    'common.deactivate': {'en': 'Deactivate', 'it': 'Disattiva'},
    'common.workouts': {'en': 'Workouts', 'it': 'Allenamenti'},
    'common.exercises': {'en': 'Exercises', 'it': 'Esercizi'},
    'common.workout': {'en': 'workout', 'it': 'scheda'},
    'common.days': {'en': 'days', 'it': 'giorni'},
    'common.na': {'en': 'N/A', 'it': 'N/D'},
    'common.seconds': {'en': 'seconds', 'it': 'secondi'},

    'nav.community': {'en': 'Community', 'it': 'Community'},
    'nav.workouts': {'en': 'Workouts', 'it': 'Allenamenti'},
    'nav.coach': {'en': 'Coach', 'it': 'Coach'},
    'nav.ideas': {'en': 'Ideas', 'it': 'Idee'},
    'nav.profile': {'en': 'Profile', 'it': 'Profilo'},

    'profile.profile': {'en': 'Profile', 'it': 'Profilo'},
    'profile.your_profile': {'en': 'Your profile', 'it': 'Il tuo profilo'},
    'profile.member': {'en': 'Coachly Member', 'it': 'Membro Coachly'},
    'profile.preferences': {'en': 'Preferences', 'it': 'Preferenze'},
    'profile.app_section': {'en': 'App', 'it': 'App'},
    'profile.logout': {'en': 'Logout', 'it': 'Logout'},
    'profile.logout_title': {'en': 'Logout', 'it': 'Logout'},
    'profile.logout_content': {
      'en': 'Are you sure you want to log out?',
      'it': 'Sei sicuro di voler uscire?',
    },
    'profile.logout_confirm': {'en': 'Exit', 'it': 'Esci'},

    'workout.recent': {'en': 'Recent Workouts', 'it': 'Schede Recenti'},
    'workout.all': {'en': 'All Workouts', 'it': 'Tutte le Schede'},
    'workout.notifications': {'en': 'Notifications', 'it': 'Notifiche'},
    'workout.notifications_soon': {
      'en': 'Notifications feature coming soon',
      'it': 'Funzionalita notifiche in arrivo',
    },
    'workout.description': {'en': 'Description', 'it': 'Descrizione'},
    'workout.sets': {'en': 'Sets', 'it': 'Serie'},
    'workout.reps': {'en': 'Reps', 'it': 'Rep'},
    'workout.load': {'en': 'Load', 'it': 'Carico'},
    'workout.rest': {'en': 'Rest', 'it': 'Rest'},
    'workout.start': {'en': 'Start Workout', 'it': 'Inizia Allenamento'},
    'workout.last_used': {'en': 'Last: {date}', 'it': 'Ultima: {date}'},
    'workout.duration': {'en': 'Duration', 'it': 'Durata'},
    'workout.duration_minutes': {'en': 'Duration (min)', 'it': 'Durata (min)'},
    'workout.focus': {'en': 'Focus', 'it': 'Focus'},
    'workout.type': {'en': 'Type', 'it': 'Tipo'},
    'workout.hypertrophy': {'en': 'Hypertrophy', 'it': 'Ipertrofia'},
    'workout.share': {'en': 'Share', 'it': 'Condividi'},
    'workout.share_soon': {
      'en': 'Workout sharing coming soon',
      'it': 'Condivisione workout in arrivo',
    },
    'workout.header_title': {'en': 'Your Workouts', 'it': 'I Tuoi Allenamenti'},
    'workout.auth_disabled': {
      'en': 'Authentication disabled',
      'it': 'Autenticazione disabilitata',
    },
    'workout.auth_disabled_content': {
      'en':
          'Login, logout, and token management are temporarily disconnected during backend refactoring.',
      'it':
          'Login, logout e gestione token sono temporaneamente scollegati durante il refactor del backend.',
    },
    'workout.access_disabled': {
      'en': 'Access disabled',
      'it': 'Accesso disabilitato',
    },
    'workout.week': {'en': 'Week', 'it': 'Settimana'},
    'workout.streak': {'en': 'Streak', 'it': 'Streak'},
    'workout.active_short': {'en': 'Active', 'it': 'Attive'},
    'workout.completed': {'en': 'Completed', 'it': 'Completate'},

    'workout.organize.title': {
      'en': 'Organize Workouts',
      'it': 'Organizza gli Allenamenti',
    },
    'workout.organize.active': {'en': 'Active Workouts', 'it': 'Schede Attive'},
    'workout.organize.inactive': {
      'en': 'Inactive Workouts',
      'it': 'Schede Non Attive',
    },
    'workout.organize.empty': {
      'en': 'No workouts in this category',
      'it': 'Nessuna scheda in questa categoria',
    },
    'workout.organize.delete_title': {
      'en': 'Confirm Deletion',
      'it': 'Conferma Eliminazione',
    },
    'workout.organize.delete_content': {
      'en': 'Are you sure you want to delete the workout "{name}"?',
      'it': 'Sei sicuro di voler eliminare la scheda "{name}"?',
    },
    'workout.organize.status_title': {
      'en': 'Confirm Status Change',
      'it': 'Conferma Modifica Stato',
    },
    'workout.organize.status_content': {
      'en': 'Are you sure you want to {action} the workout "{name}"?',
      'it': 'Sei sicuro di voler {action} la scheda "{name}"?',
    },
    'workout.organize.action_activate': {'en': 'activate', 'it': 'attivare'},
    'workout.organize.action_deactivate': {
      'en': 'deactivate',
      'it': 'disattivare',
    },
    'workout.organize.exercises_count': {
      'en': '{count} exercises',
      'it': '{count} esercizi',
    },
    'workout.organize.coach': {'en': 'Coach {name}', 'it': 'Coach {name}'},
    'workout.load_error': {
      'en': 'Error while loading.',
      'it': 'Errore nel caricamento.',
    },
    'workout.complete_title': {
      'en': 'Complete workout?',
      'it': 'Completa allenamento?',
    },
    'workout.complete_content': {
      'en': 'All data will be saved and the session registered.',
      'it': 'Tutti i dati verranno salvati e la sessione registrata.',
    },
    'workout.complete_confirm': {'en': 'Complete', 'it': 'Completa'},
    'workout.completed_saved': {
      'en': 'Workout completed and saved!',
      'it': 'Allenamento completato e salvato!',
    },
    'workout.save_error': {
      'en': 'Error while saving.',
      'it': 'Errore nel salvataggio.',
    },
    'exercise.unknown_error': {
      'en': 'Unknown error',
      'it': 'Errore sconosciuto',
    },
    'exercise.load_failed': {
      'en': 'Unable to load',
      'it': 'Impossibile caricare',
    },
    'exercise.retry': {'en': 'Retry', 'it': 'Riprova'},
    'exercise.fallback_name': {'en': 'Exercise', 'it': 'Esercizio'},
    'exercise.muscles_involved': {
      'en': 'Target muscles',
      'it': 'Muscoli coinvolti',
    },
    'exercise.safety_tips': {
      'en': 'Safety tips',
      'it': 'Consigli di sicurezza',
    },
    'exercise.equipment': {'en': 'Equipment', 'it': 'Attrezzatura'},
    'exercise.variants': {'en': 'Variants', 'it': 'Varianti'},
    'exercise.no_information': {
      'en': 'No information available.',
      'it': 'Nessuna informazione disponibile.',
    },
    'exercise.no_technical_data': {
      'en': 'No technical data available.',
      'it': 'Nessun dato tecnico disponibile.',
    },
    'exercise.required_equipment': {
      'en': 'Required equipment',
      'it': 'Attrezzatura Necessaria',
    },
    'exercise.no_muscle_data': {
      'en': 'No muscle data available.',
      'it': 'Nessun dato muscolare disponibile.',
    },
    'exercise.activation': {
      'en': 'Activation {value}%',
      'it': 'Attivazione {value}%',
    },
    'session.exit_title': {
      'en': 'Exit current session?',
      'it': 'Vuoi uscire dalla sessione?',
    },
    'session.exit_content': {
      'en': 'If you exit now, progress from this session will not be saved.',
      'it':
          'Se esci ora, i progressi della sessione corrente non verranno salvati.',
    },
    'session.stay': {'en': 'Stay in session', 'it': 'Resta nella sessione'},
    'session.exit_without_save': {
      'en': 'Exit without saving',
      'it': 'Esci senza salvare',
    },
    'session.discard_title': {
      'en': 'Finish and discard?',
      'it': 'Terminare e scartare?',
    },
    'session.discard_content': {
      'en': 'All data from this workout will be deleted.',
      'it': 'Tutti i dati di questo allenamento verranno eliminati.',
    },
    'session.discard_confirm': {'en': 'Discard', 'it': 'Scarta'},
    'session.bell_on': {'en': 'Bell enabled', 'it': 'Campanella attiva'},
    'session.bell_off': {'en': 'Bell disabled', 'it': 'Campanella disattivata'},
    'session.stop_timer': {'en': 'Stop timer', 'it': 'Ferma timer'},
    'session.rest_complete_title': {
      'en': 'Rest complete',
      'it': 'Riposo terminato',
    },
    'session.rest_complete_body': {
      'en': 'You are ready for the next set.',
      'it': 'Sei pronto per la prossima serie.',
    },
    'session.continue': {'en': 'Continue', 'it': 'Continua'},
    'session.notes': {'en': 'Workout notes', 'it': 'Note allenamento'},
    'session.history': {'en': 'Workout history', 'it': 'Storico scheda'},
    'session.finish_discard': {
      'en': 'Finish and discard',
      'it': 'Termina e scarta',
    },
    'session.exercise_count': {
      'en': '{count} exercises',
      'it': '{count} esercizi',
    },
    'workout.edit.description': {'en': 'Description', 'it': 'Descrizione'},
    'workout.edit.add_exercise': {
      'en': 'Add Exercise',
      'it': 'Aggiungi Esercizio',
    },
    'workout.edit.no_exercise': {
      'en': 'No exercises',
      'it': 'Nessun esercizio',
    },
    'workout.edit.add_first_exercise': {
      'en': 'Add your first exercise to begin',
      'it': 'Aggiungi il primo esercizio per iniziare',
    },
    'workout.edit.remove_title': {
      'en': 'Remove exercise',
      'it': 'Rimuovi esercizio',
    },
    'workout.edit.remove_content': {
      'en': 'Are you sure you want to remove this exercise?',
      'it': 'Sei sicuro di voler rimuovere questo esercizio?',
    },
    'workout.edit.remove_confirm': {'en': 'Remove', 'it': 'Rimuovi'},
    'workout.edit.variant_title': {
      'en': 'Exercise variants',
      'it': 'Varianti esercizio',
    },
    'workout.edit.saved': {
      'en': 'Workout saved successfully',
      'it': 'Scheda salvata con successo',
    },
    'workout.edit.save_completed': {
      'en': 'Save completed',
      'it': 'Salvataggio completato',
    },
    'workout.edit.save_failed': {
      'en': 'Save failed',
      'it': 'Salvataggio non riuscito',
    },
    'workout.edit.unsaved_title': {
      'en': 'Unsaved changes',
      'it': 'Modifiche non salvate',
    },
    'workout.edit.unsaved_content': {
      'en': 'You have unsaved changes. Exit without saving?',
      'it': 'Hai modifiche non salvate. Vuoi uscire senza salvare?',
    },
    'workout.edit.exit': {'en': 'Exit', 'it': 'Esci'},
    'workout.edit.name_hint': {'en': 'Workout name...', 'it': 'Nome scheda...'},
    'exercise.no_variants': {
      'en': 'No variants available.',
      'it': 'Nessuna variante disponibile.',
    },
    'ai.create_workout': {'en': 'Create Workout', 'it': 'Crea Scheda'},
    'ai.analyze_progress': {
      'en': 'Analyze progress',
      'it': 'Analizza Progressi',
    },
    'ai.goal_tips': {'en': 'Goal tips', 'it': 'Consigli Obiettivi'},
    'ai.greeting': {
      'en':
          'Hi! I am your AI Coach. I can help with workout plans, progress analysis, nutrition tips, and more. How can I help today? 💪',
      'it':
          'Ciao! Sono il tuo AI Coach. Posso aiutarti con schede di allenamento, analisi progressi, consigli nutrizionali e molto altro. Come posso aiutarti oggi? 💪',
    },
    'ai.sample_question': {
      'en': 'I am doing bench press and feel tired. Should I continue?',
      'it': 'Sto facendo la panca piana, mi sento stanco. Devo continuare?',
    },
    'ai.sample_answer': {
      'en':
          'Great question! If you feel normal muscle fatigue, continue. If you feel pain or joint instability, stop. Consider reducing the load by 5-10% in the remaining sets to keep proper form. 🎯',
      'it':
          'Ottima domanda! Se senti fatica muscolare normale, continua pure. Se invece percepisci dolore o instabilità articolare, fermati. Considera di ridurre leggermente il carico del 5-10% nelle serie rimanenti per mantenere la forma corretta. 🎯',
    },
    'workout.empty.create_first': {
      'en': 'Create your\nfirst workout!',
      'it': 'Crea la tua\nprima scheda!',
    },
    'workout.add_notes_hint': {'en': 'Add notes...', 'it': 'Aggiungi note...'},
    'workout.search_exercise_hint': {
      'en': 'Search exercise...',
      'it': 'Cerca esercizio...',
    },
    'workout.no_exercise_found': {
      'en': 'No exercise found',
      'it': 'Nessun esercizio trovato',
    },
    'workout.edit.required_fields': {
      'en': 'Fill all required fields and add at least one exercise',
      'it': 'Compila tutti i campi obbligatori e aggiungi almeno un esercizio',
    },
    'session.saving': {'en': 'Saving...', 'it': 'Salvataggio...'},
    'session.complete': {'en': 'Complete session', 'it': 'Completa sessione'},
    'exercise.info': {'en': 'Exercise info', 'it': 'Info esercizio'},
    'exercise.actions': {'en': 'Exercise actions', 'it': 'Azioni esercizio'},
    'exercise.add_set': {'en': 'Add set', 'it': 'Aggiungi serie'},
    'exercise.detail_info': {
      'en': 'Detailed information about the exercise.',
      'it': "Informazioni dettagliate sull'esercizio.",
    },
    'exercise.technique': {'en': 'Technique', 'it': 'Tecnica'},
    'exercise.video_tutorial': {'en': 'Video tutorial', 'it': 'Video Tutorial'},
    'exercise.full_details': {'en': 'Full details', 'it': 'Dettagli Completi'},
    'workout.empty.subtitle': {
      'en':
          'Design workouts tailored to you.\nStart your fitness journey today.',
      'it':
          'Progetta allenamenti su misura per te.\nInizia il tuo percorso fitness oggi.',
    },
    'workout.empty.start': {'en': "Let's start", 'it': 'Iniziamo'},
    'feedback.offline_connection': {
      'en': 'An internet connection is required to send feedback.',
      'it': 'Per inviare feedback è necessaria una connessione a Internet.',
    },
    'feedback.idea_hint': {
      'en': 'E.g. "I would like to track progress over time..."',
      'it': 'Es. "Vorrei poter vedere i progressi nel tempo..."',
    },
    'feedback.thanks_detail': {
      'en':
          'Your feedback is valuable and helps us build a better app for everyone.',
      'it':
          "Il tuo feedback è prezioso e ci aiuterà a costruire un'app migliore per tutti.",
    },
    'offline.mode': {'en': 'Offline mode', 'it': 'Modalità Offline'},
    'offline.session_expired': {
      'en': 'Session expired. Reconnect to sync.',
      'it': 'Sessione scaduta. Riconnettiti per sincronizzare.',
    },
    'exercise.difficulty': {'en': 'Difficulty', 'it': 'Difficoltà'},
    'exercise.mechanics': {'en': 'Mechanics', 'it': 'Meccanica'},
    'exercise.type': {'en': 'Type', 'it': 'Tipo'},
    'exercise.bodyweight': {'en': 'Bodyweight', 'it': 'Corpo libero'},
    'exercise.muscle': {'en': 'Muscle', 'it': 'Muscolo'},
    'exercise.force_type': {'en': 'Force type', 'it': 'Tipo di forza'},
    'exercise.bodyweight_only': {
      'en': 'Bodyweight only',
      'it': 'Solo corpo libero',
    },
    'exercise.with_equipment': {'en': 'With equipment', 'it': 'Con attrezzi'},
    'exercise.unilateral': {'en': 'Unilateral', 'it': 'Unilaterale'},
    'exercise.clear_filters': {'en': 'Clear filters', 'it': 'Rimuovi filtri'},
    'exercise.difficulty.beginner': {'en': 'Beginner', 'it': 'Principiante'},
    'exercise.difficulty.intermediate': {
      'en': 'Intermediate',
      'it': 'Intermedio',
    },
    'exercise.difficulty.advanced': {'en': 'Advanced', 'it': 'Avanzato'},
    'exercise.mechanics.compound': {'en': 'Compound', 'it': 'Composto'},
    'exercise.mechanics.isolation': {'en': 'Isolation', 'it': 'Isolamento'},
    'exercise.force.push': {'en': 'Push', 'it': 'Spinta'},
    'exercise.force.pull': {'en': 'Pull', 'it': 'Trazione'},
    'exercise.force.legs': {'en': 'Legs', 'it': 'Gambe'},
    'exercise.force.core': {'en': 'Core', 'it': 'Core'},
    'exercise.force.static': {'en': 'Static', 'it': 'Statico'},

    'auth.login.title': {
      'en': 'Sign in with Keycloak',
      'it': 'Accedi con Keycloak',
    },
    'auth.login.description': {
      'en':
          'Sign-in runs in the system browser with Authorization Code Flow and PKCE. The app never handles username or password directly.',
      'it':
          'Il login avviene nel browser di sistema con Authorization Code Flow e PKCE. L app non gestisce direttamente username e password.',
    },
    'auth.login.configuration_hint': {
      'en':
          'If the Keycloak client and redirect URIs are configured correctly, after login you are redirected back to the app automatically.',
      'it':
          'Se il client Keycloak e le redirect URI sono configurati correttamente, dopo il login torni automaticamente nell app.',
    },
    'auth.login.cta': {
      'en': 'Continue with Keycloak',
      'it': 'Continua con Keycloak',
    },

    'ai.header_ready': {
      'en': 'Always ready to help',
      'it': 'Sempre pronto ad aiutarti',
    },
    'ai.plan_week': {'en': 'Plan week', 'it': 'Pianifica settimana'},
    'ai.write_message': {
      'en': 'Write your message...',
      'it': 'Scrivi il tuo messaggio...',
    },
    'ai.loading': {
      'en': 'Loading AI Coach...',
      'it': 'Caricamento AI Coach...',
    },
    'ai.monitor_workout': {
      'en': 'Monitoring your workout',
      'it': 'Monitora il tuo workout',
    },
    'ai.listening': {'en': 'LISTENING...', 'it': 'IN ASCOLTO...'},
    'ai.speak_now': {'en': 'Speak now...', 'it': 'Parla adesso...'},
    'ai.send': {'en': 'Send', 'it': 'Invia'},
    'ai.write_or_speak': {'en': 'Write or speak...', 'it': 'Scrivi o parla...'},
    'ai.live': {'en': 'LIVE', 'it': 'LIVE'},
    'ai.now': {'en': 'now', 'it': 'adesso'},
    'ai.minutes_ago': {'en': '{value}m ago', 'it': '{value}m fa'},
    'ai.context_line': {
      'en': '{exercise} · Set {current}/{total} · {weight} kg · {time}',
      'it': '{exercise} · Set {current}/{total} · {weight} kg · {time}',
    },
    'ai.quick.adjust': {'en': 'ADJUST', 'it': 'AGGIUSTA'},
    'ai.quick.progress': {'en': 'PROGRESS', 'it': 'PROGRESSI'},
    'ai.quick.fatigue': {'en': 'FATIGUE', 'it': 'FATICA'},
    'ai.quick.next': {'en': 'NEXT', 'it': 'PROSSIMO'},
    'ai.quick.nutrition': {'en': 'NUTRITION', 'it': 'NUTRIZIONE'},
    'ai.default_opening': {
      'en':
          'I am ready. Tell me how you feel in this set and I will guide you.',
      'it': 'Sono pronto. Dimmi come ti senti in questo set e ti guido subito.',
    },
    'ai.model_unavailable': {
      'en': 'Model not available now. I will use simplified offline answers.',
      'it':
          'Modello non disponibile ora. Uso risposte locali semplificate offline.',
    },
    'ai.model_loading_retry': {
      'en': 'AI model is still warming up. Retry in a few seconds.',
      'it': 'Il modello AI sta ancora caricando. Riprova tra pochi secondi.',
    },
    'ai.retry_short': {
      'en': 'I did not complete the answer. Try again with a shorter request.',
      'it':
          'Non ho completato la risposta. Riprova con una richiesta piu breve.',
    },
    'ai.json_fallback': {
      'en': 'Rephrase briefly: I can give you a practical tip right now.',
      'it': 'Riformula in breve: posso darti un consiglio pratico adesso.',
    },
    'ai.message_fallback': {
      'en': 'I am tracking in real time: keep control and technical quality.',
      'it': 'Ti seguo in tempo reale: mantieni controllo e qualita tecnica.',
    },
    'ai.context_loading_exercise': {
      'en': 'Loading exercise',
      'it': 'Esercizio in caricamento',
    },
    'ai.prompt.system.en': {
      'en':
          'You are Coachly AI Coach, an on-device fitness assistant.\nYou have real-time workout context.\nAlways reply in JSON with this exact shape:\n{\n  "message": "<conversational reply in English, max 3 sentences>",\n  "insight_card": {\n    "icon": "<emoji>",\n    "label": "<UPPERCASE LABEL, max 3 words>",\n    "body": "<structured data, max 12 words>"\n  } | null\n}\nDo not add anything outside JSON. Do not use markdown.\nBe concise, direct, motivating. You are not a generic chatbot.',
      'it':
          'Sei AI Coach di Coachly, un assistente fitness on-device.\nHai accesso al contesto del workout in tempo reale dell utente.\nRispondi SEMPRE in JSON con questa struttura esatta:\n{\n  "message": "<risposta conversazionale in italiano, max 3 frasi>",\n  "insight_card": {\n    "icon": "<emoji>",\n    "label": "<LABEL IN UPPERCASE, max 3 parole>",\n    "body": "<dato strutturato, max 12 parole>"\n  } | null\n}\nNon aggiungere nulla fuori dal JSON. Non usare markdown.\nSei conciso, diretto, motivante. Non sei un chatbot generico.',
    },
    'ai.prompt.context_title': {
      'en': '[WORKOUT CONTEXT]',
      'it': '[CONTESTO WORKOUT]',
    },
    'ai.prompt.user_title': {
      'en': '[USER MESSAGE]',
      'it': '[MESSAGGIO UTENTE]',
    },
    'ai.prompt.exercise_line': {
      'en': 'Exercise: {name} | Set: {current}/{total}',
      'it': 'Esercizio: {name} | Set: {current}/{total}',
    },
    'ai.prompt.weight_line': {
      'en': 'Weight: {weight}kg x {reps} target reps',
      'it': 'Peso: {weight}kg x {reps} reps target',
    },
    'ai.prompt.fatigue_line': {
      'en': 'Fatigue index: {value}',
      'it': 'Indice fatica: {value}',
    },
    'ai.prompt.recent_weights_line': {
      'en': 'Recent weight history: {value}',
      'it': 'Storico pesi recenti: {value}',
    },
    'ai.prompt.minutes_line': {
      'en': 'Session minutes: {value}',
      'it': 'Minuti sessione: {value}',
    },
    'ai.offline.body': {
      'en': 'Fatigue {value}% on {exercise}',
      'it': 'Fatica {value}% su {exercise}',
    },
    'ai.offline.body_default': {
      'en': 'Keep clean technique and regular recovery',
      'it': 'Mantieni tecnica pulita e recupero regolare',
    },
    'ai.offline.message': {
      'en': 'I read: {message}. Keep controlled pace and stable form now.',
      'it':
          'Ho letto: {message}. Ora mantieni ritmo controllato e forma stabile.',
    },
    'ai.offline.label': {'en': 'QUICK CHECK', 'it': 'CHECK RAPIDO'},
  };

  static Locale normalizeLocale(Locale locale) {
    final languageCode = locale.languageCode.toLowerCase();
    if (languageCode == 'it') {
      return const Locale('it');
    }
    return const Locale('en');
  }

  static String translate(
    String key, {
    required Locale locale,
    Map<String, String> params = const {},
  }) {
    final normalized = normalizeLocale(locale);
    final values = _values[key];
    if (values == null) {
      return key;
    }

    final text =
        values[normalized.languageCode] ??
        values[defaultLocale.languageCode] ??
        values.values.first;

    var resolved = text;
    for (final entry in params.entries) {
      resolved = resolved.replaceAll('{${entry.key}}', entry.value);
    }
    return resolved;
  }

  static String languageDisplayName(
    Locale locale, {
    required Locale displayLocale,
  }) {
    final normalized = normalizeLocale(locale);
    if (normalized.languageCode == 'it') {
      return translate('common.italian', locale: displayLocale);
    }
    return translate('common.english', locale: displayLocale);
  }
}

extension AppStringsBuildContext on BuildContext {
  String tr(String key, {Map<String, String> params = const {}}) {
    final locale =
        Localizations.maybeLocaleOf(this) ?? AppStrings.defaultLocale;
    return AppStrings.translate(key, locale: locale, params: params);
  }
}
