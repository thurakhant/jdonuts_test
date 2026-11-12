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

  @override
  Future<Result<void>> register({
    required String phone,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
  }) async {
    await _latency();
    if (await _find(phone) != null) {
      return const FailureResult(PhoneAlreadyRegistered());
    }
    final users = await _loadUsers();
    users.add(
      AuthUser(
        id: 'user-${phone.replaceAll('+', '')}',
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
      ),
    );
    await _userStore.writeAll(users);
    _wrongAttempts.remove(phone);
    return const Success(null);
  }

  @override
  Future<Result<void>> requestOtp(String phone) async {
    await _latency();
    if (await _find(phone) == null) {
      return const FailureResult(UnknownNumber());
    }
    return const Success(null);
  }

  @override
  Future<Result<void>> resendOtp(String phone) async {
    final result = await requestOtp(phone);
    if (result.isSuccess) _wrongAttempts.remove(phone);
    return result;
  }

  @override
  Future<Result<AuthUser>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    await _latency();
    final user = await _find(phone);
    if (user == null) return const FailureResult(UnknownNumber());
    final used = _wrongAttempts[phone] ?? 0;
    if (used >= kMaxOtpAttempts) return const FailureResult(OtpLocked());
    final shape = validateOtp(code);
    if (shape case FailureResult(:final failure)) {
      return FailureResult(failure);
    }
    if (code != kFakeOtp) {
      final now = used + 1;
      _wrongAttempts[phone] = now;
      if (now >= kMaxOtpAttempts) return const FailureResult(OtpLocked());
      return FailureResult(WrongOtp(attemptsLeft: kMaxOtpAttempts - now));
    }
    _wrongAttempts.remove(phone);
    await _sessionStore.write(AuthSession.fromUser(user));
    return Success(user);
  }

  @override
  bool acceptsSignUpCode(String code) => code == kFakeOtp;

  @override
  Future<void> signOut() async {
    await _latency();
    await _sessionStore.clear();
  }

  @override
  Future<AuthSession?> currentSession() => _sessionStore.read();
}
