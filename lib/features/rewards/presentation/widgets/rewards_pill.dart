import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/entrance.dart';

/// Orange "Rewards" pill with a white count badge. The whole pill pops in.
class RewardsPill extends StatelessWidget {
  const RewardsPill({required this.label, required this.count, super.key});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return PopIn(
      delay: AppMotion.badgePopDelay,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.highlight,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.xs,
            AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.title.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Text(
                    '$count',
                    style: AppTypography.title.copyWith(
                      color: AppColors.highlight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
