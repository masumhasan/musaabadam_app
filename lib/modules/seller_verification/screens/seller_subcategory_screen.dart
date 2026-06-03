import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

class SellerSubcategoryScreen extends StatelessWidget {
  SellerSubcategoryScreen({super.key});

  final RxSet<String> selectedSubcategories = <String>{}.obs;

  final List<String> subcategories =[
    "Pokemon Cards", "Magic:The Gathering", "Yo-Gi-Oh! cards",
    "One Piece cards", "VeeFriends", "Naruto Cards",
    "Union Area", "Dragon Ball cards", "Other TCG",
    "Riftbound", "WeiB Schwarz", "Lorcana"
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
          children:[
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

            CustomText(
              text: AppStrings.tradingCardGames,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontColor: colorScheme.onSurface,
            ),
            SizedBoxWidget(height: 16.h),

            // Selectable Chips
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: subcategories.map((name) {
                return Obx(() {
                  final isSelected = selectedSubcategories.contains(name);
                  return _buildSubcategoryChip(context, name, isSelected);
                });
              }).toList(),
            ),

            const Spacer(),

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

  Widget _buildSubcategoryChip(BuildContext context, String name, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;

    // Using secondaryContainer for the "active" selection and outline for inactive
    // Or you can map this to your custom light orange color from AppColors
    final backgroundColor = isSelected
        ? colorScheme.primary
        : colorScheme.secondaryContainer.withValues(alpha: 0.8);

    final textColor = isSelected ? colorScheme.onPrimary : colorScheme.onSecondaryContainer;

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          selectedSubcategories.remove(name);
        } else {
          selectedSubcategories.add(name);
        }
      },
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