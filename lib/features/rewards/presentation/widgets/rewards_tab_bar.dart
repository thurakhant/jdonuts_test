import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Text tabs with a pink bar that slides under the selected one.
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
    return SizedBox(
      height: AppSpacing.tabBarHeight,
      child: Stack(
        children: [
          Row(
            children: [
              for (var i = 0; i < count; i++)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: i == selected,
                    child: InkWell(
                      onTap: () => onSelected(i),
                      child: Center(
                        child: Text(
                          labels[i],
                          style: AppTypography.title.copyWith(
                            color: i == selected
                                ? AppColors.accent
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          AnimatedAlign(
            key: const ValueKey('tab-indicator'),
            alignment: Alignment(
              count < 2 ? 0 : -1 + 2 * selected / (count - 1),
              1,
            ),
            duration: AppMotion.effective(context, AppMotion.tabIndicatorSlide),
            curve: AppMotion.emphasized,
            child: FractionallySizedBox(
              widthFactor: 1 / count,
              child: Container(
                height: AppSpacing.tabIndicatorHeight,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
