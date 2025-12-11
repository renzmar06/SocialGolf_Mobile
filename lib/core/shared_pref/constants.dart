class Constants {
  /// Preference Keys
  static String accessToken = 'accessToken';

  static String preCustomerIdKey = 'customerId';
  static String prefReferralCode = 'referral_code';
  static String prefRoleIdKey = 'roleId';
  static String prefFirstNameKey = 'firstName';
  static String prefLastNameKey = 'lastName';
  static String fcmToken = 'fcmToken';
  static String prefNameKey = 'name';
  static String prefPhoneNumberKey = 'phoneNumber';
  static String prefPasswordKey = 'password';
  static String prefEmailAddressKey = 'email';

  // CHANGE: Add constants for "Remember Me" feature
  static const String prefRememberMe = 'remember_me';
  static const String prefRememberedEmail = 'remembered_email';
  static const String prefRememberedPassword = 'remembered_password';

  static String prefShowHome = 'ShowHome';
  static String prefIsLoggedIn = 'isLoggedIn';
  static String prefInternetCheck = 'InternetCheck';

  // static String termConditionURL = 'https://pay10.ae/terms-of-service/';
  // static String privacyPolicyURL = 'https://pay10.ae/privacy-policy/';

  static String iOSReviewURL =
      "https://apps.apple.com/app/id6739810874?action=write-review";
  static String androidReviewURL =
      "https://play.google.com/store/apps/details?id=ae.payten.wallet.app&reviewId=0";

}

String returnSelectedLang(String currentLang) {
  switch (currentLang) {
    case 'en':
      return "English";
    case 'ar':
      return "Arabic";
  }
  return "";
}
