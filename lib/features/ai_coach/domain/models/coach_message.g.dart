// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoachMessage _$CoachMessageFromJson(Map<String, dynamic> json) =>
    _CoachMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      sender: $enumDecode(_$MessageSenderEnumMap, json['sender']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      insightCard: json['insightCard'] == null
          ? null
          : InsightCard.fromJson(json['insightCard'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CoachMessageToJson(_CoachMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'sender': _$MessageSenderEnumMap[instance.sender]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'insightCard': instance.insightCard,
    };

const _$MessageSenderEnumMap = {
  MessageSender.user: 'user',
  MessageSender.ai: 'ai',
};
