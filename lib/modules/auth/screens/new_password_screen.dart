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

class NewPasswordScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 31.w),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBoxWidget(height: 25),
                  SvgPicture.asset(Assets.icons.grResetPassword, width: 240.w, height: 227.h),
                  SizedBoxWidget(height: 15),
                  CustomText(text: AppStrings.setNewPassword, fontWeight: FontWeight.w700, fontSize: 18.sp),
                  SizedBoxWidget(height: 8),
                  CustomText(text: AppStrings.yourNewPassword, fontColor: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 14.sp),
                  SizedBoxWidget(height: 20),
                  CustomTextField(label: AppStrings.newPassword, hintText: AppStrings.newPassword, controller: passwordController, isPassword: true),
                  SizedBoxWidget(height: 20),
                  CustomTextField(label: AppStrings.confirmPassword, hintText: AppStrings.confirmPassword, controller: confirmPasswordController, isPassword: true),
                  SizedBoxWidget(height: 20),
                  CustomButton(label: AppStrings.resetPassword, fontWeight: FontWeight.w700, buttonHeight: 40.h, onPressed: showResetSuccessAlert),
                  TextButton(
                    onPressed: Get.back,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_rounded, color: theme.colorScheme.primary),
                        SizedBoxWidget(width: 8),
                        CustomText(text: AppStrings.backToThePlatform, fontColor: theme.colorScheme.primary),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showResetSuccessAlert() {
    Get.dialog(AlertDialog(
      backgroundColor: Get.theme.colorScheme.surface,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(Assets.icons.doneOrange),
          SizedBox(height: 15.h),
          CustomText(text: "Password reset successfully.", fontWeight: FontWeight.w500, fontSize: 18.sp),
          SizedBox(height: 20.h),
          CustomButton(label: "Ok", buttonHeight: 42, onPressed: () => Get.offAllNamed(AppRoutes.signInScreen)),
        ],
      ),
    ));
  }
}