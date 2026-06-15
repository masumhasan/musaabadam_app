import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../controllers/change_credential_controller.dart';

class ChangeCredentialScreen extends GetView<ChangeCredentialController> {
  const ChangeCredentialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: controller.isPasswordChange ? 'Change Password' : 'Change Email',
          fontWeight: FontWeight.w700,
          translate: false,
        ),
      ),
      body: Obx(() {
        return controller.step.value == CredentialChangeStep.form
            ? _FormStep(controller: controller, colorScheme: colorScheme)
            : _OtpStep(controller: controller, colorScheme: colorScheme);
      }),
    );
  }
}

// ── Step 1: Form ──────────────────────────────────────────────────────────────

class _FormStep extends StatelessWidget {
  const _FormStep({required this.controller, required this.colorScheme});

  final ChangeCredentialController controller;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: controller.isPasswordChange
                ? 'Enter your current and new password. We\'ll send a verification code to confirm.'
                : 'Enter your new email address. We\'ll send a verification code to it.',
            fontColor: colorScheme.onSurface.withValues(alpha: 0.55),
            fontSize: 14.sp,
            translate: false,
          ),
          SizedBoxWidget(height: 24),

          if (controller.isPasswordChange) ...[
            CustomTextField(
              label: 'Current Password',
              hintText: '••••••••',
              controller: controller.currentPasswordController,
              isPassword: true,
            ),
            SizedBoxWidget(height: 16),
            CustomTextField(
              label: 'New Password',
              hintText: '••••••••',
              controller: controller.newPasswordController,
              isPassword: true,
            ),
          ] else ...[
            CustomTextField(
              label: 'New Email Address',
              hintText: 'you@example.com',
              controller: controller.newEmailController,
              keyboardType: TextInputType.emailAddress,
            ),
          ],

          SizedBoxWidget(height: 28),
          Obx(() => CustomButton(
            label: 'Send Verification Code',
            fontWeight: FontWeight.w700,
            buttonHeight: 44.h,
            isLoading: controller.isLoading.value,
            onPressed: controller.isLoading.value ? null : controller.sendCode,
          )),
        ],
      ),
    );
  }
}

// ── Step 2: OTP ───────────────────────────────────────────────────────────────

class _OtpStep extends StatelessWidget {
  const _OtpStep({required this.controller, required this.colorScheme});

  final ChangeCredentialController controller;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.mark_email_read_outlined,
            size: 56,
            color: colorScheme.primary,
          ),
          SizedBoxWidget(height: 16),
          CustomText(
            text: controller.isPasswordChange
                ? 'Check your current email'
                : 'Check your new email',
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            translate: false,
          ),
          SizedBoxWidget(height: 8),
          CustomText(
            text: 'Enter the 6-digit code we sent to confirm your change.',
            fontColor: colorScheme.onSurface.withValues(alpha: 0.55),
            fontSize: 14.sp,
            translate: false,
          ),
          SizedBoxWidget(height: 32),

          // ── OTP digit boxes ──────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: KeyboardListener(
                  focusNode: FocusNode(skipTraversal: true),
                  onKeyEvent: (e) => controller.onKeyEvent(i, e),
                  child: SizedBox(
                    width: 44.w,
                    height: 52.h,
                    child: TextField(
                      controller: controller.otpDigits[i],
                      focusNode: controller.otpFocusNodes[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: colorScheme.onSurface.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                            color: colorScheme.onSurface.withValues(alpha: 0.2),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                            color: colorScheme.onSurface.withValues(alpha: 0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                      ),
                      onChanged: (v) => controller.onDigitChanged(i, v),
                    ),
                  ),
                ),
              );
            }),
          ),

          SizedBoxWidget(height: 28),
          Obx(() => CustomButton(
            label: controller.isLoading.value ? 'Verifying…' : 'Confirm Change',
            fontWeight: FontWeight.w700,
            buttonHeight: 44.h,
            isLoading: controller.isLoading.value,
            onPressed: controller.isLoading.value ? null : controller.verifyOtp,
          )),

          SizedBoxWidget(height: 16),
          TextButton(
            onPressed: controller.backToForm,
            child: Text(
              'Didn\'t receive it? Go back and resend',
              style: TextStyle(color: colorScheme.primary, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
