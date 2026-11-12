import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'placeholder_sheet.dart';

/// Standalone Google / Apple / Facebook brand marks, as in the design
/// screens (no button chrome); each opens the placeholder sheet and keeps
/// the full 48dp tap area.
class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = <(Widget, String)>[
      (const _GoogleMark(size: 26), l10n.continueWithGoogle),
      (
        const Icon(Icons.apple, size: 30, color: AppColors.brandApple),
        l10n.continueWithApple,
      ),
      (
        const Icon(Icons.facebook, size: 28, color: AppColors.brandFacebook),
        l10n.continueWithFacebook,
      ),
    ];
    // FittedBox keeps the row from overflowing on very narrow screens; at
    // normal phone widths it renders at full size.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final (icon, label) in items)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: IconButton(
                tooltip: label,
                icon: icon,
                onPressed: () => showPlaceholderSheet(context, title: label),
              ),
            ),
        ],
      ),
    );
  }
}

/// The multicolour Google "G", drawn with four arcs and the blue bar.
class _GoogleMark extends StatelessWidget {
  const _GoogleMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: const _GPainter());
  }
}

class _GPainter extends CustomPainter {
  const _GPainter();

  static const _red = AppColors.brandGoogleRed;
  static const _yellow = AppColors.brandGoogleYellow;
  static const _green = AppColors.brandGoogleGreen;
  static const _blue = AppColors.brandGoogleBlue;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final strokeWidth = s * 0.19;
    final rect = (Offset.zero & size).deflate(strokeWidth / 2 + s * 0.04);
    Paint paintFor(Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    const deg = 3.14159 / 180;
    canvas.drawArc(rect, 200 * deg, 105 * deg, false, paintFor(_red));
    canvas.drawArc(rect, 110 * deg, 92 * deg, false, paintFor(_yellow));
    canvas.drawArc(rect, 45 * deg, 67 * deg, false, paintFor(_green));
    canvas.drawArc(rect, 0 * deg, 46 * deg, false, paintFor(_blue));
    // The bar into the center.
    final c = Offset(s / 2, s / 2);
    canvas.drawRect(
      Rect.fromLTRB(
        c.dx + s * 0.04,
        c.dy - strokeWidth / 2,
        rect.right + strokeWidth / 2,
        c.dy + strokeWidth / 2,
      ),
      Paint()..color = _blue,
    );
  }

  @override
  bool shouldRepaint(_GPainter oldDelegate) => false;
}
