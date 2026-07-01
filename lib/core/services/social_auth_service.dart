import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

/// Acquires a Google/Apple ID token on-device, then exchanges it for our
/// session via [AuthController.socialLogin].
class SocialAuthService {
  SocialAuthService._();
  static final SocialAuthService instance = SocialAuthService._();

  final GoogleSignIn _google = GoogleSignIn(scopes: ['email', 'profile']);

  Future<void> signInWithGoogle() async {
    try {
      final account = await _google.signIn();
      if (account == null) return; // user cancelled
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        Get.snackbar('Google', 'Could not obtain Google token.', snackPosition: SnackPosition.BOTTOM);
        return;
      }
      await Get.find<AuthController>().socialLogin('google', idToken);
    } catch (e) {
      Get.snackbar('Google sign-in', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final idToken = credential.identityToken;
      if (idToken == null) {
        Get.snackbar('Apple', 'Could not obtain Apple token.', snackPosition: SnackPosition.BOTTOM);
        return;
      }
      await Get.find<AuthController>().socialLogin('apple', idToken);
    } catch (e) {
      Get.snackbar('Apple sign-in', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
