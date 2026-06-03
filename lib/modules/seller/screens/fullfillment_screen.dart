import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_button.dart';

enum ChipCategory { none, needLabel, readyToShip, unfulfilled }

class FulfillmentScreen extends StatelessWidget {
  FulfillmentScreen({super.key});

  final Rx<ChipCategory> selectedCategory = ChipCategory.none.obs;

  // State for chips
  final RxBool isFilterSelected = false.obs;
  final RxBool isNeedLabelSelected = false.obs;
  final RxBool isReadyToShipSelected = false.obs;
  final RxBool isUnfulfilledSelected = false.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.fulfillment,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            // Horizontal Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:[
                  _buildChip2(AppStrings.filter, isFilterSelected,
                  onClick: (){
                    showFilterDialog(context);
                  }
                  ),
                  SizedBoxWidget(width: 10.w),
                  _buildChip(AppStrings.needLabel, ChipCategory.needLabel, selectedCategory),
                  SizedBoxWidget(width: 10.w),

                  _buildChip(AppStrings.readyToShip, ChipCategory.readyToShip, selectedCategory),
                  SizedBoxWidget(width: 10.w),

                  _buildChip(AppStrings.unfulfilled, ChipCategory.unfulfilled, selectedCategory),
                ],
              ),
            ),
            SizedBoxWidget(height: 20.h),

            // Content Section
            CustomText(
              text: AppStrings.allShipments,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontColor: colorScheme.onSurface,
            ),
            SizedBoxWidget(height: 5.h),
            CustomText(
              text: AppStrings.shipmentsToFulfill,
              fontSize: 14,
              fontColor: colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  // Provided function for chips
  Widget _buildChip2(String label, RxBool state, {VoidCallback? onClick}) {
    return Obx(() => CustomChoiceChip(
      label: label.tr,
      selected: state.value,
      borderRadius: 50,
      onSelected: (val){
        state.value = !state.value;
        if(onClick != null) onClick();
      },
    ));
  }

  Widget _buildChip(String label, ChipCategory categoryType, Rx<ChipCategory> groupValue) {
    return Obx(() => CustomChoiceChip(
      label: label.tr,
      // It's selected if the group value matches this specific chip's type
      selected: groupValue.value == categoryType,
      borderRadius: 50,
      onSelected: (val) {
        // If tapped while already selected, deselect it (set to none). Otherwise, select it.
        if (groupValue.value == categoryType) {
          groupValue.value = ChipCategory.none;
        } else {
          groupValue.value = categoryType;
        }
      },
    ));
  }

  void showFilterDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final RxString selectedStatus = ''.obs;

    final List<String> statusOptions =[
      AppStrings.needsLabel,
      AppStrings.readyToShip,
      AppStrings.unfulfilled,
      AppStrings.shipping,
      AppStrings.delivered,
      AppStrings.cancelled,
      AppStrings.pickup,
    ];

    Get.dialog(
      Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Container(
          //width: 0.9.sw,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  CustomText(text: AppStrings.filters, fontSize: 18, fontWeight: FontWeight.w700),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
                ],
              ),
              SizedBox(height: 20.h),

              // Split Layout (Status Sidebar + Options List)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      CustomText(text: AppStrings.status, fontColor: colorScheme.primary, fontWeight: FontWeight.w600),
                      SizedBox(height: 10.h),
                      Container(width: 2.w, height: 250.h, color: colorScheme.outline.withValues(alpha: 0.3)),
                    ],
                  ),
                  SizedBox(width: 20.w),
                  // Options List
                  Expanded(
                    child: Column(
                      children:[
                        CustomText(text: AppStrings.status, fontColor: colorScheme.primary, fontWeight: FontWeight.w600),
                        SizedBox(height: 10.h),
                        ...statusOptions.map((option) => Obx(() => RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: CustomText(text: option, textAlignment: TextAlign.start, fontSize: 14),
                          value: option,
                          groupValue: selectedStatus.value,
                          onChanged: (val) => selectedStatus.value = val!,
                        ))),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Footer Buttons
              Row(
                children:[
                  Expanded(
                    child: CustomButton(
                      label: AppStrings.clearAll,
                      fontSize: 12,
                      backgroundColor: Colors.grey,
                      onPressed: () => selectedStatus.value = '',
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: CustomButton(
                      fontSize: 12,
                      label: AppStrings.showResults,
                      backgroundColor: AppColors.primaryColor,
                      textColor: Colors.white,
                      onPressed: () => Get.back(),
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
}