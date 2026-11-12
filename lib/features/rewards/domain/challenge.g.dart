// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Challenge _$ChallengeFromJson(Map<String, dynamic> json) => _Challenge(
  id: json['id'] as String,
  title: json['title'] as String,
  imageAsset: json['imageAsset'] as String,
  style: $enumDecode(_$ChallengeStyleEnumMap, json['style']),
  goal: (json['goal'] as num).toInt(),
  progress: (json['progress'] as num).toInt(),
  rewardPoints: (json['rewardPoints'] as num).toInt(),
);

Map<String, dynamic> _$ChallengeToJson(_Challenge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageAsset': instance.imageAsset,
      'style': _$ChallengeStyleEnumMap[instance.style]!,
      'goal': instance.goal,
      'progress': instance.progress,
      'rewardPoints': instance.rewardPoints,
    };

const _$ChallengeStyleEnumMap = {
  ChallengeStyle.quarterDonut: 'quarterDonut',
  ChallengeStyle.coffeeCup: 'coffeeCup',
};
