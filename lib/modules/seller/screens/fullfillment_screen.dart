import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/data/models/order/order_model.dart';
import 'package:musaab_adam/modules/seller/controllers/fulfillment_controller.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/custom_button.dart';

class FulfillmentScreen extends GetView<FulfillmentController> {
  FulfillmentScreen({super.key});

  // Toggle state for the filter dialog chip.
  final RxBool isFilterSelected = false.obs;

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
                  _buildChip(AppStrings.needLabel, FulfillmentFilter.needLabel),
                  SizedBoxWidget(width: 10.w),

                  _buildChip(AppStrings.readyToShip, FulfillmentFilter.readyToShip),
                  SizedBoxWidget(width: 10.w),

                  _buildChip(AppStrings.unfulfilled, FulfillmentFilter.unfulfilled),
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
            SizedBoxWidget(height: 15.h),

            // Shipments list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final orders = controller.filtered;
                if (orders.isEmpty) {
                  return Center(child: CustomText(text: AppStrings.nothingHere, fontColor: colorScheme.outline));
                }
                return RefreshIndicator(
                  onRefresh: controller.load,
                  child: ListView.separated(
                    itemCount: orders.length,
                    separatorBuilder: (_, _) => SizedBoxWidget(height: 12.h),
                    itemBuilder: (context, index) => _shipmentItem(orders[index], colorScheme),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shipmentItem(OrderModel order, ColorScheme colorScheme) {
    final item = order.items.isNotEmpty ? order.items.first : null;
    final imageUrl = (item?.imageUrl?.isNotEmpty ?? false) ? item!.imageUrl! : Dummy.product1;
    final needsLabel = order.trackingNumber == null;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedImageWidget(imageUrl: imageUrl, height: 70.h, width: 70.w),
          ),
          SizedBoxWidget(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: item?.title ?? 'Order',
                  fontWeight: FontWeight.w600,
                  textAlignment: TextAlign.start,
                  maxLines: 1,
                ),
                CustomText(
                  text: '£${order.totalAmount.toStringAsFixed(2)} · ${order.status}',
                  fontSize: 13,
                  fontColor: colorScheme.outline,
                  textAlignment: TextAlign.start,
                ),
                if (order.trackingNumber != null)
                  CustomText(
                    text: '${order.trackingCarrier ?? ''}  ${order.trackingNumber}',
                    fontSize: 12,
                    fontColor: colorScheme.primary,
                    textAlignment: TextAlign.start,
                  ),
                SizedBoxWidget(height: 8.h),
                Obx(() {
                  final busy = controller.busyOrderId.value == order.id;
                  return CustomButton(
                    label: needsLabel ? AppStrings.readyToShip : 'Mark delivered',
                    fontSize: 12,
                    buttonHeight: 34,
                    backgroundColor: needsLabel ? colorScheme.primary : AppColors.orange,
                    textColor: Colors.white,
                    isLoading: busy,
                    onPressed: () => needsLabel ? controller.generateLabel(order) : controller.markDelivered(order),
                  );
                }),
              ],
            ),
          ),
        ],
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

  Widget _buildChip(String label, FulfillmentFilter categoryType) {
    return Obx(() => CustomChoiceChip(
      label: label.tr,
      // Selected when the controller's active filter matches this chip.
      selected: controller.filter.value == categoryType,
      borderRadius: 50,
      onSelected: (val) {
        // Tapping the active chip clears the filter; otherwise apply it.
        controller.filter.value =
            controller.filter.value == categoryType ? FulfillmentFilter.none : categoryType;
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