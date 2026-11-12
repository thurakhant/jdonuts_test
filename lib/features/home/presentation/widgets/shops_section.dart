import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/failure_text.dart';
import '../../../../app/widgets/jd_image.dart';
import '../../../../app/widgets/skeleton.dart';
import '../../../../core/db/database_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_providers.dart';
import '../../domain/shop.dart';
import '../../../../app/widgets/section_message.dart';

/// Shops panel at the bottom of Home: sky-blue landscape backdrop with the
/// "shops near you" headline, an EXPLORE NOW pill and a horizontal card
/// carousel, as in the design screens.
class ShopsSection extends ConsumerWidget {
  const ShopsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final shops = ref.watch(shopsProvider);
    return shops.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.screenEdge),
        child: SkeletonBox(height: 220, radius: AppRadius.lg),
      ),
      error: (error, _) => SectionMessage(
        message: '${l10n.sectionError} ${dataErrorMessage(l10n, error)}',
        onRetry: () {
          ref.invalidate(catalogReadyProvider);
          ref.invalidate(shopsProvider);
        },
      ),
      data: (items) => items.isEmpty
          ? SectionMessage(message: l10n.sectionEmpty)
          : _ShopsPanel(items),
    );
  }
}

class _ShopsPanel extends StatelessWidget {
  const _ShopsPanel(this.shops);

  final List<Shop> shops;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/shops_backdrop.png',
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            // Until the illustration asset lands, a flat sky-to-meadow
            // gradient stands in so the layout reads the same.
            errorBuilder: (_, _, _) => const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.55, 0.78, 1.0],
                  colors: [
                    AppColors.primary,
                    Color(0xFFA9DFF2),
                    Color(0xFFB4E08A),
                    Color(0xFF8CCB62),
                  ],
                ),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.xl,
                AppSpacing.screenEdge,
                0,
              ),
              child: Text(
                l10n.shopsNearYou(shops.length),
                style: AppTypography.headline.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenEdge,
              ),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppRadius.pill),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(
                    l10n.exploreNow.toUpperCase(),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Only four shops, so a plain scroll row is fine; it takes the
            // tallest card's height, so larger text never overflows.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenEdge,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, shop) in shops.indexed) ...[
                      if (i > 0) const SizedBox(width: AppSpacing.md),
                      _ShopCard(shop),
                    ],
                  ],
                ),
              ),
            ),
            // Keeps the meadow visible under the nav bar the shell draws
            // over this panel.
            SizedBox(
              height: AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
            ),
          ],
        ),
      ],
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard(this.shop);

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: AppSpacing.shopCardWidth,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: JdImage(
                  shop.imageUrl,
                  height: AppSpacing.shopImageHeight,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(shop.name, style: AppTypography.title, maxLines: 1),
              const SizedBox(height: AppSpacing.xs),
              Text(
                shop.address,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Order Online sits right under the address, as in the design.
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.orderOnline,
                style: AppTypography.caption.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
