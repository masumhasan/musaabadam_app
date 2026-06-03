import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'signIn': 'Sign In',
      'email': 'Email',
      'password': 'Password',
      'enterEmail': 'Enter email',
      'enterPassword': 'Enter password',
      'forgotPassword': 'Forgot password?',
      'dontHaveAnAccount': 'Don’t have an account? ',
      'signUp': 'Sign Up',
    },
    // Add additional languages here as needed:
    // 'ar_SA': { ... },
    // 'es_ES': { ... },
    // 'fr_FR': { ... },
    // 'de_DE': { ... },
    // 'hi_IN': { ... },
    // 'id_ID': { ... },
    // 'pt_BR': { ... },
  };
}