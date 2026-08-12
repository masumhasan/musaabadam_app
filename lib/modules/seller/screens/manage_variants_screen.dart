import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/seller/controllers/create_product_controller.dart';

class ManageVariantsScreen extends GetView<CreateProductController> {
  const ManageVariantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: 'Manage Product Variants',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: colorScheme.primary, size: 26.sp),
            onPressed: controller.addVariant,
            tooltip: 'Add Variant',
          ),
          SizedBox(width: 8.w),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                final totalQty = controller.variantInputs.fold<int>(
                  0,
                  (sum, item) => sum + item.quantity.value,
                );
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Total Listing Quantity:',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        fontColor: colorScheme.onSurface,
                      ),
                      CustomText(
                        text: '$totalQty units',
                        fontWeight: FontWeight.w800,
                        fontSize: 16.sp,
                        fontColor: colorScheme.primary,
                      ),
                    ],
                  ),
                );
              }),
              CustomButton(
                label: 'Save & Done',
                backgroundColor: colorScheme.primary,
                textColor: Colors.white,
                buttonHeight: 48.h,
                buttonRadius: 10.r,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                onPressed: () {
                  controller.recalculateTotalQuantityFromVariants();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        final variants = controller.variantInputs;
        if (variants.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.style_outlined,
                    size: 64.sp,
                    color: colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  SizedBoxWidget(height: 16.h),
                  CustomText(
                    text: 'No Variants Added Yet',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    fontColor: colorScheme.onSurface,
                  ),
                  SizedBoxWidget(height: 8.h),
                  CustomText(
                    text: 'Add variants like Color (e.g. Pink, White) or Size. Each variant can have its own photo and stock quantity.',
                    fontSize: 13.sp,
                    fontColor: colorScheme.outline,
                    textAlignment: TextAlign.center,
                  ),
                  SizedBoxWidget(height: 24.h),
                  CustomButton(
                    label: '+ Add First Variant',
                    backgroundColor: colorScheme.primary,
                    textColor: Colors.white,
                    buttonWidth: 200.w,
                    buttonHeight: 44.h,
                    buttonRadius: 8.r,
                    onPressed: controller.addVariant,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: variants.length + 1,
          separatorBuilder: (context, index) => SizedBox(height: 14.h),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: colorScheme.primary, size: 20.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomText(
                        text: 'Upload photos and set available quantity for each variant. Total quantity auto-syncs.',
                        fontSize: 12.sp,
                        fontColor: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }

            final varIdx = index - 1;
            final item = variants[varIdx];

            return Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Variant Image picker
                      GestureDetector(
                        onTap: () => controller.pickVariantImage(varIdx),
                        child: Obx(() {
                          final file = item.pickedFile.value;
                          final netUrl = item.imageUrl.value;

                          Widget imgChild;
                          if (file != null) {
                            imgChild = Image.file(file, fit: BoxFit.cover, width: 64.w, height: 64.h);
                          } else if (netUrl.isNotEmpty) {
                            imgChild = Image.network(netUrl, fit: BoxFit.cover, width: 64.w, height: 64.h);
                          } else {
                            imgChild = Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined, size: 22.sp, color: colorScheme.primary),
                                SizedBox(height: 2.h),
                                CustomText(text: 'Photo', fontSize: 10.sp, fontColor: colorScheme.primary),
                              ],
                            );
                          }

                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Container(
                                  width: 64.w,
                                  height: 64.h,
                                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                                  child: imgChild,
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.edit, size: 10.sp, color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(width: 12.w),
                      // Variant Name Field
                      Expanded(
                        child: TextField(
                          controller: item.nameController,
                          decoration: InputDecoration(
                            labelText: 'Variant Name (e.g. Pink, White)',
                            labelStyle: TextStyle(fontSize: 12.sp, color: colorScheme.outline),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      // Delete button
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 22.sp),
                        onPressed: () => controller.removeVariant(varIdx),
                        tooltip: 'Remove Variant',
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Quantity Counter Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Quantity Available:',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        fontColor: colorScheme.onSurface,
                      ),
                      Row(
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: Icon(Icons.remove_circle_outline, color: colorScheme.primary, size: 24.sp),
                            onPressed: () {
                              if (item.quantity.value > 0) {
                                item.quantity.value--;
                                controller.recalculateTotalQuantityFromVariants();
                              }
                            },
                          ),
                          Obx(() => SizedBox(
                            width: 36.w,
                            child: Text(
                              '${item.quantity.value}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          )),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: Icon(Icons.add_circle_outline, color: colorScheme.primary, size: 24.sp),
                            onPressed: () {
                              item.quantity.value++;
                              controller.recalculateTotalQuantityFromVariants();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
