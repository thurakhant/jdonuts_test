// ignore_for_file: prefer_initializing_formals

import '../../../core/failure.dart';
import '../../../core/result.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';
import '../domain/session_store.dart';
import '../domain/validators/otp_validator.dart';

/// The only code the fake backend accepts.
const String kFakeOtp = '123456';

/// Fake backend: ~1 s latency per call, one correct OTP, users kept in
/// memory and mirrored to a [UserStore] so login survives relaunch.
class FakeAuthRepository implements AuthRepository {
  // Classic initializers on purpose: `required this._field` (private named
  // parameters, new in Dart 3.14) shows as an error in older editors.
  FakeAuthRepository({
    required SessionStore sessionStore,
    required UserStore userStore,
    this.delay = const Duration(seconds: 1),
  }) : _sessionStore = sessionStore,
       _userStore = userStore;

  final SessionStore _sessionStore;
  final UserStore _userStore;

  /// Artificial latency; use [Duration.zero] in tests.
  final Duration delay;

  List<AuthUser>? _users;
  final Map<String, int> _wrongAttempts = {};

  /// New numbers that asked for a sign-up code.
  final Set<String> _pendingSignUps = {};

  Future<List<AuthUser>> _loadUsers() async =>
      _users ??= List.of(await _userStore.readAll());

  Future<AuthUser?> _find(String phone) async {
    final users = await _loadUsers();
    for (final u in users) {
      if (u.phone == phone) return u;
    }
    return null;
  }

  Future<void> _latency() => Future<void>.delayed(delay);

  /// Storage errors become a typed [StorageFailure] instead of escaping.
  Future<Result<T>> _guarded<T>(Future<Result<T>> Function() call) async {
    try {
      return await call();
    } on Exception {
      return const FailureResult(StorageFailure());
    }
  }

  @override
  Future<Result<void>> register({
    required String phone,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
  }) async {
    await _latency();
    return _guarded(() async {
      if (await _find(phone) != null) {
        return const FailureResult(PhoneAlreadyRegistered());
      }
      final user = AuthUser(
        id: 'user-${phone.replaceAll('+', '')}',
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
      );
      // Save first; memory changes only once the save has worked.
      final updated = [...await _loadUsers(), user];
      await _userStore.writeAll(updated);
      _users = updated;
      _wrongAttempts.remove(phone);
      _pendingSignUps.remove(phone);
      return const Success(null);
    });
  }

  @override
  Future<Result<void>> requestOtp(String phone) async {
    await _latency();
    return _guarded(() async {
      if (await _find(phone) == null) {
        return const FailureResult(UnknownNumber());
      }
      return const Success(null);
    });
  }

  @override
  Future<Result<void>> requestSignUpCode(String phone) async {
    await _latency();
    return _guarded(() async {
      if (await _find(phone) != null) {
        return const FailureResult(PhoneAlreadyRegistered());
      }
      _pendingSignUps.add(phone);
      return const Success(null);
    });
  }

  @override
  Future<Result<void>> verifySignUpCode({
    required String phone,
    required String code,
  }) async {
    await _latency();
    if (!_pendingSignUps.contains(phone)) {
      return const FailureResult(UnknownNumber());
    }
    return switch (_codeProblem(phone, code)) {
      final problem? => FailureResult(problem),
      null => const Success(null),
    };
  }

  @override
  Future<Result<void>> resendOtp(String phone) async {
    await _latency();
    return _guarded(() async {
      final known = await _find(phone) != null;
      if (!known && !_pendingSignUps.contains(phone)) {
        return const FailureResult(UnknownNumber());
      }
      _wrongAttempts.remove(phone);
      return const Success(null);
    });
  }

  @override
  Future<Result<AuthUser>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    await _latency();
    return _guarded(() async {
      final user = await _find(phone);
      if (user == null) return const FailureResult(UnknownNumber());
      if (_codeProblem(phone, code) case final problem?) {
        return FailureResult(problem);
      }
      await _sessionStore.write(AuthSession.fromUser(user));
      return Success(user);
    });
  }

  /// Lock, shape and the fake code, shared by login and sign-up. Counts a
  /// wrong code; a right one clears the count.
  Failure? _codeProblem(String phone, String code) {
    final used = _wrongAttempts[phone] ?? 0;
    if (used >= kMaxOtpAttempts) return const OtpLocked();
    if (validateOtp(code) case FailureResult(:final failure)) return failure;
    if (code == kFakeOtp) {
      _wrongAttempts.remove(phone);
      return null;
    }
    final now = used + 1;
    _wrongAttempts[phone] = now;
    return now >= kMaxOtpAttempts
        ? const OtpLocked()
        : WrongOtp(attemptsLeft: kMaxOtpAttempts - now);
  }

  @override
  Future<Result<void>> signOut() async {
    await _latency();
    return _guarded(() async {
      await _sessionStore.clear();
      return const Success(null);
    });
  }

  @override
  Future<Result<AuthSession?>> currentSession() =>
      _guarded(() async => Success(await _sessionStore.read()));
}
