import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/utils/app_validator.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 31.w),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBoxWidget(height: 25),
                  //===================GRAPHICS=========================//
                  SvgPicture.asset(
                    Assets.icons.grForgotPass,
                    width: 240.w,
                    height: 238.h,
                  ),
                  SizedBox(height: 15.h),
                  CustomText(
                    text: AppStrings.forgotYourPassword,
                    fontColor: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                  SizedBoxWidget(height: 8),
                  CustomText(
                    text: AppStrings.noWorries,
                    fontColor: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 15.sp,
                  ),
                  SizedBoxWidget(height: 20),
                  //===================EMAIL=========================//
                  CustomTextField(
                    label: AppStrings.email,
                    hintText: AppStrings.enterEmail,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || !isEmailValid(email: emailController.text.trim())) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBoxWidget(height: 30),
                  //===================CONTINUE BUTTON=========================//
                  CustomButton(
                    label: AppStrings.continuee,
                    fontWeight: FontWeight.w700,
                    buttonHeight: 40.h,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Get.toNamed(AppRoutes.checkEmailScreen);
                      }
                    },
                  ),
                  //===================BACK TO THE PLATFORM=========================//
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back_rounded,
                            color: colorScheme.primary,
                          ),
                          SizedBoxWidget(width: 8),
                          CustomText(
                            text: AppStrings.backToThePlatform,
                            fontColor: colorScheme.primary,
                            fontSize: 14.sp,
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