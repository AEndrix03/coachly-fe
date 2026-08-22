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
    'common.back_to_top': {'en': 'Back to top', 'it': 'Torna in alto'},
    'common.confirm': {'en': 'Confirm', 'it': 'Conferma'},
    'common.cancel': {'en': 'Cancel', 'it': 'Annulla'},
    'common.undo': {'en': 'UNDO', 'it': 'ANNULLA'},
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
    'common.got_it': {'en': 'Got it', 'it': 'Ho capito'},
    'common.why_it_matters': {'en': 'Why it matters', 'it': 'Perché conta?'},
    'common.learn_more': {'en': 'Learn more →', 'it': 'Approfondisci →'},

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
    'profile.workout_section': {'en': 'Workout', 'it': 'Allenamento'},
    'profile.personal_exercises': {
      'en': 'Personal Exercises',
      'it': 'Esercizi personali',
    },
    'profile.logout': {'en': 'Logout', 'it': 'Logout'},
    'profile.logout_title': {'en': 'Logout', 'it': 'Logout'},
    'profile.logout_content': {
      'en': 'Are you sure you want to log out?',
      'it': 'Sei sicuro di voler uscire?',
    },
    'profile.logout_confirm': {'en': 'Exit', 'it': 'Esci'},

    'workout.recent': {'en': 'Recent Workouts', 'it': 'Schede Recenti'},
    'workout.resume': {
      'en': 'Pick up where you left off',
      'it': 'Riprendi da dove eri rimasto',
    },
    'workout.all': {'en': 'All Workouts', 'it': 'Tutte le Schede'},
    'workout.my_workouts_count': {
      'en': 'My workouts ({count})',
      'it': 'Le tue schede ({count})',
    },
    'workout.search_hint': {'en': 'Search workouts', 'it': 'Cerca una scheda'},
    'workout.clear_search': {'en': 'Clear search', 'it': 'Cancella ricerca'},
    'workout.no_search_results': {
      'en': 'No workouts match your search.',
      'it': 'Nessuna scheda corrisponde alla ricerca.',
    },
    'workout.sort': {'en': 'Sort workouts', 'it': 'Ordina schede'},
    'workout.sort_recent': {'en': 'Last used', 'it': 'Usate di recente'},
    'workout.sort_name': {'en': 'Name', 'it': 'Nome'},
    'workout.sort_progress': {'en': 'Progress', 'it': 'Progresso'},
    'workout.progress_overview': {
      'en': 'Your progress',
      'it': 'I tuoi progressi',
    },
    'workout.progress_overview_hint': {
      'en': 'A quick view of your training consistency.',
      'it': 'Una panoramica della costanza nei tuoi allenamenti.',
    },
    'workout.actions': {'en': 'Workout actions', 'it': 'Azioni scheda'},
    'workout.no_active': {
      'en':
          'You have no active workouts. Reactivate one from the archive below or create a new one.',
      'it':
          'Non hai schede attive. Riattivane una dall’archivio qui sotto o creane una nuova.',
    },
    'workout.archived_count': {
      'en': 'Archived workouts ({count})',
      'it': 'Schede archiviate ({count})',
    },
    'workout.archived_hint': {
      'en': 'Hidden from your active workout list',
      'it': 'Nascoste dalla lista delle schede attive',
    },
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
    'workout.builder.create_title': {
      'en': 'Create workout',
      'it': 'Crea una scheda',
    },
    'workout.builder.edit_title': {
      'en': 'Edit workout',
      'it': 'Modifica scheda',
    },
    'workout.builder.structure_title': {
      'en': 'Build the structure',
      'it': 'Costruisci la struttura',
    },
    'workout.builder.review_title': {
      'en': 'Review workout',
      'it': 'Rivedi la scheda',
    },
    'workout.builder.identity_heading': {
      'en': 'Let’s build\nyour workout.',
      'it': 'Iniziamo a creare\nla tua scheda.',
    },
    'workout.builder.identity_subtitle': {
      'en': 'Name your workout and choose its main goal.',
      'it': 'Dai un nome alla scheda e scegli il suo obiettivo principale.',
    },
    'workout.builder.title_label': {
      'en': 'Workout name',
      'it': 'Nome della scheda',
    },
    'workout.builder.title_hint': {
      'en': 'Back & Chest',
      'it': 'Schiena & Petto',
    },
    'workout.builder.goal_label': {
      'en': 'Session goal',
      'it': 'Obiettivo della sessione',
    },
    'workout.builder.focus_label': {
      'en': 'Session note',
      'it': 'Nota della sessione',
    },
    'workout.builder.focus_hint': {
      'en': 'What should this session emphasize?',
      'it': 'Dorso e petto con enfasi…',
    },
    'workout.builder.goal_hypertrophy': {
      'en': 'Hypertrophy',
      'it': 'Ipertrofia',
    },
    'workout.builder.goal_strength': {'en': 'Strength', 'it': 'Forza'},
    'workout.builder.goal_general': {'en': 'General', 'it': 'Generale'},
    'workout.builder.goal_hypertrophy_description': {
      'en': 'Muscle growth',
      'it': 'Crescita muscolare',
    },
    'workout.builder.goal_strength_description': {
      'en': 'Performance & load',
      'it': 'Performance e carico',
    },
    'workout.builder.goal_general_description': {
      'en': 'Balanced training',
      'it': 'Allenamento bilanciato',
    },
    'workout.builder.goal_info_tooltip': {
      'en': 'About session goals',
      'it': 'Informazioni sugli obiettivi della sessione',
    },
    'workout.builder.add_session_note': {
      'en': 'Add a session note',
      'it': 'Aggiungi una nota alla sessione',
    },
    'workout.builder.session_note': {
      'en': 'Session note',
      'it': 'Nota della sessione',
    },
    'workout.builder.optional': {'en': 'Optional', 'it': 'Opzionale'},
    'workout.builder.goal_info_title': {
      'en': 'Session context',
      'it': 'Contesto della sessione',
    },
    'workout.builder.goal_info_body': {
      'en':
          'The goal describes the session’s main type of work and helps Coachly present the workout in context.',
      'it':
          'L’obiettivo descrive il tipo principale di lavoro previsto nella sessione e aiuta Coachly a presentare il contesto della scheda.',
    },
    'workout.builder.continue_action': {'en': 'Continue', 'it': 'Continua'},
    'workout.builder.review_action': {
      'en': 'Review workout',
      'it': 'Rivedi la scheda',
    },
    'workout.builder.create_action': {
      'en': 'Create workout',
      'it': 'Crea scheda',
    },
    'workout.builder.untitled': {
      'en': 'Untitled workout',
      'it': 'Scheda senza titolo',
    },
    'workout.builder.empty': {
      'en': 'Add your first exercise to start building the workout.',
      'it': 'Aggiungi il primo esercizio per iniziare a costruire la scheda.',
    },
    'workout.builder.empty_title': {
      'en': 'Build your session',
      'it': 'Costruisci la sessione',
    },
    'workout.builder.empty_body': {
      'en':
          'Start with your first exercise. You can organize it later into sections or blocks.',
      'it':
          'Inizia dal primo esercizio. Potrai organizzarlo in sezioni o blocchi in seguito.',
    },
    'workout.builder.add_first_exercise': {
      'en': 'Add first exercise',
      'it': 'Aggiungi il primo esercizio',
    },
    'workout.builder.add': {'en': 'Add', 'it': 'Aggiungi'},
    'workout.builder.section': {'en': 'Section', 'it': 'Sezione'},
    'workout.builder.block': {'en': 'Block', 'it': 'Blocco'},
    'workout.builder.section_empty': {
      'en': 'Add exercise',
      'it': 'Aggiungi esercizio',
    },
    'workout.builder.position': {
      'en': 'position {position}',
      'it': 'posizione {position}',
    },
    'workout.builder.programming': {
      'en': 'Programming',
      'it': 'Programmazione',
    },
    'workout.builder.rep_range': {
      'en': 'Rep range',
      'it': 'Range di ripetizioni',
    },
    'workout.builder.rest': {'en': 'Rest', 'it': 'Recupero'},
    'workout.builder.target_load_heading': {
      'en': 'TARGET LOAD',
      'it': 'CARICO TARGET',
    },
    'workout.builder.from_history': {
      'en': 'From history',
      'it': 'Dallo storico',
    },
    'workout.builder.intensity': {'en': 'Intensity', 'it': 'Intensità'},
    'workout.builder.progression': {'en': 'Progression', 'it': 'Progressione'},
    'workout.builder.advanced': {'en': 'Advanced', 'it': 'Avanzate'},
    'workout.builder.not_configured': {
      'en': 'Not configured',
      'it': 'Non configurata',
    },
    'workout.builder.manual': {'en': 'Manual', 'it': 'Manuale'},
    'workout.builder.advanced_summary': {
      'en': 'Tempo, set types, notes…',
      'it': 'Tempo, tipi di serie, note…',
    },
    'workout.builder.reps_min': {
      'en': 'Minimum reps',
      'it': 'Ripetizioni minime',
    },
    'workout.builder.reps_max': {
      'en': 'Maximum reps',
      'it': 'Ripetizioni massime',
    },
    'workout.builder.decrease': {
      'en': 'Decrease {label}',
      'it': 'Diminuisci {label}',
    },
    'workout.builder.increase': {
      'en': 'Increase {label}',
      'it': 'Aumenta {label}',
    },
    'workout.builder.add_exercise': {
      'en': 'Add exercise',
      'it': 'Aggiungi esercizio',
    },
    'workout.builder.add_exercise_hint': {
      'en': 'Choose an exercise and configure its working sets.',
      'it': 'Scegli un esercizio e configura le serie di lavoro.',
    },
    'workout.builder.exercise_library_hint': {
      'en': 'Search your exercise library',
      'it': 'Cerca nella libreria esercizi',
    },
    'workout.builder.choose_destination': {
      'en': 'Where should it go?',
      'it': 'Dove vuoi inserirlo?',
    },
    'workout.builder.choose_destination_hint': {
      'en': 'Choose a section. Main is selected by default.',
      'it': 'Scegli una sezione. Principali è quella predefinita.',
    },
    'workout.builder.default_section': {'en': 'Default', 'it': 'Predefinita'},
    'workout.builder.collapse_section': {
      'en': 'Collapse section',
      'it': 'Comprimi sezione',
    },
    'workout.builder.expand_section': {
      'en': 'Expand section',
      'it': 'Espandi sezione',
    },
    'workout.builder.add_exercise_to_section': {
      'en': 'Add exercise to {section}',
      'it': 'Aggiungi esercizio a {section}',
    },
    'workout.builder.section_empty_hint': {
      'en': 'No exercises in this section yet.',
      'it': 'Nessun esercizio in questa sezione.',
    },
    'workout.builder.sections_hint_title': {'en': 'Sections', 'it': 'Sezioni'},
    'workout.builder.sections_hint_body': {
      'en': 'Organize the workout into clear parts.',
      'it': 'Organizza il workout in parti chiare.',
    },
    'workout.builder.blocks_hint_title': {'en': 'Blocks', 'it': 'Blocchi'},
    'workout.builder.blocks_hint_body': {
      'en': 'Connect exercises performed together.',
      'it': 'Collega esercizi eseguiti insieme.',
    },
    'workout.builder.create_superset_short': {
      'en': 'Create a superset →',
      'it': 'Crea un superset →',
    },
    'workout.builder.structure_actions': {
      'en': 'Add to workout structure',
      'it': 'Aggiungi alla struttura del workout',
    },
    'workout.builder.exercise': {'en': 'Exercise', 'it': 'Esercizio'},
    'workout.builder.save_changes': {
      'en': 'Save changes',
      'it': 'Salva modifiche',
    },
    'workout.builder.new_section': {'en': 'New section', 'it': 'Nuova sezione'},
    'workout.builder.edit_section': {
      'en': 'Edit section',
      'it': 'Modifica sezione',
    },
    'workout.builder.section_preparation': {
      'en': 'Preparation',
      'it': 'Preparazione',
    },
    'workout.builder.section_main': {'en': 'Main', 'it': 'Principali'},
    'workout.builder.section_accessories': {
      'en': 'Accessories',
      'it': 'Accessori',
    },
    'workout.builder.section_finisher': {'en': 'Finisher', 'it': 'Finisher'},
    'workout.builder.section_cooldown': {
      'en': 'Cooldown',
      'it': 'Defaticamento',
    },
    'workout.builder.section_explanation': {
      'en': "Organize exercises without changing how they're performed.",
      'it': 'Organizza gli esercizi senza cambiarne l’esecuzione.',
    },
    'workout.builder.customize': {'en': 'Customize', 'it': 'Personalizza'},
    'workout.builder.custom_section_hint': {
      'en': 'Upper body',
      'it': 'Parte superiore',
    },
    'workout.builder.preview': {'en': 'PREVIEW', 'it': 'ANTEPRIMA'},
    'workout.builder.custom_name': {
      'en': 'Custom name',
      'it': 'Nome personalizzato',
    },
    'workout.builder.add_section': {
      'en': 'Add section',
      'it': 'Aggiungi sezione',
    },
    'workout.builder.choose_section_type': {
      'en': 'Choose a type',
      'it': 'Scegli un tipo',
    },
    'workout.builder.open_exercise_details': {
      'en': 'Open {name} details',
      'it': 'Apri i dettagli di {name}',
    },
    'workout.builder.item_actions': {
      'en': 'Exercise actions',
      'it': 'Azioni esercizio',
    },
    'workout.builder.move': {'en': 'Move', 'it': 'Sposta'},
    'workout.builder.move_to_section': {
      'en': 'Move to section',
      'it': 'Sposta nella sezione',
    },
    'workout.builder.main_section': {'en': 'Main', 'it': 'Principale'},
    'workout.builder.more_actions': {
      'en': 'More structure actions',
      'it': 'Altre azioni sulla struttura',
    },
    'workout.builder.create_block': {
      'en': 'Create exercise block',
      'it': 'Crea un blocco di esercizi',
    },
    'workout.builder.create_block_short': {
      'en': 'Create block',
      'it': 'Crea blocco',
    },
    'workout.builder.configure_block': {
      'en': 'Configure exercise block',
      'it': 'Configura il blocco di esercizi',
    },
    'workout.builder.block_edit_explanation': {
      'en': 'Review exercise order and the essential block settings.',
      'it':
          'Rivedi l’ordine degli esercizi e le impostazioni essenziali del blocco.',
    },
    'workout.builder.rest_after_round': {
      'en': 'Rest after round · {duration}',
      'it': 'Recupero dopo il round · {duration}',
    },
    'workout.builder.selected_exercises': {
      'en': 'SELECTED',
      'it': 'SELEZIONATI',
    },
    'workout.builder.between_exercises': {
      'en': 'Between exercises',
      'it': 'Tra gli esercizi',
    },
    'workout.builder.after_each_round': {
      'en': 'After each round',
      'it': 'Dopo ogni round',
    },
    'workout.builder.review_summary': {
      'en': '{exercises} · ~{minutes} min',
      'it': '{exercises} · ~{minutes} min',
    },
    'workout.builder.create_superset': {
      'en': 'Create a superset',
      'it': 'Crea un superset',
    },
    'workout.builder.connect_exercises': {
      'en': 'Connect exercises',
      'it': 'Collega più esercizi',
    },
    'workout.builder.create_block_title': {
      'en': 'Create block',
      'it': 'Crea blocco',
    },
    'workout.builder.create_block_explanation': {
      'en': 'Connect multiple exercises into one group.',
      'it': 'Collega più esercizi in un unico gruppo.',
    },
    'workout.builder.step_type': {'en': 'Type', 'it': 'Tipo'},
    'workout.builder.step_exercises': {'en': 'Exercises', 'it': 'Esercizi'},
    'workout.builder.step_setup': {'en': 'Setup', 'it': 'Setup'},
    'workout.builder.choose_exercises': {
      'en': 'Choose {count} exercises',
      'it': 'Scegli {count} esercizi',
    },
    'workout.builder.select_more_exercises': {
      'en': 'Select {count} more to continue.',
      'it': 'Selezionane ancora {count} per continuare.',
    },
    'workout.builder.add_another_exercise': {
      'en': 'Add another exercise',
      'it': 'Aggiungi un altro esercizio',
    },
    'workout.builder.add_notes': {'en': 'Add notes', 'it': 'Aggiungi note'},
    'workout.builder.notes_title': {'en': 'Notes', 'it': 'Note'},
    'workout.builder.notes_hint': {
      'en': 'Add useful instructions or context…',
      'it': 'Aggiungi istruzioni o informazioni utili…',
    },
    'workout.builder.save_notes': {'en': 'Save notes', 'it': 'Salva note'},
    'workout.builder.workout_actions': {
      'en': 'Workout actions',
      'it': 'Azioni workout',
    },
    'workout.builder.section_actions': {
      'en': 'Section actions',
      'it': 'Azioni sezione',
    },
    'workout.builder.block_setup_title': {
      'en': '{type} setup',
      'it': 'Configura {type}',
    },
    'workout.builder.block_setup_hint': {
      'en': 'Exercises alternate in order before the round rest.',
      'it': 'Gli esercizi si alternano in ordine prima del recupero del round.',
    },
    'workout.builder.create_selected_block': {
      'en': 'Create {type}',
      'it': 'Crea {type}',
    },
    'workout.builder.block_type_superset': {
      'en': '2 exercises · Alternate between two exercises.',
      'it': '2 esercizi · Alterna due esercizi.',
    },
    'workout.builder.block_type_triset': {
      'en': '3 exercises',
      'it': '3 esercizi',
    },
    'workout.builder.block_type_giantSet': {
      'en': '4+ exercises',
      'it': '4+ esercizi',
    },
    'workout.builder.block_type_circuit': {
      'en': '2+ exercises',
      'it': '2+ esercizi',
    },
    'workout.builder.add_block': {'en': 'Add block', 'it': 'Aggiungi blocco'},
    'workout.builder.add_superset': {
      'en': 'Add superset',
      'it': 'Aggiungi superset',
    },
    'workout.builder.learn_structure': {
      'en': 'Learn about structure',
      'it': 'Impara la struttura',
    },
    'workout.builder.organize_title': {
      'en': 'Organize the workout',
      'it': 'Organizzare la scheda',
    },
    'workout.builder.section_info': {
      'en':
          'A section groups exercises to improve readability and does not change how they are performed.',
      'it':
          'Una sezione raggruppa gli esercizi per rendere la scheda più leggibile e non cambia il modo in cui vengono eseguiti.',
    },
    'workout.builder.block_info': {
      'en':
          'A block, such as a superset or circuit, connects exercises and changes their order and recovery.',
      'it':
          'Un blocco, come un superset o un circuito, collega più esercizi e influenza l’ordine e i recuperi durante l’allenamento.',
    },
    'workout.builder.info_title': {
      'en': 'Workout information',
      'it': 'Informazioni scheda',
    },
    'workout.builder.apply': {'en': 'Apply', 'it': 'Applica'},
    'workout.builder.item_removed': {
      'en': 'Item removed',
      'it': 'Elemento rimosso',
    },
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

    'workout.detail.exercises': {'en': 'Exercises', 'it': 'Esercizi'},
    'workout.detail.exercise_count_one': {
      'en': '{count} exercise',
      'it': '{count} esercizio',
    },
    'workout.detail.exercise_count_other': {
      'en': '{count} exercises',
      'it': '{count} esercizi',
    },
    'workout.detail.set_count_one': {
      'en': '{count} working set',
      'it': '{count} serie allenante',
    },
    'workout.detail.set_count_other': {
      'en': '{count} working sets',
      'it': '{count} serie allenanti',
    },
    'workout.detail.estimated_minutes': {
      'en': '~{count} min',
      'it': '~{count} min',
    },
    'workout.detail.overview': {'en': 'Overview', 'it': 'Panoramica'},
    'workout.detail.muscle_focus': {
      'en': 'Muscle focus',
      'it': 'Focus muscolare',
    },
    'workout.detail.equipment': {'en': 'Equipment', 'it': 'Attrezzatura'},
    'workout.detail.working_sets': {
      'en': 'Working sets',
      'it': 'Serie allenanti',
    },
    'workout.detail.working_sets_definition': {
      'en':
          'The prescribed sets that count as the main training work for this exercise.',
      'it':
          'Le serie prescritte che costituiscono il lavoro allenante principale dell’esercizio.',
    },
    'workout.detail.rep_range_definition': {
      'en': 'The target number of repetitions for each working set.',
      'it': 'Il numero di ripetizioni da raggiungere in ogni serie allenante.',
    },
    'workout.detail.recovery_definition': {
      'en': 'The suggested rest before the next working set.',
      'it': 'Il recupero suggerito prima della serie allenante successiva.',
    },
    'workout.detail.goal': {'en': 'Goal', 'it': 'Obiettivo'},
    'workout.detail.show_more': {'en': 'Show more', 'it': 'Mostra altro'},
    'workout.detail.show_less': {'en': 'Show less', 'it': 'Mostra meno'},
    'workout.detail.structure': {'en': 'Structure', 'it': 'Struttura'},
    'workout.detail.rest': {'en': 'Rest', 'it': 'Recupero'},
    'workout.detail.target': {'en': 'Target', 'it': 'Target'},
    'workout.detail.intensity': {'en': 'Intensity', 'it': 'Intensità'},
    'workout.detail.recovery': {'en': 'Recovery', 'it': 'Recupero'},
    'workout.detail.target_load': {'en': 'Target load', 'it': 'Carico target'},
    'workout.detail.notes': {'en': 'Notes', 'it': 'Note'},
    'workout.detail.exercise_detail': {
      'en': 'Exercise details',
      'it': 'Dettaglio esercizio',
    },
    'workout.detail.exercise_unavailable': {
      'en': 'Exercise unavailable',
      'it': 'Esercizio non disponibile',
    },
    'workout.detail.exercise_fallback': {'en': 'Exercise', 'it': 'Esercizio'},
    'workout.detail.exercise_loading': {
      'en': 'Loading exercise',
      'it': 'Caricamento esercizio',
    },
    'workout.detail.open_exercise_semantics': {
      'en': 'Open details for {name}',
      'it': 'Apri il dettaglio di {name}',
    },
    'workout.detail.exercise_semantics_position': {
      'en': 'Exercise {position}',
      'it': 'Esercizio {position}',
    },
    'workout.detail.expand_details': {
      'en': 'Expand details',
      'it': 'Espandi dettagli',
    },
    'workout.detail.collapse_details': {
      'en': 'Collapse details',
      'it': 'Comprimi dettagli',
    },
    'workout.detail.superset': {'en': 'SUPERSET', 'it': 'SUPERSET'},
    'workout.detail.triset': {'en': 'TRISET', 'it': 'TRISET'},
    'workout.detail.giant_set': {'en': 'GIANT SET', 'it': 'GIANT SET'},
    'workout.detail.circuit': {'en': 'CIRCUIT', 'it': 'CIRCUITO'},
    'workout.detail.rounds': {'en': 'rounds', 'it': 'round'},
    'workout.detail.round_count_one': {
      'en': '{count} round',
      'it': '{count} giro',
    },
    'workout.detail.round_count_other': {
      'en': '{count} rounds',
      'it': '{count} giri',
    },
    'workout.detail.rest_after_round': {
      'en': 'Rest after round',
      'it': 'Recupero dopo il round',
    },
    'workout.detail.rest_between_exercises': {
      'en': 'Rest between exercises',
      'it': 'Recupero tra esercizi',
    },
    'workout.detail.expand_group': {
      'en': 'Expand group',
      'it': 'Espandi blocco',
    },
    'workout.detail.collapse_group': {
      'en': 'Collapse group',
      'it': 'Comprimi blocco',
    },
    'workout.detail.explain_concept': {
      'en': 'Explain this concept',
      'it': 'Spiega questo concetto',
    },
    'workout.detail.what_is_it': {'en': 'What it is', 'it': 'Cos’è'},
    'workout.detail.how_to_read': {
      'en': 'How to read it',
      'it': 'Come si legge',
    },
    'workout.detail.superset_definition': {
      'en': 'Two or more exercises performed in sequence before resting.',
      'it': 'Due o più esercizi eseguiti in sequenza prima del recupero.',
    },
    'workout.detail.triset_definition': {
      'en': 'Three exercises performed in sequence before resting.',
      'it': 'Tre esercizi eseguiti in sequenza prima del recupero.',
    },
    'workout.detail.giant_set_definition': {
      'en': 'A longer sequence of exercises performed before resting.',
      'it': 'Una sequenza più lunga di esercizi eseguiti prima del recupero.',
    },
    'workout.detail.circuit_definition': {
      'en': 'A sequence of exercises repeated for the prescribed rounds.',
      'it': 'Una sequenza di esercizi ripetuta per i round prescritti.',
    },
    'workout.detail.no_exercises': {
      'en': 'No exercises',
      'it': 'Nessun esercizio',
    },
    'workout.detail.empty_hint': {
      'en': 'Build this session from the Coachly catalog or your exercises.',
      'it': 'Costruisci la sessione dal catalogo Coachly o dai tuoi esercizi.',
    },
    'workout.detail.add_exercise': {
      'en': 'Add exercise',
      'it': 'Aggiungi esercizio',
    },
    'workout.detail.programming_details': {
      'en': 'Programming details',
      'it': 'Dettagli programmazione',
    },
    'workout.detail.rep_range': {'en': 'Rep range', 'it': 'Range rep'},
    'workout.detail.concepts_used': {
      'en': 'Concepts used in this workout',
      'it': 'Concetti usati in questa scheda',
    },
    'workout.detail.sync_pending': {
      'en': 'Sync pending',
      'it': 'Sync in attesa',
    },
    'workout.detail.edit_session': {
      'en': 'Edit session',
      'it': 'Modifica sessione',
    },
    'workout.detail.done': {'en': 'Done', 'it': 'Fine'},
    'workout.detail.exercise_removed': {
      'en': 'Exercise removed',
      'it': 'Esercizio rimosso',
    },
    'workout.detail.add_section': {
      'en': 'Add section',
      'it': 'Aggiungi sezione',
    },
    'workout.detail.create_group': {
      'en': 'Create superset / circuit',
      'it': 'Crea superset / circuito',
    },
    'workout.detail.section_preparation': {
      'en': 'Preparation',
      'it': 'Preparazione',
    },
    'workout.detail.section_main': {
      'en': 'Main work',
      'it': 'Lavoro principale',
    },
    'workout.detail.section_accessory': {
      'en': 'Accessories',
      'it': 'Accessori',
    },
    'workout.detail.section_custom': {'en': 'Custom', 'it': 'Personalizzata'},
    'workout.detail.section_name': {'en': 'Section name', 'it': 'Nome sezione'},
    'workout.detail.ungroup': {'en': 'Ungroup', 'it': 'Separa gruppo'},
    'workout.detail.edit_exercise': {
      'en': 'Edit exercise',
      'it': 'Modifica esercizio',
    },
    'workout.detail.base': {'en': 'Base', 'it': 'Base'},
    'workout.detail.advanced': {'en': 'Advanced', 'it': 'Avanzate'},
    'workout.detail.set_type': {'en': 'Set type', 'it': 'Tipo serie'},
    'workout.detail.relative_load': {
      'en': 'Reduction from top set (%)',
      'it': 'Riduzione dal top set (%)',
    },
    'workout.detail.unilateral': {'en': 'Unilateral', 'it': 'Unilaterale'},
    'workout.detail.tempo': {'en': 'Tempo', 'it': 'Tempo'},
    'workout.detail.pause_seconds': {
      'en': 'Pause (seconds)',
      'it': 'Pausa (secondi)',
    },
    'workout.detail.exercise_note': {
      'en': 'Exercise note',
      'it': 'Nota esercizio',
    },
    'workout.detail.advanced_progressive': {
      'en':
          'Tempo, pauses, unilateral work, target load and notes remain hidden until needed.',
      'it':
          'Tempo, pause, unilateralità, carico target e note restano nascosti finché non servono.',
    },
    'workout.detail.none': {'en': 'None', 'it': 'Nessuna'},
    'workout.detail.saved_offline': {
      'en': 'Saved offline',
      'it': 'Salvato offline',
    },
    'workout.detail.unsaved_title': {
      'en': 'Unsaved changes',
      'it': 'Modifiche non salvate',
    },
    'workout.detail.unsaved_body': {
      'en': 'Save or discard the changes before leaving edit mode.',
      'it': 'Salva o scarta le modifiche prima di uscire dalla modifica.',
    },
    'workout.detail.continue_editing': {
      'en': 'Continue editing',
      'it': 'Continua a modificare',
    },
    'workout.detail.discard': {'en': 'Discard', 'it': 'Scarta'},
    'workout.detail.save_exit': {'en': 'Save and exit', 'it': 'Salva ed esci'},
    'workout.add_exercise.title': {
      'en': 'Add exercise',
      'it': 'Aggiungi esercizio',
    },
    'workout.add_exercise.search_hint': {
      'en': 'Search exercise, muscle or equipment…',
      'it': 'Cerca esercizio, muscolo o attrezzatura…',
    },
    'workout.add_exercise.all': {'en': 'All', 'it': 'Tutti'},
    'workout.add_exercise.verified': {'en': 'Verified', 'it': 'Verified'},
    'workout.add_exercise.mine': {'en': 'Mine', 'it': 'I miei'},
    'workout.add_exercise.muscle': {'en': 'Muscle', 'it': 'Muscolo'},
    'workout.add_exercise.movement': {'en': 'Movement', 'it': 'Movimento'},
    'workout.add_exercise.equipment': {'en': 'Equipment', 'it': 'Attrezzatura'},
    'workout.add_exercise.tracking': {'en': 'Tracking', 'it': 'Tracking'},
    'workout.add_exercise.recent': {'en': 'Recent', 'it': 'Recenti'},
    'workout.add_exercise.results': {'en': 'Results', 'it': 'Risultati'},
    'workout.add_exercise.no_results': {
      'en': 'No exercises match these filters.',
      'it': 'Nessun esercizio corrisponde ai filtri.',
    },
    'workout.add_exercise.clear_filter': {
      'en': 'Clear filter',
      'it': 'Rimuovi filtro',
    },
    'workout.add_exercise.create_personal': {
      'en': 'Create personal exercise',
      'it': 'Crea esercizio personalizzato',
    },
    'workout.add_exercise.last_configuration': {
      'en': 'Using your last compatible prescription',
      'it': 'Uso dell’ultima prescrizione compatibile',
    },
    'workout.add_exercise.reps_min': {'en': 'Min reps', 'it': 'Rep minime'},
    'workout.add_exercise.reps_max': {'en': 'Max reps', 'it': 'Rep massime'},
    'workout.add_exercise.add_to': {'en': 'Add to', 'it': 'Aggiungi a'},
    'workout.add_exercise.no_section': {
      'en': 'No section',
      'it': 'Nessuna sezione',
    },
    'workout.add_exercise.load_error': {
      'en': 'Unable to load the exercise catalog.',
      'it': 'Impossibile caricare il catalogo esercizi.',
    },
    'workout.detail.concept_rir_definition': {
      'en':
          'Reps in reserve estimates how many repetitions remained before failure.',
      'it':
          'Le ripetizioni in riserva stimano quante ripetizioni restavano prima del cedimento.',
    },
    'workout.detail.concept_rir_example': {
      'en': 'RIR 2 means you could have completed about two more repetitions.',
      'it':
          'RIR 2 significa che avresti potuto eseguire circa altre due ripetizioni.',
    },
    'workout.detail.concept_rpe_definition': {
      'en': 'RPE describes perceived effort on a scale up to 10.',
      'it': 'RPE descrive lo sforzo percepito su una scala fino a 10.',
    },
    'workout.detail.concept_rpe_example': {
      'en': 'RPE 8 is a challenging set with roughly two reps in reserve.',
      'it':
          'RPE 8 è una serie impegnativa con circa due ripetizioni in riserva.',
    },
    'workout.detail.concept_percentage1RM_definition': {
      'en': 'The load is prescribed as a percentage of your one-rep maximum.',
      'it': 'Il carico è prescritto come percentuale del tuo massimale.',
    },
    'workout.detail.concept_percentage1RM_example': {
      'en': '75% 1RM means using three quarters of your estimated maximum.',
      'it': '75% 1RM indica tre quarti del massimale stimato.',
    },
    'workout.detail.concept_superset_definition': {
      'en': 'Exercises performed in sequence before resting.',
      'it': 'Esercizi eseguiti in sequenza prima del recupero.',
    },
    'workout.detail.concept_superset_example': {
      'en': 'A1 is followed by A2, then by the prescribed recovery.',
      'it': 'A1 è seguito da A2 e poi dal recupero prescritto.',
    },
    'workout.detail.concept_circuit_definition': {
      'en': 'A sequence of exercises repeated for multiple rounds.',
      'it': 'Una sequenza di esercizi ripetuta per più round.',
    },
    'workout.detail.concept_circuit_example': {
      'en': 'Complete B1, B2 and B3, rest, then repeat.',
      'it': 'Completa B1, B2 e B3, recupera e ripeti.',
    },
    'workout.detail.concept_topSet_definition': {
      'en': 'The heaviest primary work set for the exercise.',
      'it': 'La serie allenante principale più pesante dell’esercizio.',
    },
    'workout.detail.concept_topSet_example': {
      'en': '1 × 4–6 at RPE 8.',
      'it': '1 × 4–6 a RPE 8.',
    },
    'workout.detail.concept_backoff_definition': {
      'en': 'Follow-up sets performed with less load than the top set.',
      'it': 'Serie successive eseguite con meno carico rispetto al top set.',
    },
    'workout.detail.concept_backoff_example': {
      'en': '3 × 6–8 at 7.5% less than the top set.',
      'it': '3 × 6–8 con il 7,5% in meno del top set.',
    },
    'workout.detail.concept_amrap_definition': {
      'en': 'Perform as many technically sound repetitions as possible.',
      'it': 'Esegui più ripetizioni tecnicamente valide possibili.',
    },
    'workout.detail.concept_amrap_example': {
      'en': 'Stop when another clean repetition is no longer available.',
      'it': 'Fermati quando non è più disponibile un’altra ripetizione pulita.',
    },

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
    'session.voice.title': {'en': 'Voice entry', 'it': 'Inserimento vocale'},
    'session.voice.tooltip': {
      'en': 'Voice bulk entry',
      'it': 'Inserimento massivo vocale',
    },
    'session.voice.listening': {'en': 'Listening...', 'it': 'In ascolto...'},
    'session.voice.tap_stop_hint': {
      'en': 'Speak and press Stop when you are done.',
      'it': 'Parla e premi Stop quando hai finito.',
    },
    'session.voice.live_transcript': {
      'en': 'Live transcript',
      'it': 'Trascrizione live',
    },
    'session.voice.waiting_transcript': {
      'en': 'Waiting for speech...',
      'it': 'In attesa del parlato...',
    },
    'session.voice.stop': {'en': 'Stop', 'it': 'Stop'},
    'session.voice.reactivate_hint': {
      'en': 'Microphone paused unexpectedly. Press Stop and try again.',
      'it': 'Microfono fermato inaspettatamente. Premi Stop e riprova.',
    },
    'session.voice.capture_error': {
      'en': 'Unable to start microphone capture.',
      'it': 'Impossibile avviare la cattura microfono.',
    },
    'session.voice.processing': {
      'en': 'Processing voice input...',
      'it': 'Elaborazione input vocale...',
    },
    'session.voice.no_speech': {
      'en': 'No speech detected. Try again.',
      'it': 'Nessun parlato rilevato. Riprova.',
    },
    'session.voice.no_match': {
      'en': 'No matching exercise found.',
      'it': 'Nessun esercizio corrispondente trovato.',
    },
    'session.voice.no_exercises': {
      'en': 'No exercises available in this session.',
      'it': 'Nessun esercizio disponibile in questa sessione.',
    },
    'session.voice.apply_failed': {
      'en': 'Unable to apply parsed values.',
      'it': 'Impossibile applicare i valori riconosciuti.',
    },
    'session.voice.choose_title': {
      'en': 'Choose the matched exercise',
      'it': 'Scegli l\'esercizio riconosciuto',
    },
    'session.voice.confidence': {'en': 'Confidence', 'it': 'Confidenza'},
    'session.voice.applied': {
      'en': '{exercise}: {sets}x{reps} @ {kg}kg',
      'it': '{exercise}: {sets}x{reps} @ {kg}kg',
    },
    'workout.edit.description': {'en': 'Description', 'it': 'Descrizione'},
    'workout.edit.add_exercise': {
      'en': 'Add Exercise',
      'it': 'Aggiungi Esercizio',
    },
    'workout.edit.exercises_count': {
      'en': 'Exercises ({count})',
      'it': 'Esercizi ({count})',
    },
    'workout.edit.exercises_hint': {
      'en': 'Tap a card to edit it. Drag its number to change the order.',
      'it':
          'Tocca una scheda per modificarla. Trascina il numero per riordinarla.',
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
    'exercise.scope.community': {'en': 'Community', 'it': 'Community'},
    'exercise.scope.default': {'en': 'Default', 'it': 'Default'},
    'exercise.scope.mine': {'en': 'Mine', 'it': 'I miei'},
    'exercise.personal.create': {
      'en': 'Create personal exercise',
      'it': 'Crea esercizio personale',
    },
    'exercise.personal.edit': {
      'en': 'Edit personal exercise',
      'it': 'Modifica esercizio personale',
    },
    'exercise.personal.created': {
      'en': 'Exercise created',
      'it': 'Esercizio creato',
    },
    'exercise.personal.name': {'en': 'Name', 'it': 'Nome'},
    'exercise.personal.description': {'en': 'Description', 'it': 'Descrizione'},
    'exercise.personal.delete': {
      'en': 'Delete exercise',
      'it': 'Elimina esercizio',
    },
    'exercise.personal.delete_confirm': {
      'en': 'Delete this personal exercise?',
      'it': 'Eliminare questo esercizio personale?',
    },
    'exercise.personal.empty': {
      'en': 'No personal exercises yet.',
      'it': 'Nessun esercizio personale.',
    },
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
          'You are Coachly AI Coach, an on-device fitness assistant with real-time workout context.\nReply ONLY with a single valid JSON object. No text before or after. No markdown.\nWhen an insight is useful: {"message":"<reply in English, 1-2 sentences>","insight_card":{"icon":"<emoji>","label":"<UPPERCASE 1-3 WORDS>","body":"<max 12 words>"}}\nWhen no insight is needed: {"message":"<reply in English, 1-2 sentences>","insight_card":null}\nBe concise, direct, motivating.',
      'it':
          'Sei AI Coach di Coachly, assistente fitness on-device con accesso al contesto workout in tempo reale.\nRispondi SOLO con un singolo oggetto JSON valido. Nessun testo prima o dopo. Nessun markdown.\nQuando un insight è utile: {"message":"<risposta in italiano, 1-2 frasi>","insight_card":{"icon":"<emoji>","label":"<UPPERCASE 1-3 PAROLE>","body":"<max 12 parole>"}}\nQuando non serve un insight: {"message":"<risposta in italiano, 1-2 frasi>","insight_card":null}\nSii conciso, diretto, motivante.',
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

    'ai.download.title': {
      'en': 'AI Model Required',
      'it': 'Modello AI Richiesto',
    },
    'ai.download.subtitle': {
      'en': 'Qwen2.5 1.5B · 1.5 GB · runs fully offline',
      'it': 'Qwen2.5 1.5B · 1.5 GB · gira completamente offline',
    },
    'ai.download.description': {
      'en':
          'The AI coach needs to download a model once. After that it runs entirely on your device with no internet required.',
      'it':
          "Il coach AI deve scaricare un modello una volta. Dopodichè gira completamente sul tuo dispositivo senza connessione.",
    },
    'ai.download.button': {'en': 'Download', 'it': 'Scarica'},
    'ai.download.progress': {
      'en': 'Downloading... {progress}%',
      'it': 'Download... {progress}%',
    },
    'ai.download.error': {
      'en': 'Download failed. Tap to retry.',
      'it': 'Download fallito. Tocca per riprovare.',
    },

    // Local AI settings (profile page)
    'settings.local_ai.section': {'en': 'AI Coach', 'it': 'AI Coach'},
    'settings.local_ai.toggle': {
      'en': 'Use local AI',
      'it': 'Usa AI in locale',
    },
    'settings.local_ai.toggle_subtitle': {
      'en': 'Run AI entirely on your device, offline',
      'it': 'Esegui l\'AI interamente sul dispositivo, offline',
    },
    'settings.local_ai.model_quality': {
      'en': 'Model quality',
      'it': 'Qualità modello',
    },
    'settings.local_ai.model_minimal': {'en': 'Minimal', 'it': 'Minima'},
    'settings.local_ai.model_good': {'en': 'Good', 'it': 'Buona'},
    'settings.local_ai.model_best': {'en': 'Best', 'it': 'Ottima'},
    'settings.local_ai.uninstall_all': {
      'en': 'Uninstall downloaded models',
      'it': 'Disinstalla modelli scaricati',
    },
    'settings.local_ai.uninstall_title': {
      'en': 'Uninstall models?',
      'it': 'Disinstallare i modelli?',
    },
    'settings.local_ai.uninstall_body': {
      'en': 'All downloaded AI models will be removed from your device.',
      'it': 'Tutti i modelli AI scaricati verranno rimossi dal dispositivo.',
    },
    'settings.local_ai.uninstall_confirm': {
      'en': 'Uninstall',
      'it': 'Disinstalla',
    },
    'settings.local_ai.enable_title': {
      'en': 'Enable local AI?',
      'it': 'Abilitare AI in locale?',
    },
    'settings.local_ai.storage_info': {
      'en': 'Storage required: {size}',
      'it': 'Spazio archiviazione necessario: {size}',
    },
    'settings.local_ai.no_cost': {
      'en': 'No additional costs',
      'it': 'Nessun costo aggiuntivo',
    },
    'settings.local_ai.modern_device': {
      'en': 'Designed for modern devices',
      'it': 'Pensato per dispositivi moderni',
    },
    'settings.local_ai.can_disable': {
      'en': 'You can disable it at any time',
      'it': 'Puoi disabilitare l\'opzione in qualsiasi momento',
    },
    'settings.local_ai.enable_confirm': {'en': 'Enable', 'it': 'Abilita'},
    'settings.local_ai.hf_token': {
      'en': 'HuggingFace Token (optional)',
      'it': 'Token HuggingFace (opzionale)',
    },
    'settings.local_ai.hf_token_hint': {'en': 'hf_...', 'it': 'hf_...'},
    'settings.local_ai.hf_token_subtitle': {
      'en': 'Required to download gated models from HuggingFace',
      'it': 'Necessario per scaricare i modelli protetti da HuggingFace',
    },

    // AI coach panel — disabled state
    'ai.disabled.title': {
      'en': 'Local AI disabled',
      'it': 'AI locale disabilitata',
    },
    'ai.disabled.subtitle': {
      'en':
          'Enable local AI in your profile settings to use the AI coach during workouts.',
      'it':
          'Abilita l\'AI in locale dalle impostazioni del profilo per usare il coach AI durante l\'allenamento.',
    },

    // AI coach panel — insufficient memory
    'ai.oom.title': {'en': 'Not enough memory', 'it': 'RAM insufficiente'},
    'ai.oom.subtitle': {
      'en':
          'This model is too large for your device\'s available memory. Choose a lighter model in the profile settings.',
      'it':
          'Questo modello è troppo grande per la RAM disponibile sul tuo dispositivo. Scegli un modello meno potente dalle impostazioni del profilo.',
    },
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
