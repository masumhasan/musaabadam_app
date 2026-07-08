import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/sized_box_widget.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Reactive mock list of offers
    final RxList<Map<String, dynamic>> offers = [
      {
        'id': '1',
        'buyer': 'sneaker_dan',
        'item': 'Air Jordan 1 Chicago (2015)',
        'listPrice': 450,
        'offeredPrice': 400,
        'status': 'pending',
      },
      {
        'id': '2',
        'buyer': 'vintage_clot',
        'item': 'Vintage Harley Davidson Tee 90s',
        'listPrice': 85,
        'offeredPrice': 70,
        'status': 'pending',
      },
      {
        'id': '3',
        'buyer': 'hype_beast_9',
        'item': 'Supreme Box Logo Hooded Sweatshirt',
        'listPrice': 280,
        'offeredPrice': 250,
        'status': 'pending',
      },
    ].obs;

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
        if (offers.isEmpty) {
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
          itemCount: offers.length,
          separatorBuilder: (_, __) => SizedBoxWidget(height: 12.h),
          itemBuilder: (context, index) {
            final offer = offers[index];
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
                          text: '@${offer['buyer']}',
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
                            text: 'Pending',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontColor: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBoxWidget(height: 8.h),
                    CustomText(
                      text: offer['item']!,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontColor: colorScheme.onSurface,
                      textAlignment: TextAlign.start,
                    ),
                    SizedBoxWidget(height: 12.h),
                    Row(
                      children: [
                        Text(
                          'List Price: \$${offer['listPrice']}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: colorScheme.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBoxWidget(width: 10.w),
                        CustomText(
                          text: 'Offer: \$${offer['offeredPrice']}',
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
                            onPressed: () {
                              offers.removeAt(index);
                              Get.snackbar(
                                'Offer Declined',
                                'Declined offer for ${offer['item']}',
                                backgroundColor: colorScheme.errorContainer,
                                colorText: colorScheme.onErrorContainer,
                              );
                            },
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
                            onPressed: () {
                              offers.removeAt(index);
                              Get.snackbar(
                                'Offer Accepted!',
                                'Accepted offer for ${offer['item']}',
                                backgroundColor: colorScheme.primaryContainer,
                                colorText: colorScheme.onPrimaryContainer,
                              );
                            },
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
