import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/sized_box_widget.dart';
import '../../../core/widgets/cached_image_widget.dart';
import '../controllers/seller_tips_controller.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final controller = Get.find<SellerTipsController>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: 'Received Tips',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.onSurface),
            onPressed: controller.loadTips,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadTips,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.hasError.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48.r, color: colorScheme.error),
                    SizedBoxWidget(height: 16),
                    CustomText(
                      text: 'Failed to load received tips.',
                      fontSize: 14.sp,
                      fontColor: colorScheme.onSurface,
                    ),
                    SizedBoxWidget(height: 16),
                    ElevatedButton(
                      onPressed: controller.loadTips,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final tipsList = controller.tips;

          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Summary Header Card
              SliverPadding(
                padding: EdgeInsets.all(20.w),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Total Tips Received',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.white.withValues(alpha: 0.9),
                            ),
                            SizedBoxWidget(height: 8.h),
                            CustomText(
                              text: '£${controller.totalTipsAmount.toStringAsFixed(2)}',
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w800,
                              fontColor: Colors.white,
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 28.r,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Title Header
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Tip History',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        fontColor: colorScheme.onSurface,
                      ),
                      SizedBoxWidget(height: 12.h),
                    ],
                  ),
                ),
              ),

              // Tips List or Empty State
              if (tipsList.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.images.appLogo.keyName,
                            width: 140.w,
                            opacity: const AlwaysStoppedAnimation(0.5),
                          ),
                          SizedBoxWidget(height: 20),
                          CustomText(
                            text: 'No tips received yet.',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontColor: colorScheme.onSurface,
                          ),
                          SizedBoxWidget(height: 8),
                          CustomText(
                            text: 'Tips sent by viewers during your live shows will appear here.',
                            fontSize: 12.sp,
                            fontColor: colorScheme.onSurfaceVariant,
                            textAlignment: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final tip = tipsList[index];
                        final buyer = tip['buyerId'] as Map<String, dynamic>? ?? {};
                        final buyerName = buyer['displayName']?.toString() ??
                            buyer['username']?.toString() ??
                            'Anonymous';
                        final avatarUrl = buyer['avatarUrl']?.toString() ?? '';
                        final message = tip['message']?.toString();
                        final amount = tip['amount'] is num
                            ? (tip['amount'] as num).toDouble()
                            : 0.0;

                        DateTime? createdAt;
                        try {
                          createdAt = DateTime.parse(tip['createdAt'].toString());
                        } catch (_) {}
                        final dateStr = createdAt != null
                            ? DateFormat('yMMMd').add_jm().format(createdAt)
                            : '';

                        return Card(
                          elevation: 0,
                          margin: EdgeInsets.only(bottom: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          color: colorScheme.surfaceContainerLow,
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedImageWidget(
                                        imageUrl: avatarUrl,
                                        height: 36.h,
                                        width: 36.w,
                                      ),
                                    ),
                                    SizedBoxWidget(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: buyerName,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            fontColor: colorScheme.onSurface,
                                          ),
                                          if (dateStr.isNotEmpty)
                                            CustomText(
                                              text: dateStr,
                                              fontSize: 11.sp,
                                              fontColor: colorScheme.onSurfaceVariant,
                                            ),
                                        ],
                                      ),
                                    ),
                                    CustomText(
                                      text: '£${amount.toStringAsFixed(2)}',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      fontColor: colorScheme.primary,
                                    ),
                                  ],
                                ),
                                if (message != null && message.trim().isNotEmpty) ...[
                                  SizedBoxWidget(height: 10.h),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: colorScheme.primary.withValues(alpha: 0.1),
                                      ),
                                    ),
                                    child: CustomText(
                                      text: '"$message"',
                                      fontSize: 13.sp,
                                      fontStyle: FontStyle.italic,
                                      fontColor: colorScheme.onSurface,
                                      textAlignment: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: tipsList.length,
                    ),
                  ),
                ),
              // Bottom padding
              SliverToBoxAdapter(
                child: SizedBoxWidget(height: 20.h),
              ),
            ],
          );
        }),
      ),
    );
  }
}
