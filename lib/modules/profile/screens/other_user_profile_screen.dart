import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/text_button_widget.dart';
import 'package:musaab_adam/modules/profile/components/snaps_tab.dart';
import 'package:musaab_adam/modules/profile/components/review_tab.dart';
import 'package:musaab_adam/core/services/api_report_service.dart';
import 'package:musaab_adam/modules/profile/components/shop_tab.dart';
import 'package:musaab_adam/modules/profile/controllers/other_user_profile_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

class OtherUserProfileScreen extends StatelessWidget {
  final String userId;
  OtherUserProfileScreen({super.key, required this.userId});

  OtherUserProfileController get _controller =>
      Get.find<OtherUserProfileController>(tag: userId);

  final RxInt _tabIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.screen_share_outlined, color: colorScheme.primary),
          ),
          Obx(() {
            final isBlocked = _controller.isBlockedByMe.value; // Access Rx variable inside builder
            return PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'block') _controller.blockThisUser();
                if (value == 'unblock') _controller.unblockThisUser();
                if (value == 'report') {
                  ApiReportService.showReportSheet(targetType: 'user', targetId: userId);
                }
              },
              itemBuilder: (_) => [
                if (!isBlocked)
                  const PopupMenuItem(value: 'block', child: Text('Block user'))
                else
                  const PopupMenuItem(value: 'unblock', child: Text('Unblock user')),
                const PopupMenuItem(value: 'report', child: Text('Report user')),
              ],
            );
          }),
        ],
      ),
      floatingActionButton: Obx(() {
        final isShopTab = _tabIndex.value == 0;
        final currentUser = Get.find<AuthController>().currentUser.value;
        final isOwner = currentUser != null && currentUser.id == userId;
        if (isOwner && isShopTab) {
          return FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.createQualityListingScreen),
            backgroundColor: colorScheme.primary,
            elevation: 4,
            shape: const CircleBorder(),
            child: Icon(Icons.add, color: Colors.white, size: 28.sp),
          );
        }
        return const SizedBox.shrink();
      }),
      body: Obx(() {

        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: colorScheme.primary));
        }

        final profile = _controller.profile.value;
        if (profile == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedImageWidget(
                    imageUrl: profile.avatarUrl ?? Dummy.user1,
                    height: 60.h,
                    width: 60.w,
                  ),
                ),
                SizedBox(height: 12.h),
                CustomText(
                  text: profile.displayNameOrUsername,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontColor: colorScheme.onSurface,
                ),
                SizedBox(height: 20.h),

                // Stats
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() => _buildStatColumn(
                        _controller.sellerRating.value.toStringAsFixed(1),
                        'Ratings',
                        colorScheme,
                        icon: Icons.star,
                      )),

                      _buildVerticalDivider(colorScheme),
                      Obx(() => _buildStatColumn(
                        OtherUserProfileController.formatCount(_controller.followersCount.value),
                        'Follower',
                        colorScheme,
                      )),
                      _buildVerticalDivider(colorScheme),
                      _buildStatColumn(
                        OtherUserProfileController.formatCount(profile.followingCount),
                        'Following',
                        colorScheme,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Action buttons
                Obx(() => Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: AppStrings.message,
                        textColor: Colors.white,
                        backgroundColor: Colors.orange,
                        buttonHeight: 40,
                        fontSize: 14,
                        onPressed: () => Get.toNamed(AppRoutes.messageScreen, arguments: {
                          'id': profile.id,
                          'name': profile.displayNameOrUsername,
                          'avatar': profile.avatarUrl,
                        }),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: CustomButton(
                        label: _controller.isBlockedByMe.value
                            ? 'Unblock'
                            : (_controller.isFollowing.value ? 'Unfollow' : AppStrings.follow),
                        textColor: Colors.white,
                        backgroundColor: colorScheme.primary,
                        buttonHeight: 40,
                        fontSize: 14,
                        isLoading: _controller.actionLoading.value,
                        onPressed: _controller.isBlockedByMe.value
                            ? _controller.unblockThisUser
                            : _controller.toggleFollow,
                      ),
                    ),
                  ],
                )),
                SizedBox(height: 20.h),

                // Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTab(AppStrings.shop.tr, 0, colorScheme),
                    _buildTab(AppStrings.shows.tr, 1, colorScheme),
                    _buildTab(AppStrings.reviews.tr, 2, colorScheme),
                    _buildTab(AppStrings.snaps.tr, 3, colorScheme),
                  ],
                ),
                SizedBox(height: 20.h),

                Obx(() => IndexedStack(
                  index: _tabIndex.value,
                  children: [ShopTab(sellerId: userId), _buildShowsSection(colorScheme), ReviewTab(sellerId: userId), const SnapsTab()],
                )),

                SizedBoxWidget(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Shows tab for the VIEWED seller (upcoming + previous), from the profile controller.
  Widget _buildShowsSection(ColorScheme colorScheme) {
    return Obx(() {
      if (_controller.showsLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      final upcoming = _controller.upcomingShows;
      final previous = _controller.previousShows;
      if (upcoming.isEmpty && previous.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 30.h),
          child: Center(child: CustomText(text: 'No shows yet', fontColor: colorScheme.outline)),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (upcoming.isNotEmpty) ...[
            SizedBoxWidget(height: 12.h),
            CustomText(text: 'Upcoming', fontWeight: FontWeight.w700, textAlignment: TextAlign.start),
            ...upcoming.map((s) => _showRow(s, colorScheme)),
          ],
          if (previous.isNotEmpty) ...[
            SizedBoxWidget(height: 12.h),
            CustomText(text: 'Previous', fontWeight: FontWeight.w700, textAlignment: TextAlign.start),
            ...previous.map((s) => _showRow(s, colorScheme)),
          ],
        ],
      );
    });
  }

  Widget _showRow(dynamic show, ColorScheme colorScheme) {
    final isLive = show.status == 'live';
    return GestureDetector(
      onTap: isLive ? () => Get.toNamed(AppRoutes.livestreamScreen, arguments: show.id) : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedImageWidget(
                imageUrl: show.thumbnailUrl ?? Dummy.live1,
                height: 56.h,
                width: 56.w,
              ),
            ),
            SizedBoxWidget(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: show.title ?? 'Show', fontWeight: FontWeight.w600, textAlignment: TextAlign.start, maxLines: 1),
                  CustomText(text: show.status ?? '', fontSize: 12, fontColor: colorScheme.outline, textAlignment: TextAlign.start),
                ],
              ),
            ),
            if (isLive)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6.r)),
                child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, ColorScheme colorScheme, {IconData? icon}) {
    return Column(
      children: [
        Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.orangeAccent, size: 16),
            if (icon != null) SizedBox(width: 4.w),
            CustomText(text: value, fontColor: colorScheme.onPrimary),
          ],
        ),
        CustomText(
          text: label,
          fontSize: 14,
          fontColor: colorScheme.onPrimary.withValues(alpha: 0.9),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(ColorScheme colorScheme) {
    return SizedBox(
      height: 60,
      child: VerticalDivider(
        color: colorScheme.onPrimary.withValues(alpha: 0.5),
        thickness: 2,
      ),
    );
  }

  Widget _buildTab(String title, int index, ColorScheme colorScheme) {
    return Obx(() {
      final isSelected = _tabIndex.value == index;
      return TextButtonWidget(
        text: title,
        textColor: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
        fontSize: 14,
        decoration: isSelected ? TextDecoration.underline : null,
        decorationColor: colorScheme.primary,
        fontWeight: FontWeight.w600,
        onPressed: () => _tabIndex.value = index,
      );
    });
  }
}
