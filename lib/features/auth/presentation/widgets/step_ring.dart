import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../providers/registration_flow_provider.dart';
import '../providers/registration_flow_state.dart';

const double _ringSize = 40;
const double _ringStroke = 4;

/// Progress ring for the register flow. Animates from the previous step's
/// value to this one; with [complete] it morphs into a pink check circle.
class StepRing extends ConsumerStatefulWidget {
  const StepRing({required this.step, this.complete = false, super.key});

  final AuthStep step;
  final bool complete;

  @override
  ConsumerState<StepRing> createState() => _StepRingState();
}

class _StepRingState extends ConsumerState<StepRing> {
  late final double _from;

  @override
  void initState() {
    super.initState();
    final flow = ref.read(registrationFlowProvider.notifier);
    _from = ref.read(registrationFlowProvider).step.progress;
    Future.microtask(() => flow.setStep(widget.step));
  }

  @override
  Widget build(BuildContext context) {
    final isRegister = ref.watch(registrationFlowProvider).isRegister;
    if (!isRegister) return const SizedBox.shrink();
    final duration = AppMotion.effective(context, AppMotion.progressRing);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _from, end: widget.step.progress),
      duration: duration,
      curve: AppMotion.standard,
      builder: (context, value, _) => _RingFace(
        progress: value,
        complete: widget.complete,
        percentLabel: '${(value * 100).round()}',
      ),
    );
  }
}

class _RingFace extends StatelessWidget {
  const _RingFace({
    required this.progress,
    required this.complete,
    required this.percentLabel,
  });

  final double progress;
  final bool complete;
  final String percentLabel;

  @override
  Widget build(BuildContext context) {
    final morph = AppMotion.effective(context, AppMotion.ringMorphToCheck);
    return SizedBox.square(
      dimension: _ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: complete ? 0 : 1,
            duration: morph,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: _ringStroke,
              color: AppColors.accent,
              backgroundColor: AppColors.ringTrack,
              semanticsLabel: percentLabel,
            ),
          ),
          AnimatedScale(
            scale: complete ? 1 : 0,
            duration: morph,
            curve: AppMotion.pop,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(
                dimension: _ringSize,
                child: Icon(
                  Icons.check,
                  color: AppColors.textOnPrimary,
                  size: AppSpacing.lg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
