import 'package:coachly/shared/i18n/app_strings.dart';
import 'package:flutter/widgets.dart';

/// Il titolo di una scheda come lo legge una persona.
///
/// Gemello di `exercise_display_name.dart`, e nato dallo stesso difetto: il
/// titolo mancante veniva rimpiazzato con **l'id della scheda**, in home e nel
/// dettaglio. Un id non diventa un titolo per il fatto di stare al posto di un
/// titolo.
///
/// Ora i livelli sotto lasciano il campo vuoto quando non sanno, e questo è
/// l'unico punto che decide cosa mostrare.
String workoutTitleOrPlaceholder(BuildContext context, String? title) {
  final trimmed = title?.trim() ?? '';
  return trimmed.isEmpty ? context.l10n.workoutTitlePlaceholder : trimmed;
}
