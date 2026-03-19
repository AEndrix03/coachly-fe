import 'package:freezed_annotation/freezed_annotation.dart';

part 'insight_card.freezed.dart';
part 'insight_card.g.dart';

@freezed
abstract class InsightCard with _$InsightCard {
  const factory InsightCard({
    required String icon,
    required String label,
    required String body,
  }) = _InsightCard;

  factory InsightCard.fromJson(Map<String, dynamic> json) =>
      _$InsightCardFromJson(json);
}
