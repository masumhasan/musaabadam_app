import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

import '../../../core/utils/app_colors.dart';

class CreateQualityListingScreen extends StatelessWidget {
  CreateQualityListingScreen({super.key});

  final RxInt quantity = 1.obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final RxInt selectedType = 0.obs; // 0: Buy It Now, 1: Auction, 2: Giveaway
  final RxBool isFlashSale = false.obs;
  final RxBool acceptOffers = false.obs;
  final RxBool reserveForLive = false.obs;
  final RxBool isHazardous = false.obs;

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
          children:[
            // Media Section
            CustomText(text: AppStrings.media, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30.h),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children:[
                  CustomText(text: AppStrings.optional, fontColor: colorScheme.primary, fontSize: 12),
                  Icon(Icons.image_outlined, size: 30.sp, color: colorScheme.primary),
                  CustomText(text: AppStrings.addPhotos, fontColor: colorScheme.primary, fontWeight: FontWeight.w600),
                ],
              ),
            ),
            CustomText(text: AppStrings.photosLimit, fontSize: 12, fontColor: colorScheme.outline),
            SizedBoxWidget(height: 20.h),

            // Product Details Section
            CustomText(text: AppStrings.productDetails, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),

            // Category Button (using CustomButton for consistency)
            CustomButton(
              label: AppStrings.category,
              backgroundColor: colorScheme.primary,
              icon: Icons.arrow_forward_ios,
              prefixIcon: Icons.grid_view_outlined,
              textColor: Colors.white,
              buttonHeight: 50.h,
              buttonRadius: 8.r,
              onPressed: () {},
            ),
            SizedBoxWidget(height: 15.h),

            CustomTextField(hintText: AppStrings.title, controller: titleController, label: AppStrings.title,),
            SizedBoxWidget(height: 15.h),
            CustomTextField(
              hintText: AppStrings.description,
              controller: descController,
              label: AppStrings.description,
            ),
            SizedBoxWidget(height: 20.h),

            // Quality Available
            CustomText(text: AppStrings.qualityAvailable, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            Row(
              children:[
                _buildQuantityBtn(Icons.remove, () => quantity.value = (quantity.value > 1) ? quantity.value - 1 : 1),
                SizedBox(width: 15.w),
                Obx(() => CustomText(text: '${quantity.value}', fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 15.w),
                _buildQuantityBtn(Icons.add, () => quantity.value++),
              ],
            ),
            SizedBoxWidget(height: 20.h),

            // Variants Button
            CustomButton(
              label: AppStrings.variants,
              backgroundColor: colorScheme.primary,
              icon: Icons.arrow_forward_ios,
              textColor: Colors.white,
              buttonHeight: 50.h,
              buttonRadius: 8.r,
              onPressed: () {},
            ),
            const SizedBox(height: 10,),
            Obx(() => Row(
              children:[
                _buildTypeButton(AppStrings.buyItNow, 0, colorScheme),
                SizedBoxWidget(width: 10.w),
                _buildTypeButton(AppStrings.auction, 1, colorScheme),
                SizedBoxWidget(width: 10.w),
                _buildTypeButton(AppStrings.giveaway, 2, colorScheme),
              ],
            )),
            SizedBoxWidget(height: 20.h),

            CustomTextField(hintText: AppStrings.price, label: AppStrings.price, controller: TextEditingController(),),
            SizedBoxWidget(height: 20.h),

            // Switches
            _buildSwitchTile(AppStrings.flashSale, isFlashSale, colorScheme),
            _buildSwitchTile(AppStrings.acceptOffers, acceptOffers, colorScheme),

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
            _buildSwitchTile(AppStrings.reserveForLive, reserveForLive, colorScheme),

            SizedBoxWidget(height: 20.h),
            CustomButton(
              label: AppStrings.shippingProfile,
              textColor: Colors.white,
              backgroundColor: colorScheme.primary,
              icon: Icons.chevron_right,
              prefixSvgIcon: null, // Add your SVG path here
              prefixIcon: Icons.local_shipping_outlined,
              buttonHeight: 50.h,
              buttonRadius: 8.r,
              onPressed: () {},
            ),

            SizedBoxWidget(height: 15.h),
            _buildSwitchTile(AppStrings.hazardousMaterials, isHazardous, colorScheme),

            SizedBoxWidget(height: 20.h),
            CustomText(text: AppStrings.optionalFields, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            CustomTextField(hintText: AppStrings.costPerItem, label: AppStrings.costPerItem, controller: TextEditingController()),
            SizedBoxWidget(height: 15.h),
            CustomTextField(hintText: AppStrings.sku, label: AppStrings.sku,controller: TextEditingController(),),

            SizedBoxWidget(height: 30.h),
            Row(
              children:[
                Expanded(
                  child: CustomButton(
                    label: AppStrings.saveDraft,
                  ),
                ),
                SizedBoxWidget(width: 15.w),
                Expanded(
                  child: CustomButton(
                    label: AppStrings.publish,
                    backgroundColor: AppColors.orange,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, int index, ColorScheme colorScheme) {
    final isSelected = selectedType.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => selectedType.value = index,
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
        children:[
          CustomText(text: title, fontWeight: FontWeight.w600),
          Obx(() => Switch(
            value: state.value,
            activeColor: colorScheme.primary,
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