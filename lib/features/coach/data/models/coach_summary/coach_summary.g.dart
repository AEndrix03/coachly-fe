// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoachSummary _$CoachSummaryFromJson(Map<String, dynamic> json) =>
    _CoachSummary(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      handle: json['handle'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      accentColorHex: json['accentColorHex'] as String,
      specialties:
          (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      rating: (json['rating'] as num).toDouble(),
      activeClients: (json['activeClients'] as num).toInt(),
      avgResponseHours: (json['avgResponseHours'] as num).toInt(),
      retentionRate: (json['retentionRate'] as num).toDouble(),
      isVerified: json['isVerified'] as bool,
      acceptingClients: json['acceptingClients'] as bool,
      priceRangeLabel: json['priceRangeLabel'] as String?,
      modalityLabel: json['modalityLabel'] as String,
    );

Map<String, dynamic> _$CoachSummaryToJson(_CoachSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'handle': instance.handle,
      'avatarUrl': instance.avatarUrl,
      'accentColorHex': instance.accentColorHex,
      'specialties': instance.specialties,
      'rating': instance.rating,
      'activeClients': instance.activeClients,
      'avgResponseHours': instance.avgResponseHours,
      'retentionRate': instance.retentionRate,
      'isVerified': instance.isVerified,
      'acceptingClients': instance.acceptingClients,
      'priceRangeLabel': instance.priceRangeLabel,
      'modalityLabel': instance.modalityLabel,
    };
