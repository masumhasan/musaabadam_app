import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/routes/app_pages.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/sized_box_widget.dart';

AppBar appBar = AppBar(
  centerTitle: true,
  forceMaterialTransparency: true,
  title: CustomText(text: AppStrings.activity.tr),
  actions: [
    GestureDetector(
      onTap: (){
        Get.toNamed(AppRoutes.friendsScreen);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: BoxBorder.all(color: AppColors.primaryColor, width: 1.w),
        ),
        child: Row(
          children: [
            Icon(Icons.groups_rounded, color: AppColors.primaryColor, size: 22.r),
            SizedBoxWidget(width: 5),
            CustomText(
              text: AppStrings.friends.tr,
              fontColor: AppColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    ),
    SizedBoxWidget(width: 10),
  ],
);
