import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import '../controllers/auth_controller.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Obx(() => Column(
            children: [
              SizedBoxWidget(height: 60),
              CustomText(text: AppStrings.verifyYourEmail, fontWeight: FontWeight.w700, fontColor: colorScheme.onSurface.withValues(alpha: 0.6)),
              CustomText(text: AppStrings.weSentVarificationLinkTo, fontColor: colorScheme.onSurface.withValues(alpha: 0.5)),
              CustomText(
                text: authController.pendingEmail.value.isNotEmpty
                    ? authController.pendingEmail.value
                    : 'your email',
                fontWeight: FontWeight.w600,
                fontColor: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              SizedBoxWidget(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: CustomButton(
                  label: AppStrings.sendEmail,
                  buttonWidth: double.infinity,
                  buttonHeight: 40.h,
                  isLoading: authController.isLoading.value,
                  onPressed: () => authController.resendVerification(),
                ),
              ),
              SizedBoxWidget(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: CustomButton(
                  label: AppStrings.changeEmail,
                  backgroundColor: Colors.transparent,
                  borderColor: colorScheme.primary,
                  textColor: colorScheme.primary,
                  buttonWidth: double.infinity,
                  buttonHeight: 40.h,
                  onPressed: () => Get.toNamed(AppRoutes.linkExpiredScreen),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
