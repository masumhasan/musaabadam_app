import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../controllers/address_form_controller.dart';

const _kCountries = [
  'United States', 'United Kingdom', 'Canada', 'Australia', 'Germany',
  'France', 'Italy', 'Spain', 'Netherlands', 'Sweden', 'Norway', 'Denmark',
  'Japan', 'South Korea', 'Singapore', 'India', 'Pakistan', 'Bangladesh',
  'Philippines', 'Indonesia', 'Malaysia', 'Thailand', 'Vietnam', 'China',
  'United Arab Emirates', 'Saudi Arabia', 'Qatar', 'Kuwait', 'Turkey',
  'South Africa', 'Nigeria', 'Kenya', 'Egypt', 'Brazil', 'Mexico',
  'Argentina', 'Colombia', 'New Zealand', 'Ireland', 'Portugal',
];

class NewAddressScreen extends GetView<AddressFormController> {
  const NewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface),
        ),
        title: Obx(() => CustomText(
          text: controller.isEditing ? 'Edit Address' : 'New Address',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          translate: false,
        )),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBoxWidget(height: 12),

              // ── Type selector ────────────────────────────────────────────
              CustomText(text: 'Address Type', fontSize: 14.sp, fontWeight: FontWeight.w600, translate: false),
              SizedBoxWidget(height: 8),
              Obx(() => Row(
                children: [
                  _TypeChip(
                    label: 'Shipping',
                    icon: Icons.local_shipping_outlined,
                    selected: controller.selectedType.value == 'shipping',
                    onTap: () => controller.selectedType.value = 'shipping',
                    colorScheme: colorScheme,
                  ),
                  SizedBoxWidget(width: 12),
                  _TypeChip(
                    label: 'Pickup',
                    icon: Icons.storefront_outlined,
                    selected: controller.selectedType.value == 'pickup',
                    onTap: () => controller.selectedType.value = 'pickup',
                    colorScheme: colorScheme,
                  ),
                ],
              )),

              SizedBoxWidget(height: 18),

              CustomTextField(
                label: 'Label (optional)',
                hintText: 'e.g. Home, Office, Warehouse',
                controller: controller.labelController,
              ),
              SizedBoxWidget(height: 14),

              CustomTextField(
                label: 'Full Name',
                hintText: 'John Doe',
                controller: controller.fullNameController,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Full name is required' : null,
              ),
              SizedBoxWidget(height: 14),

              CustomTextField(
                label: 'Address Line 1',
                hintText: '123 Main Street',
                controller: controller.line1Controller,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Address is required' : null,
              ),
              SizedBoxWidget(height: 14),

              CustomTextField(
                label: 'Address Line 2 (optional)',
                hintText: 'Apt, suite, floor...',
                controller: controller.line2Controller,
              ),
              SizedBoxWidget(height: 14),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'City',
                      hintText: 'New York',
                      controller: controller.cityController,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                  SizedBoxWidget(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'State / Province',
                      hintText: 'NY',
                      controller: controller.stateController,
                    ),
                  ),
                ],
              ),
              SizedBoxWidget(height: 14),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Postal Code',
                      hintText: '10001',
                      controller: controller.postalCodeController,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                  SizedBoxWidget(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Phone (optional)',
                      hintText: '+1 555 000 0000',
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              SizedBoxWidget(height: 14),

              // ── Country dropdown ─────────────────────────────────────────
              CustomText(text: 'Country', fontSize: 14.sp, fontWeight: FontWeight.w600, translate: false),
              SizedBoxWidget(height: 8),
              Obx(() => DropdownMenu<String>(
                width: double.infinity,
                initialSelection: controller.selectedCountry.value,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: colorScheme.primary, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: colorScheme.primary, width: 1),
                  ),
                ),
                menuStyle: MenuStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  backgroundColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest),
                ),
                onSelected: (v) { if (v != null) controller.selectedCountry.value = v; },
                dropdownMenuEntries: _kCountries
                    .map((c) => DropdownMenuEntry(value: c, label: c))
                    .toList(),
              )),

              SizedBoxWidget(height: 16),

              // ── Default checkbox ─────────────────────────────────────────
              Obx(() => CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: controller.isDefault.value,
                onChanged: (v) => controller.isDefault.value = v!,
                title: CustomText(
                  text: controller.selectedType.value == 'pickup'
                      ? 'Set as default pickup address'
                      : 'Set as default shipping address',
                  fontSize: 14.sp,
                  translate: false,
                ),
                activeColor: colorScheme.primary,
                controlAffinity: ListTileControlAffinity.leading,
              )),

              SizedBoxWidget(height: 24),

              Obx(() => Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Cancel',
                      backgroundColor: colorScheme.outline,
                      buttonHeight: 44.h,
                      onPressed: Get.back,
                    ),
                  ),
                  SizedBoxWidget(width: 14),
                  Expanded(
                    child: CustomButton(
                      label: controller.isEditing ? 'Update' : 'Save',
                      buttonHeight: 44.h,
                      isLoading: controller.isLoading.value,
                      onPressed: controller.isLoading.value ? null : controller.save,
                    ),
                  ),
                ],
              )),

              SizedBoxWidget(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Type chip ─────────────────────────────────────────────────────────────────

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.12)
              : colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.15),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
