import 'package:coachly/core/assets/app_assets.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:flutter/material.dart';

/// Entries of the sign-in column.
///
/// The variant decides surface, content, mark and mark tint: the call site
/// only says which entry it is, what it is called and whether it works.
/// [AuthProviderType.offline] is not a provider but the way out when the
/// device has no network, and it takes the same shape so the column never
/// changes rhythm.
enum AuthProviderType { apple, google, coachly, offline }

/// Full-width sign-in action of the login screen.
///
/// One component, three looks, all on the same grid: fixed height, soft
/// radius, icon in a leading slot, label centred on the whole button and an
/// optional trailing slot. No shadows, a hairline border instead.
///
/// - [AuthProviderType.apple]: near-black surface, thin grey border, white
///   mark and label.
/// - [AuthProviderType.google]: same structure, and when disabled it keeps
///   border and layout fully legible, lowering only the contrast of surface
///   and label and adding the [badge]. The Google mark is never tinted.
/// - [AuthProviderType.coachly]: the account you sign in with today, and the
///   real call to action. Same dark surface and border as the others: it
///   leads because it is the one at full contrast, with a chevron instead of
///   a badge. Which identity provider backs it is an
///   implementation detail the screen never names.
///
/// - [AuthProviderType.offline]: a Material glyph instead of a brand mark,
///   because nothing is being signed into.
///
/// The trailing chevron appears only on an entry that can actually be
/// pressed, so what works is readable at a glance.
class AuthProviderButton extends StatelessWidget {
  final AuthProviderType type;
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  /// True while the sign-in flow is running: the button locks, but shows no
  /// spinner of its own because the animated logo is the progress indicator.
  final bool loading;

  /// Short note for a provider that is off on purpose (e.g. "SOON"), shown as
  /// a discreet pill so the disabled state does not read as a bug.
  final String? badge;

  const AuthProviderButton({
    required this.type,
    required this.label,
    required this.onPressed,
    required this.enabled,
    this.loading = false,
    this.badge,
    super.key,
  });

  String? get _markAsset => switch (type) {
    AuthProviderType.apple => AppAssets.appleLogo,
    AuthProviderType.google => AppAssets.googleG,
    AuthProviderType.coachly => AppAssets.coachlyMark,
    AuthProviderType.offline => null,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sizes = context.sizes;
    final isEnabled = enabled && !loading && onPressed != null;

    final surface = colors.authProviderSurfaceDark;
    final content = colors.authProviderContentDark;

    // Disabilitato: si abbassa il contrasto di superficie ed etichetta, ma il
    // bordo e la struttura restano pieni. Niente `Opacity` sull'intero
    // pulsante, che lo farebbe sembrare solo slavato.
    final background = isEnabled ? surface : Color.lerp(surface, colors.surface, 0.45)!;
    final foreground = isEnabled ? content : colors.textSecondary;

    // I marchi Google e Coachly vanno mostrati nei loro colori; quello Apple
    // e' un glifo monocromatico e prende il colore del contenuto.
    final iconTint = switch (type) {
      AuthProviderType.google || AuthProviderType.coachly => null,
      AuthProviderType.apple || AuthProviderType.offline => foreground,
    };
    final asset = _markAsset;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: SizedBox(
        width: double.infinity,
        height: sizes.authAction,
        child: FilledButton(
          onPressed: isEnabled ? onPressed : null,
          style: FilledButton.styleFrom(
            backgroundColor: background,
            disabledBackgroundColor: background,
            foregroundColor: foreground,
            disabledForegroundColor: foreground,
            overlayColor: foreground,
            padding: EdgeInsets.symmetric(horizontal: context.spacing.lg),
            shape: RoundedRectangleBorder(
              borderRadius: context.radii.authActionBorder,
              side: BorderSide(color: colors.border),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox.square(
                  dimension: sizes.iconMd,
                  child: asset == null
                      ? Icon(
                          Icons.cloud_off_rounded,
                          size: sizes.iconMd,
                          color: iconTint,
                        )
                      : Image.asset(
                          asset,
                          // I file sono ritagliati sul contenuto e ancorati a
                          // sinistra: cosi' i marchi partono dalla stessa
                          // colonna qualunque sia la loro proporzione.
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                          color: iconTint,
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.spacing.xxl),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleS.copyWith(color: foreground),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: badge != null
                    ? _Badge(text: badge!)
                    : isEnabled
                    ? Icon(
                        Icons.chevron_right_rounded,
                        size: sizes.iconMd,
                        color: foreground,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pill of a provider that is announced but not available yet.
class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.xs,
        vertical: context.spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: context.colors.border,
        borderRadius: BorderRadius.circular(context.radii.pill),
      ),
      child: Text(
        text,
        style: context.text.labelStrong.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}
