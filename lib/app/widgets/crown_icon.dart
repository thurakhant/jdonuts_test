import 'package:material_ui/material_ui.dart';

/// Outline crown with dotted tips, as in the nav-bar mock. Material icons
/// ship no crown, so it is drawn by hand.
class CrownIcon extends StatelessWidget {
  const CrownIcon({required this.color, required this.size, super.key});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _CrownPainter(color),
    );
  }
}

class _CrownPainter extends CustomPainter {
  const _CrownPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.085
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final body = Path()
      ..moveTo(s * 0.22, s * 0.72)
      ..lineTo(s * 0.16, s * 0.38)
      ..lineTo(s * 0.37, s * 0.54)
      ..lineTo(s * 0.50, s * 0.28)
      ..lineTo(s * 0.63, s * 0.54)
      ..lineTo(s * 0.84, s * 0.38)
      ..lineTo(s * 0.78, s * 0.72)
      ..close();
    canvas.drawPath(body, stroke);

    final dot = Paint()..color = color;
    for (final tip in [
      Offset(s * 0.14, s * 0.30),
      Offset(s * 0.50, s * 0.18),
      Offset(s * 0.86, s * 0.30),
    ]) {
      canvas.drawCircle(tip, s * 0.055, dot);
    }
  }

  @override
  bool shouldRepaint(_CrownPainter oldDelegate) =>
      oldDelegate.color != color;
}
