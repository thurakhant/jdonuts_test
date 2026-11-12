/// Base type for all expected (non-exceptional) failures.
sealed class Failure {
  const Failure();
}

/// Why a date of birth was rejected.
enum DateOfBirthProblem { incomplete, notARealDate, inTheFuture, tooYoung }

/// Why a name was rejected.
enum NameProblem { empty, tooLong, invalidCharacters }

/// Failures raised by the auth feature (validation and repository).
sealed class AuthFailure extends Failure {
  const AuthFailure();
}

final class InvalidPhone extends AuthFailure {
  const InvalidPhone();
}

final class InvalidOtp extends AuthFailure {
  const InvalidOtp();
}

final class WrongOtp extends AuthFailure {
  const WrongOtp({required this.attemptsLeft});
  final int attemptsLeft;
}

final class OtpLocked extends AuthFailure {
  const OtpLocked();
}

final class UnknownNumber extends AuthFailure {
  const UnknownNumber();
}

final class PhoneAlreadyRegistered extends AuthFailure {
  const PhoneAlreadyRegistered();
}

final class InvalidFirstName extends AuthFailure {
  const InvalidFirstName(this.problem);
  final NameProblem problem;
}

final class InvalidLastName extends AuthFailure {
  const InvalidLastName(this.problem);
  final NameProblem problem;
}

final class InvalidDateOfBirth extends AuthFailure {
  const InvalidDateOfBirth(this.problem);
  final DateOfBirthProblem problem;
}
