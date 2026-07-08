import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/modules/livestream/controllers/tip_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../../../core/assets_gen/assets.gen.dart';

class SendTipScreen extends StatelessWidget {
  SendTipScreen({super.key});

  final TipController controller = Get.put(TipController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        leading: const BackButton(),
        title: CustomText(text: AppStrings.sendATip, fontSize: 18.sp, fontWeight: FontWeight.w700),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBoxWidget(height: 20),
            Align(alignment: Alignment.center, child: SvgPicture.asset(Assets.icons.sendTips)),
            SizedBoxWidget(height: 20),
            CustomText(text: AppStrings.chooseATipAmount, fontColor: colorScheme.onSurface, fontWeight: FontWeight.w600),
            SizedBoxWidget(height: 12),
            _buildTipAmountGrid(colorScheme),
            SizedBoxWidget(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: AppStrings.addAThankYouNote, fontColor: colorScheme.onSurface, fontWeight: FontWeight.w600),
                Obx(() => Switch(
                  value: controller.isNoteEnabled.value,
                  onChanged: (v) => controller.isNoteEnabled.value = v,
                  activeThumbColor: colorScheme.onPrimary,
                  activeTrackColor: colorScheme.primary,
                )),
              ],
            ),
            Obx(() {
              if (!controller.isNoteEnabled.value) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: TextField(
                  maxLines: 2,
                  maxLength: 100,
                  onChanged: (val) => controller.messageNote.value = val,
                  decoration: InputDecoration(
                    hintText: 'Enter thank you message...',
                    hintStyle: TextStyle(fontSize: 13.sp, color: colorScheme.outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
              );
            }),
            CustomText(
              text: AppStrings.thisMessageInChat,
              fontSize: 12.sp,
              fontColor: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            SizedBoxWidget(height: 40.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: AppStrings.cancel,
                    backgroundColor: colorScheme.outline.withValues(alpha: 0.3),
                    textColor: colorScheme.onSurface,
                    buttonHeight: 40.h,
                    onPressed: Get.back,
                  ),
                ),
                SizedBoxWidget(width: 15),
                Expanded(
                  child: CustomButton(
                    label: AppStrings.next,
                    backgroundColor: colorScheme.primary,
                    textColor: Colors.white,
                    buttonHeight: 40.h,
                    onPressed: () => Get.toNamed(AppRoutes.tipAmountScreen),
                  ),
                ),
              ],
            ),
            SizedBoxWidget(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTipAmountGrid(ColorScheme colorScheme) {
    final tips = [
      {"icon": Assets.icons.tip1, "value": 1.0, "text": "£1"},
      {"icon": Assets.icons.tip5, "value": 5.0, "text": "£5"},
      {"icon": Assets.icons.tip10, "value": 10.0, "text": "£10"},
      {"icon": Assets.icons.tip20, "value": 20.0, "text": "£20"},
      {"icon": Assets.icons.tip50, "value": 5.0, "text": "£50"}, // Fixed to 50.0 value
      {"icon": Assets.icons.tip100, "value": 100.0, "text": "£100"},
    ];

    // Correction: element index 4 should be 50.0 instead of 5.0
    tips[4]["value"] = 50.0;

    return Obx(() {
      final selected = controller.selectedAmount.value;
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: tips.map((t) {
          final val = t["value"] as double;
          final isSelected = selected == val;
          return GestureDetector(
            onTap: () => controller.selectAmount(val),
            child: Container(
              width: 90.w,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary.withValues(alpha: 0.15) : colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: isSelected ? colorScheme.primary : colorScheme.outlineVariant, width: isSelected ? 1.5 : 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(t["icon"] as String, width: 30.r, height: 30.r),
                  SizedBoxWidget(height: 6),
                  CustomText(
                    text: t["text"] as String,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontColor: isSelected ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}