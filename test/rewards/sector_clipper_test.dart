import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/features/rewards/presentation/widgets/challenge_painters.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  const size = Size(100, 100);
  // A point in each quarter of the circle, clockwise from 12 o'clock.
  const topRight = Offset(70, 30);
  const bottomRight = Offset(70, 70);
  const bottomLeft = Offset(30, 70);
  const topLeft = Offset(30, 30);

  test('a full sweep keeps the whole circle', () {
    final path = const SectorClipper(2 * math.pi).getClip(size);
    for (final p in [topRight, bottomRight, bottomLeft, topLeft]) {
      expect(path.contains(p), isTrue, reason: '$p');
    }
  });

  test('a quarter sweep keeps only the first quarter', () {
    final path = const SectorClipper(math.pi / 2).getClip(size);
    expect(path.contains(topRight), isTrue);
    expect(path.contains(bottomRight), isFalse);
    expect(path.contains(bottomLeft), isFalse);
    expect(path.contains(topLeft), isFalse);
  });
}
