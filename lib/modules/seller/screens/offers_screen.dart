import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/sized_box_widget.dart';
import '../controllers/offers_controller.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final controller = Get.put(OffersController());

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.offers,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.offers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.percent, size: 64.sp, color: colorScheme.outline),
                SizedBoxWidget(height: 16.h),
                CustomText(
                  text: 'No active offers',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontColor: colorScheme.onSurface,
                ),
                SizedBoxWidget(height: 6.h),
                CustomText(
                  text: 'Incoming buyer offers will appear here.',
                  fontSize: 14,
                  fontColor: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          itemCount: controller.offers.length,
          separatorBuilder: (_, __) => SizedBoxWidget(height: 12.h),
          itemBuilder: (context, index) {
            final offer = controller.offers[index];
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              color: colorScheme.surfaceContainerLow,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: '@${offer.buyerUsername ?? 'buyer'}',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontColor: colorScheme.primary,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: CustomText(
                            text: offer.status.capitalizeFirst ?? 'Pending',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontColor: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBoxWidget(height: 8.h),
                    CustomText(
                      text: offer.productTitle ?? 'Product',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontColor: colorScheme.onSurface,
                      textAlignment: TextAlign.start,
                    ),
                    SizedBoxWidget(height: 12.h),
                    Row(
                      children: [
                        CustomText(
                          text: 'Offer: \$${offer.amount}',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontColor: colorScheme.onSurface,
                        ),
                      ],
                    ),
                    SizedBoxWidget(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.error,
                              side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                            ),
                            onPressed: () => controller.updateOfferStatus(offer.id, 'declined'),
                            child: const Text('Decline'),
                          ),
                        ),
                        SizedBoxWidget(width: 12.w),
                        Expanded(
                          child: CustomButton(
                            label: 'Accept',
                            buttonHeight: 38.h,
                            textColor: Colors.white,
                            backgroundColor: colorScheme.primary,
                            onPressed: () => controller.updateOfferStatus(offer.id, 'accepted'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
