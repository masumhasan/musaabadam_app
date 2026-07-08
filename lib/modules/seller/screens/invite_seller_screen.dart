import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';
import '../../../core/widgets/sized_box_widget.dart';

class InviteSellerScreen extends StatelessWidget {
  const InviteSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children:[
            SizedBoxWidget(height: 40),

            // Header
            CustomText(
              text: AppStrings.inviteSellerEarn10,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontColor: colorScheme.onSurface,
            ),
            SizedBoxWidget(height: 30),

            // Info Tiles
            _buildInfoTile(context, AppStrings.shareYourInviteLink),
            SizedBoxWidget(height: 12),
            _buildInfoTile(context, AppStrings.youEarn100),
            SizedBoxWidget(height: 12),
            _buildInfoTile(context, AppStrings.theyEarnToo),

            SizedBoxWidget(height: 40),

            // Copy Link Input
            Container(
              padding: EdgeInsets.only(left: 16.w, right: 4.w),
              height: 50.h,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Row(
                children:[
                  Expanded(
                    child: CustomText(
                      text: "bidsrush.com/invite/${Get.find<AuthController>().currentUser.value?.username ?? 'user'}",
                      textAlignment: TextAlign.start,
                      fontColor: colorScheme.onSurface,
                      fontSize: 12,
                    ),
                  ),
                  CustomButton(
                    label: AppStrings.copy,
                    buttonWidth: 80.w,
                    buttonRadius: 50.r,
                    textColor: Colors.white,
                    backgroundColor: colorScheme.primary,
                    onPressed: () {
                      final link = "https://bidsrush.com/invite/${Get.find<AuthController>().currentUser.value?.username ?? 'user'}";
                      Clipboard.setData(ClipboardData(text: link));
                      Get.snackbar("Copied 📋", "Invite link copied to clipboard");
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Share Button
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: CustomButton(
                label: AppStrings.shareInvite,
                buttonWidth: double.infinity,
                textColor: Colors.white,
                backgroundColor: AppColors.orange,
                onPressed: () {
                  final link = "https://bidsrush.com/invite/${Get.find<AuthController>().currentUser.value?.username ?? 'user'}";
                  Clipboard.setData(ClipboardData(text: "Join me on BidsRush! Use my invite link to register: $link"));
                  Get.snackbar(
                    "Share Copied 🚀", 
                    "Share text copied to clipboard! Paste it anywhere to invite sellers.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children:[
          Icon(Icons.emoji_objects_outlined, color: Colors.white, size: 24.sp),
          SizedBoxWidget(width: 12.w),
          Expanded(
            child: CustomText(
              text: text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontColor: Colors.white,
              textAlignment: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}