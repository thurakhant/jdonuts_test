import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/jd_image.dart';
import '../../../../app/widgets/orange_badge.dart';
import '../../../../app/widgets/skeleton.dart';
import '../../../../core/format/mmk.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/product.dart';
import 'product_hero.dart';
import 'quantity_stepper.dart';

class ProductDetailBody extends StatefulWidget {
  const ProductDetailBody({required this.product, super.key});

  final Product product;

  @override
  State<ProductDetailBody> createState() => _ProductDetailBodyState();
}

class _ProductDetailBodyState extends State<ProductDetailBody> {
  int _quantity = 1;

  /// Visual feedback only: the demo has no persistent cart.
  void _addToCart(AppLocalizations l10n) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.addedToCart(_quantity, widget.product.name)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final product = widget.product;
    final total = formatMmk(_quantity * product.priceMmk);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenEdge),
            child: _Card(product: product, l10n: l10n, child: _stepper()),
          ),
        ),
        _AddToCartBar(
          label: l10n.addToCartButton(total),
          onPressed: () => _addToCart(l10n),
        ),
      ],
    );
  }

  Widget _stepper() => Center(
    child: QuantityStepper(
      quantity: _quantity,
      onChanged: (value) => setState(() => _quantity = value),
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.product, required this.l10n, required this.child});

  final Product product;
  final AppLocalizations l10n;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.code, style: AppTypography.caption),
            const SizedBox(height: AppSpacing.xs),
            Text(product.name, style: AppTypography.display),
            const SizedBox(height: AppSpacing.sm),
            _PriceRow(product: product, l10n: l10n),
            const SizedBox(height: AppSpacing.md),
            Hero(
              tag: productHeroTag(product.id),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: JdImage(product.imageUrl),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            child,
            const SizedBox(height: AppSpacing.md),
            Text(l10n.whatsThis, style: AppTypography.title),
            const SizedBox(height: AppSpacing.xs),
            Text(product.description, style: AppTypography.body),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.product, required this.l10n});

  final Product product;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          l10n.mmkAmount(formatMmk(product.priceMmk)),
          style: AppTypography.title,
        ),
        if (product.isNew) ...[
          const SizedBox(width: AppSpacing.sm),
          OrangeBadge(l10n.productNew),
        ],
      ],
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          0,
          AppSpacing.screenEdge,
          AppSpacing.md,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              shape: const StadiumBorder(),
            ),
            child: AnimatedSwitcher(
              duration: AppMotion.quantityTick,
              child: Text(
                label,
                key: ValueKey(label),
                style: AppTypography.button,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Grey placeholder shapes while the product loads.
class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.screenEdge),
      child: SkeletonBox(height: 420, radius: AppRadius.xl),
    );
  }
}
