import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

import '../../../core/assets_gen/assets.gen.dart';

class CheckEmailScreen extends StatelessWidget {
  final String userEmail = "dummymail@mail.com";

  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 31.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBoxWidget(height: 25),
              //===================GRAPHICS=========================//
              SvgPicture.asset(
                Assets.icons.grCheckEmail,
                width: 240.w,
                height: 238.h,
              ),
              SizedBox(height: 15),
              CustomText(
                text: AppStrings.checkYourEmail,
                fontColor: colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
              SizedBoxWidget(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.weSentVarificationLinkTo.tr,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 14.sp,
                      ),
                    ),
                    TextSpan(
                      text: "  $userEmail",
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBoxWidget(height: 20),
              //===================OPEN EMAIL APP=========================//
              CustomButton(
                label: AppStrings.openEmailApp,
                fontWeight: FontWeight.w700,
                buttonHeight: 40.h,
                onPressed: () {
                  Get.offAndToNamed(AppRoutes.newPasswordScreen);
                },
              ),
              SizedBoxWidget(height: 15),
              //===================RESEND=========================//
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.didntReceiveTheEmail.tr,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 14.sp,
                      ),
                    ),
                    TextSpan(
                      text: "  ${AppStrings.clickToResend.tr}",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => debugPrint("Resend"),
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              //===================BACK TO THE PLATFORM=========================//
              const Spacer(),
              TextButton(
                onPressed: () => Get.back(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_rounded, color: colorScheme.primary),
                    SizedBoxWidget(width: 8),
                    CustomText(
                      text: AppStrings.backToThePlatform,
                      fontColor: colorScheme.primary,
                      fontSize: 14.sp,
                    ),
                  ],
                ),
              ),
              SizedBoxWidget(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}