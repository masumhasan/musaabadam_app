import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/photo_edit_widget.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/utils/app_constants.dart';
import '../../../routes/app_pages.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/sized_box_widget.dart';
import '../../../core/widgets/custom_text_field.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final String userProfileName = "Jeremy Drake";
  // NOTE: Ideally, use separate controllers for each field in a real production app
  final TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.profile,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            spacing: 10,
            children:[
              SizedBoxWidget(height: 20),
              PhotoEditWidget(imageUrl: Dummy.user1),
              CustomText(
                text: userProfileName,
                fontWeight: FontWeight.w700,
                fontColor: colorScheme.onSurface,
                fontSize: 20,
              ),
              SizedBoxWidget(height: 15),
              _buildField(AppStrings.fullName, Assets.icons.username, colorScheme),
              _buildField("henry@mail.com", Assets.icons.mail, colorScheme),
              _buildField("(480) 555-3434", Assets.icons.phone, colorScheme),
              _buildField("2955 washterimer RD. santa area, sans Fransicco", Assets.icons.locationPin, colorScheme),
              SizedBoxWidget(height: 30),
              CustomButton(
                label: AppStrings.updateProfile,
                buttonHeight: 40.h,
                textColor: Colors.white,
                backgroundColor: colorScheme.primary,
                buttonRadius: 12,
                onPressed: () => Get.toNamed(AppRoutes.mainScreen)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, String iconPath, ColorScheme colorScheme) {
    return Column(
      children:[
        CustomTextField(
          hintText: hint,
          controller: bioController,
          label: hint,
        ),
        SizedBoxWidget(height: 15),
      ],
    );
  }
}