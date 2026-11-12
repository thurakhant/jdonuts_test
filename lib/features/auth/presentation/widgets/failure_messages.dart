import '../../../../core/failure.dart';
import '../../../../l10n/app_localizations.dart';

/// Plain-language text for a validation or repository failure.
/// Failures with an inline link (unknown / taken number) are built by the
/// phone screen instead.
String failureMessage(AppLocalizations l10n, Failure failure) {
  return switch (failure) {
    InvalidPhone() => l10n.errorPhoneInvalid,
    WrongOtp(:final attemptsLeft) => l10n.errorOtpWrong(attemptsLeft),
    OtpLocked() => l10n.errorOtpLocked,
    InvalidFirstName(:final problem) ||
    InvalidLastName(:final problem) => _name(l10n, problem),
    InvalidDateOfBirth(:final problem) => _dob(l10n, problem),
    _ => l10n.errorGeneric,
  };
}

String _name(AppLocalizations l10n, NameProblem problem) => switch (problem) {
  NameProblem.empty => l10n.errorNameRequired,
  NameProblem.tooLong => l10n.errorNameTooLong,
  NameProblem.invalidCharacters => l10n.errorNameChars,
};

String _dob(AppLocalizations l10n, DateOfBirthProblem problem) {
  return switch (problem) {
    DateOfBirthProblem.incomplete ||
    DateOfBirthProblem.notARealDate => l10n.errorDobInvalid,
    DateOfBirthProblem.inTheFuture => l10n.errorDobFuture,
    DateOfBirthProblem.tooYoung => l10n.errorDobTooYoung,
  };
}
