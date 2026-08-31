import 'package:coachly/core/assets/app_assets.dart';
import 'package:coachly/design_system/components/product/coachly_loading.dart';
import 'package:coachly/design_system/theme/coachly_theme_data.dart';
import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// L'avvio.
///
/// Mantiene la sua identita' — la foto, il marchio, il nome — ma l'attesa vera
/// e propria arriva da `CoachlyLoadingScreen`: la scena, il respiro,
/// l'annuncio al lettore di schermo e il messaggio sono gli stessi di ogni
/// altra attesa della app (`docs/development/27-loading.md`).
///
/// Prima questa pagina disegnava il proprio `CircularProgressIndicator` con la
/// propria dimensione e il proprio colore, ed era uno dei tredici modi diversi
/// in cui la app diceva la stessa cosa.
class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return CoachlyLoadingScreen(
      sceneKey: 'app',
      background: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.gymDarkBackground, fit: BoxFit.cover),
          Container(color: context.colors.surface.withValues(alpha: 0.5)),
        ],
      ),
      headline: Text(
        context.l10n.commonAppName,
        style: GoogleFonts.poppins(
          textStyle: textTheme.displaySmall,
          fontWeight: FontWeight.bold,
          color: context.colors.textPrimary,
        ),
      ),
    );
  }
}
