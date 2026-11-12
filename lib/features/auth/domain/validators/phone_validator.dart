import '../../../../core/failure.dart';
import '../../../../core/result.dart';

const String kMyanmarCountryCode = '+95';

final RegExp _nationalNumber = RegExp(r'^9\d{7,9}$');

/// Validates the part typed after the fixed +95 prefix.
///
/// Strips spaces, dashes and one leading 0, then requires `9` followed by
/// 7 to 9 digits. Returns the E.164 number, e.g. `09254135592` becomes
/// `+959254135592`.
Result<String> validateMyanmarPhone(String input) {
  var digits = input.replaceAll(RegExp(r'[\s-]'), '');
  if (digits.startsWith('0')) digits = digits.substring(1);
  if (!_nationalNumber.hasMatch(digits)) {
    return const FailureResult(InvalidPhone());
  }
  return Success('$kMyanmarCountryCode$digits');
}
