import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/photo_edit_widget.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';
import 'package:musaab_adam/modules/profile/bindings/change_credential_binding.dart';
import 'package:musaab_adam/modules/profile/controllers/update_profile_controller.dart';
import 'package:musaab_adam/modules/profile/screens/change_credentials_screen.dart';


class UpdateProfileScreen extends GetView<UpdateProfileController> {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.profile,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Obx(() {
            final user = authCtrl.currentUser.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBoxWidget(height: 20),

                // Avatar picker — shows current avatar or picked file
                PhotoEditWidget(
                  imageUrl: user?.avatarUrl,
                  onImagePicked: controller.onAvatarPicked,
                ),

                SizedBoxWidget(height: 10),

                // Display name shown below avatar
                CustomText(
                  text: user?.displayNameOrUsername ?? '',
                  fontWeight: FontWeight.w700,
                  fontColor: colorScheme.onSurface,
                  fontSize: 20,
                ),

                SizedBoxWidget(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Username',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontColor: colorScheme.onSurface,
                    ),
                    SizedBoxWidget(height: 8),
                    Obx(() {
                      final isChecking = controller.isCheckingUsername.value;
                      final isAvailable = controller.isUsernameAvailable.value;
                      final errorStr = controller.usernameError.value;

                      Widget? suffix;
                      if (isChecking) {
                        suffix = SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.primary,
                          ),
                        );
                      } else if (errorStr.isNotEmpty) {
                        suffix = Icon(
                          isAvailable ? Icons.check_circle_outline : Icons.error_outline,
                          color: isAvailable ? Colors.green : Colors.red,
                          size: 20.r,
                        );
                      }

                      Color? borderColor;
                      if (errorStr.isNotEmpty && !isChecking) {
                        borderColor = isAvailable ? Colors.green.withValues(alpha: 0.5) : Colors.red.withValues(alpha: 0.5);
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: controller.usernameController,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter username',
                              hintStyle: TextStyle(
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                                fontSize: 14.sp,
                              ),
                              prefixText: '@',
                              prefixStyle: TextStyle(
                                color: colorScheme.onSurface.withValues(alpha: 0.6),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              suffixIcon: suffix != null
                                  ? Padding(
                                      padding: EdgeInsets.all(12.w),
                                      child: suffix,
                                    )
                                  : null,
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: borderColor ?? colorScheme.outline.withValues(alpha: 0.2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: borderColor ?? colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          if (errorStr.isNotEmpty) ...[
                            SizedBoxWidget(height: 6),
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: CustomText(
                                text: errorStr,
                                fontSize: 12.sp,
                                fontColor: isChecking
                                    ? colorScheme.outline
                                    : (isAvailable ? Colors.green : Colors.red),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      );
                    }),
                  ],
                ),

                SizedBoxWidget(height: 15),

                // Display Name — editable
                CustomTextField(
                  label: AppStrings.fullName,
                  hintText: 'Your display name',
                  controller: controller.displayNameController,
                ),

                SizedBoxWidget(height: 15),

                // Email — read-only (changed via Change Email screen)
                _buildReadOnlyField(
                  label: 'Email',
                  value: user?.email ?? '',
                  colorScheme: colorScheme,
                  trailingLabel: 'Change',
                  onTrailingTap: () => Get.to(
                    () => const ChangeCredentialScreen(),
                    binding: ChangeCredentialBinding(),
                    arguments: {'isPasswordChange': false},
                  ),
                ),


                SizedBoxWidget(height: 15),

                // Phone — read-only if no edit endpoint
                _buildReadOnlyField(
                  label: 'Phone',
                  value: user?.phone ?? 'Not set',
                  colorScheme: colorScheme,
                ),

                SizedBoxWidget(height: 15),

                // Bio — editable
                CustomTextField(
                  label: 'Bio',
                  hintText: 'Tell people about yourself',
                  controller: controller.bioController,
                ),

                SizedBoxWidget(height: 15),

                // Location — editable
                CustomTextField(
                  label: 'Location',
                  hintText: 'Your city or region',
                  controller: controller.locationController,
                ),

                SizedBoxWidget(height: 30),

                // Submit button
                Obx(() => CustomButton(
                  label: controller.isLoading.value
                      ? 'Saving…'
                      : AppStrings.updateProfile,
                  buttonHeight: 40.h,
                  textColor: Colors.white,
                  backgroundColor: colorScheme.primary,
                  buttonRadius: 12,
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.updateProfile,
                )),

                SizedBoxWidget(height: 30),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required ColorScheme colorScheme,
    String? trailingLabel,
    VoidCallback? onTrailingTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontColor: colorScheme.onSurface,
        ),
        SizedBoxWidget(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomText(
                  text: value,
                  fontSize: 14,
                  fontColor: colorScheme.onSurface.withValues(alpha: 0.6),
                  textAlignment: TextAlign.start,
                ),
              ),
              if (trailingLabel != null)
                GestureDetector(
                  onTap: onTrailingTap,
                  child: CustomText(
                    text: trailingLabel,
                    fontSize: 13,
                    fontColor: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
