import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/jd_image.dart';
import '../../../../app/widgets/orange_badge.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../product/domain/product.dart';
import '../../../product/presentation/widgets/product_hero.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});

  final Product product;

  static const double width = AppSpacing.productTileSize;

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
                Hero(
                  tag: productHeroTag(product.id),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: JdImage(
                      product.imageUrl,
                      width: width,
                      height: width,
                    ),
                  ),
                ),
                if (discount != null)
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: OrangeBadge(
                      AppLocalizations.of(context)!.discountOff(discount),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
