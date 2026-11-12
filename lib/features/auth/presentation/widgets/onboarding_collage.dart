import 'package:material_ui/material_ui.dart';

import '../../../../app/motion/app_motion.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/entrance.dart';

/// Where each donut circle sits, as in the design screens: center fractions
/// of the box (so edges can bleed off-screen) and diameter as a fraction of
/// the box width. The purple donut shows on both sides in the mock.
const List<(double, double, double, String)> _circles = [
  (-0.02, 0.02, 0.44, 'assets/images/product_classic_glazed.png'),
  (1.04, 0.16, 0.42, 'assets/images/product_choco_drizzle.png'),
  (-0.04, 0.64, 0.42, 'assets/images/product_berry_bliss.png'),
  (1.05, 0.66, 0.42, 'assets/images/product_berry_bliss.png'),
  (0.50, 0.98, 0.48, 'assets/images/product_coconut.png'),
  (0.50, 0.42, 0.56, 'assets/images/product_strawberry_sprinkle.png'),
];

/// Onboarding hero: the sprinkle donut front and center, neighbors bleeding
/// off the screen edges, and the lower artwork fading into the white page.
class OnboardingCollage extends StatelessWidget {
  const OnboardingCollage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: LayoutBuilder(
        builder: (context, box) => Stack(
          clipBehavior: Clip.none,
          children: [
            for (final (i, (cx, cy, fraction, asset)) in _circles.indexed)
              Positioned(
                left: cx * box.maxWidth - fraction * box.maxWidth / 2,
                top: cy * box.maxHeight - fraction * box.maxWidth / 2,
                width: fraction * box.maxWidth,
                height: fraction * box.maxWidth,
                child: StaggeredEntrance(
                  index: i,
                  duration: AppMotion.onboardingDrift,
                  slide: AppMotion.driftSlide,
                  child: _Circle(asset: asset),
                ),
              ),
            // Fades the lower artwork into the white page; text below the
            // collage stays sharp.
            const Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00F9EEF2), AppColors.blushPink],
                      stops: [0.55, 0.98],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
      ),
      clipBehavior: Clip.antiAlias,
      child: ExcludeSemantics(
        child: Image.asset(asset, fit: BoxFit.cover, cacheWidth: 300),
      ),
    );
  }
}
