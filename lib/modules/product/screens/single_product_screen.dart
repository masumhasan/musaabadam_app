import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/modules/product/controllers/single_product_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import '../../../core/utils/app_constants.dart';

class SingleProductScreen extends GetView<SingleProductController> {
  const SingleProductScreen({super.key});

  static const Color _tealColor = Color(0xFF0088A9);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: colorScheme.onSurface, size: 26.sp),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'Make Offer',
                  backgroundColor: _tealColor,
                  textColor: Colors.white,
                  buttonHeight: 46.h,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  onPressed: controller.makeOffer,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomButton(
                  label: 'Buy Now',
                  backgroundColor: Colors.orange,
                  textColor: Colors.white,
                  buttonHeight: 46.h,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  onPressed: controller.buyNow,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final p = controller.product.value;
        if (p == null) {
          return Center(
            child: CustomText(
              text: 'Product not found',
              fontColor: colorScheme.outline,
            ),
          );
        }

        final seller = controller.sellerProfile.value;
        final sellerName = seller?['displayName'] ?? seller?['username'] ?? 'Jack Mama';
        final sellerAvatar = seller?['avatarUrl'] ?? Dummy.user1;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Display
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedImageWidget(
                  imageUrl: p.images.isNotEmpty ? p.images.first : Dummy.product1,
                  height: 280.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.h),

              // Title & Condition / Size
              CustomText(
                text: p.title.isNotEmpty ? p.title : 'Hand Bag',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontColor: colorScheme.onSurface,
                textAlignment: TextAlign.start,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: p.condition.isNotEmpty
                    ? p.condition.replaceAll('_', ' ').capitalizeFirst!
                    : 'One Size',
                fontSize: 14.sp,
                fontColor: colorScheme.onSurfaceVariant,
                textAlignment: TextAlign.start,
              ),
              SizedBox(height: 8.h),

              // Price & Shipping
              CustomText(
                text: '£${p.price.toStringAsFixed(0)}+ £3 shipping',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                fontColor: colorScheme.onSurface,
                textAlignment: TextAlign.start,
              ),
              SizedBox(height: 4.h),

              // Views Count
              CustomText(
                text: '${p.viewsCount > 0 ? p.viewsCount : 68} views on this item',
                fontSize: 12.sp,
                fontColor: colorScheme.outline,
                textAlignment: TextAlign.start,
              ),
              SizedBox(height: 16.h),

              // Save / Bookmark UI & Share Pill Action Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.toggleSaveUI,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: _tealColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Icon(
                          controller.isSaved.value
                              ? Icons.bookmark
                              : Icons.bookmark_border_rounded,
                          color: _tealColor,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.shareProduct,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: _tealColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Icon(
                          Icons.ios_share_rounded,
                          color: _tealColor,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Seller Preview Banner (Light Cyan Box)
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: _tealColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: CachedImageWidget(
                        imageUrl: sellerAvatar,
                        height: 44.r,
                        width: 44.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomText(
                        text: sellerName,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontColor: colorScheme.onSurface,
                        textAlignment: TextAlign.start,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: _tealColor.withValues(alpha: 0.3)),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.chat_bubble_outline_rounded, color: _tealColor, size: 20.sp),
                        onPressed: controller.openMessage,
                        tooltip: 'Message Seller',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // Seller 4-Column Teal Stats Bar
              _buildSellerStatsBar(colorScheme),
              SizedBox(height: 20.h),

              // Segmented Tab Selector: Details | Seller Info
              Row(
                children: [
                  _buildTabHeader('Details', 0, colorScheme),
                  SizedBox(width: 20.w),
                  _buildTabHeader('Seller Info', 1, colorScheme),
                ],
              ),
              SizedBox(height: 16.h),

              // Tab Content Switcher
              controller.selectedTab.value == 0
                  ? _buildDetailsTab(p, colorScheme)
                  : _buildSellerInfoTab(p, sellerName, sellerAvatar, colorScheme),

              SizedBox(height: 40.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSellerStatsBar(ColorScheme colorScheme) {
    return Obx(() {
      final ratingVal = controller.sellerRating.value > 0 ? controller.sellerRating.value : 5.0;
      final ratingStr = '★ ${ratingVal.toStringAsFixed(1)}';
      final followerStr = controller.formatCount(controller.followersCount.value);
      final soldStr = controller.formatCount(controller.itemsSold.value);
      final shipStr = controller.avgShipTime.value.isNotEmpty ? controller.avgShipTime.value : '2d';

      return Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: _tealColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatColumn(ratingStr, 'Rating'),
            _buildDivider(),
            _buildStatColumn(followerStr, 'Follower'),
            _buildDivider(),
            _buildStatColumn(soldStr, 'Sold'),
            _buildDivider(),
            _buildStatColumn(shipStr, 'Avg Ship'),
          ],
        ),
      );
    });
  }


  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        CustomText(
          text: value,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          fontColor: Colors.white,
        ),
        SizedBox(height: 2.h),
        CustomText(
          text: label,
          fontSize: 11.sp,
          fontColor: Colors.white.withValues(alpha: 0.8),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24.h,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

  Widget _buildTabHeader(String title, int index, ColorScheme colorScheme) {
    final isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.selectedTab.value = index,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 16.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontColor: isSelected ? colorScheme.onSurface : colorScheme.outline,
          ),
          SizedBox(height: 4.h),
          Container(
            height: 2.h,
            width: 50.w,
            color: isSelected ? colorScheme.onSurface : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(ProductModel p, ColorScheme colorScheme) {
    final descriptionText = p.description.isNotEmpty
        ? p.description
        : 'A stylish and versatile shoulder bag designed for daily use. Made with high-quality materials, this bag offers durability, comfort, and a modern look suitable for work, travel, or casual outings.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: descriptionText,
          fontSize: 14.sp,
          fontColor: colorScheme.onSurface.withValues(alpha: 0.8),
          textAlignment: TextAlign.start,
        ),
        SizedBox(height: 16.h),

        _buildSpecRow('Category', p.category.isNotEmpty ? p.category.capitalizeFirst! : 'Fashion', colorScheme),
        _buildSpecRow('Type', p.listingType.isNotEmpty ? p.listingType.replaceAll('_', ' ').capitalizeFirst! : 'Hand bag', colorScheme),
        _buildSpecRow('Brand', p.tags.isNotEmpty ? p.tags.first.capitalizeFirst! : 'Gucci', colorScheme),
        _buildSpecRow('Size', p.condition.isNotEmpty ? p.condition.replaceAll('_', ' ').capitalizeFirst! : 'Large', colorScheme),

        SizedBox(height: 20.h),
        CustomText(
          text: 'Buyer Protections',
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          fontColor: colorScheme.onSurface,
        ),
        SizedBox(height: 10.h),

        // Buyer Guarantee Teal Card
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: _tealColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Icon(Icons.verified_user_outlined, color: Colors.white, size: 22.sp),
              SizedBox(width: 10.w),
              CustomText(
                text: 'Buyer Guarantee',
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontColor: Colors.white,
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: Colors.white, size: 22.sp),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 100.w,
            child: CustomText(
              text: label,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontColor: colorScheme.onSurface,
              textAlignment: TextAlign.start,
            ),
          ),
          CustomText(
            text: value,
            fontSize: 14.sp,
            fontColor: colorScheme.outline,
            textAlignment: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildSellerInfoTab(ProductModel p, String sellerName, String sellerAvatar, ColorScheme colorScheme) {
    final reviews = controller.sellerReviews;
    final otherProducts = controller.sellerProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'About the seller',
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          fontColor: colorScheme.onSurface,
        ),
        SizedBox(height: 12.h),

        // Hero Cover Photo Banner with overlapping seller avatar
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: CachedImageWidget(
                imageUrl: Dummy.cover1,
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

            ),
            Positioned(
              bottom: -24.h,
              child: CircleAvatar(
                radius: 26.r,
                backgroundColor: colorScheme.surface,
                child: CircleAvatar(
                  radius: 24.r,
                  backgroundImage: NetworkImage(sellerAvatar),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 32.h),

        Center(
          child: CustomText(
            text: sellerName,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontColor: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 12.h),

        _buildSellerStatsBar(colorScheme),
        SizedBox(height: 16.h),

        CustomText(
          text: '"Hi! I\'m here to make your shopping easy and enjoyable. I offer quality items, fast responses, and honest service. Happy to help anytime!"',
          fontSize: 13.sp,
          fontColor: colorScheme.onSurface.withValues(alpha: 0.8),
          textAlignment: TextAlign.center,
        ),
        SizedBox(height: 16.h),

        // Follow & Message buttons
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: controller.isFollowing.value ? 'Following' : 'Follow',
                backgroundColor: _tealColor,
                textColor: Colors.white,
                buttonHeight: 42.h,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                onPressed: controller.toggleFollow,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomButton(
                label: 'Message',
                backgroundColor: Colors.orange,
                textColor: Colors.white,
                buttonHeight: 42.h,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                onPressed: controller.openMessage,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),

        // Seller Feedback section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Seller Feedback (${controller.ratingCount.value > 0 ? controller.ratingCount.value : '1.9k'})',
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              fontColor: colorScheme.onSurface,
            ),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.otherUserProfileScreen, arguments: p.sellerId),
              child: CustomText(
                text: 'View All',
                fontSize: 13.sp,
                fontColor: _tealColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        if (reviews.isNotEmpty)
          _buildReviewItem(reviews.first, colorScheme)
        else
          _buildDefaultReviewItem(colorScheme),

        SizedBox(height: 24.h),

        // More from this seller
        CustomText(
          text: 'More from this seller',
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          fontColor: colorScheme.onSurface,
        ),
        SizedBox(height: 12.h),

        if (otherProducts.isNotEmpty)
          Column(
            children: otherProducts
                .take(3)
                .map((item) => _buildMoreProductTile(item, colorScheme))
                .toList(),
          )
        else
          _buildMoreProductTile(p, colorScheme),
      ],
    );
  }

  Widget _buildReviewItem(dynamic r, ColorScheme colorScheme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundImage: NetworkImage(r.buyerAvatarUrl ?? Dummy.user1),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: r.buyerName ?? 'Isabela Silveira',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                textAlignment: TextAlign.start,
              ),
              CustomText(
                text: 'Desenvolvedora',
                fontSize: 12.sp,
                fontColor: colorScheme.outline,
                textAlignment: TextAlign.start,
              ),
            ],
          ),
        ),
        Row(
          children: List.generate(
            5,
            (index) => Icon(Icons.star, color: AppColors.orange, size: 16.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultReviewItem(ColorScheme colorScheme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundImage: const NetworkImage(Dummy.user1),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Isabela Silveira',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                textAlignment: TextAlign.start,
              ),
              CustomText(
                text: 'Desenvolvedora',
                fontSize: 12.sp,
                fontColor: colorScheme.outline,
                textAlignment: TextAlign.start,
              ),
            ],
          ),
        ),
        Row(
          children: List.generate(
            5,
            (index) => Icon(Icons.star, color: AppColors.orange, size: 16.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreProductTile(ProductModel item, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.singleProductScreen, arguments: item),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedImageWidget(
                imageUrl: item.images.isNotEmpty ? item.images.first : Dummy.product1,
                height: 80.h,
                width: 80.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: item.title,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    textAlignment: TextAlign.start,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: item.condition.isNotEmpty ? item.condition.replaceAll('_', ' ').capitalizeFirst! : 'One Size',
                    fontSize: 13.sp,
                    fontColor: colorScheme.outline,
                    textAlignment: TextAlign.start,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: 'Sold for: £${item.price.toStringAsFixed(0)}',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    fontColor: colorScheme.onSurface,
                    textAlignment: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
