import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_test/core/failure.dart';
import 'package:jdonuts_test/features/auth/domain/validators/date_of_birth_validator.dart';

void main() {
  final now = DateTime(2026, 6, 15);

  DateOfBirthProblem? problem(int? m, int? d, int? y) {
    final f = validateDateOfBirth(
      month: m,
      day: d,
      year: y,
      now: now,
    ).failureOrNull;
    return f is InvalidDateOfBirth ? f.problem : null;
  }

  test('minimum age constant is 13', () {
    expect(kMinimumAgeYears, 13);
  });
  test('a valid adult date is accepted', () {
    final r = validateDateOfBirth(month: 5, day: 20, year: 1995, now: now);
    expect(r.valueOrNull, DateTime(1995, 5, 20));
  });
  test('missing values are incomplete', () {
    expect(problem(null, 1, 2000), DateOfBirthProblem.incomplete);
    expect(problem(1, null, 2000), DateOfBirthProblem.incomplete);
    expect(problem(1, 1, null), DateOfBirthProblem.incomplete);
  });
  test('31 April is not a real date', () {
    expect(problem(4, 31, 2000), DateOfBirthProblem.notARealDate);
  });
  test('month 13 is not a real date', () {
    expect(problem(13, 1, 2000), DateOfBirthProblem.notARealDate);
  });
  test('29 February is rejected in a non-leap year', () {
    expect(problem(2, 29, 2001), DateOfBirthProblem.notARealDate);
  });
  test('29 February is accepted in a leap year', () {
    expect(problem(2, 29, 2000), isNull);
  });
  test('a future date is rejected', () {
    expect(problem(6, 16, 2026), DateOfBirthProblem.inTheFuture);
  });
  test('someone who turns 13 today is accepted', () {
    expect(problem(6, 15, 2013), isNull);
  });
  test('someone who turns 13 tomorrow is too young', () {
    expect(problem(6, 16, 2013), DateOfBirthProblem.tooYoung);
  });
  test('a 5 year old is too young', () {
    expect(problem(1, 1, 2021), DateOfBirthProblem.tooYoung);
  });
  test('today as injected reference is used rather than the real clock', () {
    final r = validateDateOfBirth(
      month: 1,
      day: 1,
      year: 2010,
      now: DateTime(2030, 1, 1),
    );
    expect(r.isSuccess, isTrue);
  });
}
