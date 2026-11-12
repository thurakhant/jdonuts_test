import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/format/mmk.dart';

void main() {
  test('groups thousands', () {
    expect(formatMmk(3200), '3,200');
    expect(formatMmk(680000), '680,000');
    expect(formatMmk(1290000), '1,290,000');
  });

  test('leaves small numbers alone', () {
    expect(formatMmk(0), '0');
    expect(formatMmk(500), '500');
    expect(formatMmk(999), '999');
    expect(formatMmk(1000), '1,000');
  });

  test('handles negatives', () => expect(formatMmk(-12500), '-12,500'));
}
