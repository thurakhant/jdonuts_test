import 'package:freezed_annotation/freezed_annotation.dart';

import '../../features/home/domain/promo_banner.dart';
import '../../features/home/domain/shop.dart';
import '../../features/member/domain/member.dart';
import '../../features/rewards/domain/challenge.dart';
import '../../features/product/domain/product.dart';

part 'catalog_snapshot.freezed.dart';

/// One versioned copy of all catalog data, as delivered by a
/// [CatalogSource]. Pure Dart: the same shape whether it came from the
/// bundled seed or (later) a server.
@freezed
abstract class CatalogSnapshot with _$CatalogSnapshot {
  const factory CatalogSnapshot({
    required int version,
    required List<Product> products,
    required List<PromoBanner> banners,
    required List<Shop> shops,
    required Member member,

    /// Null when the payload has no challenges section (older payloads):
    /// saved challenges are kept. An empty list clears them.
    required List<Challenge>? challenges,
  }) = _CatalogSnapshot;
}
