import 'package:coachly/core/logging/app_logger.dart';
import 'package:coachly/core/result/result.dart';
import 'package:coachly/features/app_update/data/repositories/app_update_repository.dart';
import 'package:coachly/features/app_update/domain/app_update_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stato della guard di aggiornamento.
///
/// `keepAlive`: la verifica si fa una volta per sessione applicativa, non a
/// ogni schermata che la osserva.
final appUpdateProvider =
    AsyncNotifierProvider<AppUpdateNotifier, AppUpdateStatus>(
      AppUpdateNotifier.new,
    );

/// Soglie dell'ultima verifica riuscita, per il testo della schermata.
final appUpdateRequirementsProvider = Provider<AppRequirements?>((ref) {
  // Si ricalcola quando la verifica cambia stato.
  ref.watch(appUpdateProvider);
  return ref.watch(appUpdateRepositoryProvider).lastKnownRequirements;
});

class AppUpdateNotifier extends AsyncNotifier<AppUpdateStatus> {
  @override
  Future<AppUpdateStatus> build() async {
    final result = await ref.read(appUpdateRepositoryProvider).checkForUpdate();

    return switch (result) {
      Ok(:final value) => value,
      // **Senza rete la app funziona lo stesso**
      // (`docs/development/25-release-and-environments.md`): un controllo che
      // non si e' potuto fare non e' un controllo fallito, e non deve mai
      // chiudere fuori l'utente dai propri dati, che sono solo sul dispositivo.
      Err(:final failure) => () {
        ref
            .read(appLoggerProvider)
            .info(
              'Update check skipped.',
              context: {'failure': failure.runtimeType.toString()},
            );
        return AppUpdateStatus.upToDate;
      }(),
    };
  }

  /// Rifa' la verifica. La schermata bloccante la usa per il tasto "riprova".
  Future<void> recheck() async {
    state = const AsyncLoading<AppUpdateStatus>();
    state = await AsyncValue.guard(build);
  }
}
