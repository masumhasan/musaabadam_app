import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';
import 'package:musaab_adam/modules/livestream/controllers/past_shows_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';

/// Grid of past shows whose recording is ready to replay.
class PastShowsScreen extends GetView<PastShowsController> {
  const PastShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('Past Streams')),
      body: RefreshIndicator(
        onRefresh: controller.loadReplays,
        child: Obx(() {
          if (controller.isLoading.value && controller.replays.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.hasError.value && controller.replays.isEmpty) {
            return _message(context, 'Could not load past streams.', onRetry: controller.loadReplays);
          }
          if (controller.replays.isEmpty) {
            return _message(context, 'No past streams yet.');
          }
          return GridView.builder(
            padding: EdgeInsets.all(15.w),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              mainAxisExtent: 185.h,
            ),
            itemCount: controller.replays.length,
            itemBuilder: (context, index) => PastShowGridItem(stream: controller.replays[index]),
          );
        }),
      ),
    );
  }

  Widget _message(BuildContext context, String text, {VoidCallback? onRetry}) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 200.h),
        Center(child: CustomText(text: text, fontColor: Theme.of(context).colorScheme.outline)),
        if (onRetry != null)
          Center(
            child: TextButton(onPressed: onRetry, child: const Text('Retry')),
          ),
      ],
    );
  }
}

/// A single past-show card with a play overlay and optional duration badge.
class PastShowGridItem extends StatelessWidget {
  final StreamModel stream;
  const PastShowGridItem({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasReplay = stream.hasReplay;
    final isProcessing = stream.recordingStatus == 'processing';
    return GestureDetector(
      onTap: () {
        if (hasReplay) {
          Get.toNamed(AppRoutes.replayScreen, arguments: stream);
        } else {
          Get.snackbar(
            'Replay unavailable',
            isProcessing
                ? 'This replay is still being processed. Check back shortly.'
                : 'No replay was recorded for this show.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: CachedImageWidget(
                  height: 25.h,
                  width: 25.w,
                  iconSize: 20,
                  imageUrl: stream.sellerAvatarUrl ?? Dummy.user2,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: CustomText(
                  text: stream.sellerName ?? '',
                  textAlignment: TextAlign.left,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontColor: colorScheme.onSurface,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          SizedBox(
            height: 90.h,
            width: 160.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    stream.thumbnailUrl ?? Dummy.live1,
                    height: 100.h,
                    width: 160.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Image.network(Dummy.live1, height: 100.h, width: 160.w, fit: BoxFit.cover),
                  ),
                ),
                // Play overlay (only when a replay is available)
                if (hasReplay)
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.play_arrow, color: Colors.white, size: 24.sp),
                  ),
                // Status badge: REPLAY when ready, PROCESSING while rendering
                if (hasReplay || isProcessing)
                  Positioned(
                    top: 5.h,
                    left: 5.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: CustomText(
                        text: hasReplay ? 'REPLAY' : 'PROCESSING',
                        fontSize: 9.sp,
                        fontColor: hasReplay ? colorScheme.primary : colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                // Duration badge
                if (_durationText != null)
                  Positioned(
                    bottom: 5.h,
                    right: 5.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: CustomText(text: _durationText!, fontSize: 9.sp, fontColor: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: stream.title,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontColor: colorScheme.onSurface,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            text: _formatViewers(stream.totalViewers),
            fontSize: 11.sp,
            fontColor: colorScheme.outline,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  String? get _durationText {
    final secs = stream.recordingDurationSeconds;
    if (secs == null || secs <= 0) return null;
    final h = secs ~/ 3600;
    final m = (secs % 3600) ~/ 60;
    final s = secs % 60;
    if (h > 0) return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String _formatViewers(int count) {
    final label = count == 1 ? 'view' : 'views';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k $label';
    return '$count $label';
  }
}
