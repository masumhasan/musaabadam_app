import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/assets_gen/assets.gen.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';

import '../../../core/widgets/sized_box_widget.dart';
import '../../../core/widgets/svg_icon.dart';

class RehearsalScreen extends StatelessWidget {
  const RehearsalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children:[
          // Background - Placeholder for Live Stream
          Container(color: colorScheme.surfaceContainerHighest),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Column(
                children:[
                  // App Bar Header
                  _buildHeader(colorScheme),
                  const Spacer(),

                  // Chat Section
                  _buildChatSection(colorScheme),
                  SizedBoxWidget(height: 10),

                  // Input & Buttons
                  _buildBottomControls(colorScheme),
                ],
              ),
            ),
          ),

          // Right Sidebar
          Positioned(
            right: 16.w,
            top: 150.h,
            child: _buildSidebar(colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      children:[
        IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface)),
        CircleAvatar(radius: 18.r, backgroundColor: colorScheme.primary),
        SizedBox(width: 8.w),
        CustomText(text: "Emma Watson", fontWeight: FontWeight.w700),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(20.r)),
          child: CustomText(text: AppStrings.rehearsal, fontColor: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSidebar(ColorScheme colorScheme) {
    final List<Map<String, dynamic>> items =[
      {'icon': Assets.icons.more, 'label': AppStrings.more},
      {'icon': Assets.icons.boost, 'label': AppStrings.promote},
      {'icon': Assets.icons.clip, 'label': AppStrings.clip},
      {'icon': Assets.icons.share, 'label': AppStrings.share},
      {'icon': Assets.icons.camera, 'label': AppStrings.switchText},
      {'icon': Assets.icons.shop, 'label': AppStrings.shop},
    ];

    return Column(
      children: items.map((item) => Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Column(
          children: [
            SvgIcon(icon: item['icon'], height: 30, width: 30, color: colorScheme.onSurface),
            CustomText(text: item['label'], fontSize: 12),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildChatSection(ColorScheme colorScheme) {
    return Row(
      children:[
        CircleAvatar(radius: 16.r, backgroundColor: colorScheme.primary),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            CustomText(text: AppStrings.alice, fontWeight: FontWeight.w700),
            CustomText(text: AppStrings.veryNice, fontColor: colorScheme.outline),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomControls(ColorScheme colorScheme) {
    return Column(
      children:[
        CustomTextField(
          hintText: AppStrings.saySomething,
          label: AppStrings.saySomething, controller: TextEditingController(),
        ),
        SizedBoxWidget(height: 15.h),
        Row(
          children:[
            Expanded(
              child: CustomButton(
                label: AppStrings.cancel,
                backgroundColor: colorScheme.surfaceContainerHighest,
                textColor: colorScheme.onSurface,
                buttonHeight: 45.h,
              ),
            ),
            SizedBoxWidget(width: 15.w),
            Expanded(
              child: CustomButton(
                label: AppStrings.startAuction,
                backgroundColor: AppColors.orange,
                buttonHeight: 45.h,
              ),
            ),
          ],
        ),
      ],
    );
  }
}