import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';

/// Where each donut circle sits: alignment in the box, diameter as a
/// fraction of the box width, and the asset.
const List<(Alignment, double, String)> _circles = [
  (Alignment(-0.8, -0.7), 0.34, 'assets/images/product_berry_bliss.png'),
  (Alignment(0.7, -0.85), 0.28, 'assets/images/product_choco_drizzle.png'),
  (Alignment(0.05, -0.1), 0.42, 'assets/images/product_classic_glazed.png'),
  (Alignment(-0.95, 0.7), 0.26, 'assets/images/product_coconut.png'),
  (Alignment(0.9, 0.55), 0.32, 'assets/images/product_strawberry_sprinkle.png'),
];

/// Static collage of donut photos in circles for the Onboarding top half.
class OnboardingCollage extends StatelessWidget {
  const OnboardingCollage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) => Stack(
        children: [
          for (final (align, fraction, asset) in _circles)
            Align(
              alignment: align,
              child: _Circle(asset: asset, size: box.maxWidth * fraction),
            ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.asset, required this.size});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
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
