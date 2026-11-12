import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/widgets/entrance.dart';

/// Compact orange "Rewards" tab with a white count badge, flush against the
/// right screen edge: only its left corners are rounded. It pops in.
class RewardsPill extends StatelessWidget {
  const RewardsPill({required this.label, required this.count, super.key});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final text = AppTypography.body.copyWith(
      color: AppColors.textOnPrimary,
      fontWeight: FontWeight.w700,
    );
    return PopIn(
      delay: AppMotion.badgePopDelay,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.rewardsOrange,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(AppRadius.pill),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: text),
              const SizedBox(width: AppSpacing.xs + 2),
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    height: 1,
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
