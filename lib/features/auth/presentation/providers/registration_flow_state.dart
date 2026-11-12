/// Which journey the user is on.
enum AuthMode { register, login }

/// Steps that drive the progress ring (phone 25% ... DOB 100%).
enum AuthStep {
  onboarding(0),
  phone(1),
  otp(2),
  name(3),
  dob(4);

  const AuthStep(this.number);
  final int number;

  static const int totalSteps = 4;

  double get progress => number / totalSteps;
}

/// Everything entered so far, kept here (not in widgets) so Back never
/// loses input.
class RegistrationFlowState {
  const RegistrationFlowState({
    this.mode = AuthMode.register,
    this.step = AuthStep.onboarding,
    this.phoneInput = '',
    this.phone,
    this.otpCode,
    this.registerOtpMisses = 0,
    this.firstName = '',
    this.lastName = '',
    this.month,
    this.day = '',
    this.year = '',
  });

  final AuthMode mode;
  final AuthStep step;

  /// Raw text in the phone field (after the +95 prefix).
  final String phoneInput;

  /// Normalized E.164 number once the phone step passed.
  final String? phone;

  /// The accepted code, kept so registration can sign in at the end.
  final String? otpCode;

  /// Wrong codes so far in register mode, where the repository cannot yet
  /// check the code because the user does not exist.
  final int registerOtpMisses;
  final String firstName;
  final String lastName;

  /// 1-12, or null until picked.
  final int? month;
  final String day;
  final String year;

  bool get isRegister => mode == AuthMode.register;

  RegistrationFlowState copyWith({
    AuthMode? mode,
    AuthStep? step,
    String? phoneInput,
    String? phone,
    String? otpCode,
    int? registerOtpMisses,
    String? firstName,
    String? lastName,
    int? month,
    String? day,
    String? year,
  }) {
    return RegistrationFlowState(
      mode: mode ?? this.mode,
      step: step ?? this.step,
      phoneInput: phoneInput ?? this.phoneInput,
      phone: phone ?? this.phone,
      otpCode: otpCode ?? this.otpCode,
      registerOtpMisses: registerOtpMisses ?? this.registerOtpMisses,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      month: month ?? this.month,
      day: day ?? this.day,
      year: year ?? this.year,
    );
  }
}
