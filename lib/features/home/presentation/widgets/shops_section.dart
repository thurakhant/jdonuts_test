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
import 'section_states.dart';

class ShopsSection extends ConsumerWidget {
  const ShopsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final shops = ref.watch(shopsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shops.maybeWhen(
          data: (items) => SectionHeader(l10n.shopsNearYou(items.length)),
          orElse: () => const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenEdge,
              AppSpacing.lg,
              AppSpacing.screenEdge,
              AppSpacing.sm,
            ),
            child: SkeletonBox(width: 220, height: 18, radius: AppRadius.sm),
          ),
        ),
        shops.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
            child: SkeletonBox(height: 160, radius: AppRadius.lg),
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
              : Column(children: [for (final s in items) _ShopCard(s)]),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        0,
        AppSpacing.screenEdge,
        AppSpacing.md,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JdImage(shop.imageUrl, height: 140, width: double.infinity),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: AppTypography.title),
                    const SizedBox(height: AppSpacing.xs),
                    Text(shop.address, style: AppTypography.caption),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Text(
                          l10n.exploreNow,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(l10n.orderOnline, style: AppTypography.caption),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
