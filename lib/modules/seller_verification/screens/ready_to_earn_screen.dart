import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

import '../../../core/assets_gen/assets.gen.dart';

class ReadyToEarnScreen extends StatelessWidget {
  const ReadyToEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children:[
              SizedBoxWidget(height: 60.h),

              // Title
              CustomText(
                text: AppStrings.readyToEarn.tr,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontColor: colorScheme.onSurface,
              ),

              SizedBoxWidget(height: 40.h),

              // Benefits List
              _buildBenefitTile(context, AppStrings.payLowestFees),
              SizedBoxWidget(height: 16.h),
              _buildBenefitTile(context, AppStrings.buyersCoverShipping),
              SizedBoxWidget(height: 16.h),
              _buildBenefitTile(context, AppStrings.honorPurchasesAndGiveaways),

              const Spacer(),

              // Got It Button
              CustomButton(
                label: AppStrings.gotIt,
                textColor: Colors.white,
                backgroundColor: AppColors.orange, // Orange as per design
                onPressed: () {
                  showOneStepCloserDialog(context);
                },
              ),
              SizedBoxWidget(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitTile(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: colorScheme.primary, // Using theme primary
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children:[
          Icon(Icons.verified_user_outlined, color: Colors.white, size: 24.sp),
          SizedBoxWidget(width: 12.w),
          Expanded(
            child: CustomText(
              text: text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontColor: Colors.white, // White text on Primary background
              textAlignment: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  void showOneStepCloserDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Important: Wraps the content tightly
            children:[
              // Icon
              SvgPicture.asset(
                Assets.icons.doneOrange, // Ensure your path is correct
                height: 100.h,
                width: 100.w,
              ),
              SizedBoxWidget(height: 25.h),

              // Text
              CustomText(
                text: AppStrings.oneStepCloserToSellingLive.tr,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontColor: Theme.of(context).colorScheme.onSurface,
              ),
              SizedBoxWidget(height: 25.h),

              // Button
              CustomButton(
                label: AppStrings.completeApplication.tr,
                textColor: Colors.white,
                backgroundColor: AppColors.orange, // Matching the orange design
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.toNamed(AppRoutes.sellerCategoryScreen);
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}