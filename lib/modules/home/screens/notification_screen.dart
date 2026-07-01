import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/data/models/notification/notification_model.dart';
import 'package:musaab_adam/modules/notifications/controllers/notification_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController _controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _controller.load(refresh: true);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: const BackButton(),
        title: CustomText(text: "Notifications", fontWeight: FontWeight.w600, fontSize: 20.sp),
        actions: [
          Obx(() => _controller.unreadCount.value > 0
              ? TextButton(onPressed: _controller.markAllRead, child: const Text('Mark all read'))
              : const SizedBox.shrink()),
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.notificationSettingsScreen),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.items.isEmpty) {
          return Center(
            child: CustomText(text: 'No notifications yet', fontColor: theme.colorScheme.outline),
          );
        }
        return RefreshIndicator(
          onRefresh: () => _controller.load(refresh: true),
          child: ListView.builder(
            itemCount: _controller.items.length,
            itemBuilder: (context, index) => _tile(theme, _controller.items[index]),
          ),
        );
      }),
    );
  }

  Widget _tile(ThemeData theme, NotificationModel n) {
    return InkWell(
      onTap: () {
        _controller.markRead(n);
        _navigate(n);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        color: n.isRead ? null : theme.colorScheme.primaryContainer.withValues(alpha: 0.18),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageWidget(
              imageUrl: (n.actorAvatarUrl?.isNotEmpty ?? false) ? n.actorAvatarUrl! : Dummy.user2,
              borderRadius: 50,
              height: 38,
              width: 38,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: n.title,
                    translate: false,
                    fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700,
                    fontColor: theme.colorScheme.onSurface,
                    textAlignment: TextAlign.start,
                  ),
                  if ((n.body ?? '').isNotEmpty)
                    CustomText(
                      text: n.body!,
                      translate: false,
                      fontSize: 13,
                      fontColor: theme.colorScheme.outline,
                      textAlignment: TextAlign.start,
                      maxLines: 3,
                    ),
                ],
              ),
            ),
            if (!n.isRead)
              Container(
                margin: EdgeInsets.only(top: 6.h, left: 6.w),
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }

  void _navigate(NotificationModel n) {
    if (n.orderId != null) {
      Get.toNamed(AppRoutes.orderTrackingScreen, arguments: n.orderId);
    } else if (n.streamId != null && n.type == 'live_started') {
      Get.toNamed(AppRoutes.livestreamScreen, arguments: n.streamId);
    }
  }
}
