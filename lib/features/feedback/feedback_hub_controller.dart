import 'package:coachly/features/feedback/data/feedback_hub_models.dart';
import 'package:coachly/features/feedback/data/feedback_hub_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackHubControllerProvider =
    NotifierProvider<FeedbackHubController, FeedbackHubState>(
      FeedbackHubController.new,
    );

class FeedbackHubState {
  const FeedbackHubState({
    this.isLoading = false,
    this.errorMessage,
    this.polls = const <FeedbackPoll>[],
    this.pollResultsById = const <String, FeedbackPollResult>{},
    this.answeredPollIds = const <String>{},
    this.featureRequests = const <FeatureRequestItem>[],
    this.selectedFeatureId,
    this.comments = const <FeedbackComment>[],
  });

  final bool isLoading;
  final String? errorMessage;
  final List<FeedbackPoll> polls;
  final Map<String, FeedbackPollResult> pollResultsById;
  final Set<String> answeredPollIds;
  final List<FeatureRequestItem> featureRequests;
  final String? selectedFeatureId;
  final List<FeedbackComment> comments;

  FeedbackHubState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<FeedbackPoll>? polls,
    Map<String, FeedbackPollResult>? pollResultsById,
    Set<String>? answeredPollIds,
    List<FeatureRequestItem>? featureRequests,
    String? selectedFeatureId,
    bool clearSelectedFeature = false,
    List<FeedbackComment>? comments,
  }) {
    return FeedbackHubState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      polls: polls ?? this.polls,
      pollResultsById: pollResultsById ?? this.pollResultsById,
      answeredPollIds: answeredPollIds ?? this.answeredPollIds,
      featureRequests: featureRequests ?? this.featureRequests,
      selectedFeatureId: clearSelectedFeature
          ? null
          : (selectedFeatureId ?? this.selectedFeatureId),
      comments: comments ?? this.comments,
    );
  }
}

class FeedbackHubController extends Notifier<FeedbackHubState> {
  FeedbackHubService get _service => ref.read(feedbackHubServiceProvider);
  bool _loading = false;

  @override
  FeedbackHubState build() {
    Future<void>.microtask(load);
    return const FeedbackHubState();
  }

  Future<void> load() async {
    if (_loading) {
      return;
    }
    _loading = true;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final polls = await _service.fetchPolls();
      final featureRequests = await _service.fetchFeatureRequests();
      if (!ref.mounted) {
        return;
      }
      final selectedFeatureId = featureRequests.isNotEmpty
          ? featureRequests.first.id
          : null;

      state = state.copyWith(
        isLoading: false,
        polls: polls,
        featureRequests: featureRequests,
        selectedFeatureId: selectedFeatureId,
        comments: const <FeedbackComment>[],
        clearError: true,
      );
      if (selectedFeatureId != null) {
        await loadComments(selectedFeatureId);
      }
    } catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    } finally {
      _loading = false;
    }
  }

  Future<void> submitFeedback({
    required String type,
    required String title,
    required String body,
    int? ratingValue,
    String? severity,
    bool? reproducible,
  }) {
    return _service.submitFeedback(
      type: type,
      title: title,
      body: body,
      ratingValue: ratingValue,
      severity: severity,
      reproducible: reproducible,
    );
  }

  Future<void> submitFeatureRequest({
    required String title,
    required String description,
    String? category,
  }) async {
    await _service.submitFeatureRequest(
      title: title,
      description: description,
      category: category,
    );
    await refreshFeatureRequests();
  }

  Future<void> refreshFeatureRequests() async {
    final featureRequests = await _service.fetchFeatureRequests();
    if (!ref.mounted) {
      return;
    }
    final selectedFeatureId = state.selectedFeatureId;
    final shouldSelectFirst =
        selectedFeatureId == null ||
        featureRequests.every((item) => item.id != selectedFeatureId);
    final nextSelectedFeatureId =
        shouldSelectFirst && featureRequests.isNotEmpty
        ? featureRequests.first.id
        : selectedFeatureId;

    state = state.copyWith(
      featureRequests: featureRequests,
      selectedFeatureId: nextSelectedFeatureId,
      comments: shouldSelectFirst ? const <FeedbackComment>[] : state.comments,
      clearError: true,
    );
    if (nextSelectedFeatureId != null &&
        (shouldSelectFirst || nextSelectedFeatureId != selectedFeatureId)) {
      await loadComments(nextSelectedFeatureId);
    }
  }

  Future<void> voteFeatureRequest(String featureId) async {
    await _service.voteFeatureRequest(featureId);
    await refreshFeatureRequests();
  }

  Future<void> loadComments(String featureId) async {
    state = state.copyWith(selectedFeatureId: featureId, comments: const []);
    try {
      final comments = await _service.fetchFeatureComments(featureId);
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(comments: comments, clearError: true);
    } catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(errorMessage: error.toString());
    }
  }

  Future<void> submitComment({
    required String featureId,
    required String body,
  }) async {
    await _service.submitFeatureComment(featureId: featureId, body: body);
    await refreshFeatureRequests();
    await loadComments(featureId);
  }

  Future<void> submitPollResponse({
    required String pollId,
    required List<String> optionIds,
  }) async {
    await _service.submitPollResponse(pollId, optionIds);
    final results = await _service.fetchPollResults(pollId);
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(
      answeredPollIds: {...state.answeredPollIds, pollId},
      pollResultsById: {...state.pollResultsById, pollId: results},
      clearError: true,
    );
  }

  Future<void> loadPollResults(String pollId) async {
    final results = await _service.fetchPollResults(pollId);
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(
      pollResultsById: {...state.pollResultsById, pollId: results},
      clearError: true,
    );
  }
}
