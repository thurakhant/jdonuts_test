import '../../../../core/failure.dart';
import '../../../../core/result.dart';

const int kOtpLength = 6;

final RegExp _otpPattern = RegExp(r'^[0-9]{6}$');

/// Checks only the shape of the code (exactly 6 ASCII digits).
/// Whether it is the right code is the repository's job.
Result<String> validateOtp(String input) {
  if (!_otpPattern.hasMatch(input)) return const FailureResult(InvalidOtp());
  return Success(input);
}
