import 'promo_banner.dart';
import 'shop.dart';

abstract interface class HomeRepository {
  Stream<List<PromoBanner>> watchBanners();
  Stream<List<Shop>> watchShops();
}
