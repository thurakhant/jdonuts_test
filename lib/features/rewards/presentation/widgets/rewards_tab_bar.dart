import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Two pill tabs on a light grey track. The cyan pill slides to the
/// selected tab.
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
    final count = labels.length;
    final radius = BorderRadius.circular(AppRadius.pill);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: radius,
      ),
      child: SizedBox(
        height: AppSpacing.tabBarHeight,
        child: Stack(
          children: [
            AnimatedAlign(
              key: const ValueKey('tab-indicator'),
              alignment: Alignment(
                count < 2 ? 0 : -1 + 2 * selected / (count - 1),
                0,
              ),
              duration: AppMotion.effective(
                context,
                AppMotion.tabIndicatorSlide,
              ),
              curve: AppMotion.emphasized,
              child: FractionallySizedBox(
                widthFactor: 1 / count,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: radius,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                for (var i = 0; i < count; i++)
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: i == selected,
                      child: InkWell(
                        borderRadius: radius,
                        onTap: () => onSelected(i),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: AppMotion.effective(
                              context,
                              AppMotion.tabIndicatorSlide,
                            ),
                            style: AppTypography.title.copyWith(
                              color: i == selected
                                  ? AppColors.textOnPrimary
                                  : AppColors.textPrimary,
                            ),
                            child: Text(labels[i]),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
