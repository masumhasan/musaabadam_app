import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/seller/controllers/schedule_show_controller.dart';

class ScheduleLiveShowScreen extends GetView<ScheduleShowController> {
  const ScheduleLiveShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: Obx(() => CustomText(
          text: controller.isEditMode ? 'Edit Show' : AppStrings.scheduleALiveShow,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: AppStrings.nameYourShow,
              hintText: AppStrings.nameYourShow,
              controller: controller.titleController,
            ),
            SizedBoxWidget(height: 15.h),

            // Date & Time Row — tapping opens system date/time pickers
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.pickDate(context),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: AppStrings.date,
                        hintText: '22 October, 2025',
                        controller: controller.dateController,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.pickTime(context),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: AppStrings.time,
                        hintText: '10:18 PM',
                        controller: controller.timeController,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBoxWidget(height: 15.h),

            // Moderators field (UI only — not submitted to API currently)
            CustomTextField(
              label: AppStrings.addModerators,
              hintText: 'Excellent',
              controller: TextEditingController(),
            ),
            SizedBoxWidget(height: 15.h),

            // Repeats Dropdown
            CustomText(text: AppStrings.repeats, fontWeight: FontWeight.w600),
            SizedBoxWidget(height: 8.h),
            Obx(() => Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(12.r),
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedRepeat.value,
                  items: [AppStrings.doesNotRepeat].map((String v) {
                    return DropdownMenuItem<String>(value: v, child: Text(v));
                  }).toList(),
                  onChanged: (val) => controller.selectedRepeat.value = val!,
                ),
              ),
            )),
            SizedBoxWidget(height: 20.h),

            // Media Section
            CustomText(text: AppStrings.media, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            _buildMediaBox(context, AppStrings.addThumbnail, Icons.image_outlined),
            SizedBoxWidget(height: 10.h),
            _buildMediaBox(context, AppStrings.addVideo, Icons.play_circle_outline),

            SizedBoxWidget(height: 20.h),

            // Category Section — loaded from API
            CustomText(text: AppStrings.primaryCategory, fontWeight: FontWeight.w700),
            CustomText(text: AppStrings.recentlyUsed, fontSize: 12, fontColor: colorScheme.outline),
            SizedBoxWidget(height: 10.h),
            Obx(() {
              // Show first 3 categories as quick-pick chips
              final cats = controller.categories.take(3).toList();
              if (cats.isEmpty) return const SizedBox.shrink();
              return Row(
                spacing: 10.w,
                children: cats.asMap().entries.map((e) {
                  final cat = e.value;
                  return Obx(() => CustomChoiceChip(
                    label: cat.name,
                    selected: controller.selectedCategory.value?.id == cat.id,
                    colorChangeable: true,
                    borderRadius: 100,
                    onSelected: (_) => controller.selectedCategory.value = cat,
                  ));
                }).toList(),
              );
            }),
            const SizedBox(height: 12),

            // Category full dropdown
            Obx(() => _buildCategoryDropdown(AppStrings.category, colorScheme)),
            _buildDropdown(AppStrings.primarySellingFormat, colorScheme, hint: AppStrings.format),

            // Primary Tags
            CustomText(text: AppStrings.primaryTags, fontWeight: FontWeight.w600),
            SizedBoxWidget(height: 10.h),
            Obx(() => Wrap(
              spacing: 10.w,
              children: controller.tags
                  .map((tag) => _buildTagChip(tag, colorScheme))
                  .toList(),
            )),
            SizedBoxWidget(height: 10.h),
            _buildDropdown(AppStrings.tags, colorScheme, hint: AppStrings.tags),

            _buildDropdown(AppStrings.primaryBrand, colorScheme, hint: AppStrings.brand),

            // Shipping Settings
            _buildSettingsTile(AppStrings.shippingSettings, AppStrings.freePickup, 'ON', colorScheme),

            // Content Settings
            CustomText(text: AppStrings.contentSettings, fontWeight: FontWeight.w600),
            Obx(() => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomText(text: AppStrings.explicitContent, textAlignment: TextAlign.start),
              value: controller.explicitContent.value,
              onChanged: (val) => controller.explicitContent.value = val,
            )),

            _buildDropdown(AppStrings.mutedWords, colorScheme, hint: 'Fake, Replica'),
            _buildDropdown(AppStrings.primaryLanguage, colorScheme, hint: 'English'),

            SizedBoxWidget(height: 20.h),
            CustomText(text: AppStrings.showDiscoverability, fontWeight: FontWeight.w600),
            Obx(() => _buildRadioTile(AppStrings.public, colorScheme)),
            Obx(() => _buildRadioTile(AppStrings.private, colorScheme)),

            SizedBoxWidget(height: 30.h),

            // Submit button
            Obx(() => CustomButton(
              label: controller.isLoading.value
                  ? (controller.isEditMode ? 'Updating…' : 'Scheduling…')
                  : (controller.isEditMode ? 'Update Show' : 'Schedule Show'),
              buttonWidth: double.infinity,
              backgroundColor: AppColors.orange,
              textColor: Colors.white,
              onPressed: controller.isLoading.value ? null : () => controller.scheduleShow(),
            )),
            if (!controller.isEditMode) ...[
              SizedBoxWidget(height: 10.h),
              Obx(() => CustomButton(
                    label: 'Save as draft',
                    buttonWidth: double.infinity,
                    backgroundColor: Colors.transparent,
                    textColor: AppColors.primaryColor,
                    borderWidth: 2,
                    borderColor: AppColors.primaryColor,
                    onPressed: controller.isLoading.value ? null : () => controller.scheduleShow(asDraft: true),
                  )),
            ],
            SizedBoxWidget(height: 20.h),
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
      children: [
        CustomText(text: section, fontWeight: FontWeight.w600),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: CustomText(text: title, textAlignment: TextAlign.start),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(text: trailing, fontColor: colorScheme.outline),
              Icon(Icons.chevron_right, color: colorScheme.onSurface),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(String title, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              value: controller.selectedCategory.value?.id,
              hint: CustomText(text: 'Select category', fontColor: colorScheme.outline),
              items: controller.categories.map((cat) {
                return DropdownMenuItem<String>(
                  value: cat.id,
                  child: Text(cat.name),
                );
              }).toList(),
              onChanged: (id) {
                if (id == null) return;
                final cat = controller.categories.firstWhereOrNull((c) => c.id == id);
                controller.selectedCategory.value = cat;
              },
            ),
          ),
        ),
        SizedBoxWidget(height: 15.h),
      ],
    );
  }

  Widget _buildDropdown(String title, ColorScheme colorScheme, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              items: const [],
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
        children: [
          CustomText(text: AppStrings.optional, fontColor: colorScheme.primary, fontSize: 12),
          Icon(icon, size: 30.sp, color: colorScheme.primary),
          CustomText(text: label, fontColor: colorScheme.primary, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  Widget _buildRadioTile(String value, ColorScheme colorScheme) {
    final selected = controller.discoverability.value == value;
    return GestureDetector(
      onTap: () => controller.discoverability.value = value,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? colorScheme.primary : colorScheme.outline,
              width: 2,
            ),
          ),
          child: selected
              ? Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary,
                    ),
                  ),
                )
              : null,
        ),
        title: CustomText(text: value, textAlignment: TextAlign.start),
      ),
    );
  }
}
