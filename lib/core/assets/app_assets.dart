/// Registro tipizzato degli asset spediti nel bundle.
///
/// Nessuna feature scrive un percorso di asset a mano: la regola vale per le
/// icone (`docs/development/12-iconography.md`) e, per gli stessi motivi —
/// rinomina sicura, un solo posto dove sbagliare — per ogni altro asset.
///
/// Convenzioni di nome e cartelle: `docs/development/16-media.md`.
abstract final class AppAssets {
  const AppAssets._();

  // Brand
  static const String logo = 'assets/brand/app_logo.png';
  static const String logo3d = 'assets/brand/coachly_logo.glb';
  static const String titleSprite = 'assets/brand/coachly_sprite_title.png';

  // Authentication brands
  static const String googleG = 'assets/icons/auth/google_g.png';
  static const String appleLogo = 'assets/icons/auth/apple_logo.png';
  static const String coachlyMark = 'assets/icons/auth/coachly_mark.png';

  // Foto
  static const String gymDarkBackground =
      'assets/photos/gym_dark_background.png';

  // Illustrazioni delle guide
  static const String guideDoubleProgression =
      'assets/illustrations/guides/double_progression.png';
  static const String guideRir = 'assets/illustrations/guides/rir.png';
  static const String guideMachineComparability =
      'assets/illustrations/guides/machine_comparability.png';
  static const String guideNineDayCycle =
      'assets/illustrations/guides/nine_day_cycle.png';

  // Illustrazioni dei tipi di blocco
  static const String setTypeSuperset =
      'assets/illustrations/set_type/superset.png';
  static const String setTypeTriset =
      'assets/illustrations/set_type/triset.png';
  static const String setTypeGiantSet =
      'assets/illustrations/set_type/giant_set.png';
  static const String setTypeCircuit =
      'assets/illustrations/set_type/circuit.png';
}
