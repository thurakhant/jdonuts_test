import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/widgets/failure_text.dart';
import '../../../../core/db/database_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../product/application/product_providers.dart';
import '../../../product/domain/product.dart';
import 'product_card.dart';
import '../../../../app/widgets/section_message.dart';
import 'section_states.dart';

/// One horizontal product list (header + tiles, skeleton, empty or error).
class ProductSectionView extends ConsumerWidget {
  const ProductSectionView({
    required this.section,
    required this.title,
    super.key,
  });

  final ProductSection section;
  final String title;

  /// Card width, panel height and framing per section, as in the design
  /// screens: Seasonal wide landscape, Popular portrait, Order again square.
  (double, double, bool) get _dims => switch (section) {
    ProductSection.seasonal => (
      AppSpacing.productTileSize,
      AppSpacing.productImageHeight,
      false,
    ),
    ProductSection.popular => (
      AppSpacing.productCardNarrow,
      AppSpacing.productImagePortrait,
      true,
    ),
    ProductSection.orderAgain => (
      AppSpacing.productCardNarrow,
      AppSpacing.productImageSquare,
      true,
    ),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final products = ref.watch(productsBySectionProvider(section));
    final (width, imageHeight, framed) = _dims;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title),
        products.when(
          loading: () =>
              ProductRowSkeleton(width: width, imageHeight: imageHeight),
          error: (error, _) => SectionMessage(
            message: '${l10n.sectionError} ${dataErrorMessage(l10n, error)}',
            onRetry: () {
              ref.invalidate(catalogReadyProvider);
              ref.invalidate(productsBySectionProvider(section));
            },
          ),
          data: (items) => items.isEmpty
              ? SectionMessage(message: l10n.sectionEmpty)
              : _Row(
                  items,
                  width: width,
                  imageHeight: imageHeight,
                  framed: framed,
                ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(
    this.items, {
    required this.width,
    required this.imageHeight,
    required this.framed,
  });

  final List<Product> items;
  final double width;
  final double imageHeight;
  final bool framed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: imageHeight + AppSpacing.productLabelHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, i) => ProductCard(
          product: items[i],
          width: width,
          imageHeight: imageHeight,
          framed: framed,
        ),
      ),
    );
  }
}
