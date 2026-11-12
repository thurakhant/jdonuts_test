import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo_banner.freezed.dart';
part 'promo_banner.g.dart';

@freezed
abstract class PromoBanner with _$PromoBanner {
  const factory PromoBanner({
    required String id,
    required String title,
    required String imageUrl,

    /// Short pill label over the title ("New shop"); null when absent.
    String? badge,
  }) = _PromoBanner;

  factory PromoBanner.fromJson(Map<String, dynamic> json) =>
      _$PromoBannerFromJson(json);
}
