import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

/// EARN pill. Cyan and gently pulsing when the challenge is complete, grey
/// otherwise. Pressing only gives touch feedback. The pulse stays off under
/// Reduce Motion.
class EarnButton extends StatefulWidget {
  const EarnButton({required this.enabled, super.key});

  final bool enabled;

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
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, AppSpacing.earnButtonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          backgroundColor: enabled ? AppColors.primary : AppColors.skeletonBase,
          foregroundColor: enabled
              ? AppColors.textOnPrimary
              : AppColors.textSecondary,
          elevation: 0,
        ),
        child: Text(AppLocalizations.of(context)!.earnButton),
      ),
    );
  }
}
