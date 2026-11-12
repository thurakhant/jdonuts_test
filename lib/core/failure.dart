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

/// Failures raised by the local data layer (database and catalog source).
sealed class DataFailure extends Failure {
  const DataFailure();
}

/// The catalog JSON (seed or, later, a server response) could not be parsed.
final class MalformedCatalog extends DataFailure {
  const MalformedCatalog([this.detail = '']);
  final String detail;
}

/// The catalog source could not be read (asset missing, or network down once
/// a real HTTP source replaces the bundled one).
final class CatalogUnavailable extends DataFailure {
  const CatalogUnavailable();
}

/// The local database failed to read or write.
final class StorageFailure extends DataFailure {
  const StorageFailure();
}
