import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/data/models/address/address_model.dart';
import 'package:musaab_adam/data/models/payment/payment_method_model.dart';
import 'package:musaab_adam/modules/payments/controllers/checkout_controller.dart';

class CheckoutScreen extends GetView<CheckoutController> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: cs.onSurface),
        title: CustomText(text: 'Checkout', fontWeight: FontWeight.w700),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.hasError.value || controller.order.value == null) {
          return Center(
            child: CustomText(text: 'Could not load this order.', fontColor: cs.outline),
          );
        }

        final order = controller.order.value!;

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                children: [
                  CustomText(text: 'Order summary', fontWeight: FontWeight.w700, textAlignment: TextAlign.start),
                  SizedBoxWidget(height: 12.h),
                  ...order.items.map((item) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                text: '${item.title}  ×${item.quantity}',
                                textAlignment: TextAlign.start,
                                maxLines: 2,
                              ),
                            ),
                            CustomText(text: '£${item.totalPrice.toStringAsFixed(2)}', fontWeight: FontWeight.w600),
                          ],
                        ),
                      )),
                  Divider(color: cs.outline.withValues(alpha: 0.3)),
                  _row('Subtotal', order.subtotal, cs),
                  _row('Shipping', order.shippingCost, cs),
                  _row('Tax', order.taxAmount, cs),
                  Divider(color: cs.outline.withValues(alpha: 0.3)),
                  _row('Total', order.totalAmount, cs, bold: true),
                  SizedBoxWidget(height: 24.h),

                  // Shipping address
                  CustomText(text: 'Shipping address', fontWeight: FontWeight.w700, textAlignment: TextAlign.start),
                  SizedBoxWidget(height: 12.h),
                  if (controller.addresses.isEmpty)
                    CustomText(
                      text: 'No saved addresses. Add one in your profile to set shipping & tax.',
                      fontColor: cs.outline,
                      textAlignment: TextAlign.start,
                    )
                  else
                    ...controller.addresses.map((a) => _addressTile(a, cs)),
                  SizedBoxWidget(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: 'Payment method', fontWeight: FontWeight.w700),
                      GestureDetector(
                        onTap: controller.addCardQuick,
                        child: CustomText(text: '+ Add card', fontColor: cs.primary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBoxWidget(height: 12.h),
                  if (controller.methods.isEmpty)
                    CustomText(
                      text: 'No saved cards. Tap “Add card” to continue.',
                      fontColor: cs.outline,
                      textAlignment: TextAlign.start,
                    )
                  else
                    ...controller.methods.map((m) => _methodTile(m, cs)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
              child: CustomButton(
                label: 'Pay £${order.totalAmount.toStringAsFixed(2)}',
                buttonWidth: double.infinity,
                backgroundColor: cs.primary,
                textColor: Colors.white,
                isLoading: controller.isPaying.value,
                onPressed: controller.pay,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _row(String label, double value, ColorScheme cs, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: label, fontColor: bold ? cs.onSurface : cs.outline, fontWeight: bold ? FontWeight.w700 : FontWeight.w400),
          CustomText(text: '£${value.toStringAsFixed(2)}', fontWeight: bold ? FontWeight.w700 : FontWeight.w500),
        ],
      ),
    );
  }

  Widget _addressTile(AddressModel a, ColorScheme cs) {
    return Obx(() {
      final selected = controller.selectedAddressId.value == a.id;
      return GestureDetector(
        onTap: () => controller.selectAddress(a),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: selected ? 0.5 : 0.2),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: selected ? cs.primary : cs.outline.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined, color: cs.onSurface, size: 20.r),
              SizedBoxWidget(width: 12.w),
              Expanded(
                child: CustomText(
                  text: '${a.fullName}, ${a.line1}, ${a.city} ${a.postalCode}, ${a.country}',
                  textAlignment: TextAlign.start,
                  maxLines: 2,
                  fontSize: 13,
                ),
              ),
              if (selected) Icon(Icons.check_circle, color: cs.primary, size: 20.r),
            ],
          ),
        ),
      );
    });
  }

  Widget _methodTile(PaymentMethodModel m, ColorScheme cs) {
    return Obx(() {
      final selected = controller.selectedMethodId.value == m.id;
      return GestureDetector(
        onTap: () => controller.selectMethod(m.id),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: selected ? 0.5 : 0.2),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: selected ? cs.primary : cs.outline.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.credit_card, color: cs.onSurface, size: 20.r),
              SizedBoxWidget(width: 12.w),
              Expanded(child: CustomText(text: m.displayLabel, textAlignment: TextAlign.start)),
              if (selected) Icon(Icons.check_circle, color: cs.primary, size: 20.r),
            ],
          ),
        ),
      );
    });
  }
}
