import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/text_button_widget.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/modules/seller/controllers/seller_inventory_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class SellerInventoryScreen extends GetView<SellerInventoryController> {
  const SellerInventoryScreen({super.key});

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
        onPressed: () => Get.toNamed(AppRoutes.createQualityListingScreen),
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: Colors.white, size: 30.sp),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Obx(() => Row(
              spacing: 20.w,
              children: [
                _buildTab(AppStrings.active, 0, colorScheme),
                _buildTab(AppStrings.draft, 1, colorScheme),
                _buildTab(AppStrings.inactive, 2, colorScheme),
              ],
            )),
            SizedBoxWidget(height: 15.h),

            // Search & Filter
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: AppStrings.search,
                    controller: controller.searchController,
                    label: AppStrings.search,
                    onChanged: (v) => controller.searchQuery.value = v,
                  ),
                ),
                SizedBoxWidget(width: 10.w),
                IconButton(
                  onPressed: controller.loadProducts,
                  icon: Icon(Icons.refresh, color: colorScheme.primary),
                ),
              ],
            ),
            SizedBoxWidget(height: 15.h),

            // Product count
            Obx(() => CustomText(
              text: '${controller.filteredProducts.length} Product${controller.filteredProducts.length == 1 ? '' : 's'}',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontColor: colorScheme.onSurface,
            )),
            SizedBoxWidget(height: 10.h),

            // List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = controller.filteredProducts;
                if (items.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No ${controller.selectedTabIndex.value == 0 ? 'active' : controller.selectedTabIndex.value == 1 ? 'draft' : 'inactive'} products.',
                      fontSize: 14,
                      fontColor: colorScheme.outline,
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) => Divider(color: colorScheme.outline.withValues(alpha: 0.15), height: 1),
                  itemBuilder: (context, index) => _ProductTile(product: items[index]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index, ColorScheme colorScheme) {
    final isSelected = controller.selectedTabIndex.value == index;
    return TextButtonWidget(
      text: title,
      fontSize: 14,
      textColor: isSelected ? colorScheme.onSurface : colorScheme.outline,
      decoration: isSelected ? TextDecoration.underline : null,
      decorationColor: colorScheme.primary,
      fontWeight: FontWeight.w600,
      onPressed: () => controller.selectTab(index),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final ProductModel product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ctrl = Get.find<SellerInventoryController>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: product.images.isNotEmpty
                ? Image.network(
                    product.images.first,
                    width: 64.w,
                    height: 64.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => _placeholder(colorScheme),
                  )
                : _placeholder(colorScheme),
          ),
          SizedBoxWidget(width: 12.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: product.title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontColor: colorScheme.onSurface,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBoxWidget(height: 4.h),
                CustomText(
                  text: '${product.displayPrice}  ·  Qty ${product.quantity - product.quantitySold}',
                  fontSize: 12,
                  fontColor: colorScheme.outline,
                ),
                SizedBoxWidget(height: 4.h),
                _StatusBadge(status: product.status, colorScheme: colorScheme),
              ],
            ),
          ),

          // Action button(s)
          if (product.isDraft)
            IconButton(
              icon: Icon(Icons.publish_outlined, color: colorScheme.primary),
              onPressed: () => ctrl.publishProduct(product.id),
              tooltip: 'Publish',
            )
          else if (product.isActive) ...[
            if (product.isAuction)
              IconButton(
                icon: Icon(Icons.gavel, color: AppColors.orange),
                onPressed: () => ctrl.pinProductForAuction(product),
                tooltip: 'Start Auction',
              ),
            IconButton(
              icon: Icon(Icons.pause_circle_outline, color: colorScheme.outline),
              onPressed: () => ctrl.deactivateProduct(product.id),
              tooltip: 'Deactivate',
            ),
          ],
        ],
      ),
    );
  }

  Widget _placeholder(ColorScheme cs) => Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(Icons.image_outlined, color: cs.outline, size: 28.sp),
      );
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final ColorScheme colorScheme;
  const _StatusBadge({required this.status, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case 'active':
        bg = Colors.green.withValues(alpha: 0.15);
        fg = Colors.green;
      case 'draft':
        bg = colorScheme.outline.withValues(alpha: 0.15);
        fg = colorScheme.outline;
      case 'inactive':
        bg = Colors.orange.withValues(alpha: 0.15);
        fg = Colors.orange;
      default:
        bg = colorScheme.outline.withValues(alpha: 0.1);
        fg = colorScheme.outline;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20.r)),
      child: CustomText(text: status.capitalize!, fontSize: 11, fontColor: fg),
    );
  }
}
