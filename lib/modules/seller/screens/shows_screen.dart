import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';
import 'package:musaab_adam/modules/seller/controllers/shows_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/sized_box_widget.dart';
import '../../../core/widgets/text_button_widget.dart';

class ShowsScreen extends GetView<ShowsController> {
  const ShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.shows,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.onSurface),
            onPressed: controller.loadShows,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.scheduleLiveShowScreen),
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: Colors.white, size: 30.sp),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            // Tabs
            Row(
              spacing: 20.w,
              children: [
                _buildTab(AppStrings.shows, 0, colorScheme),
                _buildTab(AppStrings.pastShows, 1, colorScheme),
              ],
            ),

            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = controller.currentList;
                if (items.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Assets.images.appLogo.keyName, width: 180.w),
                      SizedBoxWidget(height: 20),
                      CustomText(
                        text: AppStrings.nothingHere,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontColor: colorScheme.onSurface,
                      ),
                    ],
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.only(top: 12.h, bottom: 80.h),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => Divider(color: colorScheme.outline.withValues(alpha: 0.15), height: 1),
                  itemBuilder: (context, index) => _ShowTile(show: items[index], colorScheme: colorScheme),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index, ColorScheme colorScheme) {
    return Obx(() {
      final isSelected = controller.selectedTabIndex.value == index;
      return TextButtonWidget(
        text: title,
        textColor: isSelected ? colorScheme.onSurface : colorScheme.outline,
        decoration: isSelected ? TextDecoration.underline : null,
        decorationColor: colorScheme.primary,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        onPressed: () => controller.selectTab(index),
      );
    });
  }
}

class _ShowTile extends StatelessWidget {
  final StreamModel show;
  final ColorScheme colorScheme;
  const _ShowTile({required this.show, required this.colorScheme});

  void _showManageSheet(StreamModel show) {
    final controller = Get.find<ShowsController>();
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (show.status == 'draft')
                ListTile(
                  leading: const Icon(Icons.publish),
                  title: const Text('Publish show'),
                  onTap: () {
                    Get.back();
                    controller.publishShow(show.id);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete show', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  controller.deleteShow(show.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLive = show.status == 'live';
    final isScheduled = show.status == 'scheduled';
    final hasReplay = show.hasReplay;
    final isProcessingReplay = show.status == 'ended' && show.recordingStatus == 'processing';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (show.status == 'ended' || hasReplay)
            ? () => Get.toNamed(AppRoutes.replayScreen, arguments: show)
            : isScheduled
                ? () => Get.toNamed(AppRoutes.startShowScreen, arguments: show)
                : null,
        onLongPress: (show.status == 'draft' || isScheduled || show.status == 'cancelled')
            ? () => _showManageSheet(show)
            : null,
        child: Row(
        children: [
          // Thumbnail (with a play overlay when a replay is available)
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: show.thumbnailUrl != null
                    ? Image.network(
                        show.thumbnailUrl!,
                        width: 72.w,
                        height: 72.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              if (hasReplay)
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 22.sp),
                ),
            ],
          ),
          SizedBoxWidget(width: 12.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isLive)
                      Container(
                        margin: EdgeInsets.only(right: 6.w),
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: CustomText(text: 'LIVE', fontSize: 10, fontColor: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    Expanded(
                      child: CustomText(
                        text: show.title,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontColor: colorScheme.onSurface,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isScheduled || show.status == 'draft')
                      GestureDetector(
                        onTap: () => Get.toNamed(
                          AppRoutes.scheduleLiveShowScreen,
                          arguments: show,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Icon(Icons.edit_outlined, size: 18.sp, color: colorScheme.outline),
                        ),
                      ),
                  ],
                ),
                SizedBoxWidget(height: 4.h),
                if (show.scheduledAt != null)
                  CustomText(
                    text: _formatDateTime(show.scheduledAt!),
                    fontSize: 12,
                    fontColor: colorScheme.outline,
                  ),
                SizedBoxWidget(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.visibility_outlined, size: 14.sp, color: colorScheme.outline),
                    SizedBoxWidget(width: 4.w),
                    CustomText(text: '${show.totalViewers}', fontSize: 12, fontColor: colorScheme.outline),
                    if (isScheduled) ...[
                      SizedBoxWidget(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(text: 'Scheduled', fontSize: 11, fontColor: AppColors.orange),
                      ),
                    ],
                    if (show.status == 'draft') ...[
                      SizedBoxWidget(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colorScheme.outline.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(text: 'Draft', fontSize: 11, fontColor: colorScheme.outline),
                      ),
                    ],
                    if (hasReplay) ...[
                      SizedBoxWidget(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_circle_outline, size: 13.sp, color: colorScheme.primary),
                            SizedBoxWidget(width: 4.w),
                            CustomText(text: 'Replay', fontSize: 11, fontColor: colorScheme.primary),
                          ],
                        ),
                      ),
                    ] else if (isProcessingReplay) ...[
                      SizedBoxWidget(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colorScheme.outline.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(text: 'Processing replay…', fontSize: 11, fontColor: colorScheme.outline),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isScheduled)
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.startShowScreen, arguments: show),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  minimumSize: Size(0, 32.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                ),
                child: const Text('Join', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
        ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 72.w,
        height: 72.w,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(Icons.live_tv_outlined, color: colorScheme.outline, size: 28.sp),
      );

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final h = local.hour > 12 ? local.hour - 12 : local.hour == 0 ? 12 : local.hour;
    final m = local.minute.toString().padLeft(2, '0');
    final ampm = local.hour >= 12 ? 'PM' : 'AM';
    return '${months[local.month - 1]} ${local.day}, ${local.year}  $h:$m $ampm';
  }
}
