import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Two compact pills side by side: the selected one is sky blue, the other
/// sits on a light grey pill with a white outline.
class RewardsTabBar extends StatelessWidget {
  const RewardsTabBar({
    required this.labels,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          _TabPill(
            key: i == selected ? const ValueKey('tab-indicator') : null,
            label: labels[i],
            selected: i == selected,
            onTap: () => onSelected(i),
          ),
        ],
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.pill);
    // The pill itself is slim; the transparent margin keeps the tap target
    // at the 48px accessibility minimum.
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSpacing.tabBarHeight),
          child: Center(
            widthFactor: 1,
            child: AnimatedContainer(
              duration: AppMotion.effective(
                context,
                AppMotion.tabIndicatorSlide,
              ),
              curve: AppMotion.standard,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs + 2,
              ),
              decoration: BoxDecoration(
                color: selected ? AppColors.navBarBlue : AppColors.surfaceMuted,
                borderRadius: radius,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
              child: Text(
                label,
                style: AppTypography.body.copyWith(
                  color: selected
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
