import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/data/models/message/message_model.dart';
import '../components/message_tile.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({super.key});

  final RxList<MessageModel> messages = <MessageModel>[
    MessageModel(message: "Hello !", isMe: false),
    MessageModel(message: "How Much?", isMe: true),
    MessageModel(message: "This product is original £25", isMe: false),
  ].obs;

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        leading: BackButton(color: colorScheme.onSurface),
        title: Text('Lucy', style: TextStyle(color: colorScheme.onSurface)),
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
                () => ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) => MessageTile(
                    message: messages[index].message,
                    isMe: messages[index].isMe,
                    imageUrl: Dummy.user1,
                  ),
                ),
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
                        controller: messageController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Your message...',
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
                        onPressed: () {
                          if( messageController.text.trim().isEmpty ) return;
                          messages.add(MessageModel(message: messageController.text.trim(), isMe: true),);
                        },
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
