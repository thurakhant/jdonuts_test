import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';

/// Minus / count / plus in a light-grey capsule with a thin white outline,
/// as in the design screens. The count never drops below 1.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    required this.quantity,
    required this.onChanged,
    super.key,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.surface, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RoundButton(
              icon: Icons.remove,
              tooltip: l10n.decreaseQuantity,
              onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
            ),
            SizedBox(
              width: 48,
              child: AnimatedSwitcher(
                duration: AppMotion.effective(context, AppMotion.quantityTick),
                child: Text(
                  '$quantity',
                  key: ValueKey(quantity),
                  textAlign: TextAlign.center,
                  style: AppTypography.headline,
                ),
              ),
            ),
            _RoundButton(
              icon: Icons.add,
              tooltip: l10n.increaseQuantity,
              onPressed: () => onChanged(quantity + 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.navBarBlue,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.navBarBlue.withValues(alpha: 0.35),
        disabledForegroundColor: AppColors.textOnPrimary,
        minimumSize: const Size.square(AppSpacing.xl + AppSpacing.sm),
      ),
    );
  }
}
