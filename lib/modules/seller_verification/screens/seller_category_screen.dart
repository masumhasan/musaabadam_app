import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/components/category_item.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/seller_verification/controllers/seller_verification_controller.dart';

class SellerCategoryScreen extends GetView<SellerVerificationController> {
  const SellerCategoryScreen({super.key});

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
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBoxWidget(height: 20.h),

            // Title & Subtitle
            CustomText(
              text: AppStrings.whichCategory.tr,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.onSurface,
            ),
            SizedBoxWidget(height: 8.h),
            CustomText(
              text: AppStrings.pickAFew.tr,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.outline,
            ),
            SizedBoxWidget(height: 20.h),

            // Grid of CategoryItems
            Expanded(
              child: Obx(() {
                if (controller.categoriesLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.categories.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'No categories available.',
                      fontSize: 14,
                      fontColor: colorScheme.outline,
                    ),
                  );
                }
                return GridView.builder(
                  itemCount: controller.categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 2.w,
                    mainAxisExtent: 100.h,
                    mainAxisSpacing: 6.h,
                  ),
                  itemBuilder: (context, index) {
                    final cat = controller.categories[index];
                    return Obx(() {
                      final isSelected = controller.selectedCategoryIds.contains(cat.id);
                      return CategoryItem(
                        image: cat.imageUrl ?? '',
                        itemName: cat.name,
                        onSelectionChanged: (selected) {
                          controller.toggleCategory(cat.id, selected);
                        },
                        // Force the widget to reflect controller state
                        key: ValueKey('${cat.id}_$isSelected'),
                      );
                    });
                  },
                );
              }),
            ),

            // Bottom Next Button
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: CustomButton(
                label: AppStrings.next,
                buttonWidth: double.infinity,
                textColor: Colors.white,
                backgroundColor: AppColors.orange,
                onPressed: () async {
                  await controller.loadSubcategories();
                  Get.toNamed(AppRoutes.sellerSubCategoryScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
