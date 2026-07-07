import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/modules/home/components/inbox_item.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import '../../../core/utils/app_constants.dart';

import 'package:intl/intl.dart';
import 'package:musaab_adam/modules/home/controllers/inbox_controller.dart';

class InboxScreen extends StatelessWidget {
  InboxScreen({super.key});

  final _controller = Get.put(InboxController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomText(
          text: "Inbox",
          fontColor: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: _showMenuDialog,
            icon: Icon(Icons.menu, color: colorScheme.onSurface),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _controller.loadConversations,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value && _controller.conversations.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_controller.conversations.isEmpty) {
                  return const Center(child: CustomText(text: 'No conversations yet'));
                }
                return ListView.builder(
                  itemCount: _controller.conversations.length,
                  itemBuilder: (c, i) {
                    final conv = _controller.conversations[i];
                    return InboxItem(
                      imageUrl: conv.partnerAvatar ?? Dummy.user1,
                      name: conv.partnerName,
                      lastMessage: conv.lastMessage,
                      time: _formatTime(conv.lastMessageTime),
                      unreadCount: conv.unreadCount.toString(),
                      onTap: () async {
                        await Get.toNamed(AppRoutes.messageScreen, arguments: {
                          'id': conv.partnerId,
                          'name': conv.partnerName,
                          'avatar': conv.partnerAvatar,
                        });
                        _controller.loadConversations();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: colorScheme.primary,
      //   onPressed: () {},
      //   label: CustomText(text: "Compose", fontColor: colorScheme.onPrimary),
      //   icon: Icon(Icons.edit, color: colorScheme.onPrimary),
      // ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) {
      return DateFormat('jm').format(dt);
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return DateFormat('EEEE').format(dt);
    } else {
      return DateFormat('yMMMd').format(dt);
    }
  }

  void _showMenuDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.colorScheme.surfaceContainer,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Message Requests"),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.messageRequestScreen);
              },
            ),
            ListTile(
              title: Text("Archive"),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.archiveScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
