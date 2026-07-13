import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:musaab_adam/core/assets_gen/assets.gen.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/svg_icon.dart';
import '../controllers/rehearsal_controller.dart';

class RehearsalScreen extends GetView<RehearsalController> {
  const RehearsalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        // ── Loading ──────────────────────────────────────────────────────────
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Setting up rehearsal...',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }

        // ── Error ────────────────────────────────────────────────────────────
        if (controller.hasError.value) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(32.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.white54, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: controller.retry,
                    child: const Text('Retry'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: Get.back,
                    child: const Text('Go Back', style: TextStyle(color: Colors.white54)),
                  ),
                ],
              ),
            ),
          );
        }

        final call = controller.call;
        if (call == null) return const SizedBox.shrink();

        // ── Live stream UI ───────────────────────────────────────────────────
        return StreamCallContainer(
          call: call,
          callConnectOptions: CallConnectOptions(
            camera: TrackOption.enabled(),
            microphone: TrackOption.enabled(),
          ),
          callContentWidgetBuilder: (context, call) {
            return Stack(
              children: [
                // ── Camera feed ─────────────────────────────────────────────
                _CameraBackground(call: call),

                // ── Overlay UI ──────────────────────────────────────────────
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Column(
                      children: [
                        _buildHeader(colorScheme, call),
                        const Spacer(),
                        _buildChatSection(colorScheme),
                        SizedBoxWidget(height: 10),
                        _buildBottomControls(colorScheme),
                      ],
                    ),
                  ),
                ),

                // ── Right sidebar ────────────────────────────────────────────
                Positioned(
                  right: 16.w,
                  top: 150.h,
                  child: _buildSidebar(colorScheme),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, Call call) {
    return Obx(() => Row(
      children: [
        IconButton(
          onPressed: controller.endRehearsal,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        CircleAvatar(
          radius: 18.r,
          backgroundImage: controller.sellerAvatarUrl.value.isNotEmpty
              ? NetworkImage(controller.sellerAvatarUrl.value)
              : null,
          backgroundColor: colorScheme.primary,
          child: controller.sellerAvatarUrl.value.isEmpty
              ? Text(
                  controller.sellerName.value.isNotEmpty
                      ? controller.sellerName.value[0].toUpperCase()
                      : 'S',
                  style: const TextStyle(color: Colors.white),
                )
              : null,
        ),
        SizedBox(width: 8.w),
        CustomText(
          text: controller.sellerName.value.isNotEmpty
              ? controller.sellerName.value
              : 'Seller',
          fontWeight: FontWeight.w700,
          fontColor: Colors.white,
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: CustomText(
            text: AppStrings.rehearsal,
            fontColor: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    ));
  }

  Widget _buildSidebar(ColorScheme colorScheme) {
    return Obx(() {
      final items = [
        {
          'icon': Assets.icons.more,
          'label': AppStrings.more,
          'onTap': () {},
        },
        {
          'icon': Assets.icons.boost,
          'label': AppStrings.promote,
          'onTap': () {},
        },
        {
          'icon': Assets.icons.snap,
          'label': AppStrings.snap,
          'onTap': () {},
        },
        {
          'icon': Assets.icons.share,
          'label': AppStrings.share,
          'onTap': () {},
        },
        {
          'icon': Assets.icons.camera,
          'label': controller.isCameraEnabled.value ? 'Cam On' : 'Cam Off',
          'onTap': controller.toggleCamera,
        },
        {
          'icon': Assets.icons.shop,
          'label': controller.isMicEnabled.value ? 'Mic On' : 'Mic Off',
          'onTap': controller.toggleMic,
        },
      ];

      return Column(
        children: items
            .map((item) => GestureDetector(
                  onTap: item['onTap'] as VoidCallback,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Column(
                      children: [
                        SvgIcon(
                          icon: item['icon'] as String,
                          height: 30,
                          width: 30,
                          color: Colors.white,
                        ),
                        CustomText(
                          text: item['label'] as String,
                          fontSize: 12,
                          fontColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      );
    });
  }

  Widget _buildChatSection(ColorScheme colorScheme) {
    return Row(
      children: [
        CircleAvatar(radius: 16.r, backgroundColor: colorScheme.primary),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: AppStrings.alice,
              fontWeight: FontWeight.w700,
              fontColor: Colors.white,
            ),
            CustomText(
              text: AppStrings.veryNice,
              fontColor: Colors.white70,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomControls(ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: AppStrings.saySomething,
              hintStyle: const TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
        ),
        SizedBoxWidget(height: 15.h),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: AppStrings.cancel,
                backgroundColor: colorScheme.surfaceContainerHighest,
                textColor: colorScheme.onSurface,
                buttonHeight: 45.h,
                onPressed: controller.endRehearsal,
              ),
            ),
            SizedBoxWidget(width: 15.w),
            Expanded(
              child: CustomButton(
                label: AppStrings.startAuction,
                backgroundColor: AppColors.orange,
                buttonHeight: 45.h,
                onPressed: controller.endRehearsal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Local camera background ───────────────────────────────────────────────────

class _CameraBackground extends StatelessWidget {
  const _CameraBackground({required this.call});

  final Call call;

  @override
  Widget build(BuildContext context) {
    return PartialCallStateBuilder(
      call: call,
      selector: (state) => state.localParticipant,
      builder: (context, localParticipant) {
        if (localParticipant == null) return Container(color: Colors.black);
        return StreamCallParticipant(
          call: call,
          participant: localParticipant,
          videoFit: VideoFit.cover,
          showSpeakerBorder: false,
          showConnectionQualityIndicator: false,
        );
      },
    );
  }
}
