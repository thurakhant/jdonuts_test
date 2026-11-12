import 'dart:convert';

import '../../features/home/domain/promo_banner.dart';
import '../../features/home/domain/shop.dart';
import '../../features/member/domain/member.dart';
import '../../features/rewards/domain/challenge.dart';
import '../../features/product/domain/product.dart';
import '../failure.dart';
import '../result.dart';
import 'catalog_snapshot.dart';

/// Parses the `{"version": n, "data": {...}}` envelope. Any shape problem
/// becomes a [MalformedCatalog] failure instead of an exception.
Result<CatalogSnapshot> parseCatalog(String source) {
  try {
    final root = jsonDecode(source) as Map<String, dynamic>;
    final data = root['data'] as Map<String, dynamic>;
    final products = _list(data['products']);
    return Success(
      CatalogSnapshot(
        version: root['version'] as int,
        products: [
          for (var i = 0; i < products.length; i++) _product(products[i], i),
        ],
        banners: [
          for (final b in _list(data['banners']))
            PromoBanner(
              id: b['id'] as String,
              title: b['title'] as String,
              imageUrl: b['imageUrl'] as String,
              badge: b['badge'] as String?,
            ),
        ],
        shops: [
          for (final s in _list(data['shops']))
            Shop(
              id: s['id'] as String,
              name: s['name'] as String,
              address: s['address'] as String,
              imageUrl: s['imageUrl'] as String,
            ),
        ],
        member: _member(data['member'] as Map<String, dynamic>),
        // Older payloads predate the challenges section; absent means none.
        challenges: [
          for (final c in _list(data['challenges'] ?? const <Object>[]))
            _challenge(c),
        ],
      ),
    );
  } on Object catch (error) {
    return FailureResult(MalformedCatalog('$error'));
  }
}

List<Map<String, dynamic>> _list(Object? value) =>
    (value as List<dynamic>).cast<Map<String, dynamic>>();

Product _product(Map<String, dynamic> json, int index) {
  final section = ProductSection.tryParse(json['section'] as String?);
  if (section == null) throw FormatException('bad section: ${json['id']}');
  return Product(
    id: json['id'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
    priceMmk: json['priceMmk'] as int,
    isNew: json['isNew'] as bool,
    discountPercent: json['discountPercent'] as int?,
    imageUrl: json['imageUrl'] as String,
    description: json['description'] as String,
    section: section,
    sortOrder: index,
  );
}

Challenge _challenge(Map<String, dynamic> json) {
  final style = ChallengeStyle.tryParse(json['style'] as String?);
  if (style == null) throw FormatException('bad style: ${json['id']}');
  return Challenge(
    id: json['id'] as String,
    title: json['title'] as String,
    imageAsset: json['imageAsset'] as String,
    style: style,
    goal: json['goal'] as int,
    progress: json['progress'] as int,
    rewardPoints: json['rewardPoints'] as int,
  );
}

Member _member(Map<String, dynamic> json) => Member(
  id: json['id'] as String,
  name: json['name'] as String,
  avatarAsset: json['avatarAsset'] as String,
  tier: json['tier'] as String,
  totalPoints: json['totalPoints'] as int,
  pointsToNextTier: json['pointsToNextTier'] as int,
  nextTier: json['nextTier'] as String,
  notificationCount: json['notificationCount'] as int,
  tierProgress: (json['tierProgress'] as num).toDouble(),
);
