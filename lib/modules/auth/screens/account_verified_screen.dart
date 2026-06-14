import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import '../controllers/auth_controller.dart';

class AccountVerifiedScreen extends StatelessWidget {
  AccountVerifiedScreen({super.key});

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBoxWidget(height: 60),
              CustomText(
                text: AppStrings.accountVerified,
                fontWeight: FontWeight.w700,
                fontColor: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 20.sp,
              ),
              SizedBoxWidget(height: 20),
              CustomText(
                text: AppStrings.congratulationsYourEmailAccount,
                fontColor: colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 16.sp,
              ),
              CustomText(
                text: _authController.pendingEmail.value.isNotEmpty
                    ? _authController.pendingEmail.value
                    : _authController.currentUser.value?.email ?? '',
                fontColor: colorScheme.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text: AppStrings.hasBeenVerified,
                fontColor: colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 16.sp,
              ),
              SizedBoxWidget(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: CustomButton(
                  label: AppStrings.continueToYourAccount,
                  buttonWidth: double.infinity,
                  buttonHeight: 40.h,
                  onPressed: () => Get.toNamed(AppRoutes.profileSetupScreen),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
