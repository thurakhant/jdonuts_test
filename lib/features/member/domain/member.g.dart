// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  id: json['id'] as String,
  name: json['name'] as String,
  avatarAsset: json['avatarAsset'] as String,
  tier: json['tier'] as String,
  totalPoints: (json['totalPoints'] as num).toInt(),
  pointsToNextTier: (json['pointsToNextTier'] as num).toInt(),
  nextTier: json['nextTier'] as String,
  notificationCount: (json['notificationCount'] as num).toInt(),
  tierProgress: (json['tierProgress'] as num).toDouble(),
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatarAsset': instance.avatarAsset,
  'tier': instance.tier,
  'totalPoints': instance.totalPoints,
  'pointsToNextTier': instance.pointsToNextTier,
  'nextTier': instance.nextTier,
  'notificationCount': instance.notificationCount,
  'tierProgress': instance.tierProgress,
};
