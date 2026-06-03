import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

class InboxItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String lastMessage;
  final String time;
  final String unreadCount;
  final VoidCallback? onTap;

  const InboxItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        height: 90.h,
        decoration: BoxDecoration(
          // Use surfaceContainer for items to differentiate from main background
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: CachedImageWidget(
                    width: 45.w,
                    height: 45.h,
                    imageUrl: imageUrl,
                  ),
                ),
                title: CustomText(
                  text: name,
                  translate: false,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  textAlignment: TextAlign.start,
                  fontColor: colorScheme.onSurface,
                ),
                subtitle: CustomText(
                  text: lastMessage,
                  translate: false,
                  fontSize: 14.sp,
                  textAlignment: TextAlign.start,
                  fontColor: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (unreadCount != "0" && unreadCount.isNotEmpty)
                  CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    radius: 10.r,
                    child: CustomText(
                      translate: false,
                      text: unreadCount,
                      fontColor: colorScheme.onPrimary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  SizedBox(height: 20.h),
                SizedBox(height: 5.h),
                CustomText(
                  translate: false,
                  text: time,
                  fontSize: 12.sp,
                  fontColor: colorScheme.onSurface.withValues(alpha: 0.5),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}