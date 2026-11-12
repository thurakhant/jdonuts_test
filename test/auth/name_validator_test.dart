import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/failure.dart';
import 'package:jdonuts_test/features/auth/domain/validators/name_validator.dart';

void main() {
  group('first name', () {
    test('latin letters are accepted', () {
      expect(validateFirstName('Aung').valueOrNull, 'Aung');
    });
    test('surrounding whitespace is trimmed', () {
      expect(validateFirstName('  Aung ').valueOrNull, 'Aung');
    });
    test('spaces inside the name are allowed', () {
      expect(validateFirstName('Aung Kyaw').isSuccess, isTrue);
    });
    test('Myanmar script is accepted', () {
      expect(
        validateFirstName(
          '\u1019\u1031\u102C\u1004\u103A\u1019\u1031\u102C\u1004\u103A',
        ).isSuccess,
        isTrue,
      );
    });
    test('empty name is required', () {
      final f = validateFirstName('   ').failureOrNull;
      expect(f, isA<InvalidFirstName>());
      expect((f! as InvalidFirstName).problem, NameProblem.empty);
    });
    test('51 characters is too long', () {
      final f = validateFirstName('a' * 51).failureOrNull;
      expect((f! as InvalidFirstName).problem, NameProblem.tooLong);
    });
    test('50 characters is accepted', () {
      expect(validateFirstName('a' * 50).isSuccess, isTrue);
    });
    test('digits are rejected', () {
      final f = validateFirstName('Aung2').failureOrNull;
      expect((f! as InvalidFirstName).problem, NameProblem.invalidCharacters);
    });
    test('Myanmar digits are rejected', () {
      expect(
        validateFirstName('\u1019\u1031\u102C\u1004\u103A\u1045').failureOrNull,
        isA<InvalidFirstName>(),
      );
    });
    test('symbols are rejected', () {
      expect(validateFirstName('Aung!').failureOrNull, isA<InvalidFirstName>());
      expect(
        validateFirstName('Aung-Kyaw').failureOrNull,
        isA<InvalidFirstName>(),
      );
    });
  });

  group('last name', () {
    test('empty last name is allowed', () {
      expect(validateLastName('').valueOrNull, '');
    });
    test('whitespace-only last name is treated as empty', () {
      expect(validateLastName('   ').valueOrNull, '');
    });
    test('Myanmar script is accepted', () {
      expect(
        validateLastName('\u1026\u1038\u1000\u103B\u1031\u102C\u103A')
            .isSuccess,
        isTrue,
      );
    });
    test('digits are rejected when present', () {
      expect(validateLastName('Lin3').failureOrNull, isA<InvalidLastName>());
    });
    test('symbols are rejected when present', () {
      expect(validateLastName('Lin@').failureOrNull, isA<InvalidLastName>());
    });
    test('51 characters is too long', () {
      final f = validateLastName('b' * 51).failureOrNull;
      expect((f! as InvalidLastName).problem, NameProblem.tooLong);
    });
  });
}
