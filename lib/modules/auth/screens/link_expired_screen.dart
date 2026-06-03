import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

class LinkExpiredScreen extends StatelessWidget {
  const LinkExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBoxWidget(height: 60),
              CustomText(
                text: AppStrings.emailVerificationLinkExpired,
                fontWeight: FontWeight.w700,
                fontColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 18.sp,
              ),
              SizedBoxWidget(height: 20),
              CustomText(
                text: AppStrings.noWorriesWellSendTheLinkAgain,
                fontColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 16.sp,
              ),
              SizedBoxWidget(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: CustomButton(
                  label: AppStrings.resendVerificationLink,
                  buttonWidth: double.infinity,
                  buttonHeight: 40.h,
                  onPressed: () => Get.toNamed(AppRoutes.accountVerifiedScreen),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}