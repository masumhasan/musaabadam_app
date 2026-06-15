import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_auth_service.dart';
import 'package:musaab_adam/core/services/token_storage_service.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

enum CredentialChangeStep { form, otp }

class ChangeCredentialController extends GetxController {
  // ── Determined from navigation argument ───────────────────────────────────
  late final bool isPasswordChange;

  // ── Step tracking ─────────────────────────────────────────────────────────
  final Rx<CredentialChangeStep> step = CredentialChangeStep.form.obs;

  // ── Form fields ───────────────────────────────────────────────────────────
  final newEmailController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  // ── OTP digit boxes ───────────────────────────────────────────────────────
  final List<TextEditingController> otpDigits =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isPasswordChange = (Get.arguments as Map?)?['isPasswordChange'] ?? false;
  }

  @override
  void onClose() {
    newEmailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    for (final c in otpDigits) { c.dispose(); }
    for (final f in otpFocusNodes) { f.dispose(); }
    super.onClose();
  }

  // ── Step 1: Send OTP ──────────────────────────────────────────────────────

  Future<void> sendCode() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      if (isPasswordChange) {
        await ApiAuthService.instance.initiatePasswordChange(
          currentPassword: currentPasswordController.text.trim(),
          newPassword: newPasswordController.text.trim(),
        );
      } else {
        await ApiAuthService.instance.initiateEmailChange(
          newEmail: newEmailController.text.trim(),
        );
      }
      _clearOtp();
      step.value = CredentialChangeStep.otp;
      Get.snackbar(
        'Code sent',
        isPasswordChange
            ? 'A 6-digit verification code was sent to your email.'
            : 'A 6-digit code was sent to your new email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on DioException catch (e) {
      Get.snackbar('Error', ApiAuthService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Step 2: Verify OTP ────────────────────────────────────────────────────

  Future<void> verifyOtp() async {
    final otp = otpDigits.map((c) => c.text).join();
    if (otp.length < 6) {
      Get.snackbar('Enter code', 'Please enter all 6 digits.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      if (isPasswordChange) {
        await ApiAuthService.instance.verifyPasswordChange(
          otp: otp,
          newPassword: newPasswordController.text.trim(),
        );
        Get.back();
        Get.snackbar('Success', 'Password changed successfully.', snackPosition: SnackPosition.BOTTOM);
      } else {
        final updatedUser = await ApiAuthService.instance.verifyEmailChange(otp: otp);
        await TokenStorageService.instance.saveUser(updatedUser);
        Get.find<AuthController>().currentUser.value = updatedUser;
        Get.back();
        Get.snackbar('Success', 'Email updated successfully.', snackPosition: SnackPosition.BOTTOM);
      }
    } on DioException catch (e) {
      Get.snackbar('Error', ApiAuthService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Resend: go back to form ────────────────────────────────────────────────

  void backToForm() {
    _clearOtp();
    step.value = CredentialChangeStep.form;
  }

  // ── OTP box helpers ───────────────────────────────────────────────────────

  void onDigitChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      final chars = digits.split('').take(6).toList();
      for (int i = 0; i < chars.length && i < 6; i++) { otpDigits[i].text = chars[i]; }
      final next = chars.length < 6 ? chars.length : 5;
      otpFocusNodes[next].requestFocus();
      return;
    }
    if (value.isNotEmpty && index < 5) {
      otpFocusNodes[index + 1].requestFocus();
    }
  }

  void onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        otpDigits[index].text.isEmpty &&
        index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  void _clearOtp() {
    for (final c in otpDigits) { c.clear(); }
  }
}
