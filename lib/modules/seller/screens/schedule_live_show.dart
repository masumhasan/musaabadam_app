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
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: BackButton(color: colorScheme.onSurface),
        title: Obx(() => CustomText(
          text: controller.isEditMode ? 'Edit Show' : AppStrings.scheduleALiveShow,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        )),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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

              // Moderators field
              CustomText(text: AppStrings.addModerators, fontWeight: FontWeight.w600),
              SizedBoxWidget(height: 8.h),
              GestureDetector(
                onTap: () {
                  // Stub for picking moderators
                  Get.snackbar('Moderators', 'Moderator picker coming soon!', snackPosition: SnackPosition.BOTTOM);
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    label: '',
                    hintText: 'Select users',
                    controller: TextEditingController(),
                  ),
                ),
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
                    items: [AppStrings.doesNotRepeat, 'daily', 'weekly'].map((String v) {
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
              GestureDetector(
                onTap: controller.pickThumbnail,
                child: Obx(() => _buildMediaBox(
                  context,
                  controller.thumbnailUrl.value.isNotEmpty ? 'Thumbnail Added' : AppStrings.addThumbnail,
                  Icons.image_outlined,
                  controller.thumbnailUrl.value.isNotEmpty,
                  mediaUrl: controller.thumbnailUrl.value,
                )),
              ),
              SizedBoxWidget(height: 10.h),
              GestureDetector(
                onTap: controller.pickVideo,
                child: Obx(() => _buildMediaBox(
                  context,
                  controller.videoPreviewUrl.value.isNotEmpty ? 'Video Added' : AppStrings.addVideo,
                  Icons.play_circle_outline,
                  controller.videoPreviewUrl.value.isNotEmpty,
                  // We don't preview video in the box yet, just image
                )),
              ),

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
              
              // Primary Selling Format
              CustomText(text: AppStrings.primarySellingFormat, fontWeight: FontWeight.w600),
              SizedBoxWidget(height: 8.h),
              Obx(() => Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.primary),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.primarySellingFormat.value,
                    items: ['auction', 'buy_it_now'].map((String v) {
                      return DropdownMenuItem<String>(value: v, child: Text(v));
                    }).toList(),
                    onChanged: (val) => controller.primarySellingFormat.value = val!,
                  ),
                ),
              )),
              SizedBoxWidget(height: 15.h),

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
              GestureDetector(
                onTap: () {
                  _showMultiSelectBottomSheet(context, AppStrings.tags, controller.availableTags, controller.tags);
                },
                child: _buildDropdown(AppStrings.tags, colorScheme, hint: 'Select tags...'),
              ),

              _buildDropdown(AppStrings.primaryBrand, colorScheme, hint: AppStrings.brand),

              // Shipping Settings
              _buildSettingsTile(AppStrings.shippingSettings, AppStrings.freePickup, controller.freePickup.value ? 'ON' : 'OFF', colorScheme, onTap: () {
                controller.freePickup.value = !controller.freePickup.value;
              }),

              // Content Settings
              CustomText(text: AppStrings.contentSettings, fontWeight: FontWeight.w600),
              Obx(() => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: CustomText(text: AppStrings.explicitContent, textAlignment: TextAlign.start),
                value: controller.explicitContent.value,
                onChanged: (val) => controller.explicitContent.value = val,
              )),

              Obx(() => Wrap(
                spacing: 10.w,
                children: controller.mutedWords
                    .map((word) => _buildTagChip(word, colorScheme))
                    .toList(),
              )),
              SizedBoxWidget(height: 10.h),
              GestureDetector(
                onTap: () {
                  _showMultiSelectBottomSheet(context, AppStrings.mutedWords, controller.availableMutedWords, controller.mutedWords);
                },
                child: _buildDropdown(AppStrings.mutedWords, colorScheme, hint: 'Add muted words...'),
              ),
              
              // Primary Language
              CustomText(text: AppStrings.primaryLanguage, fontWeight: FontWeight.w600),
              SizedBoxWidget(height: 8.h),
              Obx(() => Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.primary),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.primaryLanguage.value,
                    items: ['English', 'Spanish', 'French'].map((String v) {
                      return DropdownMenuItem<String>(value: v, child: Text(v));
                    }).toList(),
                    onChanged: (val) => controller.primaryLanguage.value = val!,
                  ),
                ),
              )),
              SizedBoxWidget(height: 15.h),

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

  Widget _buildSettingsTile(String section, String title, String trailing, ColorScheme colorScheme, {VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: section, fontWeight: FontWeight.w600),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: CustomText(text: title, textAlignment: TextAlign.start),
          onTap: onTap,
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

  Widget _buildMediaBox(BuildContext context, String label, IconData icon, bool hasMedia, {String? mediaUrl}) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasImagePreview = hasMedia && mediaUrl != null && mediaUrl.isNotEmpty;
    
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        color: hasMedia ? colorScheme.primaryContainer : colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: hasMedia ? Border.all(color: colorScheme.primary) : null,
        image: hasImagePreview
            ? DecorationImage(
                image: NetworkImage(mediaUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.4), BlendMode.darken),
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!hasMedia) CustomText(text: AppStrings.optional, fontColor: colorScheme.primary, fontSize: 12),
          Icon(hasMedia ? Icons.check_circle : icon, size: 30.sp, color: hasImagePreview ? Colors.white : colorScheme.primary),
          CustomText(text: label, fontColor: hasImagePreview ? Colors.white : colorScheme.primary, fontWeight: FontWeight.w600),
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

  void _showMultiSelectBottomSheet(BuildContext context, String title, List<String> availableItems, RxList<String> selectedItems) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(color: colorScheme.outline.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(2.r)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: title, fontSize: 18, fontWeight: FontWeight.bold),
                        IconButton(icon: Icon(Icons.close, color: colorScheme.onSurface), onPressed: () => Get.back()),
                      ],
                    ),
                  ),
                  Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
                  Expanded(
                    child: availableItems.isEmpty 
                        ? Center(child: CustomText(text: 'No items available', fontColor: colorScheme.outline))
                        : Obx(() => ListView.builder(
                            controller: scrollController,
                            itemCount: availableItems.length,
                            itemBuilder: (context, index) {
                              final item = availableItems[index];
                              final isSelected = selectedItems.contains(item);
                              return CheckboxListTile(
                                title: CustomText(text: item, textAlignment: TextAlign.start),
                                value: isSelected,
                                activeColor: colorScheme.primary,
                                checkColor: colorScheme.onPrimary,
                                controlAffinity: ListTileControlAffinity.trailing,
                                onChanged: (bool? checked) {
                                  if (checked == true) {
                                    selectedItems.add(item);
                                  } else {
                                    selectedItems.remove(item);
                                  }
                                },
                              );
                            },
                          )),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
