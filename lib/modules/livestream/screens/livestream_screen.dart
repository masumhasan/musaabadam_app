import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide ApiClient;
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/labeled_iconbutton.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/svg_icon.dart';
import 'package:musaab_adam/modules/livestream/components/bidding_section.dart';
import 'package:musaab_adam/modules/livestream/components/comment_item.dart';
import 'package:musaab_adam/modules/livestream/components/livestream_dialogs.dart';
import 'package:musaab_adam/modules/livestream/controllers/livestream_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/assets_gen/assets.gen.dart';

class LiveStreamScreen extends StatelessWidget {
  LiveStreamScreen({Key? key}) : super(key: key);

  final RxBool isFullScreen = false.obs;

  @override
  Widget build(BuildContext context) {
    final lsCtrl = Get.find<LivestreamController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        // ── Loading ────────────────────────────────────────────────────────────
        if (lsCtrl.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text('Joining stream…', style: TextStyle(color: Colors.white70)),
              ],
            ),
          );
        }

        // ── Error / no call yet ────────────────────────────────────────────────
        if (lsCtrl.hasError.value || lsCtrl.call.value == null) {
          return _FallbackBackground(
            lsCtrl: lsCtrl,
            isFullScreen: isFullScreen,
          );
        }

        // ── Live video via GetStream ───────────────────────────────────────────
        // Host: enable camera + mic so the seller's webcam streams.
        // Viewer: default (camera disabled — they only watch).
        final connectOpts = lsCtrl.isHost
            ? CallConnectOptions(
                camera: TrackOption.enabled(),
                microphone: TrackOption.enabled(),
              )
            : const CallConnectOptions();

        return StreamCallContainer(
          call: lsCtrl.call.value!,
          callConnectOptions: connectOpts,
          callContentWidgetBuilder: (context, call) {
            return Stack(
              children: [
                // Live video feed fills the background
                Positioned.fill(
                  child: _VideoBackground(call: call, isHost: lsCtrl.isHost),
                ),

                // Full-screen exit button only
                Obx(() {
                  if (!isFullScreen.value) return const SizedBox.shrink();
                  return Positioned(
                    top: 40,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.fullscreen_exit, color: Colors.white, size: 30),
                      onPressed: () => isFullScreen.value = false,
                    ),
                  );
                }),

                // Main overlay UI
                Obx(() {
                  if (isFullScreen.value) return const SizedBox.shrink();
                  return SafeArea(
                    child: Column(
                      children: [
                        _headerSection(context, lsCtrl),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(child: _commentSection()),
                              _rightSideButtons(context),
                            ],
                          ),
                        ),
                        _writeCommentSection(),
                        BiddingSection(),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        );
      }),
    );
  }

  void _confirmEndStream(BuildContext context, LivestreamController lsCtrl) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End Stream?'),
        content: const Text('This will end the live stream for all viewers.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              lsCtrl.endStream();
            },
            child: const Text('End Stream', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _headerSection(BuildContext context, LivestreamController lsCtrl) {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  if (lsCtrl.isHost) {
                    _confirmEndStream(context, lsCtrl);
                  } else {
                    Get.back();
                  }
                },
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.storyScreen),
                child: CachedImageWidget(
                  imageUrl: lsCtrl.sellerAvatarUrl ?? Dummy.user1,
                  height: 40,
                  width: 40,
                  borderRadius: 50,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                lsCtrl.sellerName.isNotEmpty ? lsCtrl.sellerName : 'Live Stream',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
              ),
              const Spacer(),
              if (lsCtrl.isHost)
                IconButton(
                  icon: const Icon(Icons.stop_circle, color: Colors.red, size: 30),
                  tooltip: 'End Stream',
                  onPressed: () => _confirmEndStream(context, lsCtrl),
                ),
              IconButton(
                icon: const Icon(Icons.fullscreen, color: Colors.white, size: 30),
                onPressed: () => isFullScreen.value = !isFullScreen.value,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 48),
              SvgIcon(icon: Assets.icons.liveIcon),
              const SizedBox(width: 8),
              const Icon(Icons.visibility, color: AppColors.primaryColor, size: 16),
              const SizedBox(width: 4),
              Text(
                lsCtrl.viewerCountText,
                style: const TextStyle(color: AppColors.primaryColor, fontSize: 14),
              ),
              const SizedBoxWidget(width: 10),
              CustomButton(label: AppStrings.follow, buttonHeight: 30),
            ],
          ),
        ],
      ),
    ));
  }

  // ── Comment section ─────────────────────────────────────────────────────────
  Widget _commentSection() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: 300.h,
        child: SingleChildScrollView(
          reverse: true,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CommentItem(user: 'Lora', comment: 'Price?', isMod: false),
                CommentItem(user: 'Lora', comment: 'Price?', isMod: false),
                CommentItem(user: 'Lora', comment: 'Price?', isMod: false),
                CommentItem(user: 'David', comment: 'I want to buy', isMod: false),
                CommentItem(user: 'Alice', comment: 'Very nice', isMod: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Comment input ───────────────────────────────────────────────────────────
  Widget _writeCommentSection() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, bottom: 12),
      child: Row(
        spacing: 8,
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type comment........',
                hintStyle: const TextStyle(color: Colors.white60),
                fillColor: Colors.white.withValues(alpha: 0.2),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.cyan, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.cyan, width: 1.5),
                ),
              ),
            ),
          ),
          Transform.rotate(
            angle: -pi / 4,
            child: const CircleAvatar(
              backgroundColor: Colors.cyan,
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Right-side action buttons ────────────────────────────────────────────────
  Widget _rightSideButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, right: 12.0),
      child: SingleChildScrollView(
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LabeledIconButton(
              iconPath: Assets.icons.more,
              text: AppStrings.more,
              fontColor: Colors.white,
              onClick: () => showOptionsDialog(context),
            ),
            LabeledIconButton(
              iconPath: Assets.icons.boost,
              text: AppStrings.boost,
              fontColor: Colors.white,
              onClick: () => Get.toNamed(AppRoutes.boostScreen),
            ),
            LabeledIconButton(
              iconPath: Assets.icons.clip,
              text: AppStrings.clip,
              fontColor: Colors.white,
              onClick: () => showClipEditDialog(context: context),
            ),
            LabeledIconButton(
              iconPath: Assets.icons.share,
              text: AppStrings.share,
              fontColor: Colors.white,
              onClick: () async {
                await SharePlus.instance.share(
                  ShareParams(
                    title: 'Hey! Check this out.',
                    subject: 'Watch this live.',
                    text: 'https://www.something.com/',
                  ),
                );
              },
            ),
            LabeledIconButton(
              iconPath: Assets.icons.wallet,
              text: AppStrings.wallet,
              fontColor: Colors.white,
              onClick: () {},
            ),
            LabeledIconButton(
              iconPath: Assets.icons.shop,
              text: AppStrings.shop,
              fontColor: Colors.white,
              onClick: () {},
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Live video background ─────────────────────────────────────────────────────
// Host sees their own camera; viewers see the seller's remote video.
class _VideoBackground extends StatelessWidget {
  final Call call;
  final bool isHost;
  const _VideoBackground({required this.call, required this.isHost});

  @override
  Widget build(BuildContext context) {
    if (isHost) {
      return PartialCallStateBuilder<CallParticipantState?>(
        call: call,
        selector: (state) => state.localParticipant,
        builder: (context, localParticipant) {
          if (localParticipant == null) {
            return Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white54),
                    SizedBox(height: 12),
                    Text('Starting camera…', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
            );
          }
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

    // Viewer: show the host's video (first other participant)
    return PartialCallStateBuilder<CallParticipantState?>(
      call: call,
      selector: (state) {
        final others = state.otherParticipants;
        return others.isEmpty ? null : others.first;
      },
      builder: (context, remoteParticipant) {
        if (remoteParticipant == null) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white54),
                  SizedBox(height: 12),
                  Text('Waiting for host…', style: TextStyle(color: Colors.white54)),
                ],
              ),
            ),
          );
        }
        return StreamCallParticipant(
          call: call,
          participant: remoteParticipant,
          videoFit: VideoFit.cover,
          showSpeakerBorder: false,
          showConnectionQualityIndicator: false,
        );
      },
    );
  }
}

// ── Fallback when call hasn't joined yet (error state) ───────────────────────
class _FallbackBackground extends StatelessWidget {
  final LivestreamController lsCtrl;
  final RxBool isFullScreen;
  const _FallbackBackground({required this.lsCtrl, required this.isFullScreen});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            lsCtrl.thumbnailUrl ?? Dummy.live1,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.network(Dummy.live1, fit: BoxFit.cover),
          ),
        ),
        if (lsCtrl.hasError.value)
          const Center(
            child: Text(
              'Could not connect to stream.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
      ],
    );
  }
}
