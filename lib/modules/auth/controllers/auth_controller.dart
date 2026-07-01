import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/core/services/api_auth_service.dart';
import 'package:musaab_adam/core/services/role_service.dart';
import 'package:musaab_adam/core/services/token_storage_service.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/data/models/auth/user_model.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class AuthController extends GetxController {
  final storage = GetStorage();

  // Observables used by screens and navigation
  final RxBool isSeller = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // Holds the email that is awaiting verification — passed to VerifyEmailScreen
  final RxString pendingEmail = ''.obs;

  // Reset session token returned by verify-reset-otp — used by NewPasswordScreen
  final RxString resetSessionToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }

  // ─── Session Restore ────────────────────────────────────────────────────────

  Future<void> _restoreSession() async {
    final hasSession = await TokenStorageService.instance.hasValidSession();
    if (!hasSession) return;

    try {
      final user = await ApiAuthService.instance.getMyProfile();
      _applyUser(user);
      Get.offAllNamed(AppRoutes.mainScreen);
    } catch (_) {
      // Token invalid or expired — stay on sign-in screen
      await TokenStorageService.instance.clearTokens();
    }
  }

  // ─── Login ──────────────────────────────────────────────────────────────────

  Future<void> login(String email, String password) async {
    if (isLoading.value) return;
    _clearError();
    isLoading.value = true;

    try {
      final result = await ApiAuthService.instance.login(email: email, password: password);
      await TokenStorageService.instance.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await TokenStorageService.instance.saveUser(result.user);
      _applyUser(result.user);
      Get.offAllNamed(AppRoutes.mainScreen);
    } on DioException catch (e) {
      errorMessage.value = ApiAuthService.extractError(e);
      Get.snackbar('Login failed', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Register ───────────────────────────────────────────────────────────────

  Future<void> register(String email, String password, {String? referralCode}) async {
    if (isLoading.value) return;
    _clearError();
    isLoading.value = true;

    try {
      final result = await ApiAuthService.instance.register(
        email: email,
        password: password,
        referralCode: (referralCode != null && referralCode.trim().isNotEmpty) ? referralCode.trim() : null,
      );
      pendingEmail.value = result.email;
      Get.offAndToNamed(AppRoutes.verifyEmailScreen);
    } on DioException catch (e) {
      errorMessage.value = ApiAuthService.extractError(e);
      Get.snackbar('Registration failed', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Verify Email OTP ───────────────────────────────────────────────────────

  Future<void> verifyEmailOtp(String otp) async {
    final email = pendingEmail.value;
    if (email.isEmpty) {
      Get.snackbar('Error', 'Session lost. Please sign up again.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final result = await ApiAuthService.instance.verifyEmailOtp(email: email, otp: otp);
      await TokenStorageService.instance.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await TokenStorageService.instance.saveUser(result.user);
      _applyUser(result.user);
      Get.offAndToNamed(AppRoutes.accountVerifiedScreen);
    } on DioException catch (e) {
      Get.snackbar('Verification failed', ApiAuthService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Resend Verification ────────────────────────────────────────────────────

  Future<void> resendVerification() async {
    final email = pendingEmail.value;
    if (email.isEmpty) return;
    isLoading.value = true;

    try {
      await ApiAuthService.instance.resendVerification(email);
      Get.snackbar('Code sent', 'Check your inbox for the 6-digit code.', snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiAuthService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Forgot Password ────────────────────────────────────────────────────────

  Future<void> forgotPassword(String email) async {
    if (isLoading.value) return;
    _clearError();
    isLoading.value = true;

    try {
      await ApiAuthService.instance.forgotPassword(email);
      pendingEmail.value = email;
      // Navigate to OTP entry screen (repurposed check-email screen)
      Get.toNamed(AppRoutes.checkEmailScreen);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiAuthService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Verify Reset OTP ───────────────────────────────────────────────────────

  Future<void> verifyResetOtp(String otp) async {
    final email = pendingEmail.value;
    if (email.isEmpty) {
      Get.snackbar('Error', 'Session lost. Please start over.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final token = await ApiAuthService.instance.verifyResetOtp(email: email, otp: otp);
      resetSessionToken.value = token;
      Get.toNamed(AppRoutes.newPasswordScreen);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiAuthService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Reset Password ─────────────────────────────────────────────────────────
  // Returns true on success so the screen can show its success dialog.
  Future<bool> resetPassword(String newPassword) async {
    final token = resetSessionToken.value;
    if (token.isEmpty) {
      Get.snackbar('Error', 'Session expired. Please start over.', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (isLoading.value) return false;
    isLoading.value = true;

    try {
      await ApiAuthService.instance.resetPassword(resetToken: token, newPassword: newPassword);
      resetSessionToken.value = '';
      pendingEmail.value = '';
      return true;
    } on DioException catch (e) {
      Get.snackbar('Error', ApiAuthService.extractError(e), snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Save Profile (after registration) ──────────────────────────────────────

  Future<void> saveProfile({required String displayName, String? bio}) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final user = await ApiAuthService.instance.updateProfile(
        displayName: displayName.trim().isNotEmpty ? displayName.trim() : null,
        bio: bio?.trim().isNotEmpty == true ? bio!.trim() : null,
      );
      await TokenStorageService.instance.saveUser(user);
      _applyUser(user);
      Get.offAllNamed(AppRoutes.mainScreen);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiAuthService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Logout ─────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    try {
      final refreshToken = await TokenStorageService.instance.getRefreshToken();
      if (refreshToken != null) {
        await ApiAuthService.instance.logout(refreshToken);
      }
    } catch (_) {
      // Best-effort — always clear local session
    } finally {
      await TokenStorageService.instance.clearTokens();
      _resetState();
      Get.offAllNamed(AppRoutes.signInScreen);
    }
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  void _applyUser(UserModel user) {
    currentUser.value = user;
    final role = Role.fromString(user.role);
    isSeller.value = role == Role.seller;
    Get.find<RoleService>().updateRole(role);
    // Keep legacy GetStorage key in sync
    storage.write(ApiConstants.userKey, user.toJson());
  }

  void _resetState() {
    currentUser.value = null;
    isSeller.value = false;
    errorMessage.value = '';
    Get.find<RoleService>().updateRole(Role.buyer);
  }

  void _clearError() => errorMessage.value = '';

}
