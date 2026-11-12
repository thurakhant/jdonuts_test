// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'J\'Donuts';

  @override
  String get onboardingTitle => 'Round food for\nevery mood';

  @override
  String get letsGetStarted => 'LET\'S GET STARTED';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get logIn => 'Log In';

  @override
  String legalNotice(String termsOfUse, String privacyPolicy) {
    return 'By continuing, you acknowledge that you have read and agree to our $termsOfUse and $privacyPolicy.';
  }

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get phonePrefixMm => '+95';

  @override
  String get continueLabel => 'CONTINUE';

  @override
  String get verifyYourNumber => 'Verify your number';

  @override
  String otpSentTo(String phone) {
    return 'We\'ve sent 6 digit OTP to $phone';
  }

  @override
  String get didntReceiveCode => 'Didn\'t receive the code?';

  @override
  String resendIn(String time) {
    return 'resend in $time min';
  }

  @override
  String get resendNow => 'Resend now';

  @override
  String get whatsYourName => 'What\'s your name?';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get whatsYourDateOfBirth => 'What\'s your date of birth?';

  @override
  String get month => 'Month';

  @override
  String get day => 'Day';

  @override
  String get year => 'Year';

  @override
  String get welcomeTitle => 'Welcome to the\nworld of J\'donuts';

  @override
  String get letsExplore => 'LET\'S EXPLORE';

  @override
  String get homeTab => 'Home';

  @override
  String get rewardTab => 'Reward';

  @override
  String get settingsTab => 'Settings';

  @override
  String get logOut => 'Log out';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get placeholderSheetBody =>
      'This is a placeholder. No real integration in this demo.';
}
