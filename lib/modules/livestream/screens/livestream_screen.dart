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
import 'package:musaab_adam/modules/livestream/components/reactions_overlay.dart';
import 'package:musaab_adam/core/services/socket_service.dart';
import 'package:musaab_adam/modules/livestream/controllers/livestream_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/assets_gen/assets.gen.dart';

class LiveStreamScreen extends StatelessWidget {
  LiveStreamScreen({Key? key}) : super(key: key);

  final RxBool isFullScreen = false.obs;
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<ReactionsOverlayState> _reactionsKey = GlobalKey<ReactionsOverlayState>();
  final RxString _mentionQuery = ''.obs;

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
        // Host publishes camera + mic; viewers only watch, so their tracks must
        // be explicitly disabled. The default CallConnectOptions() resolves
        // tracks from call settings, which makes a viewer try to acquire the
        // microphone on a livestream call — and with no RECORD_AUDIO runtime
        // permission that crashes the native WebRTC audio engine.
        final connectOpts = lsCtrl.isHost
            ? CallConnectOptions(
                camera: TrackOption.enabled(),
                microphone: TrackOption.enabled(),
              )
            : CallConnectOptions(
                camera: TrackOption.disabled(),
                microphone: TrackOption.disabled(),
              );

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

                // Floating emoji reactions (above video, below controls)
                Positioned.fill(
                  child: ReactionsOverlay(
                    key: _reactionsKey,
                    streamId: lsCtrl.stream?.id ?? '',
                  ),
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
                        if (lsCtrl.activeGiveaway.value != null) _giveawayBanner(lsCtrl),
                        if (lsCtrl.isHost) _hostGiveawayControl(lsCtrl),
                        if (lsCtrl.auctionState.value == 'paused') _pausedBanner(),
                        if (lsCtrl.isHost) _hostAuctionControls(lsCtrl),
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
                onTap: () {
                  final sellerId = lsCtrl.joinResult.value?.stream.sellerId;
                  if (sellerId != null) {
                    Get.toNamed(AppRoutes.otherUserProfileScreen, arguments: sellerId);
                  }
                },
                child: CachedImageWidget(
                  imageUrl: lsCtrl.sellerAvatarUrl ?? Dummy.user1,
                  height: 40,
                  width: 40,
                  borderRadius: 50,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  final sellerId = lsCtrl.joinResult.value?.stream.sellerId;
                  if (sellerId != null) {
                    Get.toNamed(AppRoutes.otherUserProfileScreen, arguments: sellerId);
                  }
                },
                child: Text(
                  lsCtrl.sellerName.isNotEmpty ? lsCtrl.sellerName : 'Live Stream',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                  ),
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
              if (!lsCtrl.isHost) ...[
                const SizedBoxWidget(width: 10),
                CustomButton(
                  label: lsCtrl.isFollowingSeller.value ? 'Following' : AppStrings.follow,
                  buttonHeight: 30,
                  onPressed: lsCtrl.toggleFollowSeller,
                ),
              ],
            ],
          ),
        ],
      ),
    ));
  }

  // ── Comment section ─────────────────────────────────────────────────────────
  Widget _commentSection() {
    final lsCtrl = Get.find<LivestreamController>();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pinned message banner (visible to everyone)
          Obx(() {
            final pinned = lsCtrl.pinnedMessage;
            if (pinned == null) return const SizedBox.shrink();
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.cyan.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.push_pin, size: 14, color: Colors.white),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${(pinned['sender']?['displayName'] ?? '')}: ${pinned['text'] ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (lsCtrl.canModerate)
                    GestureDetector(
                      onTap: lsCtrl.unpinChatMessage,
                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                    ),
                ],
              ),
            );
          }),
          SizedBox(
            height: 260.h,
            child: Obx(() {
              final msgs = lsCtrl.messages;
              return SingleChildScrollView(
                reverse: true,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final m in msgs)
                        GestureDetector(
                          onTap: () => lsCtrl.startReply(m),
                          onLongPress: lsCtrl.canModerate ? () => _showModMenu(lsCtrl, m.id, m.senderId, m.senderName) : null,
                          child: CommentItem(
                            user: m.senderName,
                            comment: m.replyTo != null ? '↳ @${m.replyTo!.senderName}  ${m.text}' : m.text,
                            isMod: m.type == 'system',
                            avatarUrl: m.senderAvatarUrl,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Comment input ───────────────────────────────────────────────────────────
  Widget _writeCommentSection() {
    final lsCtrl = Get.find<LivestreamController>();

    void send() {
      final text = _commentController.text;
      if (text.trim().isEmpty) return;
      lsCtrl.sendComment(text);
      _commentController.clear();
      _mentionQuery.value = '';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mention autocomplete picker
        Obx(() {
          final query = _mentionQuery.value;
          if (query.isEmpty) return const SizedBox.shrink();

          final usernames = <String>{};
          if (lsCtrl.sellerName.isNotEmpty) {
            usernames.add(lsCtrl.sellerName);
          }
          for (final m in lsCtrl.messages) {
            if (m.senderName.isNotEmpty) {
              usernames.add(m.senderName);
            }
          }

          final matches = usernames
              .where((name) => name.toLowerCase().contains(query.toLowerCase()))
              .toList();

          if (matches.isEmpty) return const SizedBox.shrink();

          return Container(
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
            padding: const EdgeInsets.symmetric(vertical: 4),
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyan.withValues(alpha: 0.5)),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final name = matches[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    backgroundColor: Colors.cyan.withValues(alpha: 0.3),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    label: Text(
                      '@$name',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _selectMention(name),
                  ),
                );
              },
            ),
          );
        }),
        // Reply banner
        Obx(() {
          final r = lsCtrl.replyingTo.value;
          if (r == null) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.reply, size: 14, color: Colors.cyan),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('Replying to ${r.senderName}: ${r.text}',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ),
                GestureDetector(onTap: lsCtrl.cancelReply, child: const Icon(Icons.close, size: 14, color: Colors.white70)),
              ],
            ),
          );
        }),
        Padding(
      padding: const EdgeInsets.only(right: 12.0, bottom: 12),
      child: Row(
        spacing: 8,
        children: [
          if (lsCtrl.canModerate)
            GestureDetector(
              onTap: () => _showSlowModeMenu(lsCtrl),
              child: const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(Icons.slow_motion_video, color: Colors.white),
              ),
            ),
          Expanded(
            child: TextField(
              controller: _commentController,
              onChanged: (val) {
                final query = _getMentionQuery(val, _commentController.selection.start);
                _mentionQuery.value = query ?? '';
              },
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => send(),
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
          GestureDetector(
            onTap: send,
            child: Transform.rotate(
              angle: -pi / 4,
              child: const CircleAvatar(
                backgroundColor: Colors.cyan,
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
        ),
      ],
    );
  }

  // Host slow-mode picker.
  void _showSlowModeMenu(LivestreamController lsCtrl) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final s in [0, 3, 5, 10, 30])
                ListTile(
                  leading: const Icon(Icons.slow_motion_video),
                  title: Text(s == 0 ? 'Slow mode off' : 'Slow mode: ${s}s'),
                  onTap: () {
                    Get.back();
                    lsCtrl.setSlowMode(s);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Moderator action sheet for a chat message (long-press).
  void _showModMenu(LivestreamController lsCtrl, String messageId, String senderId, String senderName) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.push_pin),
                title: const Text('Pin message'),
                onTap: () {
                  Get.back();
                  lsCtrl.pinChatMessage(messageId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete message'),
                onTap: () {
                  Get.back();
                  SocketService.instance.deleteMessage(messageId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: Text('Ban $senderName', style: const TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  lsCtrl.banViewer(senderId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Active giveaway banner — viewers join, host draws.
  Widget _giveawayBanner(LivestreamController lsCtrl) {
    final g = lsCtrl.activeGiveaway.value!;
    return Container(
      width: double.infinity,
      color: Colors.purple.withValues(alpha: 0.9),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Text('🎁 ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              '${g['title']}  ·  ${g['entryCount'] ?? 0} entries',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!lsCtrl.isHost)
            ElevatedButton(
              onPressed: lsCtrl.giveawayJoined.value || lsCtrl.isGiveawayBusy.value ? null : lsCtrl.joinGiveaway,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.purple),
              child: Text(lsCtrl.giveawayJoined.value ? 'Joined' : 'Join'),
            ),
        ],
      ),
    );
  }

  // Host giveaway controls: create one, or draw the winner of the active one.
  Widget _hostGiveawayControl(LivestreamController lsCtrl) {
    final hasActive = lsCtrl.activeGiveaway.value != null;
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: lsCtrl.isGiveawayBusy.value
                  ? null
                  : (hasActive ? lsCtrl.hostDrawGiveaway : () => _showCreateGiveaway(lsCtrl)),
              icon: Icon(hasActive ? Icons.casino : Icons.card_giftcard, size: 16),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
              label: Text(hasActive ? 'Draw winner' : 'Start giveaway', style: const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateGiveaway(LivestreamController lsCtrl) {
    final titleCtrl = TextEditingController(text: lsCtrl.pinnedProduct.value?.title ?? 'Giveaway');
    final restriction = 'everyone'.obs;
    Get.dialog(
      AlertDialog(
        title: const Text('Start giveaway'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Prize / title')),
            const SizedBox(height: 8),
            Obx(() => DropdownButton<String>(
                  value: restriction.value,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'everyone', child: Text('Everyone')),
                    DropdownMenuItem(value: 'followers', child: Text('Followers only')),
                    DropdownMenuItem(value: 'buyers', child: Text('Buyers only')),
                  ],
                  onChanged: (v) => restriction.value = v ?? 'everyone',
                )),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              lsCtrl.hostCreateGiveaway(titleCtrl.text.trim(), restriction.value);
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  // Viewer-facing banner shown while the seller has paused the auction.
  Widget _pausedBanner() {
    return Container(
      width: double.infinity,
      color: Colors.orange.withValues(alpha: 0.9),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: const Text(
        'Auction paused',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Host-only auction controls: start a round, or pause/resume/cancel it.
  Widget _hostAuctionControls(LivestreamController lsCtrl) {
    Widget btn(String label, Color color, VoidCallback onTap) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: ElevatedButton(
              onPressed: lsCtrl.isAuctionBusy.value ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        );

    final state = lsCtrl.auctionState.value;
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          if (state == 'none') btn('Start auction', Colors.green, () => lsCtrl.startAuctionRound()),
          if (state == 'running') ...[
            btn('Pause', Colors.orange, lsCtrl.pauseAuction),
            btn('End now', Colors.blueGrey, lsCtrl.cancelAuction),
          ],
          if (state == 'paused') ...[
            btn('Resume', Colors.green, lsCtrl.resumeAuction),
            btn('Cancel', Colors.red, lsCtrl.cancelAuction),
          ],
        ],
      ),
    );
  }

  // Emoji reaction button: instantly shows a local floating emoji and
  // broadcasts it to the room via the socket.
  Widget _reactionButton(String emoji) {
    return GestureDetector(
      onTap: () {
        _reactionsKey.currentState?.spawn(emoji);
        Get.find<LivestreamController>().sendReaction(emoji);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 22)),
      ),
    );
  }

  // ── Right-side action buttons ────────────────────────────────────────────────
  Widget _rightSideButtons(BuildContext context) {
    final lsCtrl = Get.find<LivestreamController>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, right: 12.0),
      child: SingleChildScrollView(
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _reactionButton('❤️'),
            if (lsCtrl.isHost) ...[
              Obx(() => GestureDetector(
                    onTap: lsCtrl.toggleCamera,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.cyan,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            lsCtrl.isCameraEnabled.value ? Icons.videocam : Icons.videocam_off,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Camera',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
              Obx(() => GestureDetector(
                    onTap: lsCtrl.toggleMic,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.cyan,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            lsCtrl.isMicEnabled.value ? Icons.mic : Icons.mic_off,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Mic',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
            ],
            LabeledIconButton(
              iconPath: Assets.icons.more,
              text: AppStrings.more,
              fontColor: Colors.white,
              onClick: () => showOptionsDialog(context, streamId: Get.find<LivestreamController>().stream?.id),
            ),
            LabeledIconButton(
              iconPath: Assets.icons.boost,
              text: AppStrings.boost,
              fontColor: Colors.white,
              onClick: () {
                final ctrl = Get.find<LivestreamController>();
                Get.toNamed(
                  AppRoutes.boostScreen,
                  arguments: {
                    'streamId': ctrl.stream?.id,
                    'sellerId': ctrl.stream?.sellerId,
                  },
                );
              },
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

  String? _getMentionQuery(String text, int selectionStart) {
    if (selectionStart <= 0) return null;
    final textBeforeCursor = text.substring(0, selectionStart);
    final lastAt = textBeforeCursor.lastIndexOf('@');
    if (lastAt == -1) return null;
    final part = textBeforeCursor.substring(lastAt);
    if (part.contains(' ')) return null;
    return part.substring(1);
  }

  void _selectMention(String username) {
    final text = _commentController.text;
    final selection = _commentController.selection;
    if (selection.start <= 0) return;
    final textBeforeCursor = text.substring(0, selection.start);
    final lastAt = textBeforeCursor.lastIndexOf('@');
    if (lastAt == -1) return;
    final newText = text.replaceRange(lastAt, selection.start, '@$username ');
    _commentController.text = newText;
    _commentController.selection = TextSelection.fromPosition(
      TextPosition(offset: lastAt + username.length + 2),
    );
    _mentionQuery.value = '';
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
