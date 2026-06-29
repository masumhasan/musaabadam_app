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
import 'package:musaab_adam/data/models/order/order_model.dart';
import 'package:musaab_adam/modules/seller/controllers/seller_orders_controller.dart';

import '../../../core/utils/app_constants.dart';

class SellerOrderScreen extends GetView<SellerOrdersController> {
  SellerOrderScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  RxInt get selectedTabIndex => controller.selectedTabIndex;

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
              controller: _searchController,
              label: AppStrings.searchOrders,
              onChanged: (v) => controller.search.value = v,
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.hasError.value) {
                  return Center(child: CustomText(text: AppStrings.nothingHere, fontColor: colorScheme.outline));
                }
                final orders = controller.filtered;
                if (orders.isEmpty) {
                  return Center(child: CustomText(text: AppStrings.nothingHere, fontColor: colorScheme.outline));
                }
                return RefreshIndicator(
                  onRefresh: controller.load,
                  child: ListView.separated(
                    itemCount: orders.length,
                    separatorBuilder: (ctx, index) => SizedBoxWidget(height: 15.h),
                    itemBuilder: (context, index) => _buildOrderItem(orders[index], colorScheme),
                  ),
                );
              }),
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

  Widget _buildOrderItem(OrderModel order, ColorScheme colorScheme) {
    final bool isProcessing = order.status == 'processing' || order.status == 'shipped';
    final item = order.items.isNotEmpty ? order.items.first : null;
    final title = item?.title ?? 'Order';
    final imageUrl = (item?.imageUrl?.isNotEmpty ?? false) ? item!.imageUrl! : Dummy.product1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: CachedImageWidget(imageUrl: imageUrl, height: 100.h, width: 100.w),
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
                  text: _statusLabel(order.status),
                  fontSize: 12,
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBoxWidget(height: 8.h),
              CustomText(text: title, fontSize: 16, fontWeight: FontWeight.w600, textAlignment: TextAlign.start),
              CustomText(
                text: "${AppStrings.soldFor}£${order.totalAmount.toStringAsFixed(2)}",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                textAlignment: TextAlign.start,
              ),
              if (order.trackingNumber != null)
                CustomText(
                  text: "${order.trackingCarrier ?? ''}  ${order.trackingNumber}",
                  fontSize: 13,
                  fontColor: colorScheme.primary,
                  textAlignment: TextAlign.start,
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _statusLabel(String status) =>
      status.isEmpty ? '' : '${status[0].toUpperCase()}${status.substring(1)}';
}