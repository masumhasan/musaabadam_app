import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/utils/app_validator.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../controllers/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AuthController _authController = Get.find<AuthController>();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 31.w),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBoxWidget(height: 38),
                  Align(alignment: Alignment.topCenter, child: SvgPicture.asset(Assets.icons.grSignup, width: 240.w, height: 235.h)),
                  CustomTextField(label: AppStrings.email, hintText: AppStrings.enterEmail, controller: emailController, validator: (v) => !isEmailValid(email: v ?? "") ? "Enter valid email" : null),
                  CustomTextField(label: AppStrings.password, hintText: AppStrings.enterPassword, controller: passwordController, isPassword: true, validator: (v) => !isPasswordValid(password: v ?? "") ? "Invalid password" : null),
                  CustomTextField(label: AppStrings.confirmPassword, hintText: AppStrings.enterPassword, controller: confirmPasswordController, isPassword: true, validator: (v) => passwordController.text != v ? "Passwords do not match" : null),
                  CustomTextField(
                    label: AppStrings.referralCodeOptional,
                    hintText: AppStrings.enterReferralCode,
                    controller: referralCodeController,
                    validator: (v) => (v == null || v.trim().isEmpty || RegExp(r'^[a-zA-Z0-9]{4,16}$').hasMatch(v.trim()))
                        ? null
                        : "Invalid referral code",
                  ),
                  SizedBoxWidget(height: 20.h),
                  Obx(() => CustomButton(
                    label: AppStrings.signUp,
                    fontWeight: FontWeight.w700,
                    buttonHeight: 40.h,
                    isLoading: _authController.isLoading.value,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _authController.register(
                          emailController.text.trim(),
                          passwordController.text,
                          referralCode: referralCodeController.text.trim(),
                        );
                      }
                    },
                  )),
                  SizedBoxWidget(height: 15.h),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: AppStrings.alreadyHaveAnAccount.tr, style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14.sp)),
                      TextSpan(text: AppStrings.signIn.tr, recognizer: TapGestureRecognizer()..onTap = () => Get.offAndToNamed(AppRoutes.signInScreen), style: TextStyle(color: colorScheme.primary, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
