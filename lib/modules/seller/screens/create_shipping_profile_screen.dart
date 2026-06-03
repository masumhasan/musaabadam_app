import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

            SizedBoxWidget(height: 40.h),

            // Save Button
            CustomButton(
              label: AppStrings.save,
              textColor: Colors.white,
              buttonWidth: double.infinity,
              backgroundColor: colorScheme.primary,
              onPressed: () {},
            ),
          ],
        ),
      ),
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