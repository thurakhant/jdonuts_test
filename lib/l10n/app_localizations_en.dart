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

  @override
  String get placeholderSheetTitle => 'Coming soon';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get registerLink => 'register';

  @override
  String get logInLink => 'log in';

  @override
  String get errorPhoneInvalid => 'Enter a valid Myanmar mobile number.';

  @override
  String errorPhoneUnknown(String register) {
    return 'This number hasn\'t registered yet. Want to $register?';
  }

  @override
  String errorPhoneTaken(String logIn) {
    return 'This number is already registered. Want to $logIn?';
  }

  @override
  String errorOtpWrong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tries left',
      one: '1 try left',
    );
    return 'That code is wrong. $_temp0.';
  }

  @override
  String get errorOtpLocked =>
      'Too many wrong codes. Tap Resend to get a new one.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get resendActive => 'Resend';

  @override
  String get errorNameRequired => 'Please enter your name.';

  @override
  String get errorNameTooLong => 'That name is too long (50 characters max).';

  @override
  String get errorNameChars => 'Names can only contain letters and spaces.';

  @override
  String get errorDobInvalid => 'That isn\'t a real date.';

  @override
  String get errorDobFuture => 'Date of birth can\'t be in the future.';

  @override
  String get errorDobTooYoung => 'You must be at least 13 to sign up.';

  @override
  String get monthPickerTitle => 'Choose a month';

  @override
  String get month1 => 'January';

  @override
  String get month2 => 'February';

  @override
  String get month3 => 'March';

  @override
  String get month4 => 'April';

  @override
  String get month5 => 'May';

  @override
  String get month6 => 'June';

  @override
  String get month7 => 'July';

  @override
  String get month8 => 'August';

  @override
  String get month9 => 'September';

  @override
  String get month10 => 'October';

  @override
  String get month11 => 'November';

  @override
  String get month12 => 'December';

  @override
  String get offlineBanner => 'You\'re offline — showing saved data';

  @override
  String get seasonalSpecials => 'Seasonal specials';

  @override
  String get popularSection => 'Popular 🔥';

  @override
  String get orderAgain => 'Order again';

  @override
  String pointsLeftToTier(String points, String tier) {
    return '$points points left to become $tier Member';
  }

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String discountOff(int percent) {
    return '$percent% off';
  }

  @override
  String get productNew => 'New';

  @override
  String shopsNearYou(int count) {
    return 'There are $count J\'Donut shops near you 😊';
  }

  @override
  String get orderOnline => 'Order Online';

  @override
  String get exploreNow => 'Explore now';

  @override
  String get sectionEmpty => 'Nothing here yet.';

  @override
  String get sectionError => 'We couldn\'t load this section.';

  @override
  String get retry => 'Retry';

  @override
  String get errorCatalogMalformed =>
      'The saved menu data looks broken. Please try again.';

  @override
  String get errorCatalogUnavailable =>
      'We couldn\'t read the menu data. Please try again.';

  @override
  String get errorStorage =>
      'We couldn\'t open your saved data. Please try again.';

  @override
  String get refreshFailed => 'Couldn\'t refresh. Showing saved data.';

  @override
  String mmkAmount(String amount) {
    return '$amount MMK';
  }

  @override
  String get whatsThis => 'What\'s this?';

  @override
  String addToCartButton(String total) {
    return 'ADD TO CART | $total MMK';
  }

  @override
  String addedToCart(int count, String name) {
    return 'Added $count x $name to your cart';
  }

  @override
  String get productNotFound => 'We couldn\'t find that product.';

  @override
  String get backLabel => 'Back';

  @override
  String get decreaseQuantity => 'Decrease quantity';

  @override
  String get increaseQuantity => 'Increase quantity';
}
