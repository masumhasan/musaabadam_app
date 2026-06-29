import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/text_button_widget.dart';
import 'package:musaab_adam/modules/seller/controllers/seller_payout_controller.dart';

class SellerPayoutScreen extends GetView<SellerPayoutController> {
  const SellerPayoutScreen({super.key});

  RxInt get currentTab => controller.currentTab;

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
            Obx(() => CustomText(
                  text: "£${controller.available.toStringAsFixed(2)}",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                )),
            SizedBoxWidget(height: 20.h),

            // Info Card
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Obx(() => Column(
                children:[
                  _buildInfoRow(AppStrings.availableForPayout, value: '£${controller.available.toStringAsFixed(2)}'),
                  Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
                  _buildInfoRow(AppStrings.processing, value: '£${controller.pending.toStringAsFixed(2)}'),
                  Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
                  _buildInfoRow(AppStrings.notEligible, showDivider: false),
                ],
              )),
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

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final history = controller.payouts;
                if (history.isEmpty) {
                  return Center(child: CustomText(text: AppStrings.nothingHere, fontColor: colorScheme.outline));
                }
                return RefreshIndicator(
                  onRefresh: controller.load,
                  child: ListView.separated(
                    itemCount: history.length,
                    separatorBuilder: (_, _) => Divider(color: colorScheme.outline.withValues(alpha: 0.2)),
                    itemBuilder: (context, index) {
                      final p = history[index];
                      final amount = (p['amount'] is num) ? (p['amount'] as num).toDouble() : 0.0;
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: '${p['status'] ?? ''}', textAlignment: TextAlign.start),
                            CustomText(text: '£${amount.toStringAsFixed(2)}', fontWeight: FontWeight.w700),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),

            // Request payout
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Obx(() => CustomButton(
                    label: AppStrings.payouts,
                    buttonWidth: double.infinity,
                    backgroundColor: colorScheme.primary,
                    textColor: Colors.white,
                    isLoading: controller.isRequesting.value,
                    onPressed: controller.requestPayout,
                  )),
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

  Widget _buildInfoRow(String text, {bool showDivider = true, String? value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: CustomText(text: text, textAlignment: TextAlign.start)),
          if (value != null) CustomText(text: value, fontWeight: FontWeight.w700),
        ],
      ),
    );
  }
}