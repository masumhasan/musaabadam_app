import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

class ScheduleLiveShowScreen extends StatelessWidget {
  ScheduleLiveShowScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController modController = TextEditingController();
  final RxString selectedRepeat = AppStrings.doesNotRepeat.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxBool explicitContent = false.obs;
  final RxString discoverability = 'Public'.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.scheduleALiveShow,
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
            CustomTextField(
                label: AppStrings.nameYourShow,
                hintText: AppStrings.nameYourShow,
                controller: nameController
            ),
            SizedBoxWidget(height: 15.h),

            // Date & Time Row
            Row(
              children:[
                Expanded(child: CustomTextField(label: AppStrings.date, hintText: "22 October, 2025", controller: TextEditingController(),)),
                SizedBox(width: 15.w),
                Expanded(child: CustomTextField(label: AppStrings.time, hintText: "10:18 PM", controller: TextEditingController(), )),
              ],
            ),
            SizedBoxWidget(height: 15.h),

            CustomTextField(label: AppStrings.addModerators, hintText: "Excellent", controller: modController),
            SizedBoxWidget(height: 15.h),

            // Repeats Dropdown
            CustomText(text: AppStrings.repeats, fontWeight: FontWeight.w600),
            SizedBoxWidget(height: 8.h),
            DropdownButtonFormField<String>(
              value: selectedRepeat.value,
              items: [AppStrings.doesNotRepeat].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) => selectedRepeat.value = val!,
              decoration: _inputDecoration(colorScheme),
            ),
            SizedBoxWidget(height: 20.h),

            // Media Section
            CustomText(text: AppStrings.media, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            _buildMediaBox(context, AppStrings.addThumbnail, Icons.image_outlined),
            SizedBoxWidget(height: 10.h),
            _buildMediaBox(context, AppStrings.addVideo, Icons.play_circle_outline),

            SizedBoxWidget(height: 20.h),

            // Category Section
            CustomText(text: AppStrings.primaryCategory, fontWeight: FontWeight.w700),
            CustomText(text: AppStrings.recentlyUsed, fontSize: 12, fontColor: colorScheme.outline),
            SizedBoxWidget(height: 10.h),
            Row(
              spacing: 10.w,
              children:[
                _buildCategoryChip(AppStrings.streetwear, 0),
                _buildCategoryChip(AppStrings.everythingElse, 1),
                _buildCategoryChip(AppStrings.makeup, 2),
              ],
            ),
            const SizedBox(height: 12,),
            _buildDropdown(AppStrings.category, colorScheme),
            _buildDropdown(AppStrings.primarySellingFormat, colorScheme, hint: AppStrings.format),

            // Primary Tags
            CustomText(text: AppStrings.primaryTags, fontWeight: FontWeight.w600),
            SizedBoxWidget(height: 10.h),
            Wrap(
              spacing: 10.w,
              children:["Tees", "Women's", "Makeup"].map((tag) => _buildTagChip(tag, colorScheme)).toList(),
            ),
            SizedBoxWidget(height: 10.h),
            _buildDropdown(AppStrings.tags, colorScheme, hint: AppStrings.tags),

            _buildDropdown(AppStrings.primaryBrand, colorScheme, hint: AppStrings.brand),

            // Shipping Settings
            _buildSettingsTile(AppStrings.shippingSettings, AppStrings.freePickup, "ON", colorScheme),

            // Content Settings
            CustomText(text: AppStrings.contentSettings, fontWeight: FontWeight.w600),
            Obx(() => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomText(text: AppStrings.explicitContent, textAlignment: TextAlign.start),
              value: explicitContent.value,
              onChanged: (val) => explicitContent.value = val,
            )),

            _buildDropdown(AppStrings.mutedWords, colorScheme, hint: "Fake, Replica"),
            _buildDropdown(AppStrings.primaryLanguage, colorScheme, hint: "English"),

            SizedBoxWidget(height: 20.h),
            CustomText(text: AppStrings.showDiscoverability, fontWeight: FontWeight.w600),
            Obx(() => RadioListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomText(text: AppStrings.public, textAlignment: TextAlign.start),
              value: AppStrings.public,
              groupValue: discoverability.value,
              onChanged: (val) => discoverability.value = val!,
            )),
            Obx(() => RadioListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomText(text: AppStrings.private, textAlignment: TextAlign.start),
              value: AppStrings.private,
              groupValue: discoverability.value,
              onChanged: (val) => discoverability.value = val!,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String label, ColorScheme colorScheme) {
    return Chip(
      label: CustomText(text: label, fontColor: colorScheme.primary),
      backgroundColor: colorScheme.primaryContainer,
      side: BorderSide.none,
    );
  }

  Widget _buildSettingsTile(String section, String title, String trailing, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        CustomText(text: section, fontWeight: FontWeight.w600),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: CustomText(text: title, textAlignment: TextAlign.start),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children:[
              CustomText(text: trailing, fontColor: colorScheme.outline),
              Icon(Icons.chevron_right, color: colorScheme.onSurface),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String title, ColorScheme colorScheme, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        CustomText(text: title, fontWeight: FontWeight.w600),
        SizedBoxWidget(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: CustomText(text: hint ?? title, fontColor: colorScheme.outline),
              items: [], // Add your logic here
              onChanged: (_) {},
            ),
          ),
        ),
        SizedBoxWidget(height: 15.h),
      ],
    );
  }

  Widget _buildMediaBox(BuildContext context, String label, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children:[
          CustomText(text: AppStrings.optional, fontColor: colorScheme.primary, fontSize: 12),
          Icon(icon, size: 30.sp, color: colorScheme.primary),
          CustomText(text: label, fontColor: colorScheme.primary, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, int index) {
    return Obx(() => CustomChoiceChip(
      label: label,
      selected: selectedCategoryIndex.value == index,
      colorChangeable: true,
      borderRadius: 100,
      onSelected: (_) => selectedCategoryIndex.value = index,
    ));
  }

  InputDecoration _inputDecoration(ColorScheme colorScheme) {
    return InputDecoration(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorScheme.outline)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2))),
    );
  }
}