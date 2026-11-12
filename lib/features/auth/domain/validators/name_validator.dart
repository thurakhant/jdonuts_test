import '../../../../core/failure.dart';
import '../../../../core/result.dart';

const int kMaxNameLength = 50;

/// Letters (any script, including Myanmar and its combining vowel signs)
/// and plain spaces only. Digits, Myanmar digits and symbols are rejected.
final RegExp _nameChars = RegExp(r'^[\p{L}\p{M} ]+$', unicode: true);

NameProblem? _check(String trimmed) {
  if (trimmed.isEmpty) return NameProblem.empty;
  if (trimmed.runes.length > kMaxNameLength) return NameProblem.tooLong;
  if (!_nameChars.hasMatch(trimmed)) return NameProblem.invalidCharacters;
  return null;
}

/// First name is required: 1-50 characters after trimming.
Result<String> validateFirstName(String input) {
  final trimmed = input.trim();
  final problem = _check(trimmed);
  return problem == null
      ? Success(trimmed)
      : FailureResult(InvalidFirstName(problem));
}

/// Last name is optional (many Myanmar names have none); an empty value
/// succeeds with an empty string. When present it follows the same rules.
Result<String> validateLastName(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return const Success('');
  final problem = _check(trimmed);
  return problem == null
      ? Success(trimmed)
      : FailureResult(InvalidLastName(problem));
}
