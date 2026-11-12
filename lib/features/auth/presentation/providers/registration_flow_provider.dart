import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure.dart';
import '../../../../core/result.dart';
import '../../application/auth_providers.dart';
import '../../domain/auth_repository.dart';
import '../../domain/validators/date_of_birth_validator.dart';
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

  void setName({String? first, String? last}) {
    if (state.accountCreated) return;
    state = state.copyWith(firstName: first, lastName: last);
  }

  void setDob({int? month, String? day, String? year}) {
    if (state.accountCreated) return;
    state = state.copyWith(month: month, day: day, year: year);
  }

  /// Phone step: login asks for an OTP (fails for unknown numbers); sign-up
  /// asks for a sign-up code (fails for registered numbers).
  Future<Failure?> submitPhone() async {
    final phone = validateMyanmarPhone(state.phoneInput);
    if (phone case FailureResult(:final failure)) return failure;
    final e164 = phone.valueOrNull!;
    // The repository counts wrong codes per number, so Back and the same
    // number stay locked until Resend; a different number starts fresh.
    state = e164 == state.phone
        ? state
        : state.copyWith(phone: e164, otpLocked: false, accountCreated: false);
    if (!state.isRegister) return (await _repo.requestOtp(e164)).failureOrNull;
    final sent = await _repo.requestSignUpCode(e164);
    return switch (sent.failureOrNull) {
      // This flow already saved the account and is only retrying sign-in.
      PhoneAlreadyRegistered() when state.accountCreated => null,
      final failure => failure,
    };
  }

  /// OTP step. Login verifies and signs in; sign-up verifies the number, and
  /// the code signs in once the account exists (DOB step).
  Future<Failure?> verifyOtp(String code) async {
    final failure = await _check(code);
    if (failure is OtpLocked && !state.otpLocked) {
      state = state.copyWith(otpLocked: true);
    }
    return failure;
  }

  Future<Failure?> _check(String code) async {
    if (!state.isRegister) return _verifyLogin(code);
    final result = await _repo.verifySignUpCode(
      phone: state.phone!,
      code: code,
    );
    if (result.isSuccess) state = state.copyWith(otpCode: code);
    return result.failureOrNull;
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
    final code = state.otpCode;
    if (code == null) return const InvalidOtp();
    if (!state.accountCreated) {
      final registered = await _repo.register(
        phone: state.phone!,
        firstName: state.firstName.trim(),
        lastName: state.lastName.trim(),
        dateOfBirth: dob.valueOrNull!,
      );
      if (registered.failureOrNull case final failure?) return failure;
      state = state.copyWith(accountCreated: true);
    }
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
