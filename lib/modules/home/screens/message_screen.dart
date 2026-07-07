import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/modules/home/controllers/message_controller.dart';
import '../components/message_tile.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({super.key});

  final _controller = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        leading: BackButton(color: colorScheme.onSurface),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedImageWidget(
                imageUrl: _controller.partnerAvatar ?? Dummy.user1,
                height: 35.h,
                width: 35.w,
              ),
            ),
            SizedBox(width: 8.w),
            Text(_controller.partnerName, style: TextStyle(color: colorScheme.onSurface, fontSize: 18.sp)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  if (_controller.isLoading.value && _controller.messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: _controller.messages.length,
                    itemBuilder: (context, index) {
                      final msg = _controller.messages[index];
                      return MessageTile(
                        message: msg.text,
                        isMe: msg.isMe,
                        imageUrl: msg.isMe ? Dummy.user2 : (_controller.partnerAvatar ?? Dummy.user1),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.primary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _controller.textCtrl,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Your message...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    child: Transform.rotate(
                      angle: -pi / 4,
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                        onPressed: _controller.sendMsg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
