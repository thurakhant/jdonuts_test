import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure.dart';
import '../../../../core/result.dart';
import '../../application/auth_providers.dart';
import '../../domain/auth_repository.dart';
import '../../domain/validators/date_of_birth_validator.dart';
import '../../domain/validators/otp_validator.dart';
import '../../domain/validators/phone_validator.dart';
import 'registration_flow_state.dart';

/// Holds everything entered across Phone, OTP, Name and DOB, and runs the
/// calls to the auth repository. Submit methods return a [Failure] or null.
class RegistrationFlowNotifier extends Notifier<RegistrationFlowState> {
  @override
  RegistrationFlowState build() => const RegistrationFlowState();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  void start(AuthMode mode) => state = RegistrationFlowState(mode: mode);

  void switchMode(AuthMode mode) => state = state.copyWith(mode: mode);

  void setStep(AuthStep step) => state = state.copyWith(step: step);

  void setPhoneInput(String value) => state = state.copyWith(phoneInput: value);

  void setName({String? first, String? last}) =>
      state = state.copyWith(firstName: first, lastName: last);

  void setDob({int? month, String? day, String? year}) =>
      state = state.copyWith(month: month, day: day, year: year);

  /// Phone step. Login asks for an OTP (fails for unknown numbers).
  /// Register must not hit a registered number: the repository answers
  /// `requestOtp` with success only for known users, so success means taken.
  Future<Failure?> submitPhone() async {
    final phone = validateMyanmarPhone(state.phoneInput);
    if (phone case FailureResult(:final failure)) return failure;
    final e164 = phone.valueOrNull!;
    // Wrong-code attempts belong to a number: only a different number
    // starts fresh, so Back and the same number stay locked until Resend.
    state = e164 == state.phone
        ? state
        : state.copyWith(phone: e164, registerOtpMisses: 0, otpLocked: false);
    final sent = await _repo.requestOtp(e164);
    if (state.isRegister) {
      return switch (sent.failureOrNull) {
        null => const PhoneAlreadyRegistered(),
        UnknownNumber() => null,
        final other => other,
      };
    }
    return sent.failureOrNull;
  }

  /// OTP step. Login verifies (and signs in) through the repository.
  /// Register has no user yet, so the code is checked here with the same
  /// limits and verified through the repository after creating the account.
  Future<Failure?> verifyOtp(String code) async {
    final failure = await _check(code);
    if (failure is OtpLocked && !state.otpLocked) {
      state = state.copyWith(otpLocked: true);
    }
    return failure;
  }

  Future<Failure?> _check(String code) async {
    if (!state.isRegister) return _verifyLogin(code);
    final shape = validateOtp(code);
    if (shape case FailureResult(:final failure)) return failure;
    if (state.registerOtpMisses >= kMaxOtpAttempts) return const OtpLocked();
    if (_repo.acceptsSignUpCode(code)) {
      state = state.copyWith(otpCode: code);
      return null;
    }
    final misses = state.registerOtpMisses + 1;
    state = state.copyWith(registerOtpMisses: misses);
    return misses >= kMaxOtpAttempts
        ? const OtpLocked()
        : WrongOtp(attemptsLeft: kMaxOtpAttempts - misses);
  }

  Future<Failure?> _verifyLogin(String code) async {
    final result = await _repo.verifyOtp(phone: state.phone!, code: code);
    if (result.isSuccess) {
      await ref.read(currentSessionProvider.notifier).refresh();
    }
    return result.failureOrNull;
  }

  /// Sends a new code and clears the wrong-attempt counter and lock.
  Future<Failure?> resendOtp() async {
    if (state.isRegister) {
      state = state.copyWith(registerOtpMisses: 0, otpLocked: false);
      return null;
    }
    final failure = (await _repo.resendOtp(state.phone!)).failureOrNull;
    if (failure == null) state = state.copyWith(otpLocked: false);
    return failure;
  }

  /// DOB step: create the account, then verify the earlier code, which
  /// stores the session. The session is published later (Welcome) so the
  /// router does not skip the Welcome screen.
  Future<Failure?> completeRegistration() async {
    final dob = validateDateOfBirth(
      month: state.month,
      day: int.tryParse(state.day),
      year: int.tryParse(state.year),
    );
    if (dob case FailureResult(:final failure)) return failure;
    final registered = await _repo.register(
      phone: state.phone!,
      firstName: state.firstName.trim(),
      lastName: state.lastName.trim(),
      dateOfBirth: dob.valueOrNull!,
    );
    if (registered.failureOrNull case final failure?) return failure;
    final code = state.otpCode;
    if (code == null) return const InvalidOtp();
    final signedIn = await _repo.verifyOtp(phone: state.phone!, code: code);
    return signedIn.failureOrNull;
  }

  /// Publishes the stored session; the router then leaves the auth flow.
  Future<void> finish() => ref.read(currentSessionProvider.notifier).refresh();
}

final registrationFlowProvider =
    NotifierProvider<RegistrationFlowNotifier, RegistrationFlowState>(
      RegistrationFlowNotifier.new,
    );
