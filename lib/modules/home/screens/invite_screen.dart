import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/image_widget.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/modules/home/controllers/invite_controller.dart';
import '../../../core/assets_gen/assets.gen.dart';

class InviteScreen extends GetView<InviteController> {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(forceMaterialTransparency: true, leading: BackButton(color: theme.colorScheme.onSurface)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBoxWidget(height: 30),
            ImageWidget(width: 183.w, height: 153.h, imagePath: Assets.images.giftBox.keyName),
            SizedBoxWidget(height: 30),
            CustomText(text: AppStrings.shareBidsRush, fontSize: 20.sp, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 60),
            _inviteStatsContainer(theme),
            SizedBoxWidget(height: 30),
            CustomText(
              text: AppStrings.yourReferralCode,
              fontSize: 13.sp,
              fontColor: theme.colorScheme.outline,
            ),
            SizedBoxWidget(height: 8),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.r), color: theme.colorScheme.surfaceContainerHighest),
              child: Row(
                children: [
                  SizedBoxWidget(width: 12.w),
                  Expanded(
                    child: Obx(() => CustomText(
                          text: controller.isLoading.value ? '…' : (controller.referralCode.value.isEmpty ? '—' : controller.referralCode.value),
                          translate: false,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                          textAlignment: TextAlign.start,
                        )),
                  ),
                  CustomButton(label: AppStrings.copy, buttonHeight: 40.h, buttonRadius: 100.r, onPressed: controller.copyCode),
                ],
              ),
            ),
            SizedBoxWidget(height: 10),
            CustomButton(
              label: AppStrings.share,
              buttonHeight: 40.h,
              onPressed: controller.shareCode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _inviteStatsContainer(ThemeData theme) => Container(
    padding: EdgeInsets.symmetric(vertical: 20.h),
    decoration: BoxDecoration(color: theme.colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(12.r)),
    child: Column(
      children: [
        CustomText(text: AppStrings.yourInviteStats, fontSize: 20.sp, fontWeight: FontWeight.w900),
        Obx(() => Row(children: [
          Expanded(child: ListTile(title: CustomText(text: "${controller.credit.value}", translate: false), subtitle: CustomText(text: AppStrings.credit))),
          Expanded(child: ListTile(title: CustomText(text: "${controller.complete.value}", translate: false), subtitle: CustomText(text: AppStrings.complete))),
          Expanded(child: ListTile(title: CustomText(text: "${controller.pending.value}", translate: false), subtitle: CustomText(text: AppStrings.pending))),
        ])),
        CustomText(text: AppStrings.viewYourReferalHistory, fontSize: 13.sp, underline: true),
      ],
    ),
  );
}