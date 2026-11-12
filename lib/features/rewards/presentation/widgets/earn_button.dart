import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

/// EARN pill. Cyan and gently pulsing while the reward is ready to claim,
/// grey otherwise; after a claim it reads CLAIMED and stays disabled. The
/// pulse stays off under Reduce Motion.
class EarnButton extends StatefulWidget {
  const EarnButton({
    required this.enabled,
    required this.onPressed,
    this.claimed = false,
    super.key,
  });

  /// Ready to claim: complete and not yet claimed.
  final bool enabled;
  final bool claimed;
  final VoidCallback onPressed;

  @override
  State<EarnButton> createState() => _EarnButtonState();
}

class _EarnButtonState extends State<EarnButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.earnPulse,
  );
  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: AppMotion.earnPulseScale,
  ).animate(CurvedAnimation(parent: _controller, curve: AppMotion.sweep));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(EarnButton old) {
    super.didUpdateWidget(old);
    _syncPulse();
  }

  void _syncPulse() {
    final pulse = widget.enabled && !AppMotion.reduceMotion(context);
    if (pulse && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!pulse) {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    return ScaleTransition(
      scale: _scale,
      child: ElevatedButton(
        onPressed: enabled ? widget.onPressed : null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, AppSpacing.earnButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          backgroundColor: enabled
              ? AppColors.navBarBlue
              : AppColors.skeletonBase,
          foregroundColor: enabled
              ? AppColors.textOnPrimary
              : AppColors.textSecondary,
          disabledBackgroundColor: AppColors.skeletonBase,
          disabledForegroundColor: AppColors.textSecondary,
          elevation: 0,
        ),
        child: Text(
          widget.claimed
              ? AppLocalizations.of(context)!.claimedButton
              : AppLocalizations.of(context)!.earnButton,
        ),
      ),
    );
  }
}
