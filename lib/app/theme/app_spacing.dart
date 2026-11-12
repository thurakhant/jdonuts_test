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
  // Product cards per section, matching the design screens: Seasonal is a
  // wide landscape card; Popular and Order again are narrower cards with a
  // portrait and a square panel respectively.
  static const double productTileSize = 260;
  static const double productImageHeight = 174; // ~3:2 landscape
  static const double productCardNarrow = 160;
  static const double productImagePortrait = 240; // ~2:3
  static const double productImageSquare = 160; // 1:1
  static const double productLabelHeight = 64; // two-line name under image

  /// Bottom navigation bar and its icon size. The pill fills about half the
  /// bar's height in the mock, so the inset is generous.
  static const double navBarHeight = 64;
  static const double navIconSize = 20;
  static const double navPillInset = 14;
  static const double navUnderlayHeight = 18;
  static const double navPillGrow = 0.85;

  /// Rewards: points ring, tier ladder, tabs and challenge art. The ring is
  /// a thick frosting donut that bleeds off the right screen edge.
  static const double pointsRingSize = 250;
  static const double pointsRingStroke = 52;
  static const double pointsRingBleed = 56;
  static const double earnButtonHeight = 36;
  static const double iconSm = 18;
  static const double tierBadgeSize = 40;
  static const double tierLineStroke = 4;
  static const double tabBarHeight = 48;

  /// Home shop cards.
  static const double shopCardWidth = 280;
  static const double shopImageHeight = 150;
  static const double challengeArtSize = 88;
  static const double challengeStroke = 6;
  static const double ringSprinkleLength = 13;
  static const double ringSprinkleStroke = 4.5;

  /// Product detail: width of the "What's this?" side-label column.
  static const double whatsThisLabelWidth = 72;

  static const double skeletonLineWidth = 100;
  static const double skeletonLineHeight = 14;
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  /// Top corners of the bottom nav bar, rounder than the standard radii.
  static const double navBarTop = 32;

  /// Fully rounded (pill) buttons like CONTINUE.
  static const double pill = 999;
}
