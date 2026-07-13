import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';
import 'package:musaab_adam/modules/profile/components/snaps_tab.dart';
import 'package:musaab_adam/modules/profile/components/review_tab.dart';
import 'package:musaab_adam/modules/profile/components/shop_tab.dart';
import 'package:musaab_adam/modules/profile/components/shows_tab.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/text_button_widget.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_text.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final RxInt mainTabCurrentIndex = 0.obs;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Obx(() {
            final user = _authController.currentUser.value;
            return Column(
              spacing: 20.h,
              children:[
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedImageWidget(
                    imageUrl: user?.avatarUrl ?? '',
                    height: 60.h,
                    width: 60.w,
                  ),
                ),
                CustomText(
                  text: user?.displayNameOrUsername ?? '',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontColor: colorScheme.onSurface,
                ),

                // Stats Container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      _buildStatColumn(
                        ((user?.sellerProfile?['averageRating'] as num?)?.toDouble() ?? 0.0).toStringAsFixed(1),
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

                // Action Buttons
                Row(
                  spacing: 20.w,
                  children:[
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

                // Tabs Row
                Row(
                  spacing: 15.w,
                  children:[
                    _buildTab(AppStrings.shop.tr, 0, colorScheme),
                    _buildTab(AppStrings.shows.tr, 1, colorScheme),
                    _buildTab(AppStrings.reviews.tr, 2, colorScheme),
                    _buildTab(AppStrings.snaps.tr, 3, colorScheme),
                  ],
                ),

                // Tab Content
                Obx(() => IndexedStack(
                  index: mainTabCurrentIndex.value,
                  children: [ShopTab(sellerId: _authController.currentUser.value?.id), ShowsTab(), ReviewTab(sellerId: _authController.currentUser.value?.id), const SnapsTab()],
                )),
              ],
            );
          }),
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
        onPressed: () => mainTabCurrentIndex.value = index,
      );
    });
  }
}
