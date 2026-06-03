import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

class NewAddressScreen extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  final RxBool isDefaultShippingChecked = false.obs;
  final RxBool isReturnAddressChecked = false.obs;

  NewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface)),
        title: CustomText(text: AppStrings.addAddress, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children:[
            SizedBoxWidget(height: 30),
            CustomTextField(hintText: AppStrings.fullName, controller: fullNameController, label: AppStrings.fullName, ),
            SizedBoxWidget(height: 15),
            CustomTextField(hintText: AppStrings.address, controller: addressController, label: AppStrings.address,),
            SizedBoxWidget(height: 15),
            CustomTextField(hintText: AppStrings.city, controller: cityController, label: AppStrings.city),
            SizedBoxWidget(height: 15),
            CustomTextField(hintText: AppStrings.state, controller: stateController, label: AppStrings.state ),
            SizedBoxWidget(height: 15),
            CustomTextField(hintText: AppStrings.postalCode, controller: postalCodeController, label: AppStrings.postalCode ),
            SizedBoxWidget(height: 15),
            DropdownMenu<int>(
              width: double.infinity,
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: colorScheme.primary, width: 1)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: colorScheme.primary, width: 1)),
              ),
              menuStyle: MenuStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                backgroundColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest),
              ),
              hintText: AppStrings.selectCountry,
              onSelected: (value) {},
              dropdownMenuEntries: const[
                DropdownMenuEntry(value: 0, label: "Uk"),
                DropdownMenuEntry(value: 1, label: "Philippines"),
              ],
            ),
            SizedBoxWidget(height: 20),
            _buildCheckboxRow(AppStrings.defaultShipping, isDefaultShippingChecked, colorScheme),
            _buildCheckboxRow(AppStrings.returnAddress, isReturnAddressChecked, colorScheme),
            Expanded(
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children:[
                      Expanded(child: CustomButton(label: AppStrings.cancel, backgroundColor: colorScheme.outline, buttonHeight: 40)),
                      SizedBoxWidget(width: 15),
                      Expanded(child: CustomButton(label: AppStrings.save, buttonHeight: 40)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBoxWidget(height: 20)
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxRow(String label, RxBool value, ColorScheme colorScheme) {
    return Row(
      children:[
        Obx(() => Checkbox(
          side: BorderSide(color: colorScheme.error, width: 2),
          value: value.value,
          onChanged: (v) => value.value = v!,
          activeColor: colorScheme.primary,
        )),
        CustomText(text: label),
      ],
    );
  }
}