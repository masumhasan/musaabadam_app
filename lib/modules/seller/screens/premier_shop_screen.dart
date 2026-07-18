import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/seller/controllers/premier_shop_controller.dart';

class PremierShopScreen extends GetView<PremierShopController> {
  const PremierShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.premierShopProgram,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.r, color: colorScheme.error),
                SizedBoxWidget(height: 12.h),
                CustomText(
                  text: "Failed to load Premier Shop status",
                  fontSize: 16.sp,
                  fontColor: colorScheme.onSurface,
                ),
                SizedBoxWidget(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.loadPremierShopData(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- STATUS BANNER CARD ---
              _buildStatusBanner(context, colorScheme),

              SizedBoxWidget(height: 24.h),

              // --- PERKS & BENEFITS SECTION ---
              CustomText(
                text: AppStrings.perksAndBenefits,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                fontColor: colorScheme.onSurface,
              ),
              SizedBoxWidget(height: 12.h),
              _buildPerksSection(context, colorScheme),

              SizedBoxWidget(height: 24.h),

              // --- SALES & ACTIVITY VOLUME SECTION ---
              CustomText(
                text: AppStrings.salesAndActivityVolume,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                fontColor: colorScheme.onSurface,
              ),
              SizedBoxWidget(height: 12.h),
              _buildSalesVolumeSection(context, colorScheme),

              SizedBoxWidget(height: 24.h),

              // --- FULFILLMENT & SERVICE EXCELLENCE SECTION ---
              CustomText(
                text: AppStrings.fulfillmentAndServiceExcellence,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                fontColor: colorScheme.onSurface,
              ),
              SizedBoxWidget(height: 12.h),
              _buildFulfillmentSection(context, colorScheme),

              SizedBoxWidget(height: 30.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusBanner(BuildContext context, ColorScheme colorScheme) {
    final isPremier = controller.isPremierShop;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPremier
              ? [const Color(0xFFD4AF37), const Color(0xFFF3E5AB)]
              : [colorScheme.primaryContainer, colorScheme.surfaceContainerHighest],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: isPremier ? Colors.white : colorScheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPremier ? Icons.workspace_premium : Icons.stars_outlined,
                  color: isPremier ? const Color(0xFFB8860B) : colorScheme.primary,
                  size: 28.r,
                ),
              ),
              SizedBoxWidget(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: isPremier ? AppStrings.premierShopActive : AppStrings.premierShopStatus,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      fontColor: isPremier ? const Color(0xFF5C4033) : colorScheme.onSurface,
                    ),
                    SizedBoxWidget(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: isPremier ? Colors.green.withValues(alpha: 0.2) : colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: CustomText(
                        text: isPremier ? "Qualified Premier Seller" : "Evaluation In Progress (Rolling 90 Days)",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        fontColor: isPremier ? Colors.green[800]! : colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBoxWidget(height: 14.h),
          CustomText(
            text: isPremier
                ? "Congratulations! Your shop has earned Premier Shop status. Enjoy reduced commissions, priority search placement, and exclusive badges."
                : "Meet all sales volume and fulfillment criteria over a rolling 90-day period to automatically unlock Premier Shop perks.",
            fontSize: 13.sp,
            fontColor: isPremier ? const Color(0xFF5C4033) : colorScheme.onSurfaceVariant,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }

  Widget _buildPerksSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: controller.perks.map((perk) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle, color: Colors.amber[800], size: 18.r),
                ),
                SizedBoxWidget(width: 12.w),
                Expanded(
                  child: CustomText(
                    text: perk,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontColor: colorScheme.onSurface,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSalesVolumeSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _buildProgressTile(
            context: context,
            colorScheme: colorScheme,
            label: "Active Seller Tenure",
            currentVal: "${controller.activeDays} days",
            targetVal: "Min ${controller.targetActiveDays} days",
            progress: (controller.activeDays / controller.targetActiveDays).clamp(0.0, 1.0),
            icon: Icons.calendar_today_outlined,
          ),
          Divider(height: 24.h, color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
          _buildProgressTile(
            context: context,
            colorScheme: colorScheme,
            label: "Hosted Live Shows",
            currentVal: "${controller.hostedShows} shows",
            targetVal: "Min ${controller.targetHostedShows} shows",
            progress: (controller.hostedShows / controller.targetHostedShows).clamp(0.0, 1.0),
            icon: Icons.live_tv_outlined,
          ),
          Divider(height: 24.h, color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
          _buildProgressTile(
            context: context,
            colorScheme: colorScheme,
            label: "Completed Orders",
            currentVal: "${controller.completedOrders} orders",
            targetVal: "Min ${controller.targetCompletedOrders} orders",
            progress: (controller.completedOrders / controller.targetCompletedOrders).clamp(0.0, 1.0),
            icon: Icons.local_mall_outlined,
          ),
          Divider(height: 24.h, color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
          _buildProgressTile(
            context: context,
            colorScheme: colorScheme,
            label: "GMV Sales Volume",
            currentVal: "\$${controller.gmvAmount.toStringAsFixed(0)}",
            targetVal: "Min \$${controller.targetGmvAmount.toStringAsFixed(0)}",
            progress: (controller.gmvAmount / controller.targetGmvAmount).clamp(0.0, 1.0),
            icon: Icons.attach_money_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildFulfillmentSection(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _buildProgressTile(
            context: context,
            colorScheme: colorScheme,
            label: "Timely Shipping Rate",
            currentVal: "${controller.timelyShippingPercent}%",
            targetVal: "≥ ${controller.targetTimelyShippingPercent}% within ${controller.targetShippingHours} hrs",
            progress: (controller.timelyShippingPercent / controller.targetTimelyShippingPercent).clamp(0.0, 1.0),
            icon: Icons.local_shipping_outlined,
          ),
          Divider(height: 24.h, color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
          _buildProgressTile(
            context: context,
            colorScheme: colorScheme,
            label: "Order Reliability",
            currentVal: "${controller.orderReliabilityPercent}%",
            targetVal: "≥ ${controller.targetOrderReliabilityPercent}% success rate",
            progress: (controller.orderReliabilityPercent / controller.targetOrderReliabilityPercent).clamp(0.0, 1.0),
            icon: Icons.verified_user_outlined,
          ),
          Divider(height: 24.h, color: colorScheme.outlineVariant.withOpacity(0.4)),
          Row(
            children: [
              Icon(Icons.gavel_outlined, size: 20.r, color: colorScheme.primary),
              SizedBoxWidget(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Policy Adherence",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontColor: colorScheme.onSurface,
                    ),
                    SizedBoxWidget(height: 2.h),
                    CustomText(
                      text: controller.policyAdherenceText,
                      fontSize: 12.sp,
                      fontColor: colorScheme.onSurfaceVariant,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
              Icon(Icons.check_circle, color: Colors.green, size: 22.r),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTile({
    required BuildContext context,
    required ColorScheme colorScheme,
    required String label,
    required String currentVal,
    required String targetVal,
    required double progress,
    required IconData icon,
  }) {
    final isMet = progress >= 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20.r, color: colorScheme.primary),
            SizedBoxWidget(width: 10.w),
            Expanded(
              child: CustomText(
                text: label,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontColor: colorScheme.onSurface,
              ),
            ),
            CustomText(
              text: currentVal,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              fontColor: isMet ? Colors.green[700]! : colorScheme.onSurface,
            ),
          ],
        ),
        SizedBoxWidget(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8.h,
            backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              isMet ? Colors.green : colorScheme.primary,
            ),
          ),
        ),
        SizedBoxWidget(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: targetVal,
              fontSize: 11.sp,
              fontColor: colorScheme.onSurfaceVariant,
            ),
            CustomText(
              text: isMet ? "Met" : "${(progress * 100).toInt()}%",
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              fontColor: isMet ? Colors.green[700]! : colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }
}
