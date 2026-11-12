import 'package:meta/meta.dart';

/// Home list a product is shown in. Each product belongs to exactly one
/// section, so its image Hero tag is unique on the Home screen.
enum ProductSection {
  seasonal,
  popular,
  orderAgain;

  static ProductSection? tryParse(String? value) {
    for (final section in values) {
      if (section.name == value) return section;
    }
    return null;
  }
}

@immutable
final class Product {
  const Product({
    required this.id,
    required this.code,
    required this.name,
    required this.priceMmk,
    required this.isNew,
    required this.discountPercent,
    required this.imageUrl,
    required this.description,
    required this.section,
    this.sortOrder = 0,
  });

  final String id;
  final String code;
  final String name;
  final int priceMmk;
  final bool isNew;
  final int? discountPercent;

  /// An `assets/...` path or an http(s) URL; see `JdImage`.
  final String imageUrl;
  final String description;
  final ProductSection section;
  final int sortOrder;
}
