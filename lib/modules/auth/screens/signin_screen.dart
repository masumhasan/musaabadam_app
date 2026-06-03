import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/role_service.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/utils/app_validator.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/assets_gen/fonts.gen.dart';
import '../../../core/services/theme_language_service.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RoleService roleService = Get.find<RoleService>();

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
                  CustomButton(
                    label: AppStrings.signIn,
                    fontWeight: FontWeight.w700,
                    buttonHeight: 40.h,
                    onPressed: (){
                      showAuthDialog(context);
                      //Get.offAndToNamed(AppRoutes.mainScreen);
                    },
                  ),
                  SizedBoxWidget(height: 10.h),
                  //#############################################
                  // // Inside your UI code
                  // SwitchListTile(
                  //   title: CustomText(text: "Dark Mode"), // Use your CustomText here
                  //   value: ThemeLanguageService.to.isDarkMode,
                  //   onChanged: (val) {
                  //     ThemeLanguageService.to.toggleTheme();
                  //   },
                  // ),
                  // CustomText(text: "Select Language"), // Your CustomText
                  // ListTile(
                  //   title: CustomText(text: "English"),
                  //   onTap: () => ThemeLanguageService.to.updateLanguage('en_US'),
                  // ),
                  // ListTile(
                  //   title: CustomText(text: "Arabic"),
                  //   onTap: () => ThemeLanguageService.to.updateLanguage('ar_SA'),
                  // ),
                  // //#############################################
                  // SizedBoxWidget(height: 10.h),
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


  //TEMPORARY AUTH DIALOG
showAuthDialog(BuildContext context){
    showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Select Role'),
        content: Text('Select a role to view role based features.\nThis is for testing purposes only'),
          actions: [
            TextButton(
              onPressed: () {
                roleService.updateRole(Role.buyer);
                Get.offAllNamed(AppRoutes.mainScreen);
              },
              child: Text('Buyer'),
            ),
            TextButton(
              onPressed: () {
                roleService.updateRole(Role.seller);
                Get.offAllNamed(AppRoutes.mainScreen);
              },
              child: Text('Seller'),
            ),
          ],
      );
    }
    );

}
}
