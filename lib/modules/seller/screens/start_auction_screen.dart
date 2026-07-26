import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/custom_text_field.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/seller/controllers/start_auction_controller.dart';

class StartAuctionScreen extends GetView<StartAuctionController> {
  const StartAuctionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: 'Start Auction',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pinned product card
            _PinnedProductCard(controller: controller, colorScheme: colorScheme),
            SizedBoxWidget(height: 24.h),

            // Stream Title input (CustomTextField handles its own label internally)
            CustomTextField(
              label: 'Stream Title',
              hintText: 'Name your auction stream',
              controller: controller.titleController,
            ),
            SizedBoxWidget(height: 20.h),

            // Stream Description input
            CustomTextField(
              label: 'Stream Description (Optional)',
              hintText: 'Describe your stream to your viewers...',
              controller: controller.descriptionController,
              maxLines: 3,
            ),
            SizedBoxWidget(height: 20.h),

            // Stream Cover Image Section
            CustomText(
              text: 'Stream Cover Image (Optional)',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontColor: colorScheme.onSurface,
            ),
            SizedBoxWidget(height: 8.h),
            Obx(() {
              final thumbUrl = controller.thumbnailUrl.value;
              final isUploading = controller.isLoading.value && thumbUrl.isEmpty;

              return GestureDetector(
                onTap: controller.isLoading.value ? null : controller.pickThumbnail,
                child: Container(
                  width: double.infinity,
                  height: 160.h,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: thumbUrl.isNotEmpty
                        ? Stack(
                            children: [
                              Image.network(
                                thumbUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: colorScheme.surfaceContainerHighest,
                                  child: Icon(Icons.broken_image_outlined,
                                      color: colorScheme.error, size: 40.sp),
                                ),
                              ),
                              // Bottom edit bar
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit, color: Colors.white, size: 16.sp),
                                      SizedBoxWidget(width: 6.w),
                                      CustomText(
                                        text: 'Change Cover Photo',
                                        fontColor: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Clear button
                              Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.thumbnailUrl.value = '';
                                  },
                                  child: CircleAvatar(
                                    radius: 14.r,
                                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                                    child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : isUploading
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 24.w,
                                      height: 24.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: AppColors.orange,
                                      ),
                                    ),
                                    SizedBoxWidget(height: 10.h),
                                    CustomText(
                                      text: 'Uploading thumbnail...',
                                      fontSize: 12,
                                      fontColor: colorScheme.outline,
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: AppColors.orange,
                                      size: 32.sp,
                                    ),
                                    SizedBoxWidget(height: 8.h),
                                    CustomText(
                                      text: 'Upload Cover Photo',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      fontColor: colorScheme.onSurface,
                                    ),
                                    SizedBoxWidget(height: 4.h),
                                    CustomText(
                                      text: 'Recommended: JPG or PNG format',
                                      fontSize: 11,
                                      fontColor: colorScheme.outline,
                                    ),
                                  ],
                                ),
                              ),
                  ),
                ),
              );
            }),
            SizedBoxWidget(height: 32.h),

            // Info banner
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppColors.orange, size: 20.sp),
                  SizedBoxWidget(width: 10.w),
                  Expanded(
                    child: CustomText(
                      text: 'Your auction stream starts immediately. Viewers can place bids in real time. The product will be pinned during the stream.',
                      fontSize: 12,
                      fontColor: AppColors.orange,
                      textAlignment: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            SizedBoxWidget(height: 32.h),

            Obx(() => CustomButton(
              label: controller.isLoading.value && controller.thumbnailUrl.value.isNotEmpty ? 'Starting…' : 'Start Auction Now',
              buttonWidth: double.infinity,
              backgroundColor: AppColors.orange,
              textColor: Colors.white,
              onPressed: controller.isLoading.value ? null : controller.startAuction,
            )),
            SizedBoxWidget(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _PinnedProductCard extends StatelessWidget {
  final StartAuctionController controller;
  final ColorScheme colorScheme;
  const _PinnedProductCard({required this.controller, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: product.images.isNotEmpty
                ? Image.network(
                    product.images.first,
                    width: 70.w,
                    height: 70.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _placeholder(colorScheme),
                  )
                : _placeholder(colorScheme),
          ),
          SizedBoxWidget(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.gavel, size: 12.sp, color: AppColors.orange),
                      SizedBoxWidget(width: 4.w),
                      CustomText(text: 'Auction', fontSize: 11, fontColor: AppColors.orange),
                    ],
                  ),
                ),
                SizedBoxWidget(height: 6.h),
                CustomText(
                  text: product.title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontColor: colorScheme.onSurface,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlignment: TextAlign.start,
                ),
                SizedBoxWidget(height: 4.h),
                CustomText(
                  text: product.displayPrice,
                  fontSize: 13,
                  fontColor: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(ColorScheme cs) => Container(
        width: 70.w,
        height: 70.w,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(Icons.image_outlined, color: cs.outline, size: 28.sp),
      );
}
