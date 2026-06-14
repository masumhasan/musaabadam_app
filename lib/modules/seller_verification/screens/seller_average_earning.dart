import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/seller_verification/controllers/seller_verification_controller.dart';

class SellerAverageEarning extends GetView<SellerVerificationController> {
  SellerAverageEarning({super.key});

  final List<String> incomeRanges = [
    AppStrings.range1,
    AppStrings.range2,
    AppStrings.range3,
    AppStrings.range4,
  ];

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
          children:[
            SizedBoxWidget(height: 20.h),

            // Title & Subtitle
            CustomText(
              text: AppStrings.averageMonthlyEarnings,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.onSurface,
            ),
            SizedBoxWidget(height: 8.h),
            CustomText(
              text: AppStrings.tailorTools,
              fontSize: 16,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.outline,
            ),
            SizedBoxWidget(height: 20.h),

            // Dropdown Selector
            Obx(() => Column(
              children:[
                // The Select Box
                GestureDetector(
                  onTap: () => controller.isDropdownExpanded.value = !controller.isDropdownExpanded.value,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.orange),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        CustomText(text: controller.selectedRange.value, fontColor: colorScheme.onSurface),
                        Icon(controller.isDropdownExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: colorScheme.onSurface),
                      ],
                    ),
                  ),
                ),

                // The Expanded List
                if (controller.isDropdownExpanded.value)
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.lightOrange,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: incomeRanges.map((range) => _buildOption(range)).toList(),
                    ),
                  ),
              ],
            )),

            const Spacer(),

            // Submit Application Button
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Obx(() => CustomButton(
                label: AppStrings.next,
                textColor: Colors.white,
                buttonWidth: double.infinity,
                backgroundColor: AppColors.orange,
                isLoading: controller.isLoading.value,
                onPressed: controller.isLoading.value ? null : () {
                  controller.submitApplication();
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String range) {
    return GestureDetector(
      onTap: () {
        controller.selectedRange.value = range;
        controller.isDropdownExpanded.value = false;
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: CustomText(
          text: range,
          textAlignment: TextAlign.start,
          fontColor: Colors.black, // Keeping distinct as per requested screenshot
        ),
      ),
    );
  }
}