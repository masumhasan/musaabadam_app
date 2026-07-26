import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/seller/controllers/payout_history_controller.dart';

class PayoutHistoryScreen extends StatelessWidget {
  const PayoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Bulletproof controller initialization
    PayoutHistoryController? controller;
    try {
      if (Get.isRegistered<PayoutHistoryController>()) {
        controller = Get.find<PayoutHistoryController>();
      }
    } catch (_) {}
    controller ??= Get.put(PayoutHistoryController());

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: 'Transactions History',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller!.loadPayouts(refresh: true),
        child: Obx(() {
          if (controller!.isLoading.value && controller.payouts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.hasError.value && controller.payouts.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.r, color: colorScheme.error),
                    SizedBoxWidget(height: 16),
                    CustomText(
                      text: 'Failed to load payout history.',
                      fontSize: 14.sp,
                      fontColor: colorScheme.onSurface,
                    ),
                    SizedBoxWidget(height: 16),
                    ElevatedButton(
                      onPressed: () => controller!.loadPayouts(refresh: true),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final list = controller.payouts;

          if (list.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 400.h,
                  child: Center(
                    child: CustomText(
                      text: AppStrings.nothingHere,
                      fontColor: colorScheme.outline,
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            itemCount: list.length + (controller.isLoadingMore.value ? 1 : 0),
            separatorBuilder: (context, index) => Divider(
              color: colorScheme.outline.withValues(alpha: 0.3),
              height: 20.h,
            ),
            itemBuilder: (context, index) {
              if (index == list.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              final entry = list[index];
              final amount = (entry['amount'] as num?)?.toDouble() ?? 0.0;
              final type = entry['type'] ?? 'transaction';
              final status = entry['status'] ?? 'completed';
              final isPositive = amount > 0;
              final amountText = '${isPositive ? '+' : ''}£${amount.toStringAsFixed(2)}';
              final displayType = type.toString().replaceAll('_', ' ').toUpperCase();
              
              DateTime? createdAt;
              try {
                createdAt = DateTime.parse(entry['createdAt'].toString());
              } catch (_) {}
              final dateStr = createdAt != null
                  ? DateFormat('yMMMd').add_jm().format(createdAt)
                  : '';

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomText(
                                text: displayType,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                fontColor: colorScheme.onSurface,
                              ),
                              SizedBoxWidget(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: (status == 'completed' || status == 'succeeded')
                                      ? Colors.green.withValues(alpha: 0.15)
                                      : Colors.orange.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: CustomText(
                                  text: status.toUpperCase(),
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                  fontColor: (status == 'completed' || status == 'succeeded') ? Colors.green : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          SizedBoxWidget(height: 6.h),
                          if (dateStr.isNotEmpty)
                            CustomText(
                              text: dateStr,
                              fontSize: 12.sp,
                              fontColor: colorScheme.onSurfaceVariant,
                            ),
                        ],
                      ),
                    ),
                    CustomText(
                      text: amountText,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      fontColor: isPositive ? Colors.green : colorScheme.onSurface,
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
