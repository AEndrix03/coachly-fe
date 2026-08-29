import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// Migrated from common.app_name
  ///
  /// In en, this message translates to:
  /// **'Coachly'**
  String get commonAppName;

  /// Migrated from exercise.create.save_failed
  ///
  /// In en, this message translates to:
  /// **'Could not save the exercise'**
  String get exerciseCreateSaveFailed;

  /// Migrated from workout.active.search_exercises
  ///
  /// In en, this message translates to:
  /// **'Search local exercises'**
  String get workoutActiveSearchExercises;

  /// Migrated from workout.active.cluster
  ///
  /// In en, this message translates to:
  /// **'Cluster'**
  String get workoutActiveCluster;

  /// Migrated from workout.active.failure
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get workoutActiveFailure;

  /// Migrated from workout.active.weight
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get workoutActiveWeight;

  /// Migrated from workout.active.reps
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get workoutActiveReps;

  /// Migrated from workout.active.add_title
  ///
  /// In en, this message translates to:
  /// **'Add to workout'**
  String get workoutActiveAddTitle;

  /// Migrated from workout.active.add_subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose what you want to add'**
  String get workoutActiveAddSubtitle;

  /// Migrated from workout.active.add_set
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get workoutActiveAddSet;

  /// Migrated from workout.active.add_set_hint
  ///
  /// In en, this message translates to:
  /// **'Add another set to this exercise'**
  String get workoutActiveAddSetHint;

  /// Migrated from workout.active.add_movement
  ///
  /// In en, this message translates to:
  /// **'Add another movement'**
  String get workoutActiveAddMovement;

  /// Migrated from workout.active.combine_hint
  ///
  /// In en, this message translates to:
  /// **'Combine exercises into a sequence'**
  String get workoutActiveCombineHint;

  /// Migrated from workout.active.note_hint
  ///
  /// In en, this message translates to:
  /// **'Write a note…'**
  String get workoutActiveNoteHint;

  /// Migrated from workout.active.saving
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get workoutActiveSaving;

  /// Migrated from workout.active.saved
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get workoutActiveSaved;

  /// Migrated from workout.active.finish
  ///
  /// In en, this message translates to:
  /// **'Finish workout'**
  String get workoutActiveFinish;

  /// Migrated from exercise.biomechanics.title
  ///
  /// In en, this message translates to:
  /// **'Biomechanics'**
  String get exerciseBiomechanicsTitle;

  /// Migrated from exercise.biomechanics.main_pattern
  ///
  /// In en, this message translates to:
  /// **'Main pattern'**
  String get exerciseBiomechanicsMainPattern;

  /// Migrated from exercise.biomechanics.updating
  ///
  /// In en, this message translates to:
  /// **'Data being updated'**
  String get exerciseBiomechanicsUpdating;

  /// Migrated from exercise.biomechanics.resistance
  ///
  /// In en, this message translates to:
  /// **'External resistance'**
  String get exerciseBiomechanicsResistance;

  /// Migrated from exercise.biomechanics.no_profile
  ///
  /// In en, this message translates to:
  /// **'Profile not available yet'**
  String get exerciseBiomechanicsNoProfile;

  /// Migrated from exercise.biomechanics.how_read
  ///
  /// In en, this message translates to:
  /// **'How Coachly reads this data'**
  String get exerciseBiomechanicsHowRead;

  /// Migrated from exercise.create.hint
  ///
  /// In en, this message translates to:
  /// **'Complete one block at a time: you can always edit the exercise later.'**
  String get exerciseCreateHint;

  /// Migrated from exercise.create.upload_soon
  ///
  /// In en, this message translates to:
  /// **'Upload will be available once media storage is configured.'**
  String get exerciseCreateUploadSoon;

  /// Migrated from exercise.play_media
  ///
  /// In en, this message translates to:
  /// **'Play exercise media'**
  String get exercisePlayMedia;

  /// Migrated from exercise.media_soon
  ///
  /// In en, this message translates to:
  /// **'Media coming soon'**
  String get exerciseMediaSoon;

  /// Migrated from common.information
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get commonInformation;

  /// Migrated from exercise.common_mistakes
  ///
  /// In en, this message translates to:
  /// **'Common mistakes'**
  String get exerciseCommonMistakes;

  /// Migrated from exercise.muscles_primary
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get exerciseMusclesPrimary;

  /// Migrated from exercise.muscles_secondary
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get exerciseMusclesSecondary;

  /// Migrated from exercise.explore_muscles
  ///
  /// In en, this message translates to:
  /// **'Explore muscles'**
  String get exerciseExploreMuscles;

  /// Migrated from exercise.pattern
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get exercisePattern;

  /// Migrated from exercise.stability
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get exerciseStability;

  /// Migrated from exercise.spinal_load
  ///
  /// In en, this message translates to:
  /// **'Spinal load'**
  String get exerciseSpinalLoad;

  /// Migrated from exercise.explore_biomechanics
  ///
  /// In en, this message translates to:
  /// **'Explore biomechanics'**
  String get exerciseExploreBiomechanics;

  /// Migrated from exercise.required
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get exerciseRequired;

  /// Migrated from exercise.remember
  ///
  /// In en, this message translates to:
  /// **'Worth remembering'**
  String get exerciseRemember;

  /// Migrated from common.more_actions
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get commonMoreActions;

  /// Migrated from exercise.muscles.front
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get exerciseMusclesFront;

  /// Migrated from exercise.muscles.back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get exerciseMusclesBack;

  /// Migrated from exercise.muscles.view_mode
  ///
  /// In en, this message translates to:
  /// **'Muscle view mode'**
  String get exerciseMusclesViewMode;

  /// Migrated from exercise.muscles.role_primary
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get exerciseMusclesRolePrimary;

  /// Migrated from exercise.muscles.role_secondary
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get exerciseMusclesRoleSecondary;

  /// Migrated from exercise.muscles.role_stabilizer
  ///
  /// In en, this message translates to:
  /// **'Stabiliser'**
  String get exerciseMusclesRoleStabilizer;

  /// Migrated from exercise.muscles.lengthened
  ///
  /// In en, this message translates to:
  /// **'Lengthened'**
  String get exerciseMusclesLengthened;

  /// Migrated from exercise.muscles.midrange
  ///
  /// In en, this message translates to:
  /// **'Mid ROM'**
  String get exerciseMusclesMidrange;

  /// Migrated from exercise.muscles.mid
  ///
  /// In en, this message translates to:
  /// **'Mid'**
  String get exerciseMusclesMid;

  /// Migrated from exercise.muscles.shortened
  ///
  /// In en, this message translates to:
  /// **'Shortened'**
  String get exerciseMusclesShortened;

  /// Migrated from exercise.muscles.title
  ///
  /// In en, this message translates to:
  /// **'Muscles'**
  String get exerciseMusclesTitle;

  /// Migrated from exercise.variants.title
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get exerciseVariantsTitle;

  /// Migrated from common.loading
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// Migrated from exercise.create.name_required
  ///
  /// In en, this message translates to:
  /// **'At least the Italian name is required.'**
  String get exerciseCreateNameRequired;

  /// Migrated from exercise.create.title
  ///
  /// In en, this message translates to:
  /// **'Create exercise'**
  String get exerciseCreateTitle;

  /// Migrated from common.back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// Migrated from exercise.create.media
  ///
  /// In en, this message translates to:
  /// **'Photos and video'**
  String get exerciseCreateMedia;

  /// Migrated from common.share
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// Migrated from exercise.rom_start
  ///
  /// In en, this message translates to:
  /// **'ROM start'**
  String get exerciseRomStart;

  /// Migrated from exercise.rom_end
  ///
  /// In en, this message translates to:
  /// **'ROM end'**
  String get exerciseRomEnd;

  /// Migrated from exercise.profile_indicative
  ///
  /// In en, this message translates to:
  /// **'Indicative profile'**
  String get exerciseProfileIndicative;

  /// Migrated from exercise.add_to_workout
  ///
  /// In en, this message translates to:
  /// **'Add to workout'**
  String get exerciseAddToWorkout;

  /// Migrated from workout.active.rest_minus_30
  ///
  /// In en, this message translates to:
  /// **'−30 s'**
  String get workoutActiveRestMinus30;

  /// Migrated from workout.active.rest_plus_30
  ///
  /// In en, this message translates to:
  /// **'+30 s'**
  String get workoutActiveRestPlus30;

  /// Migrated from workout.active.col_set
  ///
  /// In en, this message translates to:
  /// **'SET'**
  String get workoutActiveColSet;

  /// Migrated from workout.active.col_previous
  ///
  /// In en, this message translates to:
  /// **'PREVIOUS'**
  String get workoutActiveColPrevious;

  /// Migrated from workout.active.col_reps
  ///
  /// In en, this message translates to:
  /// **'REPS'**
  String get workoutActiveColReps;

  /// Migrated from workout.active.col_rir
  ///
  /// In en, this message translates to:
  /// **'RIR'**
  String get workoutActiveColRir;

  /// Migrated from workout.active.rir_explained
  ///
  /// In en, this message translates to:
  /// **'RIR · Reps in Reserve'**
  String get workoutActiveRirExplained;

  /// Migrated from workout.active.blocks
  ///
  /// In en, this message translates to:
  /// **'BLOCKS'**
  String get workoutActiveBlocks;

  /// Migrated from workout.active.exercises
  ///
  /// In en, this message translates to:
  /// **'EXERCISES'**
  String get workoutActiveExercises;

  /// Migrated from workout.active.add_exercise
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get workoutActiveAddExercise;

  /// Migrated from workout.active.quick_add
  ///
  /// In en, this message translates to:
  /// **'QUICK ADD'**
  String get workoutActiveQuickAdd;

  /// Migrated from workout.active.add_to_group
  ///
  /// In en, this message translates to:
  /// **'Add to current group'**
  String get workoutActiveAddToGroup;

  /// Migrated from workout.active.end_of_workout
  ///
  /// In en, this message translates to:
  /// **'End of workout'**
  String get workoutActiveEndOfWorkout;

  /// Migrated from community.placeholder_title
  ///
  /// In en, this message translates to:
  /// **'Community is on the way'**
  String get communityPlaceholderTitle;

  /// Migrated from community.placeholder_body
  ///
  /// In en, this message translates to:
  /// **'Soon you will be able to follow coaches and share your workouts.'**
  String get communityPlaceholderBody;

  /// Migrated from common.settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// Migrated from common.language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get commonLanguage;

  /// Migrated from common.select_language
  ///
  /// In en, this message translates to:
  /// **'Select a language'**
  String get commonSelectLanguage;

  /// Migrated from common.english
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get commonEnglish;

  /// Migrated from common.italian
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get commonItalian;

  /// Migrated from common.version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get commonVersion;

  /// Migrated from common.build
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get commonBuild;

  /// Migrated from common.error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// Migrated from common.go_back
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get commonGoBack;

  /// Migrated from common.back_to_top
  ///
  /// In en, this message translates to:
  /// **'Back to top'**
  String get commonBackToTop;

  /// Migrated from common.confirm
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// Migrated from common.cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Migrated from common.close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// Migrated from common.retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// Migrated from common.undo
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get commonUndo;

  /// Migrated from common.edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// Migrated from common.duplicate
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get commonDuplicate;

  /// Migrated from common.delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// Migrated from common.activate
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get commonActivate;

  /// Migrated from common.deactivate
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get commonDeactivate;

  /// Migrated from common.workouts
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get commonWorkouts;

  /// Migrated from common.exercises
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get commonExercises;

  /// Migrated from common.workout
  ///
  /// In en, this message translates to:
  /// **'workout'**
  String get commonWorkout;

  /// Migrated from common.days
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get commonDays;

  /// Migrated from common.na
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get commonNa;

  /// Migrated from common.seconds
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get commonSeconds;

  /// Migrated from common.got_it
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get commonGotIt;

  /// Migrated from common.why_it_matters
  ///
  /// In en, this message translates to:
  /// **'Why it matters'**
  String get commonWhyItMatters;

  /// Migrated from common.learn_more
  ///
  /// In en, this message translates to:
  /// **'Learn more →'**
  String get commonLearnMore;

  /// Migrated from nav.community
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunity;

  /// Migrated from nav.workouts
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get navWorkouts;

  /// Migrated from nav.coach
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get navCoach;

  /// Migrated from nav.ideas
  ///
  /// In en, this message translates to:
  /// **'Ideas'**
  String get navIdeas;

  /// Migrated from nav.profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Migrated from profile.profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileProfile;

  /// Migrated from profile.your_profile
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get profileYourProfile;

  /// Migrated from profile.member
  ///
  /// In en, this message translates to:
  /// **'Coachly Member'**
  String get profileMember;

  /// Migrated from profile.preferences
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profilePreferences;

  /// Migrated from profile.app_section
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get profileAppSection;

  /// Migrated from profile.workout_section
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get profileWorkoutSection;

  /// Migrated from profile.personal_exercises
  ///
  /// In en, this message translates to:
  /// **'Personal Exercises'**
  String get profilePersonalExercises;

  /// Migrated from profile.logout
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// Migrated from profile.logout_title
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogoutTitle;

  /// Migrated from profile.logout_content
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get profileLogoutContent;

  /// Migrated from profile.logout_confirm
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get profileLogoutConfirm;

  /// Migrated from profile.logout_pending_title
  ///
  /// In en, this message translates to:
  /// **'Unsynced data'**
  String get profileLogoutPendingTitle;

  /// Migrated from profile.logout_pending_content
  ///
  /// In en, this message translates to:
  /// **'There are {count} changes that have not reached the server yet. Logging out deletes the local database and those changes are lost for good. Reconnect and wait for the sync, or confirm to discard them.'**
  String profileLogoutPendingContent(String count);

  /// Migrated from profile.logout_pending_confirm
  ///
  /// In en, this message translates to:
  /// **'Discard and exit'**
  String get profileLogoutPendingConfirm;

  /// Migrated from workout.recent
  ///
  /// In en, this message translates to:
  /// **'Recent Workouts'**
  String get workoutRecent;

  /// Migrated from workout.resume
  ///
  /// In en, this message translates to:
  /// **'Pick up where you left off'**
  String get workoutResume;

  /// Migrated from workout.all
  ///
  /// In en, this message translates to:
  /// **'All Workouts'**
  String get workoutAll;

  /// Migrated from workout.my_workouts_count
  ///
  /// In en, this message translates to:
  /// **'My workouts ({count})'**
  String workoutMyWorkoutsCount(String count);

  /// Migrated from workout.search_hint
  ///
  /// In en, this message translates to:
  /// **'Search workouts'**
  String get workoutSearchHint;

  /// Migrated from workout.clear_search
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get workoutClearSearch;

  /// Migrated from workout.no_search_results
  ///
  /// In en, this message translates to:
  /// **'No workouts match your search.'**
  String get workoutNoSearchResults;

  /// Migrated from workout.sort
  ///
  /// In en, this message translates to:
  /// **'Sort workouts'**
  String get workoutSort;

  /// Migrated from workout.sort_recent
  ///
  /// In en, this message translates to:
  /// **'Last used'**
  String get workoutSortRecent;

  /// Migrated from workout.sort_name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get workoutSortName;

  /// Migrated from workout.sort_progress
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get workoutSortProgress;

  /// Migrated from workout.progress_overview
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get workoutProgressOverview;

  /// Migrated from workout.progress_overview_hint
  ///
  /// In en, this message translates to:
  /// **'A quick view of your training consistency.'**
  String get workoutProgressOverviewHint;

  /// Migrated from workout.actions
  ///
  /// In en, this message translates to:
  /// **'Workout actions'**
  String get workoutActions;

  /// Migrated from workout.no_active
  ///
  /// In en, this message translates to:
  /// **'You have no active workouts. Reactivate one from the archive below or create a new one.'**
  String get workoutNoActive;

  /// Migrated from workout.archived_count
  ///
  /// In en, this message translates to:
  /// **'Archived workouts ({count})'**
  String workoutArchivedCount(String count);

  /// Migrated from workout.archived_hint
  ///
  /// In en, this message translates to:
  /// **'Hidden from your active workout list'**
  String get workoutArchivedHint;

  /// Migrated from workout.notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get workoutNotifications;

  /// Migrated from workout.notifications_soon
  ///
  /// In en, this message translates to:
  /// **'Notifications feature coming soon'**
  String get workoutNotificationsSoon;

  /// Migrated from workout.description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get workoutDescription;

  /// Migrated from workout.sets
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get workoutSets;

  /// Migrated from workout.reps
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get workoutReps;

  /// Migrated from workout.load
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get workoutLoad;

  /// Migrated from workout.rest
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get workoutRest;

  /// Migrated from workout.start
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get workoutStart;

  /// Migrated from workout.last_used
  ///
  /// In en, this message translates to:
  /// **'Last: {date}'**
  String workoutLastUsed(String date);

  /// Migrated from workout.duration
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get workoutDuration;

  /// Migrated from workout.duration_minutes
  ///
  /// In en, this message translates to:
  /// **'Duration (min)'**
  String get workoutDurationMinutes;

  /// Migrated from workout.focus
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get workoutFocus;

  /// Migrated from workout.type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get workoutType;

  /// Migrated from workout.hypertrophy
  ///
  /// In en, this message translates to:
  /// **'Hypertrophy'**
  String get workoutHypertrophy;

  /// Migrated from workout.builder.create_title
  ///
  /// In en, this message translates to:
  /// **'Create workout'**
  String get workoutBuilderCreateTitle;

  /// Migrated from workout.builder.edit_title
  ///
  /// In en, this message translates to:
  /// **'Edit workout'**
  String get workoutBuilderEditTitle;

  /// Migrated from workout.builder.structure_title
  ///
  /// In en, this message translates to:
  /// **'Build the structure'**
  String get workoutBuilderStructureTitle;

  /// Migrated from workout.builder.review_title
  ///
  /// In en, this message translates to:
  /// **'Review workout'**
  String get workoutBuilderReviewTitle;

  /// Migrated from workout.builder.identity_heading
  ///
  /// In en, this message translates to:
  /// **'Let’s build\nyour workout.'**
  String get workoutBuilderIdentityHeading;

  /// Migrated from workout.builder.identity_subtitle
  ///
  /// In en, this message translates to:
  /// **'Name your workout and choose its main goal.'**
  String get workoutBuilderIdentitySubtitle;

  /// Migrated from workout.builder.title_label
  ///
  /// In en, this message translates to:
  /// **'Workout name'**
  String get workoutBuilderTitleLabel;

  /// Migrated from workout.builder.title_hint
  ///
  /// In en, this message translates to:
  /// **'Back & Chest'**
  String get workoutBuilderTitleHint;

  /// Migrated from workout.builder.goal_label
  ///
  /// In en, this message translates to:
  /// **'Session goal'**
  String get workoutBuilderGoalLabel;

  /// Migrated from workout.builder.focus_label
  ///
  /// In en, this message translates to:
  /// **'Session note'**
  String get workoutBuilderFocusLabel;

  /// Migrated from workout.builder.focus_hint
  ///
  /// In en, this message translates to:
  /// **'What should this session emphasize?'**
  String get workoutBuilderFocusHint;

  /// Migrated from workout.builder.goal_hypertrophy
  ///
  /// In en, this message translates to:
  /// **'Hypertrophy'**
  String get workoutBuilderGoalHypertrophy;

  /// Migrated from workout.builder.goal_strength
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get workoutBuilderGoalStrength;

  /// Migrated from workout.builder.goal_general
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get workoutBuilderGoalGeneral;

  /// Migrated from workout.builder.goal_hypertrophy_description
  ///
  /// In en, this message translates to:
  /// **'Muscle growth'**
  String get workoutBuilderGoalHypertrophyDescription;

  /// Migrated from workout.builder.goal_strength_description
  ///
  /// In en, this message translates to:
  /// **'Performance & load'**
  String get workoutBuilderGoalStrengthDescription;

  /// Migrated from workout.builder.goal_general_description
  ///
  /// In en, this message translates to:
  /// **'Balanced training'**
  String get workoutBuilderGoalGeneralDescription;

  /// Migrated from workout.builder.goal_info_tooltip
  ///
  /// In en, this message translates to:
  /// **'About session goals'**
  String get workoutBuilderGoalInfoTooltip;

  /// Migrated from workout.builder.add_session_note
  ///
  /// In en, this message translates to:
  /// **'Add a session note'**
  String get workoutBuilderAddSessionNote;

  /// Migrated from workout.builder.session_note
  ///
  /// In en, this message translates to:
  /// **'Session note'**
  String get workoutBuilderSessionNote;

  /// Migrated from workout.builder.optional
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get workoutBuilderOptional;

  /// Migrated from workout.builder.goal_info_title
  ///
  /// In en, this message translates to:
  /// **'Session context'**
  String get workoutBuilderGoalInfoTitle;

  /// Migrated from workout.builder.goal_info_body
  ///
  /// In en, this message translates to:
  /// **'The goal describes the session’s main type of work and helps Coachly present the workout in context.'**
  String get workoutBuilderGoalInfoBody;

  /// Migrated from workout.builder.continue_action
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get workoutBuilderContinueAction;

  /// Migrated from workout.builder.review_action
  ///
  /// In en, this message translates to:
  /// **'Review workout'**
  String get workoutBuilderReviewAction;

  /// Migrated from workout.builder.create_action
  ///
  /// In en, this message translates to:
  /// **'Create workout'**
  String get workoutBuilderCreateAction;

  /// Migrated from workout.builder.untitled
  ///
  /// In en, this message translates to:
  /// **'Untitled workout'**
  String get workoutBuilderUntitled;

  /// Migrated from workout.builder.empty
  ///
  /// In en, this message translates to:
  /// **'Add your first exercise to start building the workout.'**
  String get workoutBuilderEmpty;

  /// Migrated from workout.builder.empty_title
  ///
  /// In en, this message translates to:
  /// **'Build your session'**
  String get workoutBuilderEmptyTitle;

  /// Migrated from workout.builder.empty_body
  ///
  /// In en, this message translates to:
  /// **'Start with your first exercise. You can organize it later into sections or blocks.'**
  String get workoutBuilderEmptyBody;

  /// Migrated from workout.builder.add_first_exercise
  ///
  /// In en, this message translates to:
  /// **'Add first exercise'**
  String get workoutBuilderAddFirstExercise;

  /// Migrated from workout.builder.add
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get workoutBuilderAdd;

  /// Migrated from workout.builder.section
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get workoutBuilderSection;

  /// Migrated from workout.builder.block
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get workoutBuilderBlock;

  /// Migrated from workout.builder.section_empty
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get workoutBuilderSectionEmpty;

  /// Migrated from workout.builder.position
  ///
  /// In en, this message translates to:
  /// **'position {position}'**
  String workoutBuilderPosition(String position);

  /// Migrated from workout.builder.programming
  ///
  /// In en, this message translates to:
  /// **'Programming'**
  String get workoutBuilderProgramming;

  /// Migrated from workout.builder.rep_range
  ///
  /// In en, this message translates to:
  /// **'Rep range'**
  String get workoutBuilderRepRange;

  /// Migrated from workout.builder.rest
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get workoutBuilderRest;

  /// Migrated from workout.builder.target_load_heading
  ///
  /// In en, this message translates to:
  /// **'TARGET LOAD'**
  String get workoutBuilderTargetLoadHeading;

  /// Migrated from workout.builder.set_target_load
  ///
  /// In en, this message translates to:
  /// **'Set target load'**
  String get workoutBuilderSetTargetLoad;

  /// Migrated from workout.builder.from_history
  ///
  /// In en, this message translates to:
  /// **'From history'**
  String get workoutBuilderFromHistory;

  /// Migrated from workout.builder.intensity
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get workoutBuilderIntensity;

  /// Migrated from workout.builder.progression
  ///
  /// In en, this message translates to:
  /// **'Progression'**
  String get workoutBuilderProgression;

  /// Migrated from workout.builder.advanced
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get workoutBuilderAdvanced;

  /// Migrated from workout.builder.not_configured
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get workoutBuilderNotConfigured;

  /// Migrated from workout.builder.manual
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get workoutBuilderManual;

  /// Migrated from workout.builder.advanced_summary
  ///
  /// In en, this message translates to:
  /// **'Tempo, set types, notes…'**
  String get workoutBuilderAdvancedSummary;

  /// Migrated from workout.builder.reps_min
  ///
  /// In en, this message translates to:
  /// **'Minimum reps'**
  String get workoutBuilderRepsMin;

  /// Migrated from workout.builder.reps_max
  ///
  /// In en, this message translates to:
  /// **'Maximum reps'**
  String get workoutBuilderRepsMax;

  /// Migrated from workout.builder.decrease
  ///
  /// In en, this message translates to:
  /// **'Decrease {label}'**
  String workoutBuilderDecrease(String label);

  /// Migrated from workout.builder.increase
  ///
  /// In en, this message translates to:
  /// **'Increase {label}'**
  String workoutBuilderIncrease(String label);

  /// Migrated from workout.builder.add_exercise
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get workoutBuilderAddExercise;

  /// Migrated from workout.builder.add_exercise_hint
  ///
  /// In en, this message translates to:
  /// **'Choose an exercise and configure its working sets.'**
  String get workoutBuilderAddExerciseHint;

  /// Migrated from workout.builder.discover
  ///
  /// In en, this message translates to:
  /// **'Discover workout builder'**
  String get workoutBuilderDiscover;

  /// Migrated from workout.builder.tour_step
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String workoutBuilderTourStep(String current, String total);

  /// Migrated from workout.builder.tour_next
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get workoutBuilderTourNext;

  /// Migrated from workout.builder.tour_done
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get workoutBuilderTourDone;

  /// Migrated from workout.builder.tour_dont_show_again
  ///
  /// In en, this message translates to:
  /// **'Don\'\'t show again'**
  String get workoutBuilderTourDontShowAgain;

  /// Migrated from workout.builder.tour_intro_title
  ///
  /// In en, this message translates to:
  /// **'Build it your way'**
  String get workoutBuilderTourIntroTitle;

  /// Migrated from workout.builder.tour_intro_body
  ///
  /// In en, this message translates to:
  /// **'Exercises, sections, blocks and notes. Structure your workout exactly how you want it.'**
  String get workoutBuilderTourIntroBody;

  /// Migrated from workout.builder.tour_exercise_title
  ///
  /// In en, this message translates to:
  /// **'Start with an exercise'**
  String get workoutBuilderTourExerciseTitle;

  /// Migrated from workout.builder.tour_exercise_body
  ///
  /// In en, this message translates to:
  /// **'Choose from the Coachly library or create your own.'**
  String get workoutBuilderTourExerciseBody;

  /// Migrated from workout.builder.tour_sections_title
  ///
  /// In en, this message translates to:
  /// **'Keep things organized'**
  String get workoutBuilderTourSectionsTitle;

  /// Migrated from workout.builder.tour_sections_body
  ///
  /// In en, this message translates to:
  /// **'As your workout grows, split it into sections. Create as many as you need.'**
  String get workoutBuilderTourSectionsBody;

  /// Migrated from workout.builder.tour_notes_title
  ///
  /// In en, this message translates to:
  /// **'Leave context for later'**
  String get workoutBuilderTourNotesTitle;

  /// Migrated from workout.builder.tour_notes_body
  ///
  /// In en, this message translates to:
  /// **'Add notes to any section and update them during the workout.'**
  String get workoutBuilderTourNotesBody;

  /// Migrated from workout.builder.tour_notes_secondary
  ///
  /// In en, this message translates to:
  /// **'Save any useful cues, goals and reminders here.'**
  String get workoutBuilderTourNotesSecondary;

  /// Migrated from workout.builder.tour_blocks_title
  ///
  /// In en, this message translates to:
  /// **'Train exercises together'**
  String get workoutBuilderTourBlocksTitle;

  /// Migrated from workout.builder.tour_blocks_body
  ///
  /// In en, this message translates to:
  /// **'Build supersets, circuits and more by grouping exercises into a block.'**
  String get workoutBuilderTourBlocksBody;

  /// Migrated from workout.builder.tour_blocks_secondary
  ///
  /// In en, this message translates to:
  /// **'Control timing and targets together.'**
  String get workoutBuilderTourBlocksSecondary;

  /// Migrated from workout.builder.tour_check_title
  ///
  /// In en, this message translates to:
  /// **'Check the whole workout'**
  String get workoutBuilderTourCheckTitle;

  /// Migrated from workout.builder.tour_check_body
  ///
  /// In en, this message translates to:
  /// **'See muscle coverage, overlap and structure for your goal.'**
  String get workoutBuilderTourCheckBody;

  /// Migrated from workout.builder.tour_check_secondary
  ///
  /// In en, this message translates to:
  /// **'Coachly explains what stands out. You decide what changes.'**
  String get workoutBuilderTourCheckSecondary;

  /// Migrated from workout.builder.tour_review_title
  ///
  /// In en, this message translates to:
  /// **'Review before you finish'**
  String get workoutBuilderTourReviewTitle;

  /// Migrated from workout.builder.tour_review_body
  ///
  /// In en, this message translates to:
  /// **'Review the complete workout before creating it.'**
  String get workoutBuilderTourReviewBody;

  /// Migrated from workout.builder.tour_replay_hint
  ///
  /// In en, this message translates to:
  /// **'Discover is always here when you need it.'**
  String get workoutBuilderTourReplayHint;

  /// Migrated from workout.check.open
  ///
  /// In en, this message translates to:
  /// **'Check workout'**
  String get workoutCheckOpen;

  /// Migrated from workout.check.title
  ///
  /// In en, this message translates to:
  /// **'Workout Check'**
  String get workoutCheckTitle;

  /// Migrated from workout.check.empty_title
  ///
  /// In en, this message translates to:
  /// **'Your workout is still empty'**
  String get workoutCheckEmptyTitle;

  /// Migrated from workout.check.empty_body
  ///
  /// In en, this message translates to:
  /// **'Add a few exercises and Coachly will start building its analysis.'**
  String get workoutCheckEmptyBody;

  /// Migrated from workout.check.capability_muscles
  ///
  /// In en, this message translates to:
  /// **'Muscle coverage'**
  String get workoutCheckCapabilityMuscles;

  /// Migrated from workout.check.capability_patterns
  ///
  /// In en, this message translates to:
  /// **'Movement patterns'**
  String get workoutCheckCapabilityPatterns;

  /// Migrated from workout.check.capability_overlap
  ///
  /// In en, this message translates to:
  /// **'Exercise overlap'**
  String get workoutCheckCapabilityOverlap;

  /// Migrated from workout.check.capability_structure
  ///
  /// In en, this message translates to:
  /// **'Session structure'**
  String get workoutCheckCapabilityStructure;

  /// Migrated from workout.check.capability_goal
  ///
  /// In en, this message translates to:
  /// **'Goal alignment'**
  String get workoutCheckCapabilityGoal;

  /// Migrated from workout.check.mode_bodybuilding
  ///
  /// In en, this message translates to:
  /// **'BODYBUILDING'**
  String get workoutCheckModeBodybuilding;

  /// Migrated from workout.check.summary
  ///
  /// In en, this message translates to:
  /// **'{passed} checks passed · {review} to review · {missing} need more data'**
  String workoutCheckSummary(String passed, String review, String missing);

  /// Migrated from workout.check.data_partial
  ///
  /// In en, this message translates to:
  /// **'Some exercise metadata is not cached yet. The report only uses data available on this device.'**
  String get workoutCheckDataPartial;

  /// Migrated from workout.check.data_insufficient
  ///
  /// In en, this message translates to:
  /// **'Detailed exercise metadata is not available locally yet. Structure and timing checks remain available.'**
  String get workoutCheckDataInsufficient;

  /// Migrated from workout.check.muscle_coverage
  ///
  /// In en, this message translates to:
  /// **'Muscle coverage'**
  String get workoutCheckMuscleCoverage;

  /// Migrated from workout.check.coverage_title
  ///
  /// In en, this message translates to:
  /// **'Muscle coverage is available'**
  String get workoutCheckCoverageTitle;

  /// Migrated from workout.check.coverage_body
  ///
  /// In en, this message translates to:
  /// **'Coachly found catalogue muscle relations across {muscles} muscle areas. Treat set exposure as an orientation, not an exact physiological measure.'**
  String workoutCheckCoverageBody(String muscles);

  /// Migrated from workout.check.movement_title
  ///
  /// In en, this message translates to:
  /// **'Movement profile'**
  String get workoutCheckMovementTitle;

  /// Migrated from workout.check.movement_body
  ///
  /// In en, this message translates to:
  /// **'{count} locally available movement profiles contribute to this workout.'**
  String workoutCheckMovementBody(String count);

  /// Migrated from workout.check.set_exposure
  ///
  /// In en, this message translates to:
  /// **'{count} set exposure'**
  String workoutCheckSetExposure(String count);

  /// Migrated from workout.check.structure_title
  ///
  /// In en, this message translates to:
  /// **'The workout has a clear structure'**
  String get workoutCheckStructureTitle;

  /// Migrated from workout.check.structure_body
  ///
  /// In en, this message translates to:
  /// **'{sections} populated sections and {blocks} connected blocks organize the session.'**
  String workoutCheckStructureBody(String sections, String blocks);

  /// Migrated from workout.check.duration_title
  ///
  /// In en, this message translates to:
  /// **'Estimated duration · ~{minutes} min'**
  String workoutCheckDurationTitle(String minutes);

  /// Migrated from workout.check.duration_body
  ///
  /// In en, this message translates to:
  /// **'This is an approximate estimate based on working sets and configured rest.'**
  String get workoutCheckDurationBody;

  /// Migrated from workout.check.goal_title
  ///
  /// In en, this message translates to:
  /// **'Goal context is available'**
  String get workoutCheckGoalTitle;

  /// Migrated from workout.check.goal_body
  ///
  /// In en, this message translates to:
  /// **'Coachly evaluates the workout using the selected {goal} goal.'**
  String workoutCheckGoalBody(String goal);

  /// Migrated from workout.check.goal_missing_title
  ///
  /// In en, this message translates to:
  /// **'Goal alignment needs more data'**
  String get workoutCheckGoalMissingTitle;

  /// Migrated from workout.check.goal_missing_body
  ///
  /// In en, this message translates to:
  /// **'Choose a training goal to make this check more specific.'**
  String get workoutCheckGoalMissingBody;

  /// Migrated from workout.check.overlap_title
  ///
  /// In en, this message translates to:
  /// **'Some exercises have similar profiles'**
  String get workoutCheckOverlapTitle;

  /// Migrated from workout.check.overlap_body
  ///
  /// In en, this message translates to:
  /// **'Coachly found a shared movement profile and {count} common muscle relations. Review whether the overlap is intentional.'**
  String workoutCheckOverlapBody(String count);

  /// Migrated from workout.check.overlap_clear_title
  ///
  /// In en, this message translates to:
  /// **'No strong exercise overlap stands out'**
  String get workoutCheckOverlapClearTitle;

  /// Migrated from workout.check.overlap_clear_body
  ///
  /// In en, this message translates to:
  /// **'The locally available profiles do not show an obvious duplicate pattern.'**
  String get workoutCheckOverlapClearBody;

  /// Migrated from workout.check.why
  ///
  /// In en, this message translates to:
  /// **'Why?'**
  String get workoutCheckWhy;

  /// Migrated from workout.check.used_data
  ///
  /// In en, this message translates to:
  /// **'Coachly used:'**
  String get workoutCheckUsedData;

  /// Migrated from workout.check.evidence_sections
  ///
  /// In en, this message translates to:
  /// **'{count} populated sections'**
  String workoutCheckEvidenceSections(String count);

  /// Migrated from workout.check.evidence_blocks
  ///
  /// In en, this message translates to:
  /// **'{count} exercise blocks'**
  String workoutCheckEvidenceBlocks(String count);

  /// Migrated from workout.check.evidence_exercises
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String workoutCheckEvidenceExercises(String count);

  /// Migrated from workout.check.evidence_sets
  ///
  /// In en, this message translates to:
  /// **'{count} working sets'**
  String workoutCheckEvidenceSets(String count);

  /// Migrated from workout.check.evidence_rest
  ///
  /// In en, this message translates to:
  /// **'Configured rest times'**
  String get workoutCheckEvidenceRest;

  /// Migrated from workout.check.evidence_execution
  ///
  /// In en, this message translates to:
  /// **'Approximate execution time'**
  String get workoutCheckEvidenceExecution;

  /// Migrated from workout.check.evidence_goal
  ///
  /// In en, this message translates to:
  /// **'Selected goal: {goal}'**
  String workoutCheckEvidenceGoal(String goal);

  /// Migrated from workout.check.evidence_movement
  ///
  /// In en, this message translates to:
  /// **'Shared movement profile: {movement}'**
  String workoutCheckEvidenceMovement(String movement);

  /// Migrated from workout.check.evidence_muscles
  ///
  /// In en, this message translates to:
  /// **'{count} shared muscle relations'**
  String workoutCheckEvidenceMuscles(String count);

  /// Migrated from workout.check.evidence_peak_muscle
  ///
  /// In en, this message translates to:
  /// **'{muscle}: {count} related working sets'**
  String workoutCheckEvidencePeakMuscle(String muscle, String count);

  /// Migrated from workout.check.evidence_catalogue
  ///
  /// In en, this message translates to:
  /// **'Locally cached catalogue muscle metadata'**
  String get workoutCheckEvidenceCatalogue;

  /// Migrated from workout.check.evidence_pattern
  ///
  /// In en, this message translates to:
  /// **'Movement profile: {pattern}'**
  String workoutCheckEvidencePattern(String pattern);

  /// Migrated from workout.check.unavailable
  ///
  /// In en, this message translates to:
  /// **'Workout Check is temporarily unavailable.'**
  String get workoutCheckUnavailable;

  /// Migrated from workout.builder.exercise_library_hint
  ///
  /// In en, this message translates to:
  /// **'Search your exercise library'**
  String get workoutBuilderExerciseLibraryHint;

  /// Migrated from workout.builder.choose_destination
  ///
  /// In en, this message translates to:
  /// **'Where should it go?'**
  String get workoutBuilderChooseDestination;

  /// Migrated from workout.builder.choose_destination_hint
  ///
  /// In en, this message translates to:
  /// **'Choose a section. Main is selected by default.'**
  String get workoutBuilderChooseDestinationHint;

  /// Migrated from workout.builder.default_section
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get workoutBuilderDefaultSection;

  /// Migrated from workout.builder.collapse_section
  ///
  /// In en, this message translates to:
  /// **'Collapse section'**
  String get workoutBuilderCollapseSection;

  /// Migrated from workout.builder.expand_section
  ///
  /// In en, this message translates to:
  /// **'Expand section'**
  String get workoutBuilderExpandSection;

  /// Migrated from workout.builder.add_exercise_to_section
  ///
  /// In en, this message translates to:
  /// **'Add exercise to {section}'**
  String workoutBuilderAddExerciseToSection(String section);

  /// Migrated from workout.builder.section_empty_hint
  ///
  /// In en, this message translates to:
  /// **'No exercises in this section yet.'**
  String get workoutBuilderSectionEmptyHint;

  /// Migrated from workout.builder.sections_hint_title
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get workoutBuilderSectionsHintTitle;

  /// Migrated from workout.builder.sections_hint_body
  ///
  /// In en, this message translates to:
  /// **'Organize the workout into clear parts.'**
  String get workoutBuilderSectionsHintBody;

  /// Migrated from workout.builder.blocks_hint_title
  ///
  /// In en, this message translates to:
  /// **'Blocks'**
  String get workoutBuilderBlocksHintTitle;

  /// Migrated from workout.builder.blocks_hint_body
  ///
  /// In en, this message translates to:
  /// **'Connect exercises performed together.'**
  String get workoutBuilderBlocksHintBody;

  /// Migrated from workout.builder.create_superset_short
  ///
  /// In en, this message translates to:
  /// **'Create a superset →'**
  String get workoutBuilderCreateSupersetShort;

  /// Migrated from workout.builder.structure_actions
  ///
  /// In en, this message translates to:
  /// **'Add to workout structure'**
  String get workoutBuilderStructureActions;

  /// Migrated from workout.builder.exercise
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get workoutBuilderExercise;

  /// Migrated from workout.builder.save_changes
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get workoutBuilderSaveChanges;

  /// Migrated from workout.builder.new_section
  ///
  /// In en, this message translates to:
  /// **'New section'**
  String get workoutBuilderNewSection;

  /// Migrated from workout.builder.edit_section
  ///
  /// In en, this message translates to:
  /// **'Edit section'**
  String get workoutBuilderEditSection;

  /// Migrated from workout.builder.section_preparation
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get workoutBuilderSectionPreparation;

  /// Migrated from workout.builder.section_main
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get workoutBuilderSectionMain;

  /// Migrated from workout.builder.section_accessories
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get workoutBuilderSectionAccessories;

  /// Migrated from workout.builder.section_finisher
  ///
  /// In en, this message translates to:
  /// **'Finisher'**
  String get workoutBuilderSectionFinisher;

  /// Migrated from workout.builder.section_cooldown
  ///
  /// In en, this message translates to:
  /// **'Cooldown'**
  String get workoutBuilderSectionCooldown;

  /// Migrated from workout.builder.section_explanation
  ///
  /// In en, this message translates to:
  /// **'Organize exercises without changing how they\'\'re performed.'**
  String get workoutBuilderSectionExplanation;

  /// Migrated from workout.builder.customize
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get workoutBuilderCustomize;

  /// Migrated from workout.builder.custom_section_hint
  ///
  /// In en, this message translates to:
  /// **'Upper body'**
  String get workoutBuilderCustomSectionHint;

  /// Migrated from workout.builder.preview
  ///
  /// In en, this message translates to:
  /// **'PREVIEW'**
  String get workoutBuilderPreview;

  /// Migrated from workout.builder.custom_name
  ///
  /// In en, this message translates to:
  /// **'Custom name'**
  String get workoutBuilderCustomName;

  /// Migrated from workout.builder.add_section
  ///
  /// In en, this message translates to:
  /// **'Add section'**
  String get workoutBuilderAddSection;

  /// Migrated from workout.builder.choose_section_type
  ///
  /// In en, this message translates to:
  /// **'Choose a type'**
  String get workoutBuilderChooseSectionType;

  /// Migrated from workout.builder.open_exercise_details
  ///
  /// In en, this message translates to:
  /// **'Open {name} details'**
  String workoutBuilderOpenExerciseDetails(String name);

  /// Migrated from workout.builder.item_actions
  ///
  /// In en, this message translates to:
  /// **'Exercise actions'**
  String get workoutBuilderItemActions;

  /// Migrated from workout.builder.move
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get workoutBuilderMove;

  /// Migrated from workout.builder.move_to_section
  ///
  /// In en, this message translates to:
  /// **'Move to section'**
  String get workoutBuilderMoveToSection;

  /// Migrated from workout.builder.main_section
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get workoutBuilderMainSection;

  /// Migrated from workout.builder.more_actions
  ///
  /// In en, this message translates to:
  /// **'More structure actions'**
  String get workoutBuilderMoreActions;

  /// Migrated from workout.builder.create_block
  ///
  /// In en, this message translates to:
  /// **'Create exercise block'**
  String get workoutBuilderCreateBlock;

  /// Migrated from workout.builder.create_block_short
  ///
  /// In en, this message translates to:
  /// **'Create block'**
  String get workoutBuilderCreateBlockShort;

  /// Migrated from workout.builder.configure_block
  ///
  /// In en, this message translates to:
  /// **'Configure exercise block'**
  String get workoutBuilderConfigureBlock;

  /// Migrated from workout.builder.block_edit_explanation
  ///
  /// In en, this message translates to:
  /// **'Review exercise order and the essential block settings.'**
  String get workoutBuilderBlockEditExplanation;

  /// Migrated from workout.builder.rest_after_round
  ///
  /// In en, this message translates to:
  /// **'Rest after round · {duration}'**
  String workoutBuilderRestAfterRound(String duration);

  /// Migrated from workout.builder.selected_exercises
  ///
  /// In en, this message translates to:
  /// **'SELECTED'**
  String get workoutBuilderSelectedExercises;

  /// Migrated from workout.builder.between_exercises
  ///
  /// In en, this message translates to:
  /// **'Between exercises'**
  String get workoutBuilderBetweenExercises;

  /// Migrated from workout.builder.after_each_round
  ///
  /// In en, this message translates to:
  /// **'After each round'**
  String get workoutBuilderAfterEachRound;

  /// Migrated from workout.builder.review_summary
  ///
  /// In en, this message translates to:
  /// **'{exercises} · ~{minutes} min'**
  String workoutBuilderReviewSummary(String exercises, String minutes);

  /// Migrated from workout.builder.create_superset
  ///
  /// In en, this message translates to:
  /// **'Create a superset'**
  String get workoutBuilderCreateSuperset;

  /// Migrated from workout.builder.connect_exercises
  ///
  /// In en, this message translates to:
  /// **'Connect exercises'**
  String get workoutBuilderConnectExercises;

  /// Migrated from workout.builder.create_block_title
  ///
  /// In en, this message translates to:
  /// **'Create block'**
  String get workoutBuilderCreateBlockTitle;

  /// Migrated from workout.builder.create_block_explanation
  ///
  /// In en, this message translates to:
  /// **'Connect multiple exercises into one group.'**
  String get workoutBuilderCreateBlockExplanation;

  /// Migrated from workout.builder.step_type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get workoutBuilderStepType;

  /// Migrated from workout.builder.step_exercises
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get workoutBuilderStepExercises;

  /// Migrated from workout.builder.step_setup
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get workoutBuilderStepSetup;

  /// Migrated from workout.builder.choose_exercises
  ///
  /// In en, this message translates to:
  /// **'Choose {count} exercises'**
  String workoutBuilderChooseExercises(String count);

  /// Migrated from workout.builder.select_more_exercises
  ///
  /// In en, this message translates to:
  /// **'Select {count} more to continue.'**
  String workoutBuilderSelectMoreExercises(String count);

  /// Migrated from workout.builder.add_another_exercise
  ///
  /// In en, this message translates to:
  /// **'Add another exercise'**
  String get workoutBuilderAddAnotherExercise;

  /// Migrated from workout.builder.add_notes
  ///
  /// In en, this message translates to:
  /// **'Add notes'**
  String get workoutBuilderAddNotes;

  /// Migrated from workout.builder.notes_title
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get workoutBuilderNotesTitle;

  /// Migrated from workout.builder.notes_hint
  ///
  /// In en, this message translates to:
  /// **'Add useful instructions or context…'**
  String get workoutBuilderNotesHint;

  /// Migrated from workout.builder.save_notes
  ///
  /// In en, this message translates to:
  /// **'Save notes'**
  String get workoutBuilderSaveNotes;

  /// Migrated from workout.builder.workout_actions
  ///
  /// In en, this message translates to:
  /// **'Workout actions'**
  String get workoutBuilderWorkoutActions;

  /// Migrated from workout.builder.section_actions
  ///
  /// In en, this message translates to:
  /// **'Section actions'**
  String get workoutBuilderSectionActions;

  /// Migrated from workout.builder.block_setup_title
  ///
  /// In en, this message translates to:
  /// **'{type} setup'**
  String workoutBuilderBlockSetupTitle(String type);

  /// Migrated from workout.builder.block_setup_hint
  ///
  /// In en, this message translates to:
  /// **'Exercises alternate in order before the round rest.'**
  String get workoutBuilderBlockSetupHint;

  /// Migrated from workout.builder.create_selected_block
  ///
  /// In en, this message translates to:
  /// **'Create {type}'**
  String workoutBuilderCreateSelectedBlock(String type);

  /// Migrated from workout.builder.block_type_superset
  ///
  /// In en, this message translates to:
  /// **'2 exercises · Alternate between two exercises.'**
  String get workoutBuilderBlockTypeSuperset;

  /// Migrated from workout.builder.block_type_triset
  ///
  /// In en, this message translates to:
  /// **'3 exercises'**
  String get workoutBuilderBlockTypeTriset;

  /// Migrated from workout.builder.block_type_giantSet
  ///
  /// In en, this message translates to:
  /// **'4+ exercises'**
  String get workoutBuilderBlockTypeGiantSet;

  /// Migrated from workout.builder.block_type_circuit
  ///
  /// In en, this message translates to:
  /// **'2+ exercises'**
  String get workoutBuilderBlockTypeCircuit;

  /// Migrated from workout.builder.add_block
  ///
  /// In en, this message translates to:
  /// **'Add block'**
  String get workoutBuilderAddBlock;

  /// Migrated from workout.builder.add_superset
  ///
  /// In en, this message translates to:
  /// **'Add superset'**
  String get workoutBuilderAddSuperset;

  /// Migrated from workout.builder.learn_structure
  ///
  /// In en, this message translates to:
  /// **'Learn about structure'**
  String get workoutBuilderLearnStructure;

  /// Migrated from workout.builder.organize_title
  ///
  /// In en, this message translates to:
  /// **'Organize the workout'**
  String get workoutBuilderOrganizeTitle;

  /// Migrated from workout.builder.section_info
  ///
  /// In en, this message translates to:
  /// **'A section groups exercises to improve readability and does not change how they are performed.'**
  String get workoutBuilderSectionInfo;

  /// Migrated from workout.builder.block_info
  ///
  /// In en, this message translates to:
  /// **'A block, such as a superset or circuit, connects exercises and changes their order and recovery.'**
  String get workoutBuilderBlockInfo;

  /// Migrated from workout.builder.info_title
  ///
  /// In en, this message translates to:
  /// **'Workout information'**
  String get workoutBuilderInfoTitle;

  /// Migrated from workout.builder.apply
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get workoutBuilderApply;

  /// Migrated from workout.builder.item_removed
  ///
  /// In en, this message translates to:
  /// **'Item removed'**
  String get workoutBuilderItemRemoved;

  /// Migrated from workout.share
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get workoutShare;

  /// Migrated from workout.share_soon
  ///
  /// In en, this message translates to:
  /// **'Workout sharing coming soon'**
  String get workoutShareSoon;

  /// Migrated from workout.header_title
  ///
  /// In en, this message translates to:
  /// **'Your Workouts'**
  String get workoutHeaderTitle;

  /// Migrated from workout.auth_disabled
  ///
  /// In en, this message translates to:
  /// **'Authentication disabled'**
  String get workoutAuthDisabled;

  /// Migrated from workout.auth_disabled_content
  ///
  /// In en, this message translates to:
  /// **'Login, logout, and token management are temporarily disconnected during backend refactoring.'**
  String get workoutAuthDisabledContent;

  /// Migrated from workout.access_disabled
  ///
  /// In en, this message translates to:
  /// **'Access disabled'**
  String get workoutAccessDisabled;

  /// Migrated from workout.week
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get workoutWeek;

  /// Migrated from workout.streak
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get workoutStreak;

  /// Migrated from workout.active_short
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get workoutActiveShort;

  /// Migrated from workout.completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get workoutCompleted;

  /// Migrated from workout.detail.exercises
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get workoutDetailExercises;

  /// Migrated from workout.detail.exercise_count_one
  ///
  /// In en, this message translates to:
  /// **'{count} exercise'**
  String workoutDetailExerciseCountOne(String count);

  /// Migrated from workout.detail.exercise_count_other
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String workoutDetailExerciseCountOther(String count);

  /// Migrated from workout.detail.set_count_one
  ///
  /// In en, this message translates to:
  /// **'{count} working set'**
  String workoutDetailSetCountOne(String count);

  /// Migrated from workout.detail.set_count_other
  ///
  /// In en, this message translates to:
  /// **'{count} working sets'**
  String workoutDetailSetCountOther(String count);

  /// Migrated from workout.detail.estimated_minutes
  ///
  /// In en, this message translates to:
  /// **'~{count} min'**
  String workoutDetailEstimatedMinutes(String count);

  /// Migrated from workout.detail.overview
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get workoutDetailOverview;

  /// Migrated from workout.detail.muscle_focus
  ///
  /// In en, this message translates to:
  /// **'Muscle focus'**
  String get workoutDetailMuscleFocus;

  /// Migrated from workout.detail.equipment
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get workoutDetailEquipment;

  /// Migrated from workout.detail.working_sets
  ///
  /// In en, this message translates to:
  /// **'Working sets'**
  String get workoutDetailWorkingSets;

  /// Migrated from workout.detail.working_sets_definition
  ///
  /// In en, this message translates to:
  /// **'The prescribed sets that count as the main training work for this exercise.'**
  String get workoutDetailWorkingSetsDefinition;

  /// Migrated from workout.detail.rep_range_definition
  ///
  /// In en, this message translates to:
  /// **'The target number of repetitions for each working set.'**
  String get workoutDetailRepRangeDefinition;

  /// Migrated from workout.detail.recovery_definition
  ///
  /// In en, this message translates to:
  /// **'The suggested rest before the next working set.'**
  String get workoutDetailRecoveryDefinition;

  /// Migrated from workout.detail.goal
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get workoutDetailGoal;

  /// Migrated from workout.detail.show_more
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get workoutDetailShowMore;

  /// Migrated from workout.detail.show_less
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get workoutDetailShowLess;

  /// Migrated from workout.detail.structure
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get workoutDetailStructure;

  /// Migrated from workout.detail.rest
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get workoutDetailRest;

  /// Migrated from workout.detail.target
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get workoutDetailTarget;

  /// Migrated from workout.detail.intensity
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get workoutDetailIntensity;

  /// Migrated from workout.detail.recovery
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get workoutDetailRecovery;

  /// Migrated from workout.detail.target_load
  ///
  /// In en, this message translates to:
  /// **'Target load'**
  String get workoutDetailTargetLoad;

  /// Migrated from workout.detail.notes
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get workoutDetailNotes;

  /// Migrated from workout.detail.exercise_detail
  ///
  /// In en, this message translates to:
  /// **'Exercise details'**
  String get workoutDetailExerciseDetail;

  /// Migrated from workout.detail.exercise_unavailable
  ///
  /// In en, this message translates to:
  /// **'Exercise unavailable'**
  String get workoutDetailExerciseUnavailable;

  /// Migrated from workout.detail.exercise_fallback
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get workoutDetailExerciseFallback;

  /// Migrated from workout.detail.exercise_loading
  ///
  /// In en, this message translates to:
  /// **'Loading exercise'**
  String get workoutDetailExerciseLoading;

  /// Migrated from workout.detail.open_exercise_semantics
  ///
  /// In en, this message translates to:
  /// **'Open details for {name}'**
  String workoutDetailOpenExerciseSemantics(String name);

  /// Migrated from workout.detail.exercise_semantics_position
  ///
  /// In en, this message translates to:
  /// **'Exercise {position}'**
  String workoutDetailExerciseSemanticsPosition(String position);

  /// Migrated from workout.detail.expand_details
  ///
  /// In en, this message translates to:
  /// **'Expand details'**
  String get workoutDetailExpandDetails;

  /// Migrated from workout.detail.collapse_details
  ///
  /// In en, this message translates to:
  /// **'Collapse details'**
  String get workoutDetailCollapseDetails;

  /// Migrated from workout.detail.superset
  ///
  /// In en, this message translates to:
  /// **'SUPERSET'**
  String get workoutDetailSuperset;

  /// Migrated from workout.detail.triset
  ///
  /// In en, this message translates to:
  /// **'TRISET'**
  String get workoutDetailTriset;

  /// Migrated from workout.detail.giant_set
  ///
  /// In en, this message translates to:
  /// **'GIANT SET'**
  String get workoutDetailGiantSet;

  /// Migrated from workout.detail.circuit
  ///
  /// In en, this message translates to:
  /// **'CIRCUIT'**
  String get workoutDetailCircuit;

  /// Migrated from workout.detail.rounds
  ///
  /// In en, this message translates to:
  /// **'rounds'**
  String get workoutDetailRounds;

  /// Migrated from workout.detail.round_count_one
  ///
  /// In en, this message translates to:
  /// **'{count} round'**
  String workoutDetailRoundCountOne(String count);

  /// Migrated from workout.detail.round_count_other
  ///
  /// In en, this message translates to:
  /// **'{count} rounds'**
  String workoutDetailRoundCountOther(String count);

  /// Migrated from workout.detail.rest_after_round
  ///
  /// In en, this message translates to:
  /// **'Rest after round'**
  String get workoutDetailRestAfterRound;

  /// Migrated from workout.detail.rest_between_exercises
  ///
  /// In en, this message translates to:
  /// **'Rest between exercises'**
  String get workoutDetailRestBetweenExercises;

  /// Migrated from workout.detail.expand_group
  ///
  /// In en, this message translates to:
  /// **'Expand group'**
  String get workoutDetailExpandGroup;

  /// Migrated from workout.detail.collapse_group
  ///
  /// In en, this message translates to:
  /// **'Collapse group'**
  String get workoutDetailCollapseGroup;

  /// Migrated from workout.detail.explain_concept
  ///
  /// In en, this message translates to:
  /// **'Explain this concept'**
  String get workoutDetailExplainConcept;

  /// Migrated from workout.detail.what_is_it
  ///
  /// In en, this message translates to:
  /// **'What it is'**
  String get workoutDetailWhatIsIt;

  /// Migrated from workout.detail.how_to_read
  ///
  /// In en, this message translates to:
  /// **'How to read it'**
  String get workoutDetailHowToRead;

  /// Migrated from workout.detail.superset_definition
  ///
  /// In en, this message translates to:
  /// **'Two or more exercises performed in sequence before resting.'**
  String get workoutDetailSupersetDefinition;

  /// Migrated from workout.detail.triset_definition
  ///
  /// In en, this message translates to:
  /// **'Three exercises performed in sequence before resting.'**
  String get workoutDetailTrisetDefinition;

  /// Migrated from workout.detail.giant_set_definition
  ///
  /// In en, this message translates to:
  /// **'A longer sequence of exercises performed before resting.'**
  String get workoutDetailGiantSetDefinition;

  /// Migrated from workout.detail.circuit_definition
  ///
  /// In en, this message translates to:
  /// **'A sequence of exercises repeated for the prescribed rounds.'**
  String get workoutDetailCircuitDefinition;

  /// Migrated from workout.detail.no_exercises
  ///
  /// In en, this message translates to:
  /// **'No exercises'**
  String get workoutDetailNoExercises;

  /// Migrated from workout.detail.empty_hint
  ///
  /// In en, this message translates to:
  /// **'Build this session from the Coachly catalog or your exercises.'**
  String get workoutDetailEmptyHint;

  /// Migrated from workout.detail.add_exercise
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get workoutDetailAddExercise;

  /// Migrated from workout.detail.programming_details
  ///
  /// In en, this message translates to:
  /// **'Programming details'**
  String get workoutDetailProgrammingDetails;

  /// Migrated from workout.detail.rep_range
  ///
  /// In en, this message translates to:
  /// **'Rep range'**
  String get workoutDetailRepRange;

  /// Migrated from workout.detail.concepts_used
  ///
  /// In en, this message translates to:
  /// **'Concepts used in this workout'**
  String get workoutDetailConceptsUsed;

  /// Migrated from workout.detail.sync_pending
  ///
  /// In en, this message translates to:
  /// **'Sync pending'**
  String get workoutDetailSyncPending;

  /// Migrated from workout.detail.edit_session
  ///
  /// In en, this message translates to:
  /// **'Edit session'**
  String get workoutDetailEditSession;

  /// Migrated from workout.detail.done
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get workoutDetailDone;

  /// Migrated from workout.detail.exercise_removed
  ///
  /// In en, this message translates to:
  /// **'Exercise removed'**
  String get workoutDetailExerciseRemoved;

  /// Migrated from workout.detail.add_section
  ///
  /// In en, this message translates to:
  /// **'Add section'**
  String get workoutDetailAddSection;

  /// Migrated from workout.detail.create_group
  ///
  /// In en, this message translates to:
  /// **'Create superset / circuit'**
  String get workoutDetailCreateGroup;

  /// Migrated from workout.detail.section_preparation
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get workoutDetailSectionPreparation;

  /// Migrated from workout.detail.section_main
  ///
  /// In en, this message translates to:
  /// **'Main work'**
  String get workoutDetailSectionMain;

  /// Migrated from workout.detail.section_accessory
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get workoutDetailSectionAccessory;

  /// Migrated from workout.detail.section_custom
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get workoutDetailSectionCustom;

  /// Migrated from workout.detail.section_name
  ///
  /// In en, this message translates to:
  /// **'Section name'**
  String get workoutDetailSectionName;

  /// Migrated from workout.detail.ungroup
  ///
  /// In en, this message translates to:
  /// **'Ungroup'**
  String get workoutDetailUngroup;

  /// Migrated from workout.detail.edit_exercise
  ///
  /// In en, this message translates to:
  /// **'Edit exercise'**
  String get workoutDetailEditExercise;

  /// Migrated from workout.detail.base
  ///
  /// In en, this message translates to:
  /// **'Base'**
  String get workoutDetailBase;

  /// Migrated from workout.detail.advanced
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get workoutDetailAdvanced;

  /// Migrated from workout.detail.set_type
  ///
  /// In en, this message translates to:
  /// **'Set type'**
  String get workoutDetailSetType;

  /// Migrated from workout.detail.relative_load
  ///
  /// In en, this message translates to:
  /// **'Reduction from top set (%)'**
  String get workoutDetailRelativeLoad;

  /// Migrated from workout.detail.unilateral
  ///
  /// In en, this message translates to:
  /// **'Unilateral'**
  String get workoutDetailUnilateral;

  /// Migrated from workout.detail.tempo
  ///
  /// In en, this message translates to:
  /// **'Tempo'**
  String get workoutDetailTempo;

  /// Migrated from workout.detail.pause_seconds
  ///
  /// In en, this message translates to:
  /// **'Pause (seconds)'**
  String get workoutDetailPauseSeconds;

  /// Migrated from workout.detail.exercise_note
  ///
  /// In en, this message translates to:
  /// **'Exercise note'**
  String get workoutDetailExerciseNote;

  /// Migrated from workout.detail.advanced_progressive
  ///
  /// In en, this message translates to:
  /// **'Tempo, pauses, unilateral work, target load and notes remain hidden until needed.'**
  String get workoutDetailAdvancedProgressive;

  /// Migrated from workout.detail.none
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get workoutDetailNone;

  /// Migrated from workout.detail.saved_offline
  ///
  /// In en, this message translates to:
  /// **'Saved offline'**
  String get workoutDetailSavedOffline;

  /// Migrated from workout.detail.unsaved_title
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get workoutDetailUnsavedTitle;

  /// Migrated from workout.detail.unsaved_body
  ///
  /// In en, this message translates to:
  /// **'Save or discard the changes before leaving edit mode.'**
  String get workoutDetailUnsavedBody;

  /// Migrated from workout.detail.continue_editing
  ///
  /// In en, this message translates to:
  /// **'Continue editing'**
  String get workoutDetailContinueEditing;

  /// Migrated from workout.detail.discard
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get workoutDetailDiscard;

  /// Migrated from workout.detail.save_exit
  ///
  /// In en, this message translates to:
  /// **'Save and exit'**
  String get workoutDetailSaveExit;

  /// Migrated from workout.add_exercise.title
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get workoutAddExerciseTitle;

  /// Migrated from workout.add_exercise.search_hint
  ///
  /// In en, this message translates to:
  /// **'Search exercise, muscle or equipment…'**
  String get workoutAddExerciseSearchHint;

  /// Migrated from workout.add_exercise.all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get workoutAddExerciseAll;

  /// Migrated from workout.add_exercise.verified
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get workoutAddExerciseVerified;

  /// Migrated from workout.add_exercise.mine
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get workoutAddExerciseMine;

  /// Migrated from workout.add_exercise.muscle
  ///
  /// In en, this message translates to:
  /// **'Muscle'**
  String get workoutAddExerciseMuscle;

  /// Migrated from workout.add_exercise.movement
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get workoutAddExerciseMovement;

  /// Migrated from workout.add_exercise.equipment
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get workoutAddExerciseEquipment;

  /// Migrated from workout.add_exercise.tracking
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get workoutAddExerciseTracking;

  /// Migrated from workout.add_exercise.recent
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get workoutAddExerciseRecent;

  /// Migrated from workout.add_exercise.results
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get workoutAddExerciseResults;

  /// Migrated from workout.add_exercise.no_results
  ///
  /// In en, this message translates to:
  /// **'No exercises match these filters.'**
  String get workoutAddExerciseNoResults;

  /// Migrated from workout.add_exercise.clear_filter
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get workoutAddExerciseClearFilter;

  /// Migrated from workout.add_exercise.create_personal
  ///
  /// In en, this message translates to:
  /// **'Create personal exercise'**
  String get workoutAddExerciseCreatePersonal;

  /// Migrated from workout.add_exercise.last_configuration
  ///
  /// In en, this message translates to:
  /// **'Using your last compatible prescription'**
  String get workoutAddExerciseLastConfiguration;

  /// Migrated from workout.add_exercise.reps_min
  ///
  /// In en, this message translates to:
  /// **'Min reps'**
  String get workoutAddExerciseRepsMin;

  /// Migrated from workout.add_exercise.reps_max
  ///
  /// In en, this message translates to:
  /// **'Max reps'**
  String get workoutAddExerciseRepsMax;

  /// Migrated from workout.add_exercise.add_to
  ///
  /// In en, this message translates to:
  /// **'Add to'**
  String get workoutAddExerciseAddTo;

  /// Migrated from workout.add_exercise.no_section
  ///
  /// In en, this message translates to:
  /// **'No section'**
  String get workoutAddExerciseNoSection;

  /// Migrated from workout.add_exercise.load_error
  ///
  /// In en, this message translates to:
  /// **'Unable to load the exercise catalog.'**
  String get workoutAddExerciseLoadError;

  /// Migrated from workout.detail.concept_rir_definition
  ///
  /// In en, this message translates to:
  /// **'Reps in reserve estimates how many repetitions remained before failure.'**
  String get workoutDetailConceptRirDefinition;

  /// Migrated from workout.detail.concept_rir_example
  ///
  /// In en, this message translates to:
  /// **'RIR 2 means you could have completed about two more repetitions.'**
  String get workoutDetailConceptRirExample;

  /// Migrated from workout.detail.concept_rpe_definition
  ///
  /// In en, this message translates to:
  /// **'RPE describes perceived effort on a scale up to 10.'**
  String get workoutDetailConceptRpeDefinition;

  /// Migrated from workout.detail.concept_rpe_example
  ///
  /// In en, this message translates to:
  /// **'RPE 8 is a challenging set with roughly two reps in reserve.'**
  String get workoutDetailConceptRpeExample;

  /// Migrated from workout.detail.concept_percentage1RM_definition
  ///
  /// In en, this message translates to:
  /// **'The load is prescribed as a percentage of your one-rep maximum.'**
  String get workoutDetailConceptPercentage1RMDefinition;

  /// Migrated from workout.detail.concept_percentage1RM_example
  ///
  /// In en, this message translates to:
  /// **'75% 1RM means using three quarters of your estimated maximum.'**
  String get workoutDetailConceptPercentage1RMExample;

  /// Migrated from workout.detail.concept_superset_definition
  ///
  /// In en, this message translates to:
  /// **'Exercises performed in sequence before resting.'**
  String get workoutDetailConceptSupersetDefinition;

  /// Migrated from workout.detail.concept_superset_example
  ///
  /// In en, this message translates to:
  /// **'A1 is followed by A2, then by the prescribed recovery.'**
  String get workoutDetailConceptSupersetExample;

  /// Migrated from workout.detail.concept_circuit_definition
  ///
  /// In en, this message translates to:
  /// **'A sequence of exercises repeated for multiple rounds.'**
  String get workoutDetailConceptCircuitDefinition;

  /// Migrated from workout.detail.concept_circuit_example
  ///
  /// In en, this message translates to:
  /// **'Complete B1, B2 and B3, rest, then repeat.'**
  String get workoutDetailConceptCircuitExample;

  /// Migrated from workout.detail.concept_topSet_definition
  ///
  /// In en, this message translates to:
  /// **'The heaviest primary work set for the exercise.'**
  String get workoutDetailConceptTopSetDefinition;

  /// Migrated from workout.detail.concept_topSet_example
  ///
  /// In en, this message translates to:
  /// **'1 × 4–6 at RPE 8.'**
  String get workoutDetailConceptTopSetExample;

  /// Migrated from workout.detail.concept_backoff_definition
  ///
  /// In en, this message translates to:
  /// **'Follow-up sets performed with less load than the top set.'**
  String get workoutDetailConceptBackoffDefinition;

  /// Migrated from workout.detail.concept_backoff_example
  ///
  /// In en, this message translates to:
  /// **'3 × 6–8 at 7.5% less than the top set.'**
  String get workoutDetailConceptBackoffExample;

  /// Migrated from workout.detail.concept_amrap_definition
  ///
  /// In en, this message translates to:
  /// **'Perform as many technically sound repetitions as possible.'**
  String get workoutDetailConceptAmrapDefinition;

  /// Migrated from workout.detail.concept_amrap_example
  ///
  /// In en, this message translates to:
  /// **'Stop when another clean repetition is no longer available.'**
  String get workoutDetailConceptAmrapExample;

  /// Migrated from workout.organize.title
  ///
  /// In en, this message translates to:
  /// **'Organize Workouts'**
  String get workoutOrganizeTitle;

  /// Migrated from workout.organize.active
  ///
  /// In en, this message translates to:
  /// **'Active Workouts'**
  String get workoutOrganizeActive;

  /// Migrated from workout.organize.inactive
  ///
  /// In en, this message translates to:
  /// **'Inactive Workouts'**
  String get workoutOrganizeInactive;

  /// Migrated from workout.organize.empty
  ///
  /// In en, this message translates to:
  /// **'No workouts in this category'**
  String get workoutOrganizeEmpty;

  /// Migrated from workout.organize.delete_title
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get workoutOrganizeDeleteTitle;

  /// Migrated from workout.organize.delete_content
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the workout \"{name}\"?'**
  String workoutOrganizeDeleteContent(String name);

  /// Migrated from workout.organize.status_title
  ///
  /// In en, this message translates to:
  /// **'Confirm Status Change'**
  String get workoutOrganizeStatusTitle;

  /// Migrated from workout.organize.status_content
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to {action} the workout \"{name}\"?'**
  String workoutOrganizeStatusContent(String action, String name);

  /// Migrated from workout.organize.action_activate
  ///
  /// In en, this message translates to:
  /// **'activate'**
  String get workoutOrganizeActionActivate;

  /// Migrated from workout.organize.action_deactivate
  ///
  /// In en, this message translates to:
  /// **'deactivate'**
  String get workoutOrganizeActionDeactivate;

  /// Migrated from workout.organize.exercises_count
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String workoutOrganizeExercisesCount(String count);

  /// Migrated from workout.organize.coach
  ///
  /// In en, this message translates to:
  /// **'Coach {name}'**
  String workoutOrganizeCoach(String name);

  /// Migrated from workout.load_error
  ///
  /// In en, this message translates to:
  /// **'Error while loading.'**
  String get workoutLoadError;

  /// Migrated from workout.complete_title
  ///
  /// In en, this message translates to:
  /// **'Complete workout?'**
  String get workoutCompleteTitle;

  /// Migrated from workout.complete_content
  ///
  /// In en, this message translates to:
  /// **'All data will be saved and the session registered.'**
  String get workoutCompleteContent;

  /// Migrated from workout.complete_confirm
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get workoutCompleteConfirm;

  /// Migrated from workout.completed_saved
  ///
  /// In en, this message translates to:
  /// **'Workout completed and saved!'**
  String get workoutCompletedSaved;

  /// Migrated from workout.save_error
  ///
  /// In en, this message translates to:
  /// **'Error while saving.'**
  String get workoutSaveError;

  /// Migrated from exercise.unknown_error
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get exerciseUnknownError;

  /// Migrated from exercise.load_failed
  ///
  /// In en, this message translates to:
  /// **'Unable to load'**
  String get exerciseLoadFailed;

  /// Migrated from exercise.retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get exerciseRetry;

  /// Migrated from exercise.fallback_name
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exerciseFallbackName;

  /// Migrated from exercise.muscles_involved
  ///
  /// In en, this message translates to:
  /// **'Target muscles'**
  String get exerciseMusclesInvolved;

  /// Migrated from exercise.safety_tips
  ///
  /// In en, this message translates to:
  /// **'Safety tips'**
  String get exerciseSafetyTips;

  /// Migrated from exercise.equipment
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get exerciseEquipment;

  /// Migrated from exercise.variants
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get exerciseVariants;

  /// Migrated from exercise.no_information
  ///
  /// In en, this message translates to:
  /// **'No information available.'**
  String get exerciseNoInformation;

  /// Migrated from exercise.no_technical_data
  ///
  /// In en, this message translates to:
  /// **'No technical data available.'**
  String get exerciseNoTechnicalData;

  /// Migrated from exercise.required_equipment
  ///
  /// In en, this message translates to:
  /// **'Required equipment'**
  String get exerciseRequiredEquipment;

  /// Migrated from exercise.no_muscle_data
  ///
  /// In en, this message translates to:
  /// **'No muscle data available.'**
  String get exerciseNoMuscleData;

  /// Migrated from exercise.activation
  ///
  /// In en, this message translates to:
  /// **'Activation {value}%'**
  String exerciseActivation(String value);

  /// Migrated from session.exit_title
  ///
  /// In en, this message translates to:
  /// **'Exit current session?'**
  String get sessionExitTitle;

  /// Migrated from session.exit_content
  ///
  /// In en, this message translates to:
  /// **'If you exit now, progress from this session will not be saved.'**
  String get sessionExitContent;

  /// Migrated from session.stay
  ///
  /// In en, this message translates to:
  /// **'Stay in session'**
  String get sessionStay;

  /// Migrated from session.exit_without_save
  ///
  /// In en, this message translates to:
  /// **'Exit without saving'**
  String get sessionExitWithoutSave;

  /// Migrated from session.discard_title
  ///
  /// In en, this message translates to:
  /// **'Finish and discard?'**
  String get sessionDiscardTitle;

  /// Migrated from session.discard_content
  ///
  /// In en, this message translates to:
  /// **'All data from this workout will be deleted.'**
  String get sessionDiscardContent;

  /// Migrated from session.discard_confirm
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get sessionDiscardConfirm;

  /// Migrated from session.bell_on
  ///
  /// In en, this message translates to:
  /// **'Bell enabled'**
  String get sessionBellOn;

  /// Migrated from session.bell_off
  ///
  /// In en, this message translates to:
  /// **'Bell disabled'**
  String get sessionBellOff;

  /// Migrated from session.stop_timer
  ///
  /// In en, this message translates to:
  /// **'Stop timer'**
  String get sessionStopTimer;

  /// Migrated from session.rest_complete_title
  ///
  /// In en, this message translates to:
  /// **'Rest complete'**
  String get sessionRestCompleteTitle;

  /// Migrated from session.rest_complete_body
  ///
  /// In en, this message translates to:
  /// **'You are ready for the next set.'**
  String get sessionRestCompleteBody;

  /// Migrated from session.continue
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get sessionContinue;

  /// Migrated from session.notes
  ///
  /// In en, this message translates to:
  /// **'Workout notes'**
  String get sessionNotes;

  /// Migrated from session.history
  ///
  /// In en, this message translates to:
  /// **'Workout history'**
  String get sessionHistory;

  /// Migrated from session.finish_discard
  ///
  /// In en, this message translates to:
  /// **'Finish and discard'**
  String get sessionFinishDiscard;

  /// Migrated from session.exercise_count
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String sessionExerciseCount(String count);

  /// Migrated from session.voice.title
  ///
  /// In en, this message translates to:
  /// **'Voice entry'**
  String get sessionVoiceTitle;

  /// Migrated from session.voice.tooltip
  ///
  /// In en, this message translates to:
  /// **'Voice bulk entry'**
  String get sessionVoiceTooltip;

  /// Migrated from session.voice.listening
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get sessionVoiceListening;

  /// Migrated from session.voice.tap_stop_hint
  ///
  /// In en, this message translates to:
  /// **'Speak and press Stop when you are done.'**
  String get sessionVoiceTapStopHint;

  /// Migrated from session.voice.live_transcript
  ///
  /// In en, this message translates to:
  /// **'Live transcript'**
  String get sessionVoiceLiveTranscript;

  /// Migrated from session.voice.waiting_transcript
  ///
  /// In en, this message translates to:
  /// **'Waiting for speech...'**
  String get sessionVoiceWaitingTranscript;

  /// Migrated from session.voice.stop
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get sessionVoiceStop;

  /// Migrated from session.voice.reactivate_hint
  ///
  /// In en, this message translates to:
  /// **'Microphone paused unexpectedly. Press Stop and try again.'**
  String get sessionVoiceReactivateHint;

  /// Migrated from session.voice.capture_error
  ///
  /// In en, this message translates to:
  /// **'Unable to start microphone capture.'**
  String get sessionVoiceCaptureError;

  /// Migrated from session.voice.processing
  ///
  /// In en, this message translates to:
  /// **'Processing voice input...'**
  String get sessionVoiceProcessing;

  /// Migrated from session.voice.no_speech
  ///
  /// In en, this message translates to:
  /// **'No speech detected. Try again.'**
  String get sessionVoiceNoSpeech;

  /// Migrated from session.voice.no_match
  ///
  /// In en, this message translates to:
  /// **'No matching exercise found.'**
  String get sessionVoiceNoMatch;

  /// Migrated from session.voice.no_exercises
  ///
  /// In en, this message translates to:
  /// **'No exercises available in this session.'**
  String get sessionVoiceNoExercises;

  /// Migrated from session.voice.apply_failed
  ///
  /// In en, this message translates to:
  /// **'Unable to apply parsed values.'**
  String get sessionVoiceApplyFailed;

  /// Migrated from session.voice.choose_title
  ///
  /// In en, this message translates to:
  /// **'Choose the matched exercise'**
  String get sessionVoiceChooseTitle;

  /// Migrated from session.voice.confidence
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get sessionVoiceConfidence;

  /// Migrated from session.voice.applied
  ///
  /// In en, this message translates to:
  /// **'{exercise}: {sets}x{reps} @ {kg}kg'**
  String sessionVoiceApplied(
    String exercise,
    String sets,
    String reps,
    String kg,
  );

  /// Migrated from workout.edit.description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get workoutEditDescription;

  /// Migrated from workout.edit.add_exercise
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get workoutEditAddExercise;

  /// Migrated from workout.edit.exercises_count
  ///
  /// In en, this message translates to:
  /// **'Exercises ({count})'**
  String workoutEditExercisesCount(String count);

  /// Migrated from workout.edit.exercises_hint
  ///
  /// In en, this message translates to:
  /// **'Tap a card to edit it. Drag its number to change the order.'**
  String get workoutEditExercisesHint;

  /// Migrated from workout.edit.no_exercise
  ///
  /// In en, this message translates to:
  /// **'No exercises'**
  String get workoutEditNoExercise;

  /// Migrated from workout.edit.add_first_exercise
  ///
  /// In en, this message translates to:
  /// **'Add your first exercise to begin'**
  String get workoutEditAddFirstExercise;

  /// Migrated from workout.edit.remove_title
  ///
  /// In en, this message translates to:
  /// **'Remove exercise'**
  String get workoutEditRemoveTitle;

  /// Migrated from workout.edit.remove_content
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this exercise?'**
  String get workoutEditRemoveContent;

  /// Migrated from workout.edit.remove_confirm
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get workoutEditRemoveConfirm;

  /// Migrated from workout.edit.variant_title
  ///
  /// In en, this message translates to:
  /// **'Exercise variants'**
  String get workoutEditVariantTitle;

  /// Migrated from workout.edit.saved
  ///
  /// In en, this message translates to:
  /// **'Workout saved successfully'**
  String get workoutEditSaved;

  /// Migrated from workout.edit.save_completed
  ///
  /// In en, this message translates to:
  /// **'Save completed'**
  String get workoutEditSaveCompleted;

  /// Migrated from workout.edit.save_failed
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get workoutEditSaveFailed;

  /// Migrated from workout.edit.unsaved_title
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get workoutEditUnsavedTitle;

  /// Migrated from workout.edit.unsaved_content
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Exit without saving?'**
  String get workoutEditUnsavedContent;

  /// Migrated from workout.edit.exit
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get workoutEditExit;

  /// Migrated from workout.edit.name_hint
  ///
  /// In en, this message translates to:
  /// **'Workout name...'**
  String get workoutEditNameHint;

  /// Migrated from exercise.no_variants
  ///
  /// In en, this message translates to:
  /// **'No variants available.'**
  String get exerciseNoVariants;

  /// Migrated from workout.empty.create_first
  ///
  /// In en, this message translates to:
  /// **'Create your\nfirst workout!'**
  String get workoutEmptyCreateFirst;

  /// Migrated from workout.add_notes_hint
  ///
  /// In en, this message translates to:
  /// **'Add notes...'**
  String get workoutAddNotesHint;

  /// Migrated from workout.search_exercise_hint
  ///
  /// In en, this message translates to:
  /// **'Search exercise...'**
  String get workoutSearchExerciseHint;

  /// Migrated from workout.no_exercise_found
  ///
  /// In en, this message translates to:
  /// **'No exercise found'**
  String get workoutNoExerciseFound;

  /// Migrated from workout.edit.required_fields
  ///
  /// In en, this message translates to:
  /// **'Fill all required fields and add at least one exercise'**
  String get workoutEditRequiredFields;

  /// Migrated from session.saving
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get sessionSaving;

  /// Migrated from session.complete
  ///
  /// In en, this message translates to:
  /// **'Complete session'**
  String get sessionComplete;

  /// Migrated from exercise.info
  ///
  /// In en, this message translates to:
  /// **'Exercise info'**
  String get exerciseInfo;

  /// Migrated from exercise.actions
  ///
  /// In en, this message translates to:
  /// **'Exercise actions'**
  String get exerciseActions;

  /// Migrated from exercise.add_set
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get exerciseAddSet;

  /// Migrated from exercise.detail_info
  ///
  /// In en, this message translates to:
  /// **'Detailed information about the exercise.'**
  String get exerciseDetailInfo;

  /// Migrated from exercise.technique
  ///
  /// In en, this message translates to:
  /// **'Technique'**
  String get exerciseTechnique;

  /// Migrated from exercise.video_tutorial
  ///
  /// In en, this message translates to:
  /// **'Video tutorial'**
  String get exerciseVideoTutorial;

  /// Migrated from exercise.full_details
  ///
  /// In en, this message translates to:
  /// **'Full details'**
  String get exerciseFullDetails;

  /// Migrated from workout.empty.subtitle
  ///
  /// In en, this message translates to:
  /// **'Design workouts tailored to you.\nStart your fitness journey today.'**
  String get workoutEmptySubtitle;

  /// Migrated from workout.empty.start
  ///
  /// In en, this message translates to:
  /// **'Let\'\'s start'**
  String get workoutEmptyStart;

  /// Migrated from offline.mode
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get offlineMode;

  /// Migrated from offline.session_expired
  ///
  /// In en, this message translates to:
  /// **'Session expired. Reconnect to sync.'**
  String get offlineSessionExpired;

  /// Migrated from exercise.difficulty
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get exerciseDifficulty;

  /// Migrated from exercise.mechanics
  ///
  /// In en, this message translates to:
  /// **'Mechanics'**
  String get exerciseMechanics;

  /// Migrated from exercise.type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get exerciseType;

  /// Migrated from exercise.bodyweight
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get exerciseBodyweight;

  /// Migrated from exercise.muscle
  ///
  /// In en, this message translates to:
  /// **'Muscle'**
  String get exerciseMuscle;

  /// Migrated from exercise.force_type
  ///
  /// In en, this message translates to:
  /// **'Force type'**
  String get exerciseForceType;

  /// Migrated from exercise.bodyweight_only
  ///
  /// In en, this message translates to:
  /// **'Bodyweight only'**
  String get exerciseBodyweightOnly;

  /// Migrated from exercise.with_equipment
  ///
  /// In en, this message translates to:
  /// **'With equipment'**
  String get exerciseWithEquipment;

  /// Migrated from exercise.unilateral
  ///
  /// In en, this message translates to:
  /// **'Unilateral'**
  String get exerciseUnilateral;

  /// Migrated from exercise.clear_filters
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get exerciseClearFilters;

  /// Migrated from exercise.scope.community
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get exerciseScopeCommunity;

  /// Migrated from exercise.scope.default
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get exerciseScopeDefault;

  /// Migrated from exercise.scope.mine
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get exerciseScopeMine;

  /// Migrated from exercise.personal.create
  ///
  /// In en, this message translates to:
  /// **'Create personal exercise'**
  String get exercisePersonalCreate;

  /// Migrated from exercise.personal.edit
  ///
  /// In en, this message translates to:
  /// **'Edit personal exercise'**
  String get exercisePersonalEdit;

  /// Migrated from exercise.personal.created
  ///
  /// In en, this message translates to:
  /// **'Exercise created'**
  String get exercisePersonalCreated;

  /// Migrated from exercise.personal.name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get exercisePersonalName;

  /// Migrated from exercise.personal.description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get exercisePersonalDescription;

  /// Migrated from exercise.personal.delete
  ///
  /// In en, this message translates to:
  /// **'Delete exercise'**
  String get exercisePersonalDelete;

  /// Migrated from exercise.personal.delete_confirm
  ///
  /// In en, this message translates to:
  /// **'Delete this personal exercise?'**
  String get exercisePersonalDeleteConfirm;

  /// Migrated from exercise.personal.empty
  ///
  /// In en, this message translates to:
  /// **'No personal exercises yet.'**
  String get exercisePersonalEmpty;

  /// Migrated from exercise.difficulty.beginner
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get exerciseDifficultyBeginner;

  /// Migrated from exercise.difficulty.intermediate
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get exerciseDifficultyIntermediate;

  /// Migrated from exercise.difficulty.advanced
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get exerciseDifficultyAdvanced;

  /// Migrated from exercise.mechanics.compound
  ///
  /// In en, this message translates to:
  /// **'Compound'**
  String get exerciseMechanicsCompound;

  /// Migrated from exercise.mechanics.isolation
  ///
  /// In en, this message translates to:
  /// **'Isolation'**
  String get exerciseMechanicsIsolation;

  /// Migrated from exercise.force.push
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get exerciseForcePush;

  /// Migrated from exercise.force.pull
  ///
  /// In en, this message translates to:
  /// **'Pull'**
  String get exerciseForcePull;

  /// Migrated from exercise.force.legs
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get exerciseForceLegs;

  /// Migrated from exercise.force.core
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get exerciseForceCore;

  /// Migrated from exercise.force.static
  ///
  /// In en, this message translates to:
  /// **'Static'**
  String get exerciseForceStatic;

  /// Migrated from auth.login.title
  ///
  /// In en, this message translates to:
  /// **'Sign in with Keycloak'**
  String get authLoginTitle;

  /// Migrated from auth.login.description
  ///
  /// In en, this message translates to:
  /// **'Sign-in runs in the system browser with Authorization Code Flow and PKCE. The app never handles username or password directly.'**
  String get authLoginDescription;

  /// Migrated from auth.login.configuration_hint
  ///
  /// In en, this message translates to:
  /// **'If the Keycloak client and redirect URIs are configured correctly, after login you are redirected back to the app automatically.'**
  String get authLoginConfigurationHint;

  /// Migrated from auth.login.cta
  ///
  /// In en, this message translates to:
  /// **'Continue with Keycloak'**
  String get authLoginCta;

  /// Migrated from home.header.greeting
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String homeHeaderGreeting(String name);

  /// Migrated from home.header.greeting_generic
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get homeHeaderGreetingGeneric;

  /// Migrated from home.header.subtitle
  ///
  /// In en, this message translates to:
  /// **'Ready to train?'**
  String get homeHeaderSubtitle;

  /// Migrated from home.sync.offline
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get homeSyncOffline;

  /// Migrated from home.sync.syncing
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get homeSyncSyncing;

  /// Migrated from home.today.title
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeTodayTitle;

  /// Migrated from home.today.in_progress
  ///
  /// In en, this message translates to:
  /// **'Workout in progress'**
  String get homeTodayInProgress;

  /// Migrated from home.today.planned_break
  ///
  /// In en, this message translates to:
  /// **'Planned break'**
  String get homeTodayPlannedBreak;

  /// Migrated from home.today.program_paused
  ///
  /// In en, this message translates to:
  /// **'Programming paused'**
  String get homeTodayProgramPaused;

  /// Migrated from home.today.recovery_day
  ///
  /// In en, this message translates to:
  /// **'Recovery day'**
  String get homeTodayRecoveryDay;

  /// Migrated from home.today.start_workout
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get homeTodayStartWorkout;

  /// Migrated from home.today.resume_workout
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get homeTodayResumeWorkout;

  /// Migrated from home.today.training_metadata
  ///
  /// In en, this message translates to:
  /// **'~{minutes} min · {sets} working sets'**
  String homeTodayTrainingMetadata(String minutes, String sets);

  /// Migrated from home.today.progress_metadata
  ///
  /// In en, this message translates to:
  /// **'{minutes} min · {done} / {total} exercises'**
  String homeTodayProgressMetadata(String minutes, String done, String total);

  /// Migrated from home.today.next_session
  ///
  /// In en, this message translates to:
  /// **'Next session: {workout} · {date}'**
  String homeTodayNextSession(String workout, String date);

  /// Migrated from home.empty.title
  ///
  /// In en, this message translates to:
  /// **'Start training with Coachly'**
  String get homeEmptyTitle;

  /// Migrated from home.empty.body
  ///
  /// In en, this message translates to:
  /// **'Create a routine, build a program, or record a free workout.'**
  String get homeEmptyBody;

  /// Migrated from home.cycle.position
  ///
  /// In en, this message translates to:
  /// **'Cycle {position} of {length}'**
  String homeCyclePosition(String position, String length);

  /// Migrated from home.cycle.semantics
  ///
  /// In en, this message translates to:
  /// **'Cycle {position} of {length}, {percent}% complete'**
  String homeCycleSemantics(String position, String length, String percent);

  /// Migrated from home.calendar.title
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get homeCalendarTitle;

  /// Migrated from home.calendar.next
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get homeCalendarNext;

  /// Migrated from home.calendar.today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeCalendarToday;

  /// Migrated from home.calendar.cycle
  ///
  /// In en, this message translates to:
  /// **'Day {position} of a {length}-day cycle'**
  String homeCalendarCycle(String position, String length);

  /// Migrated from home.goal.title
  ///
  /// In en, this message translates to:
  /// **'Main goal'**
  String get homeGoalTitle;

  /// Migrated from home.goal.baseline
  ///
  /// In en, this message translates to:
  /// **'Building your baseline'**
  String get homeGoalBaseline;

  /// Migrated from home.goal.empty_title
  ///
  /// In en, this message translates to:
  /// **'Set your first goal'**
  String get homeGoalEmptyTitle;

  /// Migrated from home.goal.empty_body
  ///
  /// In en, this message translates to:
  /// **'Your next concrete milestone will appear here.'**
  String get homeGoalEmptyBody;

  /// Migrated from home.insights.title
  ///
  /// In en, this message translates to:
  /// **'Coachly Insights'**
  String get homeInsightsTitle;

  /// Migrated from home.insights.learning_title
  ///
  /// In en, this message translates to:
  /// **'Coachly is learning from your training'**
  String get homeInsightsLearningTitle;

  /// Migrated from home.insights.learning_body
  ///
  /// In en, this message translates to:
  /// **'Complete a few sessions to receive personalized guidance.'**
  String get homeInsightsLearningBody;

  /// Migrated from home.insight.progression_title
  ///
  /// In en, this message translates to:
  /// **'Ready to progress'**
  String get homeInsightProgressionTitle;

  /// Migrated from home.insight.progression_body
  ///
  /// In en, this message translates to:
  /// **'One of your routines is close to its progression target.'**
  String get homeInsightProgressionBody;

  /// Migrated from home.insight.progression_specific
  ///
  /// In en, this message translates to:
  /// **'You are close to the progression target. Complete the next comparable session to confirm the increase.'**
  String get homeInsightProgressionSpecific;

  /// Migrated from home.insight.consistency_title
  ///
  /// In en, this message translates to:
  /// **'Your path is taking shape'**
  String get homeInsightConsistencyTitle;

  /// Migrated from home.insight.consistency_body
  ///
  /// In en, this message translates to:
  /// **'Keep recording comparable sessions to make suggestions more precise.'**
  String get homeInsightConsistencyBody;

  /// Migrated from home.actions.title
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get homeActionsTitle;

  /// Migrated from home.action.create_workout
  ///
  /// In en, this message translates to:
  /// **'Create workout'**
  String get homeActionCreateWorkout;

  /// Migrated from home.action.create_exercise
  ///
  /// In en, this message translates to:
  /// **'Create exercise'**
  String get homeActionCreateExercise;

  /// Migrated from home.action.empty_workout
  ///
  /// In en, this message translates to:
  /// **'Empty workout'**
  String get homeActionEmptyWorkout;

  /// Migrated from home.guides.title
  ///
  /// In en, this message translates to:
  /// **'Coachly Guides'**
  String get homeGuidesTitle;

  /// Migrated from home.guide.double_progression
  ///
  /// In en, this message translates to:
  /// **'How double progression works'**
  String get homeGuideDoubleProgression;

  /// Migrated from home.guide.rir
  ///
  /// In en, this message translates to:
  /// **'What RIR really means'**
  String get homeGuideRir;

  /// Migrated from home.guide.machines
  ///
  /// In en, this message translates to:
  /// **'Why machine loads are not comparable'**
  String get homeGuideMachines;

  /// Migrated from home.guide.nine_day_cycle
  ///
  /// In en, this message translates to:
  /// **'Build a nine-day training cycle'**
  String get homeGuideNineDayCycle;

  /// Migrated from home.guide.beginner
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get homeGuideBeginner;

  /// Migrated from home.guide.intermediate
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get homeGuideIntermediate;

  /// Migrated from home.guide.all_levels
  ///
  /// In en, this message translates to:
  /// **'All levels'**
  String get homeGuideAllLevels;

  /// Migrated from home.routines.title
  ///
  /// In en, this message translates to:
  /// **'Your routines'**
  String get homeRoutinesTitle;

  /// Migrated from home.routines.metadata
  ///
  /// In en, this message translates to:
  /// **'{exercises} exercises · ~{minutes} min'**
  String homeRoutinesMetadata(String exercises, String minutes);

  /// Migrated from home.routines.last_yesterday
  ///
  /// In en, this message translates to:
  /// **'Last: yesterday'**
  String get homeRoutinesLastYesterday;

  /// Migrated from home.routines.last_days
  ///
  /// In en, this message translates to:
  /// **'Last: {days} days ago'**
  String homeRoutinesLastDays(String days);

  /// Migrated from home.routines.empty_title
  ///
  /// In en, this message translates to:
  /// **'Create your first routine'**
  String get homeRoutinesEmptyTitle;

  /// Migrated from home.routines.empty_body
  ///
  /// In en, this message translates to:
  /// **'Turn your next session into a reusable plan.'**
  String get homeRoutinesEmptyBody;

  /// Migrated from home.error.title
  ///
  /// In en, this message translates to:
  /// **'Your local data could not be opened'**
  String get homeErrorTitle;

  /// Migrated from home.error.body
  ///
  /// In en, this message translates to:
  /// **'Pull down to try again.'**
  String get homeErrorBody;

  /// ICU plural example
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No sets completed} =1{1 set completed} other{{count} sets completed}}'**
  String setsCompletedCount(int count);

  /// ICU plural example
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No exercises} =1{1 exercise} other{{count} exercises}}'**
  String exercisesInWorkoutCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
