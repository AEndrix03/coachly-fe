import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/api_response.dart';
import 'package:coachly/features/feedback/data/feedback_hub_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackHubServiceProvider = Provider<FeedbackHubService>((ref) {
  return FeedbackHubService(ref.watch(apiClientProvider));
});

class FeedbackHubService {
  FeedbackHubService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<FeedbackPoll>> fetchPolls() async {
    final response = await _apiClient.get<List<FeedbackPoll>>(
      '/polls',
      fromJson: (json) {
        final payload = _unwrapData(json);
        if (payload is! List) {
          return const <FeedbackPoll>[];
        }

        return payload
            .whereType<Map>()
            .map(
              (item) => FeedbackPoll.fromJson(
                item.map((key, value) => MapEntry(key.toString(), value)),
              ),
            )
            .toList();
      },
    );

    return _requireData(response, 'Impossibile caricare i sondaggi');
  }

  Future<FeedbackPollResult> fetchPollResults(String pollId) async {
    final response = await _apiClient.get<FeedbackPollResult>(
      '/polls/$pollId/results',
      fromJson: (json) {
        final payload = _unwrapData(json);
        if (payload is! Map) {
          return const FeedbackPollResult(
            pollId: '',
            participants: 0,
            options: <FeedbackPollResultOption>[],
          );
        }

        return FeedbackPollResult.fromJson(
          payload.map((key, value) => MapEntry(key.toString(), value)),
        );
      },
    );

    return _requireData(response, 'Impossibile caricare i risultati');
  }

  Future<void> submitPollResponse(String pollId, List<String> optionIds) async {
    final response = await _apiClient.post<void>(
      '/polls/$pollId/responses',
      body: {'optionIds': optionIds},
      fromJson: (_) {},
    );

    _requireSuccess(response, 'Impossibile inviare il voto al sondaggio');
  }

  Future<List<FeatureRequestItem>> fetchFeatureRequests() async {
    final response = await _apiClient.get<List<FeatureRequestItem>>(
      '/feature-requests',
      queryParameters: {'sort': 'trending', 'size': '30', 'page': '0'},
      fromJson: (json) {
        final payload = _unwrapData(json);
        if (payload is Map) {
          final content = payload['content'];
          if (content is List) {
            return content
                .whereType<Map>()
                .map(
                  (item) => FeatureRequestItem.fromJson(
                    item.map((key, value) => MapEntry(key.toString(), value)),
                  ),
                )
                .toList();
          }
        }

        return const <FeatureRequestItem>[];
      },
    );

    return _requireData(
      response,
      'Impossibile caricare le richieste di funzionalita',
    );
  }

  Future<void> submitFeatureRequest({
    required String title,
    required String description,
    String? category,
  }) async {
    final response = await _apiClient.post<void>(
      '/feature-requests',
      body: {
        'title': title,
        'description': description,
        'category': category,
        'platformTarget': 'MOBILE',
        'moduleKey': 'feedback-hub',
      },
      fromJson: (_) {},
    );

    _requireSuccess(
      response,
      'Impossibile inviare la richiesta di funzionalita',
    );
  }

  Future<void> voteFeatureRequest(String featureId) async {
    final response = await _apiClient.post<void>(
      '/feature-requests/$featureId/vote',
      body: {'voteType': 'UP'},
      fromJson: (_) {},
    );

    _requireSuccess(response, 'Impossibile registrare il voto');
  }

  Future<List<FeedbackComment>> fetchFeatureComments(String featureId) async {
    final response = await _apiClient.get<List<FeedbackComment>>(
      '/comments',
      queryParameters: {
        'targetType': 'FEATURE_REQUEST',
        'targetId': featureId,
        'sort': 'top',
      },
      fromJson: (json) {
        final payload = _unwrapData(json);
        if (payload is! List) {
          return const <FeedbackComment>[];
        }

        return payload
            .whereType<Map>()
            .map(
              (item) => FeedbackComment.fromJson(
                item.map((key, value) => MapEntry(key.toString(), value)),
              ),
            )
            .toList();
      },
    );

    return _requireData(response, 'Impossibile caricare i commenti');
  }

  Future<void> submitFeatureComment({
    required String featureId,
    required String body,
  }) async {
    final response = await _apiClient.post<void>(
      '/comments',
      body: {
        'targetType': 'FEATURE_REQUEST',
        'targetId': featureId,
        'body': body,
      },
      fromJson: (_) {},
    );

    _requireSuccess(response, 'Impossibile inviare il commento');
  }

  Future<void> submitFeedback({
    required String type,
    required String title,
    required String body,
    int? ratingValue,
    String? severity,
    bool? reproducible,
  }) async {
    final response = await _apiClient.post<void>(
      '/feedback',
      body: {
        'type': type,
        'title': title,
        'body': body,
        'ratingValue': ratingValue,
        'category': 'mobile-app',
        'targetType': 'GENERIC',
        'targetId': '11111111-1111-1111-1111-111111111111',
        'featureKey': 'feedback-tab',
        'screenKey': 'feedback_page',
        'flowKey': 'feedback_hub',
        'platform': 'MOBILE',
        'appVersion': '1.0.0',
        'severity': severity,
        'reproducible': reproducible,
      },
      fromJson: (_) {},
    );

    _requireSuccess(response, 'Impossibile inviare il feedback');
  }

  dynamic _unwrapData(dynamic json) {
    if (json is Map && json.containsKey('data')) {
      return json['data'];
    }
    return json;
  }

  T _requireData<T>(ApiResponse<T> response, String fallbackMessage) {
    if (!response.success || response.data == null) {
      throw Exception(response.message ?? fallbackMessage);
    }

    return response.data as T;
  }

  void _requireSuccess(ApiResponse<void> response, String fallbackMessage) {
    if (!response.success) {
      throw Exception(response.message ?? fallbackMessage);
    }
  }
}
