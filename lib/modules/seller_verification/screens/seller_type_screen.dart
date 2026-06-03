import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

class SellerTypeScreen extends StatelessWidget {
  SellerTypeScreen({super.key});

  final RxInt selectedIndex = (-1).obs;

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
            SizedBoxWidget(height: 30.h),

            // Title
            CustomText(
              text: AppStrings.whichDescribesYou,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.onSurface,
            ),
            SizedBoxWidget(height: 8.h),

            // Subtitle
            CustomText(
              text: AppStrings.tailorExperience,
              fontSize: 16,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.outline,
            ),
            SizedBoxWidget(height: 30.h),

            // Selection Options
            Obx(() => _buildSelectionTile(
              context,
              AppStrings.startingOut,
              0,
            )),
            SizedBoxWidget(height: 20.h),
            Obx(() => _buildSelectionTile(
              context,
              AppStrings.activelySelling,
              1,
            )),

            const Spacer(),

            // Next Button
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: CustomButton(
                label: AppStrings.next,
                buttonWidth: double.infinity,
                textColor: Colors.white,
                backgroundColor: AppColors.orange,
                onPressed: (){
                  Get.toNamed(AppRoutes.sellerAddressScreen);
                },
                // onPressed: selectedIndex.value == -1 ? null : () {
                //
                // },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionTile(BuildContext context, String title, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selectedIndex.value == index;

    return GestureDetector(
      onTap: () => selectedIndex.value = index,
      child: Row(
        children:[
          Expanded(
            child: CustomText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.onSurface,
            ),
          ),
          Container(
            height: 24.r,
            width: 24.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? colorScheme.primary : colorScheme.outline,
                width: 2.w,
              ),
            ),
            child: isSelected
                ? Center(
              child: Container(
                height: 12.r,
                width: 12.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary,
                ),
              ),
            )
                : null,
          ),
        ],
      ),
    );
  }
}