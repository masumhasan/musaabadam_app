import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import '../assets_gen/assets.gen.dart';

class LivestreamGridItem extends StatelessWidget {
  final String userName;
  final String userAvatarUrl;
  final String thumbnailUrl;
  final String viewerCount;
  final String streamTitle;
  final String category;
  final VoidCallback? onTap;

  const LivestreamGridItem({
    super.key,
    required this.userName,
    required this.userAvatarUrl,
    required this.thumbnailUrl,
    required this.viewerCount,
    required this.streamTitle,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          // 1. User Header
          Row(
            children:[
              ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: CachedImageWidget(
                  height: 25.h,
                  width: 25.w,
                  iconSize: 20,
                  imageUrl: userAvatarUrl,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: CustomText(
                  text: userName,
                  textAlignment: TextAlign.left,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontColor: colorScheme.onSurface,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),

          // 2. Thumbnail with Overlays
          SizedBoxWidget(
            height: 90.h,
            width: 160.w,
            child: Stack(
              children:[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    thumbnailUrl,
                    height: 100.h,
                    width: 160.w,
                    fit: BoxFit.cover,
                  ),
                ),
                // Viewer Count Overlay
                Positioned(
                  top: 5.h,
                  left: 5.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      children:[
                        Icon(Icons.visibility, size: 12.sp, color: colorScheme.primary),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: viewerCount,
                          fontSize: 10.sp,
                          fontColor: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
                // Live Badge Overlay (Bottom Right)
                Positioned(
                  bottom: 20.h,
                  right: 20.w,
                  child: SvgPicture.asset(Assets.icons.liveIcon),
                ),
              ],
            ),
          ),
          // 3. Stream Details
          SizedBox(height: 4.h),
          CustomText(
            text: streamTitle,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontColor: colorScheme.onSurface,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          CustomText(
            text: category,
            fontSize: 11.sp,
            fontColor: colorScheme.outline,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}