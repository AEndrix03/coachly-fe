import 'dart:convert';

import 'package:coachly/core/database/app_database.dart';
import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionEventServiceProvider = Provider<SessionEventService>((ref) {
  return SessionEventService(ref.watch(apiClientProvider));
});

/// Invio degli eventi di sessione al backend.
///
/// Gli eventi salgono **in batch**: un allenamento da quaranta serie produce
/// una richiesta, non quaranta (`docs/development/05-sync-and-offline.md`).
class SessionEventService {
  const SessionEventService(this._apiClient);

  /// Tetto del batch, allineato al limite che il backend rifiuta.
  static const int maxBatchSize = 500;

  final ApiClient _apiClient;

  /// Appende gli eventi di **una** sessione.
  ///
  /// L'append e' idempotente per `(sessionId, seq)`: un reinvio dopo un timeout
  /// ambiguo non duplica nulla, quindi il chiamante puo' ritentare senza
  /// chiedersi se la prima volta era arrivata.
  Future<ApiResponse<void>> appendEvents({
    required String sessionId,
    required List<SessionEventRow> events,
  }) {
    return _apiClient.post<void>(
      '/workouts/sessions/$sessionId/events',
      body: {
        'events': [
          for (final event in events)
            {
              'id': event.id,
              'seq': event.seq,
              'occurredAt': event.occurredAt.toUtc().toIso8601String(),
              'type': event.type,
              'payload': _decodePayload(event.payload),
            },
        ],
      },
      fromJson: (_) {},
    );
  }

  /// Il payload vive in locale come testo e viaggia come oggetto: il DTO del
  /// backend dichiara una mappa, e mandargli una stringa farebbe fallire la
  /// deserializzazione dell'intero batch.
  ///
  /// Un payload illeggibile non fa perdere l'evento: si manda una mappa vuota
  /// e si conserva il testo sotto una chiave, cosi' il fatto — che e' la cosa
  /// che conta — arriva comunque.
  static Map<String, dynamic> _decodePayload(String raw) {
    if (raw.trim().isEmpty) return const {};
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : {'value': decoded};
    } on FormatException {
      return {'malformed': raw};
    }
  }
}
