import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final RxBool isAllEnabled = false.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: const BackButton(),
        title: CustomText(text: "Notifications", fontWeight: FontWeight.w600, fontSize: 20.sp),
        actions: [IconButton(onPressed: () => Get.toNamed(AppRoutes.notificationSettingsScreen), icon: const Icon(Icons.settings_outlined))],
      ),
      body: ListView.builder(itemCount: 7, itemBuilder: (context, index) => _notificationTile(theme)),
    );
  }

  Widget _notificationTile(ThemeData theme) => Container(
    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2)))),
    child: ListTile(
      leading: CachedImageWidget(imageUrl: Dummy.user2, borderRadius: 50, height: 35, width: 35,),
      title: CustomText(text: "Ronaldo liked your post", translate: false, fontColor: theme.colorScheme.onSurface),
      trailing: CustomText(text: "2h ago", translate: false, fontSize: 12.sp),
    ),
  );
}