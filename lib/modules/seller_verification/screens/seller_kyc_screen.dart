import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/seller_verification/controllers/seller_verification_controller.dart';

class SellerKycScreen extends GetView<SellerVerificationController> {
  const SellerKycScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.setupProfile,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBoxWidget(height: 20.h),

            // Title & Subtitle
            CustomText(
              text: 'Verification Documents',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.onSurface,
            ),
            SizedBoxWidget(height: 8.h),
            CustomText(
              text: 'Upload identification documents to establish policy standing and complete registration.',
              fontSize: 14,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.outline,
            ),
            SizedBoxWidget(height: 30.h),

            // Identity Document Box
            Obx(() => _buildUploadBox(
                  context: context,
                  title: 'Identity Document (ID/Passport)',
                  url: controller.identityDocUrl.value,
                  isUploading: controller.identityDocUploading.value,
                  onTap: controller.pickIdentityDoc,
                )),
            SizedBoxWidget(height: 20.h),

            // Business License Box
            Obx(() => _buildUploadBox(
                  context: context,
                  title: 'Business License / Permit',
                  url: controller.businessLicenseUrl.value,
                  isUploading: controller.businessLicenseUploading.value,
                  onTap: controller.pickBusinessLicense,
                )),

            const Spacer(),

            // Safety Warning Note
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield_outlined, color: AppColors.orange, size: 18.sp),
                SizedBoxWidget(width: 8.w),
                Expanded(
                  child: CustomText(
                    text: 'Your document data is encrypted, secure, and used solely for manual policy approvals by BidsRush admins.',
                    fontSize: 11.sp,
                    fontColor: colorScheme.outline,
                    textAlignment: TextAlign.start,
                  ),
                ),
              ],
            ),
            SizedBoxWidget(height: 20.h),

            // Submit Button
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Obx(() => CustomButton(
                    label: 'Submit Application',
                    textColor: Colors.white,
                    buttonWidth: double.infinity,
                    backgroundColor: AppColors.orange,
                    isLoading: controller.isLoading.value,
                    onPressed: (controller.isLoading.value ||
                            controller.identityDocUploading.value ||
                            controller.businessLicenseUploading.value)
                        ? null
                        : () {
                            if (controller.identityDocUrl.value == null) {
                              Get.snackbar('Required', 'Please upload your identity document.');
                              return;
                            }
                            controller.submitApplication();
                          },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBox({
    required BuildContext context,
    required String title,
    required String? url,
    required bool isUploading,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isUploading ? null : onTap,
      child: Container(
        height: 120.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: url != null ? AppColors.lightOrange.withValues(alpha: 0.2) : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: url != null ? AppColors.orange : colorScheme.outlineVariant,
            style: url != null ? BorderStyle.solid : BorderStyle.solid,
            width: url != null ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: isUploading
              ? SizedBox(
                  height: 24.r,
                  width: 24.r,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.orange),
                )
              : url != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppColors.orange, size: 36.sp),
                        SizedBoxWidget(height: 8.h),
                        CustomText(
                          text: '$title Uploaded',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          fontColor: colorScheme.onSurface,
                        ),
                        SizedBoxWidget(height: 2.h),
                        CustomText(
                          text: 'Tap to replace file',
                          fontSize: 10.sp,
                          fontColor: colorScheme.outline,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined, color: colorScheme.outline, size: 32.sp),
                        SizedBoxWidget(height: 8.h),
                        CustomText(
                          text: 'Upload $title',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          fontColor: colorScheme.onSurface,
                        ),
                        SizedBoxWidget(height: 2.h),
                        CustomText(
                          text: 'Format: JPEG, PNG',
                          fontSize: 10.sp,
                          fontColor: colorScheme.outline,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
