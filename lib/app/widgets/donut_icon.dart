import 'package:material_ui/material_ui.dart';

/// The nav bar's J'Donuts mark from the design screens: an outlined circle
/// with a horizontal band broken by a center dot (a donut seen from the side).
class DonutIcon extends StatelessWidget {
  const DonutIcon({required this.color, required this.size, super.key});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _DonutPainter(color));
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = Offset(s / 2, s / 2);
    final r = s * 0.42;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.09
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(c, r, stroke);
    canvas.drawLine(c + Offset(-r, 0), c + Offset(-s * 0.15, 0), stroke);
    canvas.drawLine(c + Offset(s * 0.15, 0), c + Offset(r, 0), stroke);
    canvas.drawCircle(c, s * 0.08, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) => oldDelegate.color != color;
}
