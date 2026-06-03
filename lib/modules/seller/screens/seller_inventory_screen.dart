import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/text_button_widget.dart';

class SellerInventoryScreen extends StatelessWidget {
  SellerInventoryScreen({super.key});

  final RxInt selectedTabIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.inventory,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add new item
        },
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: Colors.white, size: 30.sp),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            // 1. Tabs
            Row(
              spacing: 20.w,
              children:[
                _buildTab(AppStrings.active, 0, colorScheme),
                _buildTab(AppStrings.draft, 1, colorScheme),
                _buildTab(AppStrings.inactive, 2, colorScheme),
              ],
            ),
            SizedBoxWidget(height: 15.h),

            // 2. Search & Filter
            Row(
              children:[
                Expanded(
                  child: CustomTextField(
                    hintText: AppStrings.search,
                    controller: TextEditingController(),
                    label: AppStrings.search,
                  ),
                ),
                SizedBoxWidget(width: 10.w),
                IconButton(
                  onPressed: () {
                    // Open Filter Dialog
                  },
                  icon: Icon(Icons.tune, color: colorScheme.primary),
                ),
              ],
            ),
            SizedBoxWidget(height: 20.h),

            // 3. Products Count
            CustomText(
              text: AppStrings.zeroProducts,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontColor: colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index, ColorScheme colorScheme) {
    return Obx(() {
      final isSelected = selectedTabIndex.value == index;
      return TextButtonWidget(
        text: title,
        fontSize: 14,
        textColor: isSelected ? colorScheme.onSurface : colorScheme.outline,
        decoration: isSelected ? TextDecoration.underline : null,
        decorationColor: colorScheme.primary,
        fontWeight: FontWeight.w600,
        onPressed: () => selectedTabIndex.value = index,
      );
    });
  }
}