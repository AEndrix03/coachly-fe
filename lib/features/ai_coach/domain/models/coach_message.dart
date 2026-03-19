import 'package:coachly/features/ai_coach/domain/models/insight_card.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_message.freezed.dart';
part 'coach_message.g.dart';

enum MessageSender { user, ai }

@freezed
class CoachMessage with _$CoachMessage {
  const factory CoachMessage({
    required String id,
    required String text,
    required MessageSender sender,
    required DateTime timestamp,
    InsightCard? insightCard,
  }) = _CoachMessage;

  factory CoachMessage.fromJson(Map<String, dynamic> json) =>
      _$CoachMessageFromJson(json);
}
