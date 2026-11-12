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
          for (var i = 0; i < products.length; i++)
            Product.fromJson(products[i]).copyWith(sortOrder: i),
        ],
        banners: [
          for (final b in _list(data['banners'])) PromoBanner.fromJson(b),
        ],
        shops: [for (final s in _list(data['shops'])) Shop.fromJson(s)],
        member: Member.fromJson(data['member'] as Map<String, dynamic>),
        // Older payloads have no challenges section: null keeps saved ones.
        challenges: data['challenges'] == null
            ? null
            : [
                for (final c in _list(data['challenges']))
                  Challenge.fromJson(c),
              ],
      ),
    );
  } on Object catch (error) {
    // Generated fromJson throws on a missing field, wrong type or unknown
    // enum value; all of them mean the payload is malformed.
    return FailureResult(MalformedCatalog('$error'));
  }
}

List<Map<String, dynamic>> _list(Object? value) =>
    (value as List<dynamic>).cast<Map<String, dynamic>>();
