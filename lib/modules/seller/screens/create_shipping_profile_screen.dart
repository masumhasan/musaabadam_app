import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_shipping_service.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';

import '../../../core/widgets/sized_box_widget.dart';

class CreateShippingProfileScreen extends StatelessWidget {
  CreateShippingProfileScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController flatRateController = TextEditingController();
  final TextEditingController freeOverController = TextEditingController();
  final RxBool _isSaving = false.obs;

  // Backend carrier keys → display labels (see ShippingProfile.CARRIERS).
  static const Map<String, String> _carriers = {
    'royal_mail': 'Royal Mail',
    'dpd': 'DPD',
    'evri': 'Evri',
    'ups': 'UPS',
  };
  final RxString selectedCarrier = 'royal_mail'.obs;

  Future<void> _save() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Required', 'Please enter a profile name.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final flatRate = double.tryParse(flatRateController.text.trim());
    if (flatRateController.text.trim().isNotEmpty && (flatRate == null || flatRate < 0)) {
      Get.snackbar('Invalid rate', 'Enter a valid shipping rate (0 or more).', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final freeOver = double.tryParse(freeOverController.text.trim());

    if (_isSaving.value) return;
    _isSaving.value = true;
    try {
      await ApiShippingService.instance.createProfile({
        'name': name,
        'carrier': selectedCarrier.value,
        'flatRate': flatRate ?? 0,
        if (freeOver != null && freeOver > 0) 'freeShippingThreshold': freeOver,
        'handlingDays': 1,
      });
      Get.back();
      Get.snackbar('Saved', 'Shipping profile created.', snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiShippingService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      _isSaving.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.createShippingProfile,
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
            // Details Section
            CustomText(text: AppStrings.details, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            CustomTextField(label: AppStrings.name, hintText: AppStrings.name, controller: nameController),
            SizedBoxWidget(height: 15.h),
            Row(
              children:[
                Expanded(child: CustomTextField(label: AppStrings.weight, hintText: AppStrings.weight, controller: weightController)),
                SizedBoxWidget(width: 15.w),
                Expanded(child: _buildDropdownField(AppStrings.scale, colorScheme)),
              ],
            ),
            SizedBoxWidget(height: 25.h),

            // Item Dimensions Section
            CustomText(text: AppStrings.itemDimensions, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            Row(
              children:[
                Expanded(child: CustomTextField(label: AppStrings.length, hintText: AppStrings.length, controller: lengthController)),
                SizedBoxWidget(width: 15.w),
                Expanded(child: CustomTextField(label: AppStrings.width, hintText: AppStrings.width, controller: widthController)),
              ],
            ),
            SizedBoxWidget(height: 15.h),
            Row(
              children:[
                Expanded(child: CustomTextField(label: AppStrings.height, hintText: AppStrings.height, controller: heightController)),
                SizedBoxWidget(width: 15.w),
                Expanded(child: _buildDropdownField(AppStrings.scale, colorScheme)),
              ],
            ),

            SizedBoxWidget(height: 25.h),

            // Shipping Rate Section
            CustomText(text: AppStrings.shippingRate, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            Row(
              children:[
                Expanded(
                  child: CustomTextField(
                    label: AppStrings.flatRate,
                    hintText: AppStrings.flatRate,
                    controller: flatRateController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                SizedBoxWidget(width: 15.w),
                Expanded(child: _buildCarrierDropdown(colorScheme)),
              ],
            ),
            SizedBoxWidget(height: 15.h),
            CustomTextField(
              label: AppStrings.freeShippingThreshold,
              hintText: AppStrings.freeShippingThreshold,
              controller: freeOverController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),

            SizedBoxWidget(height: 40.h),

            // Save Button
            Obx(() => CustomButton(
              label: AppStrings.save,
              textColor: Colors.white,
              buttonWidth: double.infinity,
              backgroundColor: colorScheme.primary,
              isLoading: _isSaving.value,
              onPressed: _save,
            )),
          ],
        ),
      ),
    );
  }

  // Carrier picker styled to match the scale dropdown.
  Widget _buildCarrierDropdown(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        CustomText(text: AppStrings.carrier, fontSize: 12, fontColor: colorScheme.onSurface),
        SizedBoxWidget(height: 8),
        Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: Obx(() => DropdownButton<String>(
              isExpanded: true,
              value: selectedCarrier.value,
              items: _carriers.entries
                  .map((e) => DropdownMenuItem<String>(value: e.key, child: Text(e.value)))
                  .toList(),
              onChanged: (val) {
                if (val != null) selectedCarrier.value = val;
              },
            )),
          ),
        ),
      ],
    );
  }

  // Custom Dropdown that matches your CustomTextField styling
  Widget _buildDropdownField(String label, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        CustomText(text: label, fontSize: 12, fontColor: colorScheme.onSurface),
        SizedBoxWidget(height: 8),
        Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: CustomText(text: AppStrings.scale, fontColor: colorScheme.outline),
              items:["Kg", "Lb"].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }
}