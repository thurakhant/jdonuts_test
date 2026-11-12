import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

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

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String code,
    required String name,
    required int priceMmk,
    required bool isNew,
    required int? discountPercent,

    /// An `assets/...` path or an http(s) URL; see `JdImage`.
    required String imageUrl,
    required String description,
    required ProductSection section,

    /// Position in its Home list; set from the catalog order, not the JSON.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(0)
    int sortOrder,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
