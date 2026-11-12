/// Formats a Myanmar kyat amount with thousands separators: 3200 -> "3,200".
/// Pure Dart on purpose (no intl): the app only ever shows whole MMK.
String formatMmk(int amount) {
  final digits = amount.abs().toString();
  final buffer = StringBuffer(amount < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}
