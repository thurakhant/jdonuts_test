// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  priceMmk: (json['priceMmk'] as num).toInt(),
  isNew: json['isNew'] as bool,
  discountPercent: (json['discountPercent'] as num?)?.toInt(),
  imageUrl: json['imageUrl'] as String,
  description: json['description'] as String,
  section: $enumDecode(_$ProductSectionEnumMap, json['section']),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'priceMmk': instance.priceMmk,
  'isNew': instance.isNew,
  'discountPercent': instance.discountPercent,
  'imageUrl': instance.imageUrl,
  'description': instance.description,
  'section': _$ProductSectionEnumMap[instance.section]!,
};

const _$ProductSectionEnumMap = {
  ProductSection.seasonal: 'seasonal',
  ProductSection.popular: 'popular',
  ProductSection.orderAgain: 'orderAgain',
};
