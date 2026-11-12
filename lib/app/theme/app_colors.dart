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

  // Surfaces
  static const Color background = Color(0xFFFFF7F9);
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
  static const Color ringTrack = Color(0xFFBDE9F6); // pale cyan ring track
  static const Color skeletonBase = Color(0xFFEDEDF0);
  static const Color skeletonShine = Color(0xFFF8F8FA);
}
