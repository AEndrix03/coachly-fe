import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/catalog_sync/domain/catalog_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catalogDeltaServiceProvider = Provider<CatalogDeltaService>((ref) {
  return CatalogDeltaService(ref.watch(apiClientProvider));
});

/// Unico punto che parla con il canale a delta del catalogo.
///
/// Il catalogo **non si scarica**: viaggia col bundle e si aggiorna a delta
/// (`docs/development/04-data-layer.md`). Questo servizio serve solo la seconda
/// meta'.
class CatalogDeltaService {
  const CatalogDeltaService(this._apiClient);

  final ApiClient _apiClient;

  /// Versione corrente del catalogo sul backend.
  ///
  /// E' la chiamata che nel caso normale — nessun cambiamento — **sostituisce**
  /// un trasferimento: si confronta un intero invece di scaricare un delta
  /// vuoto.
  Future<ApiResponse<int>> fetchVersion({CancelToken? cancelToken}) {
    return _apiClient.get<int>(
      '/catalog/version',
      cancelToken: cancelToken,
      fromJson: (json) {
        final map = json as Map<String, dynamic>;
        return (map['version'] as num?)?.toInt() ?? 0;
      },
    );
  }

  /// Le righe cambiate da [since] in poi.
  Future<ApiResponse<CatalogDelta>> fetchDelta({
    required int since,
    int limit = 1000,
    CancelToken? cancelToken,
  }) {
    return _apiClient.get<CatalogDelta>(
      '/catalog/delta',
      queryParameters: {'since': '$since', 'limit': '$limit'},
      cancelToken: cancelToken,
      // Un delta puo' essere grande: il timeout e' quello dei batch, non
      // quello di una chiamata interattiva (`06-networking.md`).
      receiveTimeoutOverride: NetworkTimeouts.syncReceive,
      fromJson: (json) => CatalogDelta.fromJson(json as Map<String, dynamic>),
    );
  }
}
