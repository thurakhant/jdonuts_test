import '../../../core/result.dart';
import 'auth_user.dart';

/// Number of wrong OTP codes allowed before the number is locked.
const int kMaxOtpAttempts = 3;

abstract interface class AuthRepository {
  /// Creates an account and sends an OTP. Fails with `PhoneAlreadyRegistered`.
  /// [phone] is E.164 (see the phone validator).
  Future<Result<void>> register({
    required String phone,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
  });

  /// Sends an OTP for login. Fails with `UnknownNumber` if not registered.
  Future<Result<void>> requestOtp(String phone);

  /// Sign-up only: whether [code] is the code that was sent. There is no
  /// account yet, so this neither signs in nor counts attempts.
  bool acceptsSignUpCode(String code);

  /// Sends a new OTP and clears the wrong-attempt counter and lock.
  Future<Result<void>> resendOtp(String phone);

  /// Checks the code. Fails with `WrongOtp` (with attempts left) and, after
  /// [kMaxOtpAttempts] wrong codes, `OtpLocked`. On success signs the user in.
  Future<Result<AuthUser>> verifyOtp({
    required String phone,
    required String code,
  });

  /// Forgets the session. Fails with `StorageFailure` if it can't be removed.
  Future<Result<void>> signOut();

  /// The remembered session, or null when signed out. Fails with
  /// `StorageFailure` if secure storage can't be read.
  Future<Result<AuthSession?>> currentSession();
}
