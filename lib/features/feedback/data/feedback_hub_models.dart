class FeedbackPoll {
  const FeedbackPoll({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.multipleChoice,
    required this.options,
    required this.opensAt,
    required this.closesAt,
  });

  final String id;
  final String title;
  final String description;
  final String status;
  final bool multipleChoice;
  final List<FeedbackPollOption> options;
  final DateTime? opensAt;
  final DateTime? closesAt;

  factory FeedbackPoll.fromJson(Map<String, dynamic> json) {
    final optionsRaw = json['options'];
    final options = optionsRaw is List
        ? optionsRaw
              .whereType<Map>()
              .map(
                (item) => FeedbackPollOption.fromJson(
                  item.map((key, value) => MapEntry(key.toString(), value)),
                ),
              )
              .toList()
        : const <FeedbackPollOption>[];

    return FeedbackPoll(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      multipleChoice: json['multipleChoice'] == true,
      options: options,
      opensAt: _parseDate(json['opensAt']),
      closesAt: _parseDate(json['closesAt']),
    );
  }
}

class FeedbackPollOption {
  const FeedbackPollOption({
    required this.id,
    required this.label,
    required this.position,
  });

  final String id;
  final String label;
  final int position;

  factory FeedbackPollOption.fromJson(Map<String, dynamic> json) {
    return FeedbackPollOption(
      id: (json['id'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      position: (json['position'] as num?)?.toInt() ?? 0,
    );
  }
}

class FeedbackPollResult {
  const FeedbackPollResult({
    required this.pollId,
    required this.participants,
    required this.options,
  });

  final String pollId;
  final int participants;
  final List<FeedbackPollResultOption> options;

  factory FeedbackPollResult.fromJson(Map<String, dynamic> json) {
    final optionsRaw = json['options'];
    final options = optionsRaw is List
        ? optionsRaw
              .whereType<Map>()
              .map(
                (item) => FeedbackPollResultOption.fromJson(
                  item.map((key, value) => MapEntry(key.toString(), value)),
                ),
              )
              .toList()
        : const <FeedbackPollResultOption>[];

    return FeedbackPollResult(
      pollId: (json['pollId'] ?? '').toString(),
      participants: (json['participants'] as num?)?.toInt() ?? 0,
      options: options,
    );
  }
}

class FeedbackPollResultOption {
  const FeedbackPollResultOption({
    required this.optionId,
    required this.label,
    required this.votes,
    required this.percentage,
  });

  final String optionId;
  final String label;
  final int votes;
  final double percentage;

  factory FeedbackPollResultOption.fromJson(Map<String, dynamic> json) {
    return FeedbackPollResultOption(
      optionId: (json['optionId'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      votes: (json['votes'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
    );
  }
}

class FeatureRequestItem {
  const FeatureRequestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    required this.upvotesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.moduleKey,
    required this.platformTarget,
  });

  final String id;
  final String title;
  final String description;
  final String status;
  final String? category;
  final int upvotesCount;
  final int commentsCount;
  final DateTime? createdAt;
  final String? moduleKey;
  final String? platformTarget;

  factory FeatureRequestItem.fromJson(Map<String, dynamic> json) {
    return FeatureRequestItem(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      category: json['category']?.toString(),
      upvotesCount: (json['upvotesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      createdAt: _parseDate(json['createdAt']),
      moduleKey: json['moduleKey']?.toString(),
      platformTarget: json['platformTarget']?.toString(),
    );
  }
}

class FeedbackComment {
  const FeedbackComment({
    required this.id,
    required this.authorUserId,
    required this.body,
    required this.score,
    required this.repliesCount,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String authorUserId;
  final String body;
  final int score;
  final int repliesCount;
  final String status;
  final DateTime? createdAt;

  factory FeedbackComment.fromJson(Map<String, dynamic> json) {
    return FeedbackComment(
      id: (json['id'] ?? '').toString(),
      authorUserId: (json['authorUserId'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      score: (json['score'] as num?)?.toInt() ?? 0,
      repliesCount: (json['repliesCount'] as num?)?.toInt() ?? 0,
      status: (json['status'] ?? '').toString(),
      createdAt: _parseDate(json['createdAt']),
    );
  }
}

DateTime? _parseDate(dynamic raw) {
  if (raw == null) {
    return null;
  }

  if (raw is String && raw.isNotEmpty) {
    return DateTime.tryParse(raw);
  }

  return null;
}
