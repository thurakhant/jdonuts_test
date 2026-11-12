import '../../../../core/failure.dart';
import '../../../../core/result.dart';

/// Minimum age in years to register.
const int kMinimumAgeYears = 13;

const int _earliestYear = 1900;

/// Validates a date of birth entered as separate month, day and year values.
///
/// [now] is injectable so tests are deterministic.
Result<DateTime> validateDateOfBirth({
  required int? month,
  required int? day,
  required int? year,
  DateTime? now,
}) {
  if (month == null || day == null || year == null) {
    return const FailureResult(
      InvalidDateOfBirth(DateOfBirthProblem.incomplete),
    );
  }
  final today = now ?? DateTime.now();
  final date = DateTime(year, month, day);
  // DateTime rolls invalid dates over (31 April -> 1 May); detect that.
  final isReal =
      year >= _earliestYear &&
      date.year == year &&
      date.month == month &&
      date.day == day;
  if (!isReal) {
    return const FailureResult(
      InvalidDateOfBirth(DateOfBirthProblem.notARealDate),
    );
  }
  final todayDate = DateTime(today.year, today.month, today.day);
  if (date.isAfter(todayDate)) {
    return const FailureResult(
      InvalidDateOfBirth(DateOfBirthProblem.inTheFuture),
    );
  }
  var age = todayDate.year - date.year;
  if (todayDate.month < date.month ||
      (todayDate.month == date.month && todayDate.day < date.day)) {
    age--;
  }
  if (age < kMinimumAgeYears) {
    return const FailureResult(InvalidDateOfBirth(DateOfBirthProblem.tooYoung));
  }
  return Success(date);
}
