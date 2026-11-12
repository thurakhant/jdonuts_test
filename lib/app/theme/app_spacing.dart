/// Spacing and radius tokens. Widgets use these instead of magic numbers.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Default horizontal screen padding.
  static const double screenEdge = 24;

  /// Gap between carousel page dots, and the dot sizes.
  static const double dotGap = 3;
  static const double dotSize = 6;
  static const double dotActiveWidth = 18;

  /// Horizontal product rows on Home: tile width and total row height.
  static const double productTileSize = 140;
  static const double productRowHeight = 200;

  /// Bottom navigation bar and its icon size.
  static const double navBarHeight = 64;
  static const double navIconSize = 24;
  static const double skeletonLineWidth = 100;
  static const double skeletonLineHeight = 14;
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  /// Fully rounded (pill) buttons like CONTINUE.
  static const double pill = 999;
}
