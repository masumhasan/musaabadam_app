import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/labeled_iconbutton.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../../../core/assets_gen/assets.gen.dart';

class SendTipScreen extends StatelessWidget {
  SendTipScreen({super.key});

  final RxBool isSwitchEnabled = false.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        leading: const BackButton(),
        title: CustomText(text: AppStrings.sendATip, fontSize: 18.sp, fontWeight: FontWeight.w700),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBoxWidget(height: 20),
            Align(alignment: Alignment.center, child: SvgPicture.asset(Assets.icons.sendTips)),
            SizedBoxWidget(height: 10),
            _buildTipAmountSelection(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildTipAmountSelection(ColorScheme colorScheme) {
    final tips = [
      {"icon": Assets.icons.tip1, "text": "\$1"},
      {"icon": Assets.icons.tip5, "text": "\$5"},
      {"icon": Assets.icons.tip10, "text": "\$10"},
      {"icon": Assets.icons.tip20, "text": "\$20"},
      {"icon": Assets.icons.tip50, "text": "\$50"},
      {"icon": Assets.icons.tip100, "text": "\$100"},
    ];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: AppStrings.chooseATipAmount, fontColor: colorScheme.onSurface),
          SizedBoxWidget(height: 10),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: tips.map((t) => LabeledIconButton(
              iconPath: t["icon"]!,
              text: t["text"]!,
              iconHeight: 45, iconWidth: 45,
              isLabelInside: true, borderRadius: 8,
              color: colorScheme.surfaceContainer,
            )).toList(),
          ),
          SizedBoxWidget(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: AppStrings.addAThankYouNote, fontColor: colorScheme.onSurface),
              Obx(() => Switch(
                value: isSwitchEnabled.value,
                onChanged: (v) => isSwitchEnabled.value = v,
                activeColor: colorScheme.onPrimary,
                activeTrackColor: colorScheme.primary,
              )),
            ],
          ),
          CustomText(text: AppStrings.thisMessageInChat, fontSize: 12.sp, fontColor: colorScheme.onSurface.withValues(alpha: 0.5)),
          const Spacer(),
          Row(
            children: [
              Expanded(child: CustomButton(label: AppStrings.cancel, backgroundColor: colorScheme.outline, buttonHeight: 40.h, onPressed: Get.back)),
              SizedBoxWidget(width: 15),
              Expanded(child: CustomButton(label: AppStrings.next, backgroundColor: colorScheme.surfaceContainer, textColor: colorScheme.primary, buttonHeight: 40.h, onPressed: () => Get.toNamed(AppRoutes.tipAmountScreen))),
            ],
          ),
          SizedBoxWidget(height: 30),
        ],
      ),
    );
  }
}