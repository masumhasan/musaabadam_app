import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/text_button_widget.dart';

class SellerPayoutScreen extends StatelessWidget {
  SellerPayoutScreen({super.key});

  final RxInt currentTab = 0.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(text: AppStrings.payouts, fontWeight: FontWeight.w700),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            // Tabs
            Row(
              children:[
                _buildTab(AppStrings.payouts, 0, colorScheme),
                SizedBoxWidget(width: 20.w),
                _buildTab(AppStrings.transactions, 1, colorScheme),
              ],
            ),
            SizedBoxWidget(height: 20.h),

            // Balance
            CustomText(text: AppStrings.accountBalance, fontSize: 14, fontColor: colorScheme.outline),
            CustomText(text: "£0", fontSize: 32, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 20.h),

            // Info Card
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children:[
                  _buildInfoRow(AppStrings.availableForPayout),
                  Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
                  _buildInfoRow(AppStrings.processing),
                  Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
                  _buildInfoRow(AppStrings.notEligible, showDivider: false),
                ],
              ),
            ),
            SizedBoxWidget(height: 30.h),

            // History Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                CustomText(text: AppStrings.payoutsHistory, fontWeight: FontWeight.w700),
                CustomText(text: AppStrings.viewAll, fontColor: colorScheme.primary, fontWeight: FontWeight.w600),
              ],
            ),
            SizedBoxWidget(height: 20.h),

            Center(
              child: CustomText(text: AppStrings.nothingHere, fontColor: colorScheme.outline),
            ),

            const Spacer(),

            // Verification Button
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: CustomButton(
                label: AppStrings.beginSellerVerification,
                buttonWidth: double.infinity,
                backgroundColor: colorScheme.primary,
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index, ColorScheme colorScheme) {
    return Obx(() => TextButtonWidget(
      text: title,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      textColor: currentTab.value == index ? colorScheme.onSurface : colorScheme.outline,
      decoration: currentTab.value == index ? TextDecoration.underline : null,
      onPressed: () => currentTab.value = index,
    ));
  }

  Widget _buildInfoRow(String text, {bool showDivider = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CustomText(text: text, textAlignment: TextAlign.start),
    );
  }
}