import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/social_auth_service.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/utils/app_validator.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/assets_gen/fonts.gen.dart';
import '../controllers/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final AuthController _authController = Get.find<AuthController>();

  SignInScreen({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBoxWidget(height: 38),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(
                      Assets.icons.grLogin,
                      width: 281.w,
                      height: 269.h,
                    ),
                  ),
                  SizedBoxWidget(height: 15),
                  CustomTextField(
                    label: AppStrings.email,
                    hintText: AppStrings.enterEmail,
                    controller: emailController,
                    validator: (v) => !isEmailValid(email: v ?? "")
                        ? "Enter valid email"
                        : null,
                  ),
                  SizedBoxWidget(height: 16),
                  CustomTextField(
                    label: AppStrings.password,
                    hintText: AppStrings.enterPassword,
                    controller: passwordController,
                    isPassword: true,
                    validator: (v) => !isPasswordValid(password: v ?? "")
                        ? "Enter valid password"
                        : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      child: GestureDetector(
                        onTap: () =>
                            Get.toNamed(AppRoutes.forgotPasswordScreen),
                        child: CustomText(
                          text: AppStrings.forgotPassword,
                          fontFamily: FontFamily.mulish,
                          fontColor: colorScheme.primary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBoxWidget(height: 20.h),
                  Obx(() => CustomButton(
                    label: AppStrings.signIn,
                    fontWeight: FontWeight.w700,
                    buttonHeight: 40.h,
                    isLoading: _authController.isLoading.value,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _authController.login(
                          emailController.text.trim(),
                          passwordController.text,
                        );
                      }
                    },
                  )),
                  SizedBoxWidget(height: 14.h),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text('or', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  SizedBoxWidget(height: 12.h),
                  OutlinedButton.icon(
                    onPressed: () => SocialAuthService.instance.signInWithGoogle(),
                    icon: const Icon(Icons.g_mobiledata, size: 28),
                    label: const Text('Continue with Google'),
                    style: OutlinedButton.styleFrom(minimumSize: Size(double.infinity, 44.h)),
                  ),
                  SizedBoxWidget(height: 10.h),
                  OutlinedButton.icon(
                    onPressed: () => SocialAuthService.instance.signInWithApple(),
                    icon: const Icon(Icons.apple, size: 22),
                    label: const Text('Continue with Apple'),
                    style: OutlinedButton.styleFrom(minimumSize: Size(double.infinity, 44.h)),
                  ),
                  SizedBoxWidget(height: 10.h),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: AppStrings.dontHaveAnAccount.tr,
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 14.sp,
                            ),
                          ),
                          TextSpan(
                            text: AppStrings.signUp.tr,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  Get.offAndToNamed(AppRoutes.signUpScreen),
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
