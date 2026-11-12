import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/failure.dart';
import 'package:jdonuts_test/features/auth/domain/validators/otp_validator.dart';

void main() {
  test('exactly six digits is accepted', () {
    expect(validateOtp('123456').valueOrNull, '123456');
  });
  test('any six digits is accepted even if not the correct code', () {
    expect(validateOtp('000000').isSuccess, isTrue);
  });
  test('five digits is rejected', () {
    expect(validateOtp('12345').failureOrNull, isA<InvalidOtp>());
  });
  test('seven digits is rejected', () {
    expect(validateOtp('1234567').failureOrNull, isA<InvalidOtp>());
  });
  test('letters are rejected', () {
    expect(validateOtp('12345a').failureOrNull, isA<InvalidOtp>());
  });
  test('Myanmar digits are rejected', () {
    expect(
      validateOtp('\u1041\u1042\u1043\u1044\u1045\u1046').failureOrNull,
      isA<InvalidOtp>(),
    );
  });
  test('spaces are rejected', () {
    expect(validateOtp('123 56').failureOrNull, isA<InvalidOtp>());
  });
  test('empty input is rejected', () {
    expect(validateOtp('').failureOrNull, isA<InvalidOtp>());
  });
}
