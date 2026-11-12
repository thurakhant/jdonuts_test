import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/jd_image.dart';
import '../../../../app/widgets/orange_badge.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../product/domain/product.dart';
import '../../../product/presentation/widgets/product_hero.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    this.width = AppSpacing.productTileSize,
    this.imageHeight = AppSpacing.productImageHeight,
    this.framed = false,
    super.key,
  });

  final Product product;
  final double width;
  final double imageHeight;

  /// Framed cards (Popular, Order again) show the whole product on a white
  /// panel with a soft shadow; unframed ones fill the panel with the image.
  final bool framed;

  @override
  Widget build(BuildContext context) {
    final discount = product.discountPercent;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () =>
          context.push(AppRoutes.productDetail(product.id), extra: product),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(tag: productHeroTag(product.id), child: _panel()),
                if (discount != null)
                  Positioned(
                    bottom: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: OrangeBadge(
                      AppLocalizations.of(context)!.discountOff(discount),
                      compact: framed,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _panel() {
    if (!framed) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: JdImage(product.imageUrl, width: width, height: imageHeight),
      );
    }
    return Container(
      width: width,
      height: imageHeight,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: JdImage(product.imageUrl, fit: BoxFit.contain),
    );
  }
}
