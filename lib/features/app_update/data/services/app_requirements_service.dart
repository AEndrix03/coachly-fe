import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/app_update/domain/app_update_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appRequirementsServiceProvider = Provider<AppRequirementsService>((ref) {
  return AppRequirementsService(ref.watch(apiClientProvider));
});

/// Unico punto che parla con `GET /app/requirements`.
///
/// L'endpoint e' servito dal gateway ed e' l'unico sotto `/api` che non
/// richiede un token: un client troppo vecchio per parlare col backend puo'
/// esserlo anche per autenticarsi.
class AppRequirementsService {
  const AppRequirementsService(this._apiClient);

  final ApiClient _apiClient;

  Future<ApiResponse<AppRequirements>> fetchRequirements({
    CancelToken? cancelToken,
  }) {
    return _apiClient.get<AppRequirements>(
      '/app/requirements',
      cancelToken: cancelToken,
      fromJson: (json) {
        final map = json as Map<String, dynamic>;
        return AppRequirements(
          minSupportedVersion: map['minSupportedVersion'] as String? ?? '',
          recommendedVersion: map['recommendedVersion'] as String? ?? '',
          message: map['message'] as String? ?? '',
        );
      },
    );
  }
}
