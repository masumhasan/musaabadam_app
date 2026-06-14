import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/text_button_widget.dart';
import 'package:musaab_adam/modules/profile/components/clips_tab.dart';
import 'package:musaab_adam/modules/profile/components/review_tab.dart';
import 'package:musaab_adam/modules/profile/components/shop_tab.dart';
import 'package:musaab_adam/modules/profile/components/shows_tab.dart';
import 'package:musaab_adam/modules/profile/controllers/other_user_profile_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

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
          Obx(() => PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'block') _controller.blockThisUser();
              if (value == 'unblock') _controller.unblockThisUser();
            },
            itemBuilder: (_) => [
              if (!_controller.isBlockedByMe.value)
                const PopupMenuItem(value: 'block', child: Text('Block user'))
              else
                const PopupMenuItem(value: 'unblock', child: Text('Unblock user')),
            ],
          )),
        ],
      ),
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
              spacing: 20.h,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedImageWidget(
                    imageUrl: profile.avatarUrl ?? Dummy.user1,
                    height: 60.h,
                    width: 60.w,
                  ),
                ),
                CustomText(
                  text: profile.displayNameOrUsername,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontColor: colorScheme.onSurface,
                ),

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
                      _buildStatColumn(
                        profile.buyerRating.toStringAsFixed(1),
                        'Ratings',
                        colorScheme,
                        icon: Icons.star,
                      ),
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

                // Action buttons
                Obx(() => Row(
                  spacing: 20.w,
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: AppStrings.message,
                        textColor: Colors.white,
                        backgroundColor: Colors.orange,
                        buttonHeight: 40,
                        fontSize: 14,
                        onPressed: () => Get.toNamed(AppRoutes.messageScreen),
                      ),
                    ),
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

                // Tabs
                Row(
                  spacing: 15.w,
                  children: [
                    _buildTab(AppStrings.shop.tr, 0, colorScheme),
                    _buildTab(AppStrings.shows.tr, 1, colorScheme),
                    _buildTab(AppStrings.reviews.tr, 2, colorScheme),
                    _buildTab(AppStrings.clips.tr, 3, colorScheme),
                  ],
                ),

                Obx(() => IndexedStack(
                  index: _tabIndex.value,
                  children: [ShopTab(), ShowsTab(), ReviewTab(), ClipsTab()],
                )),

                SizedBoxWidget(height: 20),
              ],
            ),
          ),
        );
      }),
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
