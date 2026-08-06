import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';
import 'package:musaab_adam/modules/profile/components/snaps_tab.dart';
import 'package:musaab_adam/modules/profile/components/saved_products_tab.dart';
import 'package:musaab_adam/modules/profile/components/review_tab.dart';
import 'package:musaab_adam/modules/profile/components/shop_tab.dart';
import 'package:musaab_adam/modules/profile/components/shows_tab.dart';
import 'package:musaab_adam/modules/profile/controllers/profile_shows_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/text_button_widget.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_text.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final RxInt mainTabCurrentIndex = 0.obs;
  final RxInt refreshTrigger = 0.obs;
  final AuthController _authController = Get.find<AuthController>();

  static String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}m';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        actions:[
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.wishlistScreen),
            icon: Icon(Icons.favorite_border, color: colorScheme.primary),
            tooltip: 'Wishlist',
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.screen_share_outlined,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        final currentUser = _authController.currentUser.value;
        if (currentUser == null) return const SizedBox.shrink();
        final isApprovedSeller = currentUser.isSellerApproved;

        final List<String> activeTabTitles = [];
        if (isApprovedSeller) {
          activeTabTitles.add(AppStrings.shop.tr);
          activeTabTitles.add(AppStrings.shows.tr);
          activeTabTitles.add(AppStrings.reviews.tr);
        }
        activeTabTitles.add(AppStrings.snaps.tr);
        activeTabTitles.add('Saved Products');

        final activeIndex = mainTabCurrentIndex.value;
        final activeTitle = (activeIndex >= 0 && activeIndex < activeTabTitles.length)
            ? activeTabTitles[activeIndex]
            : '';

        final isShopTab = activeTitle == AppStrings.shop.tr;

        if (isApprovedSeller && isShopTab) {
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
      body: RefreshIndicator(
        onRefresh: () async {
          await _authController.reloadUser();
          if (Get.isRegistered<ProfileShowsController>()) {
            await Get.find<ProfileShowsController>().loadShows();
          }
          refreshTrigger.value++;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Obx(() {
              final user = _authController.currentUser.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedImageWidget(
                      imageUrl: user?.avatarUrl ?? '',
                      height: 60.h,
                      width: 60.w,
                    ),
                  ),
                SizedBox(height: 12.h),
                CustomText(
                  text: user?.displayNameOrUsername ?? '',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontColor: colorScheme.onSurface,
                ),
                SizedBox(height: 20.h),

                // Stats Container
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
                        (((user?.sellerProfile?['averageRating'] as num?)?.toDouble() ?? 0.0) > 0
                                ? (user?.sellerProfile?['averageRating'] as num).toDouble()
                                : 5.0)
                            .toStringAsFixed(1),
                        "Ratings",
                        colorScheme,
                        icon: Icons.star,
                      ),

                      _buildVerticalDivider(colorScheme),
                      _buildStatColumn(
                        _formatCount(user?.followersCount ?? 0),
                        "Follower",
                        colorScheme,
                      ),
                      _buildVerticalDivider(colorScheme),
                      _buildStatColumn(
                        _formatCount(user?.followingCount ?? 0),
                        "Following",
                        colorScheme,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: AppStrings.editProfile,
                        textColor: Colors.white,
                        backgroundColor: colorScheme.primary,
                        buttonHeight: 40,
                        fontSize: 14,
                        onPressed: () => Get.toNamed(AppRoutes.updateProfileScreen),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Tabs Row
                Obx(() {
                  final user = _authController.currentUser.value;
                  final isApprovedSeller = user?.isSellerApproved ?? false;

                  final List<_ProfileTabItem> tabs = [];
                  if (isApprovedSeller) {
                    tabs.add(_ProfileTabItem(
                      title: AppStrings.shop.tr,
                      content: ShopTab(
                        key: ValueKey('shop_${refreshTrigger.value}'),
                        sellerId: user?.id,
                      ),
                    ));
                    tabs.add(_ProfileTabItem(
                      title: AppStrings.shows.tr,
                      content: ShowsTab(
                        key: ValueKey('shows_${refreshTrigger.value}'),
                      ),
                    ));
                    tabs.add(_ProfileTabItem(
                      title: AppStrings.reviews.tr,
                      content: ReviewTab(
                        key: ValueKey('reviews_${refreshTrigger.value}'),
                        sellerId: user?.id,
                      ),
                    ));
                  }

                  tabs.add(_ProfileTabItem(
                    title: AppStrings.snaps.tr,
                    content: SnapsTab(
                      key: ValueKey('snaps_${refreshTrigger.value}'),
                    ),
                  ));
                  tabs.add(_ProfileTabItem(
                    title: 'Saved Products',
                    content: SavedProductsTab(
                      key: ValueKey('saved_${refreshTrigger.value}'),
                    ),
                  ));

                  if (mainTabCurrentIndex.value >= tabs.length) {
                    mainTabCurrentIndex.value = 0;
                  }

                  return Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            for (int i = 0; i < tabs.length; i++) ...[
                              _buildTab(tabs[i].title, i, colorScheme),
                              if (i < tabs.length - 1) SizedBox(width: 20.w),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      IndexedStack(
                        index: mainTabCurrentIndex.value,
                        children: tabs.map((t) => t.content).toList(),
                      ),
                    ],
                  );
                }),
              ],
            );
          }),
        ),
      ),
    ),
  );
}

  Widget _buildStatColumn(String value, String label, ColorScheme colorScheme, {IconData? icon}) {
    return Column(
      children: [
        Row(
          children:[
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
      final isSelected = mainTabCurrentIndex.value == index;
      return TextButtonWidget(
        text: title,
        textColor: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
        fontSize: 14,
        decoration: isSelected ? TextDecoration.underline : null,
        decorationColor: colorScheme.primary,
        fontWeight: FontWeight.w600,
        onPressed: () {
          mainTabCurrentIndex.value = index;
          refreshTrigger.value++;
        },
      );
    });
  }
}

class _ProfileTabItem {
  final String title;
  final Widget content;
  _ProfileTabItem({required this.title, required this.content});
}
