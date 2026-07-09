import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../controllers/end_show_insights_controller.dart';

class EndShowInsightsScreen extends GetView<EndShowInsightsController> {
  const EndShowInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Top Blue Section
                  Container(
                    width: double.infinity,
                    color: AppColors.primaryColor,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 32.h,
                      bottom: 32.h,
                      left: 16.w,
                      right: 16.w,
                    ),
                    child: Column(
                      children: [
                        // Checkmark Icon Placeholder
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 100.sp, color: Colors.white),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.favorite, color: Colors.white, size: 16.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBoxWidget(height: 24.h),
                        CustomText(
                          text: 'Great show, ${controller.sellerName.value}!',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontColor: Colors.white,
                        ),
                        SizedBoxWidget(height: 8.h),
                        CustomText(
                          text: 'Here\'s your show overview and insights',
                          fontSize: 14,
                          fontColor: Colors.white.withValues(alpha: 0.9),
                        ),
                      ],
                    ),
                  ),
                  
                  // Bottom Stats Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    // Main Stats
                    _buildStatContainer(
                      colorScheme: colorScheme,
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(child: _buildStatItem('Sales', '\$${controller.sales.value}', colorScheme)),
                                VerticalDivider(color: colorScheme.onSurface.withValues(alpha: 0.1), thickness: 1),
                                Expanded(child: _buildStatItem('Orders', '${controller.orders.value}', colorScheme)),
                              ],
                            ),
                          ),
                          Divider(color: colorScheme.onSurface.withValues(alpha: 0.1), thickness: 1),
                          _buildStatItem('Shares', '${controller.shares.value}', colorScheme, alignLeft: true),
                        ],
                      ),
                    ),
                    
                    SizedBoxWidget(height: 24.h),
                    
                    CustomText(
                      text: 'Promote Tools',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontColor: colorScheme.onSurface,
                      textAlignment: TextAlign.left,
                    ),
                    SizedBoxWidget(height: 12.h),
                    
                    // Promote Tools Stats
                    _buildStatContainer(
                      colorScheme: colorScheme,
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(child: _buildStatItem('Viewers', '${controller.viewers.value}', colorScheme)),
                                VerticalDivider(color: colorScheme.onSurface.withValues(alpha: 0.1), thickness: 1),
                                Expanded(child: _buildStatItem('New Followers', '${controller.newFollowers.value}', colorScheme)),
                              ],
                            ),
                          ),
                          Divider(color: colorScheme.onSurface.withValues(alpha: 0.1), thickness: 1),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(child: _buildStatItem('Total Bids', '${controller.totalBids.value}', colorScheme)),
                                VerticalDivider(color: colorScheme.onSurface.withValues(alpha: 0.1), thickness: 1),
                                Expanded(child: _buildStatItem('First Time Buyers', '${controller.firstTimeBuyers.value}', colorScheme)),
                              ],
                            ),
                          ),
                          Divider(color: colorScheme.onSurface.withValues(alpha: 0.1), thickness: 1),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(child: _buildStatItem('Promo Sales', '\$${controller.promoSales.value}', colorScheme)),
                                VerticalDivider(color: colorScheme.onSurface.withValues(alpha: 0.1), thickness: 1),
                                Expanded(child: _buildStatItem('Spend', '\$${controller.spend.value}', colorScheme)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBoxWidget(height: 32.h),
                    
                    CustomButton(
                      label: 'Schedule Next Show',
                      backgroundColor: AppColors.primaryColor,
                      textColor: Colors.white,
                      buttonHeight: 50.h,
                      onPressed: controller.scheduleNextShow,
                    ),
                    
                    SizedBoxWidget(height: 16.h),
                    
                    // Analytics Banner
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.show_chart, color: colorScheme.onSurface.withValues(alpha: 0.6), size: 24.sp),
                          SizedBoxWidget(width: 12.w),
                          Expanded(
                            child: CustomText(
                              text: 'Take a look at our new and improved seller analytics design!',
                              fontSize: 12,
                              fontColor: colorScheme.onSurface.withValues(alpha: 0.9),
                              textAlignment: TextAlign.left,
                            ),
                          ),
                          Icon(Icons.chevron_right, color: colorScheme.onSurface.withValues(alpha: 0.6), size: 20.sp),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
                ],
              ),
            ),
            
            // Sticky Close Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16.h,
              right: 16.w,
              child: GestureDetector(
                onTap: controller.closeInsights,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatContainer({required Widget child, required ColorScheme colorScheme}) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: child,
    );
  }

  Widget _buildStatItem(String label, String value, ColorScheme colorScheme, {bool alignLeft = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          CustomText(
            text: label,
            fontSize: 12,
            fontColor: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          SizedBoxWidget(height: 8.h),
          CustomText(
            text: value,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontColor: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}
