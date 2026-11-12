import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../motion/app_motion.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// One tab in [PillNavBar]. Pass [iconBuilder] for an icon that is not in
/// the Material set (the crown).
class PillNavItem {
  const PillNavItem({required this.label, this.icon, this.iconBuilder})
    : assert(icon != null || iconBuilder != null, 'tab needs an icon');

  final IconData? icon;
  final Widget Function(Color color, double size)? iconBuilder;
  final String label;
}

/// Floating cyan bar with white icons. Only the selected tab shows its
/// label, inside a pink pill that slides between tabs. A pink band peeks
/// out behind the bar at the bottom edge.
class PillNavBar extends StatelessWidget {
  const PillNavBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<PillNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final height =
        AppSpacing.navBarHeight +
        AppSpacing.md +
        AppSpacing.navUnderlayHeight / 2;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: AppSpacing.navUnderlayHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xl),
                  ),
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.navUnderlayHeight / 2,
              height: AppSpacing.navBarHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: _Slots(
                  items: items,
                  selectedIndex: selectedIndex,
                  onSelected: onSelected,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lays out the tabs. The selected one is wider; its width and the pill
/// position both follow one animated "position" value, so the pill slides
/// while the slots resize around it.
class _Slots extends StatelessWidget {
  const _Slots({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<PillNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: selectedIndex.toDouble()),
      duration: AppMotion.effective(context, AppMotion.navPillSlide),
      curve: AppMotion.emphasized,
      builder: (context, pos, _) => LayoutBuilder(
        builder: (context, box) {
          // Slot weights: 1 each, plus a growing share for the tab the pill
          // is on.
          final weights = [
            for (var i = 0; i < items.length; i++)
              1 + AppSpacing.navPillGrow * math.max(0.0, 1 - (i - pos).abs()),
          ];
          final unit = box.maxWidth / weights.reduce((a, b) => a + b);
          final starts = <double>[];
          var x = 0.0;
          for (final w in weights) {
            starts.add(x);
            x += w * unit;
          }
          final lo = pos.floor().clamp(0, items.length - 1);
          final hi = pos.ceil().clamp(0, items.length - 1);
          final t = pos - pos.floor();
          final pillLeft = starts[lo] + (starts[hi] - starts[lo]) * t;
          final pillWidth = (1 + AppSpacing.navPillGrow) * unit;
          return Stack(
            children: [
              Positioned(
                left: pillLeft,
                width: pillWidth,
                top: AppSpacing.xs,
                bottom: AppSpacing.xs,
                child: const DecoratedBox(
                  key: ValueKey('nav-pill'),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppRadius.pill),
                    ),
                  ),
                ),
              ),
              for (var i = 0; i < items.length; i++)
                Positioned(
                  left: starts[i],
                  width: weights[i] * unit,
                  top: 0,
                  bottom: 0,
                  child: _Tab(
                    item: items[i],
                    selected: i == selectedIndex,
                    openness: math.max(0.0, 1 - (i - pos).abs()),
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.item,
    required this.selected,
    required this.openness,
    required this.onTap,
  });

  final PillNavItem item;
  final bool selected;

  /// 0 (closed) .. 1 (fully the pill's tab): fades the label in and out.
  final double openness;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        highlightShape: BoxShape.rectangle,
        child: Center(
          child: ClipRect(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                item.iconBuilder?.call(
                      AppColors.textOnPrimary,
                      AppSpacing.navIconSize,
                    ) ??
                    Icon(
                      item.icon,
                      color: AppColors.textOnPrimary,
                      size: AppSpacing.navIconSize,
                    ),
                if (openness > 0.55) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Opacity(
                      opacity: ((openness - 0.55) / 0.45).clamp(0.0, 1.0),
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
