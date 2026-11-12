import 'package:material_ui/material_ui.dart';

/// Every animation duration and curve in the app lives here, as the spec
/// asks: "Keep durations and curves as named constants in one motion file."
abstract final class AppMotion {
  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration staggerStep = Duration(milliseconds: 80);
  static const Duration onboardingDrift = Duration(milliseconds: 700);
  static const Duration progressRing = Duration(milliseconds: 450);
  static const Duration ringMorphToCheck = Duration(milliseconds: 350);
  static const Duration otpShake = Duration(milliseconds: 450);
  static const Duration buttonPress = Duration(milliseconds: 110);
  static const Duration skeletonShimmer = Duration(milliseconds: 1200);
  static const Duration pointsRingSweep = Duration(milliseconds: 1400);
  static const Duration pointsCountUp = Duration(milliseconds: 1600);
  static const Duration tierLadderStep = Duration(milliseconds: 220);
  static const Duration tabIndicatorSlide = Duration(milliseconds: 280);
  static const Duration cardStagger = Duration(milliseconds: 90);
  static const Duration badgePop = Duration(milliseconds: 500);
  static const Duration navPillSlide = Duration(milliseconds: 300);
  static const Duration heroFlight = Duration(milliseconds: 400);
  static const Duration bannerAutoAdvance = Duration(seconds: 4);
  static const Duration bannerSlide = Duration(milliseconds: 500);
  static const Duration quantityTick = Duration(milliseconds: 180);

  // Curves
  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;
  static const Curve enter = Curves.easeOutBack;
  static const Curve exit = Curves.easeInCubic;
  static const Curve pop = Curves.elasticOut;
  static const Curve sweep = Curves.easeInOutCubic;

  /// Honors the OS "Reduce Motion" setting: callers shorten or skip
  /// decorative animations when this returns true.
  static bool reduceMotion(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  /// Picks a duration respecting Reduce Motion.
  static Duration effective(BuildContext context, Duration duration) =>
      reduceMotion(context) ? Duration.zero : duration;
}
