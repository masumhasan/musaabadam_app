import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/seller/controllers/create_product_controller.dart';

import '../../../core/utils/app_colors.dart';

class CreateQualityListingScreen extends GetView<CreateProductController> {
  const CreateQualityListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: AppStrings.createQualityListing,
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
          children: [
            // Media Section
            CustomText(text: AppStrings.media, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            Obx(() {
              final images = controller.pickedImages;
              if (images.isEmpty) {
                return GestureDetector(
                  onTap: controller.pickImages,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        CustomText(text: AppStrings.optional, fontColor: colorScheme.primary, fontSize: 12),
                        Icon(Icons.image_outlined, size: 30.sp, color: colorScheme.primary),
                        CustomText(text: AppStrings.addPhotos, fontColor: colorScheme.primary, fontWeight: FontWeight.w600),
                      ],
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 90.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...images.asMap().entries.map((entry) => Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.file(
                              entry.value,
                              width: 90.w,
                              height: 90.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () => controller.removeImage(entry.key),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    if (images.length < CreateProductController.maxImages)
                      GestureDetector(
                        onTap: controller.pickImages,
                        child: Container(
                          width: 90.w,
                          height: 90.h,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.4)),
                          ),
                          child: Icon(Icons.add_photo_alternate_outlined, color: colorScheme.primary, size: 28.sp),
                        ),
                      ),
                  ],
                ),
              );
            }),
            CustomText(text: AppStrings.photosLimit, fontSize: 12, fontColor: colorScheme.outline),
            SizedBoxWidget(height: 20.h),

            // Product Details Section
            CustomText(text: AppStrings.productDetails, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),

            // Category + Condition button
            Obx(() => CustomButton(
              label: controller.selectedCategory.value != null
                  ? '${controller.selectedCategory.value!.name} · ${controller.selectedCondition.value}'
                  : AppStrings.category,
              backgroundColor: colorScheme.primary,
              icon: Icons.arrow_forward_ios,
              prefixIcon: Icons.grid_view_outlined,
              textColor: Colors.white,
              buttonHeight: 50.h,
              buttonRadius: 8.r,
              onPressed: () => _showCategoryConditionSheet(context, colorScheme),
            )),
            SizedBoxWidget(height: 15.h),

            CustomTextField(hintText: AppStrings.title, controller: controller.titleController, label: AppStrings.title),
            SizedBoxWidget(height: 15.h),
            CustomTextField(
              hintText: AppStrings.description,
              controller: controller.descController,
              label: AppStrings.description,
            ),
            SizedBoxWidget(height: 20.h),

            // Quantity
            CustomText(text: AppStrings.qualityAvailable, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            Row(
              children: [
                _buildQuantityBtn(Icons.remove, () => controller.quantity.value = (controller.quantity.value > 1) ? controller.quantity.value - 1 : 1),
                SizedBox(width: 15.w),
                Obx(() => CustomText(text: '${controller.quantity.value}', fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 15.w),
                _buildQuantityBtn(Icons.add, () => controller.quantity.value++),
              ],
            ),
            SizedBoxWidget(height: 20.h),

            // Variants (placeholder — navigates to future variants screen)
            CustomButton(
              label: AppStrings.variants,
              backgroundColor: colorScheme.primary,
              icon: Icons.arrow_forward_ios,
              textColor: Colors.white,
              buttonHeight: 50.h,
              buttonRadius: 8.r,
              onPressed: () {},
            ),
            const SizedBox(height: 10),

            // Listing Type
            Obx(() => Row(
              children: [
                _buildTypeButton(AppStrings.buyItNow, 0, colorScheme),
                SizedBoxWidget(width: 10.w),
                _buildTypeButton(AppStrings.auction, 1, colorScheme),
                SizedBoxWidget(width: 10.w),
                _buildTypeButton(AppStrings.giveaway, 2, colorScheme),
              ],
            )),
            SizedBoxWidget(height: 20.h),

            // Price field — label and behaviour adapts to listing type
            Obx(() {
              if (controller.selectedListingType.value == 2) {
                // Giveaway — no price
                return const SizedBox.shrink();
              }
              if (controller.selectedListingType.value == 1) {
                // Auction
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      hintText: 'Starting price',
                      label: 'Starting Price',
                      controller: controller.startingPriceController,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBoxWidget(height: 15.h),
                    GestureDetector(
                      onTap: () => controller.pickAuctionEndDateTime(context),
                      child: AbsorbPointer(
                        child: CustomTextField(
                          hintText: 'Pick auction end date & time',
                          label: 'Auction Ends At',
                          controller: controller.auctionEndDateController,
                        ),
                      ),
                    ),
                  ],
                );
              }
              // Buy It Now
              return CustomTextField(
                hintText: AppStrings.price,
                label: AppStrings.price,
                controller: controller.priceController,
                keyboardType: TextInputType.number,
              );
            }),
            SizedBoxWidget(height: 20.h),

            // Switches
            _buildSwitchTile(AppStrings.flashSale, controller.isFlashSale, colorScheme),
            _buildSwitchTile(AppStrings.acceptOffers, controller.acceptOffers, colorScheme),

            SizedBoxWidget(height: 10.h),
            CustomButton(
              label: AppStrings.selectMaxDiscount,
              backgroundColor: colorScheme.primary,
              icon: Icons.chevron_right,
              prefixIcon: Icons.percent_outlined,
              textColor: Colors.white,
              buttonHeight: 50.h,
              buttonRadius: 8.r,
              onPressed: () {},
            ),

            SizedBoxWidget(height: 15.h),
            _buildSwitchTile(AppStrings.reserveForLive, controller.reserveForLive, colorScheme),

            SizedBoxWidget(height: 20.h),
            CustomButton(
              label: AppStrings.shippingProfile,
              textColor: Colors.white,
              backgroundColor: colorScheme.primary,
              icon: Icons.chevron_right,
              prefixIcon: Icons.local_shipping_outlined,
              buttonHeight: 50.h,
              buttonRadius: 8.r,
              onPressed: () {},
            ),

            SizedBoxWidget(height: 15.h),
            _buildSwitchTile(AppStrings.hazardousMaterials, controller.isHazardous, colorScheme),

            SizedBoxWidget(height: 20.h),
            CustomText(text: AppStrings.optionalFields, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            CustomTextField(hintText: AppStrings.costPerItem, label: AppStrings.costPerItem, controller: controller.costController),
            SizedBoxWidget(height: 15.h),
            CustomTextField(hintText: AppStrings.sku, label: AppStrings.sku, controller: controller.skuController),

            SizedBoxWidget(height: 30.h),
            Obx(() {
              final busy = controller.isLoading.value;
              final uploading = controller.isUploading.value;
              final draftLabel = uploading ? 'Uploading…' : busy ? 'Saving…' : AppStrings.saveDraft;
              final publishLabel = uploading ? 'Uploading…' : busy ? 'Publishing…' : AppStrings.publish;
              return Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: draftLabel,
                      onPressed: busy ? null : () => controller.submitProduct(publishNow: false),
                    ),
                  ),
                  SizedBoxWidget(width: 15.w),
                  Expanded(
                    child: CustomButton(
                      label: publishLabel,
                      backgroundColor: AppColors.orange,
                      textColor: Colors.white,
                      onPressed: busy ? null : () => controller.submitProduct(publishNow: true),
                    ),
                  ),
                ],
              );
            }),
            SizedBoxWidget(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showCategoryConditionSheet(BuildContext context, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollCtrl) => Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: colorScheme.outline.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2))),
              ),
              SizedBoxWidget(height: 16.h),
              CustomText(text: 'Select Category', fontWeight: FontWeight.w700, fontSize: 18, fontColor: colorScheme.onSurface),
              SizedBoxWidget(height: 12.h),
              Obx(() {
                if (controller.categoriesLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Expanded(
                  child: ListView.builder(
                    controller: scrollCtrl,
                    itemCount: controller.categories.length + 2, // +2 for condition section
                    itemBuilder: (context, index) {
                      if (index < controller.categories.length) {
                        final cat = controller.categories[index];
                        return Obx(() => ListTile(
                          title: Text(cat.name, style: TextStyle(color: colorScheme.onSurface)),
                          trailing: controller.selectedCategory.value?.id == cat.id
                              ? Icon(Icons.check, color: colorScheme.primary)
                              : null,
                          onTap: () => controller.selectedCategory.value = cat,
                        ));
                      }
                      if (index == controller.categories.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                          child: CustomText(text: 'Condition', fontWeight: FontWeight.w700, fontSize: 18, fontColor: colorScheme.onSurface),
                        );
                      }
                      // Condition dropdown row
                      return Obx(() => Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: controller.selectedCondition.value,
                            items: List.generate(CreateProductController.conditions.length, (i) {
                              return DropdownMenuItem(
                                value: CreateProductController.conditions[i],
                                child: Text(CreateProductController.conditionLabels[i]),
                              );
                            }),
                            onChanged: (v) {
                              if (v != null) controller.selectedCondition.value = v;
                            },
                          ),
                        ),
                      ));
                    },
                  ),
                );
              }),
              SizedBoxWidget(height: 12.h),
              CustomButton(
                label: 'Done',
                backgroundColor: AppColors.orange,
                textColor: Colors.white,
                buttonWidth: double.infinity,
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, int index, ColorScheme colorScheme) {
    final isSelected = controller.selectedListingType.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedListingType.value = index,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: CustomText(
            text: label,
            fontColor: isSelected ? Colors.white : colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, RxBool state, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: title, fontWeight: FontWeight.w600),
          Obx(() => Switch(
            value: state.value,
            activeThumbColor: colorScheme.primary,
            onChanged: (val) => state.value = val,
          )),
        ],
      ),
    );
  }

  Widget _buildQuantityBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }
}
