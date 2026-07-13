import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

class BecomeASellerScreen extends StatelessWidget {
  const BecomeASellerScreen({super.key});

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
              SizedBoxWidget(height: 50.h),

              // Title
              CustomText(
                text: AppStrings.interestingInSelling,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontColor: colorScheme.onSurface,
              ),
              SizedBoxWidget(height: 40.h),

              // Info Tiles
              _buildInfoTile(context, AppStrings.sellInSeconds),
              SizedBoxWidget(height: 16.h),
              _buildInfoTile(context, AppStrings.keepMoreOfWhatYouEarn),
              SizedBoxWidget(height: 16.h),
              _buildInfoTile(context, AppStrings.sellToBestBuyers),

              const Spacer(),

              // Bottom Buttons
              Row(
                children:[
                  Expanded(
                    child: CustomButton(
                      label: AppStrings.faqs,
                      buttonHeight: 38.h,
                      onPressed: () {
                        Get.toNamed(AppRoutes.sellerFaqScreen, arguments: 'seller');
                      },
                    ),
                  ),
                  SizedBoxWidget(width: 15.w),
                  Expanded(
                    child: CustomButton(
                      label: AppStrings.getStarted,
                      buttonHeight: 38.h,
                      textColor: Colors.white,
                      backgroundColor: AppColors.orange,
                      onPressed: () {
                        Get.toNamed(AppRoutes.readyToEarnScreen);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to keep the code clean
  Widget _buildInfoTile(BuildContext context, String text) {
    //final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        //color: colorScheme.primaryContainer,
        color: AppColors.primaryColor,
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
              //fontColor: colorScheme.onSurface,
              fontColor: Colors.white,
              textAlignment: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}