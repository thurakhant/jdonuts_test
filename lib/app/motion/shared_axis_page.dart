import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'app_motion.dart';

/// A horizontal shared-axis transition: the new step slides in from the
/// right while fading, and the old step slides slightly left and fades out.
/// Under Reduce Motion the step simply appears.
CustomTransitionPage<void> sharedAxisPage({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppMotion.effective(context, AppMotion.pageTransition),
    reverseTransitionDuration: AppMotion.effective(
      context,
      AppMotion.pageTransition,
    ),
    transitionsBuilder: (context, animation, secondary, child) {
      final inCurve = animation.drive(CurveTween(curve: AppMotion.emphasized));
      final outCurve = secondary.drive(CurveTween(curve: AppMotion.emphasized));
      return SlideTransition(
        position: outCurve.drive(
          Tween(begin: Offset.zero, end: -AppMotion.sharedAxisSlide),
        ),
        child: FadeTransition(
          opacity: ReverseAnimation(outCurve),
          child: SlideTransition(
            position: inCurve.drive(
              Tween(begin: AppMotion.sharedAxisSlide, end: Offset.zero),
            ),
            child: FadeTransition(opacity: inCurve, child: child),
          ),
        ),
      );
    },
  );
}
