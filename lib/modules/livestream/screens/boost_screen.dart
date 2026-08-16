import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/modules/livestream/controllers/tip_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/assets_gen/assets.gen.dart';

class BoostScreen extends StatelessWidget {
  const BoostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = Get.put(TipController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Boost Seller',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Community Boost
            sectionHeader(Icons.bolt_rounded, "Community Boost"),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: "Learn More",
                    buttonHeight: 45,
                    backgroundColor: const Color(0xFFC4C4C4),
                    textColor: Colors.black,
                    onPressed: () {
                      Get.toNamed(AppRoutes.boostInfoScreen);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    label: "Boost Show",
                    buttonHeight: 45,
                    backgroundColor: const Color(0xFFFFD5A1),
                    textColor: const Color(0xFFE67E22),
                    onPressed: () {
                      Get.toNamed(AppRoutes.addPaymentMethodScreen);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            boostProgressBar(current: 5, total: 25),

            const SizedBox(height: 40),

            // Section: Send a Tip (Directly integrated tip selection)
            sectionHeader(Icons.front_hand_outlined, "Send a Tip"),
            const SizedBox(height: 16),

            CustomText(
              text: AppStrings.chooseATipAmount,
              fontColor: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 12),
            _buildTipAmountGrid(controller, colorScheme),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: AppStrings.addAThankYouNote,
                  fontColor: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
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
            const SizedBox(height: 40),

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
                const SizedBox(width: 15),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Header row with Icon and Text
  Widget sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.black),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Custom Progress Bar with Labels
  Widget boostProgressBar({required double current, required double total}) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 12,
            backgroundColor: const Color(0xFFE0E6ED),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('£${current.toInt()}', style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('£${total.toInt()}', style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildTipAmountGrid(TipController controller, ColorScheme colorScheme) {
    final tips = [
      {"icon": Assets.icons.tip1, "value": 1.0, "text": "£1"},
      {"icon": Assets.icons.tip5, "value": 5.0, "text": "£5"},
      {"icon": Assets.icons.tip10, "value": 10.0, "text": "£10"},
      {"icon": Assets.icons.tip20, "value": 20.0, "text": "£20"},
      {"icon": Assets.icons.tip50, "value": 50.0, "text": "£50"},
      {"icon": Assets.icons.tip100, "value": 100.0, "text": "£100"},
    ];

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
                  const SizedBox(height: 6),
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