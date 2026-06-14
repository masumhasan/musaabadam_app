import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/seller_verification/controllers/seller_verification_controller.dart';

class SellerSubcategoryScreen extends GetView<SellerVerificationController> {
  const SellerSubcategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.setupProfile.tr,
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
              text: AppStrings.whichSubcategory,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.onSurface,
            ),
            SizedBoxWidget(height: 8.h),
            CustomText(
              text: AppStrings.canAddMoreLater,
              fontSize: 16,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.outline,
            ),
            SizedBoxWidget(height: 20.h),

            Expanded(
              child: Obx(() {
                if (controller.subcategoriesLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.subcategories.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No subcategories available for your selected categories.',
                      fontSize: 14,
                      fontColor: colorScheme.outline,
                      textAlignment: TextAlign.center,
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: controller.subcategories.map((cat) {
                      return Obx(() {
                        final isSelected = controller.selectedSubcategoryIds.contains(cat.id);
                        return _buildSubcategoryChip(context, cat.name, cat.id, isSelected);
                      });
                    }).toList(),
                  ),
                );
              }),
            ),

            // Next Button
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: CustomButton(
                label: AppStrings.next,
                buttonWidth: double.infinity,
                textColor: Colors.white,
                backgroundColor: AppColors.orange,
                onPressed: () {
                  Get.toNamed(AppRoutes.sellerTypeScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryChip(BuildContext context, String name, String id, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = isSelected
        ? colorScheme.primary
        : colorScheme.secondaryContainer.withValues(alpha: 0.8);

    final textColor = isSelected ? colorScheme.onPrimary : colorScheme.onSecondaryContainer;

    return GestureDetector(
      onTap: () => controller.toggleSubcategory(id),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: CustomText(
          text: name,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontColor: textColor,
        ),
      ),
    );
  }
}
