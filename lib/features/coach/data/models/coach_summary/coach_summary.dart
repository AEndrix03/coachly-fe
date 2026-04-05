import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_summary.freezed.dart';
part 'coach_summary.g.dart';

@freezed
abstract class CoachSummary with _$CoachSummary {
  const factory CoachSummary({
    required String id,
    required String displayName,
    required String handle,
    String? avatarUrl,
    required String accentColorHex,
    @Default(<String>[]) List<String> specialties,
    required double rating,
    required int activeClients,
    required int avgResponseHours,
    required double retentionRate,
    required bool isVerified,
    required bool acceptingClients,
    String? priceRangeLabel,
    required String modalityLabel,
  }) = _CoachSummary;

  factory CoachSummary.fromJson(Map<String, dynamic> json) =>
      _$CoachSummaryFromJson(json);
}
