import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

import '../../../core/utils/app_constants.dart';

class SellerOrderScreen extends StatelessWidget {
  SellerOrderScreen({super.key});

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
          text: AppStrings.order,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children:[
            SizedBoxWidget(height: 10.h),

            // Search Bar
            CustomTextField(
              hintText: AppStrings.searchOrders,
              controller: TextEditingController(),
              label: AppStrings.searchOrders,
            ),
            SizedBoxWidget(height: 15.h),

            // Tabs/Filters
            Row(
              spacing: 10.w,
              children:[
                _buildTab(AppStrings.all, 0),
                _buildTab(AppStrings.created, 1),
                _buildTab(AppStrings.processing, 2),
                _buildTab(AppStrings.completed, 3),
              ],
            ),
            SizedBoxWidget(height: 20.h),

            // List
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (ctx, index) => SizedBoxWidget(height: 15.h),
                itemBuilder: (context, index) {
                  // Mock data based on screenshot
                  String status = index == 2 ? AppStrings.processing : AppStrings.created;
                  return _buildOrderItem(status, colorScheme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    return Obx(() => CustomChoiceChip(
      label: label,
      selected: selectedTabIndex.value == index,
      colorChangeable: true,
      borderRadius: 50,
      onSelected: (_) => selectedTabIndex.value = index,
    ));
  }

  Widget _buildOrderItem(String status, ColorScheme colorScheme) {
    final bool isProcessing = status == AppStrings.processing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: CachedImageWidget(imageUrl: Dummy.product1, height: 100.h, width: 100.w),
        ),
        SizedBoxWidget(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isProcessing ? AppColors.orange : colorScheme.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  text: status,
                  fontSize: 12,
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBoxWidget(height: 8.h),
              CustomText(text: "Hand Bag", fontSize: 16, fontWeight: FontWeight.w600),
              CustomText(text: "${AppStrings.soldFor}£5,000", fontSize: 14, fontWeight: FontWeight.w700),
              CustomText(text: "${AppStrings.from}aum_burgains", fontSize: 14, fontColor: colorScheme.primary),
            ],
          ),
        ),
      ],
    );
  }
}