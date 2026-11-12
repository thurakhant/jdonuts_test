import 'package:material_ui/material_ui.dart';

/// Design color tokens taken from the J'Donuts design screens.
///
/// Widgets never hard-code a [Color]; they read these tokens (usually
/// through [ThemeData] / `Theme.of(context)`).
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF59C9E8); // cyan CTA buttons, nav bar
  static const Color accent = Color(0xFFEE5A8E); // hot-pink links, ring, pill
  static const Color highlight = Color(
    0xFFF7941D,
  ); // orange badges (New, % off)
  static const Color rewardsOrange = Color(0xFFEF863C); // Rewards header tab

  // Home header panel (peach) and its shield watermark.
  static const Color headerPeach = Color(0xFFFBEADB);
  static const Color headerShield = Color(0xFFF2DABF);
  static const Color headerStar = Color(0xFFCBB49C);

  // Banner card backgrounds cycle through these.
  static const Color bannerPurple = Color(0xFF6C5DD3);

  // Bottom navigation, sampled from the design screens: softer than the
  // brand cyan and pink used elsewhere.
  static const Color navBarBlue = Color(0xFF7ACCE8);
  static const Color navBarPink = Color(0xFFE0639E);

  // Onboarding page blush, sampled from the design screens.
  static const Color blushPink = Color(0xFFF9EEF2);

  // Surfaces
  static const Color background = Color(0xFFF4F5F7);
  static const Color backgroundPink = Color(0xFFFCE4EC); // soft pink wash
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF5F5F7);

  // Text
  static const Color textPrimary = Color(0xFF32313A);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Feedback
  static const Color error = Color(0xFFE0404A);
  static const Color success = Color(0xFF4CAF50);

  // Rewards tiers
  static const Color tierSilver = Color(0xFFB0BEC5);
  static const Color tierGold = Color(0xFFE8C34A);
  static const Color tierPlatinum = Color(0xFF9FD8EF);

  // Decorative
  static const Color donutPink = Color(0xFFF48FB1);
  static const Color ringTrack = Color(0xFFB1DDF6); // pale blue ring track
  static const Color skeletonBase = Color(0xFFEDEDF0);
  static const Color skeletonShine = Color(0xFFF8F8FA);
}
