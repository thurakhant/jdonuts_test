import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/failure.dart';
import 'package:jdonuts_test/core/result.dart';
import 'package:jdonuts_test/features/auth/domain/validators/phone_validator.dart';

void main() {
  String? ok(String s) => validateMyanmarPhone(s).valueOrNull;

  test('phone with one leading zero is normalized to E.164', () {
    expect(ok('09254135592'), '+959254135592');
  });
  test('phone without leading zero is accepted', () {
    expect(ok('9254135592'), '+959254135592');
  });
  test('spaces and dashes are stripped', () {
    expect(ok('09 254-135 592'), '+959254135592');
  });
  test('only one leading zero is removed so a double zero fails', () {
    expect(validateMyanmarPhone('009254135592'), isA<FailureResult<String>>());
  });
  test('shortest valid number has 7 digits after the 9', () {
    expect(ok('91234567'), '+9591234567');
  });
  test('longest valid number has 9 digits after the 9', () {
    expect(ok('9123456789'), '+959123456789');
  });
  test('too short number is rejected', () {
    expect(validateMyanmarPhone('9123456').failureOrNull, isA<InvalidPhone>());
  });
  test('too long number is rejected', () {
    expect(
      validateMyanmarPhone('91234567890').failureOrNull,
      isA<InvalidPhone>(),
    );
  });
  test('number not starting with 9 is rejected', () {
    expect(
      validateMyanmarPhone('0812345678').failureOrNull,
      isA<InvalidPhone>(),
    );
  });
  test('letters are rejected', () {
    expect(
      validateMyanmarPhone('92541abc92').failureOrNull,
      isA<InvalidPhone>(),
    );
  });
  test('empty input is rejected', () {
    expect(validateMyanmarPhone('').failureOrNull, isA<InvalidPhone>());
  });
}
