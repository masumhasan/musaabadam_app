import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/livestream/controllers/tip_controller.dart';
import '../../../core/assets_gen/assets.gen.dart';

class TipAmountScreen extends StatelessWidget {
  TipAmountScreen({super.key});

  final TipController controller = Get.find<TipController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(text: 'Send a Tip', fontSize: 18.sp, fontWeight: FontWeight.w700),
        centerTitle: true,
      ),
      body: Obx(() {
        final amount = controller.selectedAmount.value;
        final fee = amount * 0.033;
        final total = amount + fee;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBoxWidget(height: 20.h),
              Center(
                child: SvgPicture.asset(Assets.icons.sendTips, width: 100.r, height: 100.r),
              ),
              SizedBoxWidget(height: 40.h),

              // Financial Details Section
              _buildPriceRow('Tip amount', '£${amount.toStringAsFixed(2)}', colorScheme, isBold: true),
              SizedBoxWidget(height: 16.h),
              _buildPaymentRow('Payment', colorScheme),
              SizedBoxWidget(height: 16.h),
              _buildPriceRow('Subtotal', '£${amount.toStringAsFixed(2)}', colorScheme, isBold: true),
              SizedBoxWidget(height: 16.h),
              _buildPriceRow('Payment processing fee', '£${fee.toStringAsFixed(2)}', colorScheme),
              SizedBoxWidget(height: 20.h),
              Divider(color: colorScheme.outlineVariant),
              SizedBoxWidget(height: 16.h),

              // Total Row
              _buildPriceRow('Total', '£${total.toStringAsFixed(2)}', colorScheme, isBold: true, fontSize: 18),

              const Spacer(),

              // Footer Buttons
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'Cancel',
                        backgroundColor: colorScheme.outline.withValues(alpha: 0.3),
                        textColor: colorScheme.onSurface,
                        buttonHeight: 44.h,
                        onPressed: () => Get.back(),
                      ),
                    ),
                    SizedBoxWidget(width: 16.w),
                    Expanded(
                      child: CustomButton(
                        label: 'Send Tip',
                        backgroundColor: colorScheme.primary,
                        textColor: Colors.white,
                        buttonHeight: 44.h,
                        isLoading: controller.isLoading.value,
                        onPressed: () async {
                          await controller.sendTip();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPriceRow(String label, String amount, ColorScheme cs, {bool isBold = false, double fontSize = 15}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          fontSize: fontSize,
          fontColor: isBold ? cs.onSurface : cs.onSurfaceVariant,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
        CustomText(
          text: amount,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          fontColor: cs.onSurface,
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, ColorScheme cs) {
    final selectedCard = controller.selectedCardId.value;
    final cardLabel = selectedCard != null
        ? controller.cards.firstWhereOrNull((c) => c.id == selectedCard)?.displayLabel ?? 'Saved Card'
        : 'No payment card';

    return GestureDetector(
      onTap: controller.addCardQuick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: label, fontSize: 13, fontWeight: FontWeight.bold, fontColor: cs.onSurface),
                CustomText(text: cardLabel, fontSize: 11, fontColor: cs.primary),
              ],
            ),
            Row(
              children: [
                CustomText(text: selectedCard == null ? 'Add Card' : 'Change', fontSize: 12, fontColor: cs.primary),
                SizedBoxWidget(width: 4.w),
                Icon(Icons.chevron_right, size: 16.r, color: cs.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}