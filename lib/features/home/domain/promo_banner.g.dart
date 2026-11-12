// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PromoBanner _$PromoBannerFromJson(Map<String, dynamic> json) => _PromoBanner(
  id: json['id'] as String,
  title: json['title'] as String,
  imageUrl: json['imageUrl'] as String,
  badge: json['badge'] as String?,
);

Map<String, dynamic> _$PromoBannerToJson(_PromoBanner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'badge': instance.badge,
    };
