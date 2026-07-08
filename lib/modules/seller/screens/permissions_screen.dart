import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

import '../../../core/widgets/sized_box_widget.dart';

class PermissionsScreen extends StatelessWidget {
  PermissionsScreen({super.key});

  final List<String> categories =[
    "Surprise Sets in Sneakers & Streetwear",
    "Luxury Bags & Accessories",
    "Surprise Sets in Bags & Accessories",
    "Pallet Sales",
    "BNTA Dealers"
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
          text: AppStrings.permissions,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            // Permission Tiles
            _buildPermissionTile(AppStrings.marketplaceSeller, Icons.storefront, colorScheme),
            SizedBoxWidget(height: 10.h),
            _buildPermissionTile(AppStrings.sellLive, Icons.cloud_upload_outlined, colorScheme),
            SizedBoxWidget(height: 10.h),
            _buildPermissionTile(AppStrings.teenSellerApproval, Icons.assignment_turned_in_outlined, colorScheme),
            SizedBoxWidget(height: 25.h),

            // Gated Categories
            CustomText(text: AppStrings.gatedCategories, fontSize: 18, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.primary),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  CustomText(text: AppStrings.eligibleCategories, fontWeight: FontWeight.w700),
                  SizedBoxWidget(height: 10.h),
                  ...categories.map((cat) => _buildGatedCategoryRow(cat, colorScheme)),
                ],
              ),
            ),

            SizedBoxWidget(height: 30.h),

            // Resources
            CustomText(text: AppStrings.resources, fontSize: 18, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.inboxScreen),
              child: CustomText(
                text: AppStrings.contactSellerSupport,
                fontColor: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile(String title, IconData icon, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children:[
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBoxWidget(width: 12),
          CustomText(text: title, fontColor: Colors.white, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  Widget _buildGatedCategoryRow(String title, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Expanded(
            child: CustomText(
              text: title,
              textAlignment: TextAlign.start,
              fontSize: 14,
            ),
          ),
          CustomButton(
            label: AppStrings.applyNow,
            buttonHeight: 30.h,
            textColor: Colors.white,
            fontSize: 12,
            backgroundColor: const Color(0xFFF39C12),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}