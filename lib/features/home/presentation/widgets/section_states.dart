import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/skeleton.dart';
import '../../../../l10n/app_localizations.dart';

/// Section title with a display-only chevron (no "see all" screen exists).
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.lg,
        AppSpacing.screenEdge,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTypography.title)),
          const DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xs + 2),
              child: Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Grey placeholder cards in the shape of product tiles.
class ProductRowSkeleton extends StatelessWidget {
  const ProductRowSkeleton({
    this.width = AppSpacing.productTileSize,
    this.imageHeight = AppSpacing.productImageHeight,
    super.key,
  });

  final double width;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: imageHeight + AppSpacing.productLabelHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(
              width: width,
              height: imageHeight,
              radius: AppRadius.lg,
            ),
            SizedBox(height: AppSpacing.sm),
            SkeletonBox(
              width: AppSpacing.skeletonLineWidth,
              height: AppSpacing.skeletonLineHeight,
              radius: AppRadius.sm,
            ),
          ],
        ),
      ),
    );
  }
}

/// Friendly message for an empty or failed section, with optional Retry.
class SectionMessage extends StatelessWidget {
  const SectionMessage({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenEdge,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(child: Text(message, style: AppTypography.caption)),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
        ],
      ),
    );
  }
}
