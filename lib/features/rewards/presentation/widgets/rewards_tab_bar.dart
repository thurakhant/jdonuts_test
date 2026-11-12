import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Two compact grey pills with white outlines; one sky-blue pill slides
/// between them to mark the selected tab.
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

  static const double _border = 2;
  static const _padding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.xs + 2,
  );

  TextStyle _style(bool isSelected) => AppTypography.body.copyWith(
    color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
  );

  /// Pill sizes come from the bold label, so a pill keeps its size when it
  /// is selected and the sliding pill can match it exactly.
  Size _pillSize(BuildContext context, String label) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: _style(true)),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final size = Size(
      painter.width + _padding.horizontal + 2 * _border,
      painter.height + _padding.vertical + 2 * _border,
    );
    painter.dispose();
    return size;
  }

  @override
  Widget build(BuildContext context) {
    final sizes = [for (final label in labels) _pillSize(context, label)];
    final lefts = <double>[];
    var x = 0.0;
    for (final size in sizes) {
      lefts.add(x);
      x += size.width + AppSpacing.xs;
    }
    final width = x - AppSpacing.xs;
    final pillHeight = sizes.first.height;
    final height = pillHeight > AppSpacing.tabBarHeight
        ? pillHeight
        : AppSpacing.tabBarHeight;
    final top = (height - pillHeight) / 2;
    final duration = AppMotion.effective(context, AppMotion.tabIndicatorSlide);

    // Scales the pair down together, and only when it cannot fit.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenEdge),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                for (var i = 0; i < labels.length; i++)
                  Positioned(
                    left: lefts[i],
                    top: top,
                    width: sizes[i].width,
                    height: pillHeight,
                    child: const _Pill(color: AppColors.surfaceMuted),
                  ),
                AnimatedPositioned(
                  key: const ValueKey('tab-indicator'),
                  duration: duration,
                  curve: AppMotion.standard,
                  left: lefts[selected],
                  top: top,
                  width: sizes[selected].width,
                  height: pillHeight,
                  child: const _Pill(color: AppColors.navBarBlue),
                ),
                for (var i = 0; i < labels.length; i++)
                  Positioned(
                    left: lefts[i],
                    top: 0,
                    width: sizes[i].width,
                    height: height,
                    child: Semantics(
                      button: true,
                      selected: i == selected,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onSelected(i),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: duration,
                            style: _style(i == selected),
                            child: Text(labels[i], maxLines: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: AppColors.surface,
          width: RewardsTabBar._border,
        ),
      ),
    );
  }
}
