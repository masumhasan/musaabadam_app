import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

class SellerAddressScreen extends StatelessWidget {
  SellerAddressScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.setupProfile,
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
            // Header Section
            CustomText(
              text: AppStrings.whereShouldWeSend,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.onSurface,
            ),
            SizedBoxWidget(height: 10.h),
            CustomText(
              text: AppStrings.toPreventDelays,
              fontSize: 14,
              textAlignment: TextAlign.start,
              fontColor: colorScheme.outline,
            ),
            SizedBoxWidget(height: 20.h),

            // Search Address Field
            CustomTextField(
              label: AppStrings.searchAddress,
              hintText: AppStrings.searchAddress,
              controller: TextEditingController(),
            ),

            SizedBoxWidget(height: 20.h),
            Center(
              child: CustomText(
                text: AppStrings.orEnterManually,
                fontSize: 14,
                fontColor: colorScheme.outline,
              ),
            ),
            SizedBoxWidget(height: 20.h),

            // Form Fields with Label and Hint
            CustomTextField(label: AppStrings.fullName, hintText: AppStrings.fullName, controller: nameController),
            SizedBoxWidget(height: 15.h),
            CustomTextField(label: AppStrings.address, hintText: AppStrings.address, controller: addressController),
            SizedBoxWidget(height: 15.h),
            CustomTextField(label: AppStrings.address2, hintText: AppStrings.address2, controller: address2Controller),
            SizedBoxWidget(height: 15.h),
            CustomTextField(label: AppStrings.city, hintText: AppStrings.city, controller: cityController),
            SizedBoxWidget(height: 15.h),
            CustomTextField(label: AppStrings.stateProvince, hintText: AppStrings.stateProvince, controller: stateController),
            SizedBoxWidget(height: 15.h),
            CustomTextField(label: AppStrings.postalCode, hintText: AppStrings.postalCode, controller: zipController),
            SizedBoxWidget(height: 15.h),

            // Country Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: AppStrings.country,
                labelStyle: TextStyle(color: colorScheme.onSurface),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
                ),
              ),
              hint: CustomText(text: AppStrings.country, fontColor: colorScheme.outline),
              items: ["USA", "UK", "Canada"].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (_) {},
            ),

            SizedBoxWidget(height: 40.h),

            // Next Button
            CustomButton(
              label: AppStrings.next,
              buttonWidth: double.infinity,
              textColor: Colors.white,
              backgroundColor: AppColors.orange,
              onPressed: () {
                Get.toNamed(AppRoutes.sellerAverageEarningScreen);
              },
            ),
            SizedBoxWidget(height: 20.h),
          ],
        ),
      ),
    );
  }
}