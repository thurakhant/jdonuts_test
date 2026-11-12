import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Small orange pill ("50% off", "New") used on product tiles and detail.
/// The design outlines the large badges in white; [compact] is the smaller
/// borderless variant the narrow cards use.
class OrangeBadge extends StatelessWidget {
  const OrangeBadge(this.label, {this.compact = false, super.key});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.highlight,
        border: compact
            ? null
            : Border.all(color: AppColors.textOnPrimary, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: compact
            ? const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              )
            : const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm + AppSpacing.xs,
                vertical: AppSpacing.xs + 2,
              ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: compact ? 12 : 13,
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
