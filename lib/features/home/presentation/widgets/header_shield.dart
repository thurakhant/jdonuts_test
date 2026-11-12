import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';

/// Soft shield-with-star watermark behind the Home header, as in the design
/// screens. Decorative only, so it is excluded from semantics.
class HeaderShield extends StatelessWidget {
  const HeaderShield({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: const _ShieldPainter(),
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  const _ShieldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;

    // Rounded shield: flat top, sides tapering to a rounded bottom point.
    final shield = Path()
      ..moveTo(s * 0.18, s * 0.12)
      ..quadraticBezierTo(s * 0.5, s * 0.02, s * 0.82, s * 0.12)
      ..quadraticBezierTo(s * 0.94, s * 0.16, s * 0.92, s * 0.32)
      ..quadraticBezierTo(s * 0.88, s * 0.70, s * 0.5, s * 0.96)
      ..quadraticBezierTo(s * 0.12, s * 0.70, s * 0.08, s * 0.32)
      ..quadraticBezierTo(s * 0.06, s * 0.16, s * 0.18, s * 0.12)
      ..close();
    canvas.drawPath(shield, Paint()..color = AppColors.headerShield);

    // Five-point star in the shield's upper half.
    const points = 5;
    final center = Offset(s * 0.5, s * 0.42);
    final outer = s * 0.17;
    final inner = outer * 0.5;
    final star = Path();
    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? outer : inner;
      final angle = -90.0 + i * (360 / (points * 2));
      final p = center + Offset.fromDirection(angle * 3.14159 / 180, r);
      i == 0 ? star.moveTo(p.dx, p.dy) : star.lineTo(p.dx, p.dy);
    }
    star.close();
    canvas.drawPath(star, Paint()..color = AppColors.headerStar);
  }

  @override
  bool shouldRepaint(_ShieldPainter oldDelegate) => false;
}
