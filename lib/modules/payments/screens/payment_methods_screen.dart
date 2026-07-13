import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import '../controllers/payment_methods_controller.dart';
import 'package:musaab_adam/data/models/payment/payment_method_model.dart';

class PaymentMethodsScreen extends GetView<PaymentMethodsController> {
  const PaymentMethodsScreen({super.key});

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
          text: 'Payment Methods',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.onSurface),
            onPressed: controller.loadMethods,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.methods.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.credit_card_off_rounded, size: 64.sp, color: colorScheme.outline),
                SizedBoxWidget(height: 16.h),
                CustomText(
                  text: 'Failed to load payment methods',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontColor: colorScheme.onSurface,
                ),
                SizedBoxWidget(height: 12.h),
                TextButton(
                  onPressed: controller.loadMethods,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: controller.methods.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.payment_rounded, size: 64.sp, color: colorScheme.outline),
                            SizedBoxWidget(height: 16.h),
                            CustomText(
                              text: 'No payment methods yet',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontColor: colorScheme.onSurface,
                            ),
                            SizedBoxWidget(height: 8.h),
                            CustomText(
                              text: 'Add a credit or debit card to use during live auctions and checkouts.',
                              fontSize: 14,
                              fontColor: colorScheme.onSurfaceVariant,
                              textAlignment: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      itemCount: controller.methods.length,
                      itemBuilder: (context, index) {
                        final m = controller.methods[index];
                        return _buildCardItem(context, m, colorScheme);
                      },
                    ),
            ),
            _buildBottomBar(colorScheme),
          ],
        );
      }),
    );
  }

  Widget _buildCardItem(BuildContext context, PaymentMethodModel m, ColorScheme cs) {
    final expMonthStr = m.expMonth?.toString().padLeft(2, '0') ?? '??';
    final expYearStr = m.expYear?.toString().substring(m.expYear.toString().length - 2) ?? '??';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: m.isDefault ? cs.primary : cs.outlineVariant,
          width: m.isDefault ? 2.w : 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (!m.isDefault) {
                _showSetDefaultDialog(context, m);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Card Brand Icon
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.credit_card_rounded,
                      color: cs.primary,
                      size: 28.sp,
                    ),
                  ),
                  SizedBoxWidget(width: 16.w),

                  // Card details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: m.displayLabel,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontColor: cs.onSurface,
                            ),
                            if (m.isDefault) ...[
                              SizedBoxWidget(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: cs.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: CustomText(
                                  text: 'Default',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontColor: cs.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBoxWidget(height: 4.h),
                        CustomText(
                          text: 'Expires $expMonthStr/$expYearStr',
                          fontSize: 13,
                          fontColor: cs.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),

                  // Actions
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: cs.error, size: 22.sp),
                    onPressed: () => _showDeleteDialog(context, m),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(ColorScheme cs) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: SafeArea(
        child: CustomButton(
          label: 'Add Payment Method',
          buttonWidth: double.infinity,
          buttonHeight: 48.h,
          textColor: Colors.white,
          backgroundColor: cs.primary,
          onPressed: () async {
            await Get.toNamed(AppRoutes.addPaymentMethodScreen);
            controller.loadMethods(); // Reload cards on return
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PaymentMethodModel m) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Payment Method'),
        content: Text('Are you sure you want to remove the payment method ${m.displayLabel}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteMethod(m.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSetDefaultDialog(BuildContext context, PaymentMethodModel m) {
    Get.dialog(
      AlertDialog(
        title: const Text('Set as Default'),
        content: Text('Do you want to set ${m.displayLabel} as your default payment method?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.setDefault(m.id);
            },
            child: const Text('Set Default'),
          ),
        ],
      ),
    );
  }
}
