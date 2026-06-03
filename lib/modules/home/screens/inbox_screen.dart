import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/modules/home/components/inbox_item.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import '../../../core/utils/app_constants.dart';

class InboxScreen extends StatelessWidget {
  final RxInt selectedTabIndex = 0.obs; // Unified index logic

  InboxScreen({super.key});

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
      body: Column(
        children: [
          // Simplified tab/filter row
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (c, i) => InboxItem(
                imageUrl: Dummy.user1,
                name: "Hazrat Ali",
                lastMessage: "Hello",
                time: "Today",
                unreadCount: "2",
                onTap: (){
                  Get.toNamed(AppRoutes.messageScreen);
                },
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: colorScheme.primary,
      //   onPressed: () {},
      //   label: CustomText(text: "Compose", fontColor: colorScheme.onPrimary),
      //   icon: Icon(Icons.edit, color: colorScheme.onPrimary),
      // ),
    );
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
