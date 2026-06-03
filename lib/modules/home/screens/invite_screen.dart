import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/image_widget.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import '../../../core/assets_gen/assets.gen.dart';

class InviteScreen extends StatelessWidget {
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
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.r), color: theme.colorScheme.surfaceContainerHighest),
              child: Row(
                children: [
                  Expanded(child: CustomText(text: "https://heyguys.com", translate: false, fontStyle: FontStyle.italic)),
                  CustomButton(label: AppStrings.copy, buttonHeight: 40.h, buttonRadius: 100.r),
                ],
              ),
            ),
            SizedBoxWidget(height: 10),
            CustomButton(
                label: AppStrings.share,
                buttonHeight: 40.h
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
        Row(children: [
          Expanded(child: ListTile(title: CustomText(text: "0", translate: false), subtitle: CustomText(text: AppStrings.credit))),
          Expanded(child: ListTile(title: CustomText(text: "0", translate: false), subtitle: CustomText(text: AppStrings.complete))),
          Expanded(child: ListTile(title: CustomText(text: "0", translate: false), subtitle: CustomText(text: AppStrings.pending))),
        ]),
        CustomText(text: AppStrings.viewYourReferalHistory, fontSize: 13.sp, underline: true),
      ],
    ),
  );
}