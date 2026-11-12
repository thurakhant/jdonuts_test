import '../../features/home/domain/promo_banner.dart';
import '../../features/home/domain/shop.dart';
import '../../features/member/domain/member.dart';
import '../../features/rewards/domain/challenge.dart';
import '../../features/product/domain/product.dart';

/// One versioned copy of all catalog data, as delivered by a
/// [CatalogSource]. Pure Dart: the same shape whether it came from the
/// bundled seed or (later) a server.
class CatalogSnapshot {
  const CatalogSnapshot({
    required this.version,
    required this.products,
    required this.banners,
    required this.shops,
    required this.member,
    required this.challenges,
  });

  final int version;
  final List<Product> products;
  final List<PromoBanner> banners;
  final List<Shop> shops;
  final Member member;

  /// Null when the payload has no challenges section (older payloads):
  /// saved challenges are kept. An empty list clears them.
  final List<Challenge>? challenges;
}
