import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/shipping/controllers/order_tracking_controller.dart';

class OrderTrackingScreen extends GetView<OrderTrackingController> {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: cs.onSurface),
        title: CustomText(text: 'Order tracking', fontWeight: FontWeight.w700),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.hasError.value || controller.order.value == null) {
          return Center(child: CustomText(text: 'Could not load tracking.', fontColor: cs.outline));
        }

        final order = controller.order.value!;
        final events = controller.events;

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: 'Status', fontColor: cs.outline, fontSize: 13),
                      CustomText(text: _pretty(order.status), fontWeight: FontWeight.w700),
                    ],
                  ),
                  if (controller.trackingNumber.value.isNotEmpty) ...[
                    SizedBoxWidget(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: 'Tracking #', fontColor: cs.outline, fontSize: 13),
                        Flexible(child: CustomText(text: controller.trackingNumber.value, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBoxWidget(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: 'Carrier', fontColor: cs.outline, fontSize: 13),
                        CustomText(text: _pretty(controller.carrier.value), fontWeight: FontWeight.w600),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBoxWidget(height: 24.h),
            CustomText(text: 'History', fontWeight: FontWeight.w700, textAlignment: TextAlign.start),
            SizedBoxWidget(height: 12.h),
            if (events.isEmpty)
              CustomText(text: 'No tracking events yet.', fontColor: cs.outline, textAlignment: TextAlign.start)
            else
              ...events.map((e) => _timelineRow(e, cs)),

            // Buyer confirm-receipt action (delivered → completed)
            if (order.isDelivered) ...[
              SizedBoxWidget(height: 28.h),
              CustomButton(
                label: 'Confirm receipt',
                buttonWidth: double.infinity,
                backgroundColor: cs.primary,
                textColor: Colors.white,
                isLoading: controller.isConfirming.value,
                onPressed: controller.confirmReceipt,
              ),
              SizedBoxWidget(height: 6.h),
              CustomText(
                text: 'Confirms your order arrived and completes it.',
                fontSize: 12,
                fontColor: cs.outline,
              ),
            ] else if (order.isCompleted) ...[
              SizedBoxWidget(height: 24.h),
              Center(
                child: CustomText(
                  text: '✓ Order completed',
                  fontWeight: FontWeight.w700,
                  fontColor: cs.primary,
                ),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _timelineRow(Map<String, dynamic> e, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Icon(Icons.check_circle, color: cs.primary, size: 16.r),
          ),
          SizedBoxWidget(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: e['label']?.toString() ?? '', textAlignment: TextAlign.start, fontWeight: FontWeight.w600),
                if (e['at'] != null)
                  CustomText(
                    text: _date(e['at'].toString()),
                    textAlignment: TextAlign.start,
                    fontColor: cs.outline,
                    fontSize: 12,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _pretty(String s) =>
      s.isEmpty ? '—' : s.split('_').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  String _date(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return '';
    return '${d.day}/${d.month}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
