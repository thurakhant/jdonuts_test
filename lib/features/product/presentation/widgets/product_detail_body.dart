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

/// How far the quantity capsule hangs below the white card, so it straddles
/// the card's bottom edge as in the design screens.
const double _stepperOverlap = 28;

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
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenEdge,
              0,
              AppSpacing.screenEdge,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: _stepperOverlap),
                      child: _Card(product: product, l10n: l10n),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: QuantityStepper(
                          quantity: _quantity,
                          onChanged: (value) =>
                              setState(() => _quantity = value),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                // Description lives on the grey page, outside the card.
                _WhatsThisRow(l10n: l10n, description: product.description),
              ],
            ),
          ),
        ),
        _AddToCartBar(
          total: formatMmk(_quantity * product.priceMmk),
          onPressed: () => _addToCart(l10n),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.product, required this.l10n});

  final Product product;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl + AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(product.code, style: AppTypography.caption),
                ),
                if (product.isNew) OrangeBadge(l10n.productNew),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(product.name, style: AppTypography.display),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.mmkAmount(formatMmk(product.priceMmk)),
              style: AppTypography.title,
            ),
            const SizedBox(height: AppSpacing.lg),
            // Generous white space around the artwork, as in the design.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Hero(
                tag: productHeroTag(product.id),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: JdImage(product.imageUrl),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Side-label layout from the mock: a green "?" and "What's this?" on the
/// left, a thin white divider, the description in muted text on the right.
class _WhatsThisRow extends StatelessWidget {
  const _WhatsThisRow({required this.l10n, required this.description});

  final AppLocalizations l10n;
  final String description;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.whatsThisLabelWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.help,
                  color: AppColors.success,
                  size: AppSpacing.lg,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(l10n.whatsThis, style: AppTypography.title),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(width: 2, color: AppColors.surface),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              description,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({required this.total, required this.onPressed});

  final String total;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              backgroundColor: AppColors.navBarBlue,
              foregroundColor: AppColors.textOnPrimary,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: const StadiumBorder(),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.addToCartLabel, style: AppTypography.button),
                  const SizedBox(width: AppSpacing.md),
                  // A drawn divider, not a typed "|".
                  Container(
                    width: 1.5,
                    height: 18,
                    color: AppColors.textOnPrimary.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  AnimatedSwitcher(
                    duration: AppMotion.quantityTick,
                    child: Text(
                      l10n.mmkAmount(total),
                      key: ValueKey(total),
                      style: AppTypography.button,
                    ),
                  ),
                ],
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
