import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/payments/controllers/wallet_controller.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final _controller = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.wallet,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.onSurface),
            onPressed: _controller.refreshWallet,
          )
        ],
      ),
      body: Obx(() {
        final available = _controller.wallet.value?.available ?? 0.0;
        final pending = _controller.wallet.value?.pending ?? 0.0;
        final lifetimeEarned = _controller.wallet.value?.lifetimeEarned ?? 0.0;

        if (_controller.isLoading.value && _controller.wallet.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _controller.refreshWallet,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Balance Card (Whatnot style)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.85)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Available to Cash Out',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontColor: Colors.white.withValues(alpha: 0.85),
                      ),
                      SizedBoxWidget(height: 6.h),
                      CustomText(
                        text: '£${available.toStringAsFixed(2)}',
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        fontColor: Colors.white,
                      ),
                      SizedBoxWidget(height: 16.h),
                      const Divider(color: Colors.white24, height: 1),
                      SizedBoxWidget(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Pending Balance',
                                fontSize: 12,
                                fontColor: Colors.white.withValues(alpha: 0.85),
                              ),
                              SizedBoxWidget(height: 2.h),
                              CustomText(
                                text: '£${pending.toStringAsFixed(2)}',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontColor: Colors.white,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Lifetime Earned',
                                fontSize: 12,
                                fontColor: Colors.white.withValues(alpha: 0.85),
                              ),
                              SizedBoxWidget(height: 2.h),
                              CustomText(
                                text: '£${lifetimeEarned.toStringAsFixed(2)}',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontColor: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBoxWidget(height: 20.h),

                // 2. Cash Out Action Button
                CustomButton(
                  label: 'Cash Out Funds',
                  buttonWidth: double.infinity,
                  buttonHeight: 48.h,
                  textColor: Colors.white,
                  backgroundColor: available >= 10.0 ? colorScheme.primary : colorScheme.outlineVariant,
                  onPressed: available >= 10.0 ? _controller.cashOut : null,
                ),

                SizedBoxWidget(height: 24.h),

                // 3. Transactions List Header
                CustomText(
                  text: 'Transaction History',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontColor: colorScheme.onSurface,
                ),

                SizedBoxWidget(height: 12.h),

                // 4. Ledger List
                if (_controller.isLedgerLoading.value && _controller.ledgerEntries.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else if (_controller.ledgerEntries.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Column(
                        children: [
                          Icon(Icons.history, size: 48.sp, color: colorScheme.outline),
                          SizedBoxWidget(height: 12.h),
                          CustomText(
                            text: 'No transactions yet',
                            fontSize: 14,
                            fontColor: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _controller.ledgerEntries.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final entry = _controller.ledgerEntries[index];
                      final amount = (entry['amount'] as num?)?.toDouble() ?? 0.0;
                      final type = entry['type'] ?? 'transaction';
                      final bucket = entry['bucket'] ?? 'available';
                      final status = entry['status'] ?? 'completed';
                      final createdAt = entry['createdAt']?.toString().split('T')[0] ?? '';

                      final isPositive = amount > 0;
                      final amountText = '${isPositive ? '+' : ''}£${amount.toStringAsFixed(2)}';
                      final displayType = type.toString().replaceAll('_', ' ').toUpperCase();

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: CustomText(
                          text: displayType,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontColor: colorScheme.onSurface,
                          textAlignment: TextAlign.start,
                        ),
                        subtitle: Row(
                          children: [
                            CustomText(
                              text: createdAt,
                              fontSize: 12,
                              fontColor: colorScheme.onSurfaceVariant,
                            ),
                            SizedBoxWidget(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: (status == 'completed')
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: CustomText(
                                text: status,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontColor: (status == 'completed') ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        trailing: CustomText(
                          text: amountText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontColor: isPositive ? Colors.green : colorScheme.onSurface,
                        ),
                      );
                    },
                  ),
                SizedBoxWidget(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}
