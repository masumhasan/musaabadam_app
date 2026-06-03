import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/photo_edit_widget.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import '../../../core/components/category_item.dart';
import '../../../core/utils/app_constants.dart';

class ProfileSetupScreen extends StatelessWidget {
  final TextEditingController bioController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(text: AppStrings.setupProfile, fontWeight: FontWeight.w600, fontSize: 24.sp, fontColor: theme.colorScheme.onSurface),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBoxWidget(height: 20),
            Align(alignment: Alignment.topCenter, child: PhotoEditWidget()),
            SizedBoxWidget(height: 20),
            CustomTextField(label: AppStrings.fullName, hintText: AppStrings.name, controller: nameController),
            SizedBoxWidget(height: 15),
            CustomText(text: AppStrings.bio.tr, fontSize: 18.sp, fontWeight: FontWeight.w600),
            SizedBoxWidget(height: 8),
            CustomTextField(label: "", hintText: "", controller: bioController),
            SizedBoxWidget(height: 20),
            CustomText(text: AppStrings.preference, fontSize: 18.sp, fontWeight: FontWeight.w600),
            CustomText(text: AppStrings.pickAFewToGetStarted, fontSize: 14.sp, fontColor: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            SizedBoxWidget(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: List.generate(7, (i) => CategoryItem(image: Dummy.product1, itemName: "Watch"))),
            ),
            SizedBoxWidget(height: 20),
            CustomButton(label: AppStrings.continuee, buttonHeight: 40.h, buttonRadius: 8, onPressed: () => Get.toNamed(AppRoutes.mainScreen)),
            SizedBoxWidget(height: 20),
          ],
        ),
      ),
    );
  }
}