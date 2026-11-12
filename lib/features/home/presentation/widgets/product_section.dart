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
  ({double width, double imageHeight, bool framed}) get _cardLayout =>
      switch (section) {
        ProductSection.seasonal => (
          width: AppSpacing.productTileSize,
          imageHeight: AppSpacing.productImageHeight,
          framed: false,
        ),
        ProductSection.popular => (
          width: AppSpacing.productCardNarrow,
          imageHeight: AppSpacing.productImagePortrait,
          framed: true,
        ),
        ProductSection.orderAgain => (
          width: AppSpacing.productCardNarrow,
          imageHeight: AppSpacing.productImageSquare,
          framed: true,
        ),
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final products = ref.watch(productsBySectionProvider(section));
    final (:width, :imageHeight, :framed) = _cardLayout;
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
              : _HorizontalProductList(
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

class _HorizontalProductList extends StatelessWidget {
  const _HorizontalProductList(
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
