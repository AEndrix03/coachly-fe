import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/features/coach/data/models/coach_summary/coach_summary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coachServiceProvider = Provider<CoachService>((ref) {
  return CoachService(ref.watch(apiClientProvider));
});

class CoachService {
  CoachService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<CoachSummary>> fetchCoaches() async {
    final response = await _apiClient.get<List<CoachSummary>>(
      '/coaches/discovery',
      fromJson: (json) {
        final payload = _unwrapData(json);
        if (payload is! List) {
          return const <CoachSummary>[];
        }

        return payload
            .whereType<Map>()
            .map(
              (item) => CoachSummary.fromJson(
                item.map((key, value) => MapEntry(key.toString(), value)),
              ),
            )
            .toList();
      },
    );

    if (!response.success || response.data == null) {
      throw Exception(
        response.message ?? 'Unable to load coach discovery list.',
      );
    }

    return response.data!;
  }

  dynamic _unwrapData(dynamic json) {
    if (json is Map && json.containsKey('data')) {
      return json['data'];
    }
    return json;
  }
}
