import 'package:coachly/core/network/session_gateway.dart';
import 'package:coachly/features/sync/data/local/outbox_dao.dart';
import 'package:coachly/core/sync/sync_queue.dart';
import 'package:coachly/features/auth/data/services/auth_session_gateway.dart';
import 'package:coachly/features/auth/providers/auth_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cablaggio fra `core/` e le feature.
///
/// `core/` dichiara le interfacce di cui ha bisogno e non può costruirne le
/// implementazioni, che vivono nelle feature: il collegamento avviene qui, nel
/// livello `app/`, l'unico autorizzato a conoscere entrambi
/// (`docs/development/01-principles.md`).
///
/// Ritorna direttamente lo scope perché Riverpod 3 non esporta il tipo
/// `Override`, quindi una `List<Override>` non è dichiarabile.
ProviderScope buildAppScope({required Widget child}) {
  return ProviderScope(
    overrides: [
      sessionGatewayProvider.overrideWith(
        (ref) => AuthSessionGateway(
          ref.watch(authServiceProvider),
          () => ref.invalidate(authProvider),
        ),
      ),
      syncQueueProvider.overrideWith(
        (ref) => OutboxSyncQueue(ref.watch(outboxDaoProvider)),
      ),
    ],
    child: child,
  );
}
