import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import '../../../core/utils/app_constants.dart';
import '../components/inbox_item.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: theme.colorScheme.onSurface),
        centerTitle: true,
        title: CustomText(
          text: AppStrings.archive,
          fontColor: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return InboxItem(
              imageUrl: Dummy.user1,
              name: "Hazrat Ali",
              lastMessage: "Please send us carefully",
              time: "Today",
              unreadCount: "2",
              onTap: () => Get.toNamed(AppRoutes.messageScreen),
            );
          }),
    );
  }
}