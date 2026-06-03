import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/tile_button.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class SellerToolScreen extends StatelessWidget {
  const SellerToolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.sellerTool,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            // --- MANAGE SECTION ---
            CustomText(text: AppStrings.manage, fontSize: 18, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            _buildTile(AppStrings.inventory, Icons.inventory_2_outlined, () => Get.toNamed(AppRoutes.sellerInventoryScreen)),
            _buildTile(AppStrings.shows, Icons.video_call_outlined, () => Get.toNamed(AppRoutes.showsScreen)),
            _buildTile(AppStrings.offers, Icons.percent_outlined, (){
              Get.toNamed(AppRoutes.offersScreen);
            }),
            _buildTile(AppStrings.customerSupport, Icons.headset_mic_outlined, (){
              Get.toNamed(AppRoutes.inboxScreen);
            }),

            SizedBoxWidget(height: 20.h),

            // --- SALES SECTION ---
            CustomText(text: AppStrings.sales, fontSize: 18, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            _buildTile(AppStrings.payouts, Icons.account_balance_wallet_outlined, () => Get.toNamed(AppRoutes.sellerPayoutScreen)),
            _buildTile(AppStrings.fulfillment, Icons.local_shipping_outlined, () => Get.toNamed(AppRoutes.fulfillmentScreen)),
            _buildTile(AppStrings.orders, Icons.description_outlined, () => Get.toNamed(AppRoutes.sellerOrderScreen)),
            _buildTile(AppStrings.tips, Icons.lightbulb_outline, () => Get.toNamed(AppRoutes.tipsScreen) ),

            SizedBoxWidget(height: 20.h),

            // --- PROMOTIONS SECTION ---
            CustomText(text: AppStrings.promotions, fontSize: 18, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            _buildTile(AppStrings.inviteASellerEarn, Icons.group_add_outlined, () => Get.toNamed(AppRoutes.inviteSellerScreen)),
            _buildTile(AppStrings.referBuyersGainFollowers, Icons.rate_review_outlined, () => Get.toNamed(AppRoutes.inviteScreen)),
            _buildTile(AppStrings.promoteTools, Icons.lightbulb_outline, () => Get.toNamed(AppRoutes.promoteToolScreen)),
            SizedBoxWidget(height: 20.h),

// Performance Section
            CustomText(text: AppStrings.performance, fontSize: 18, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            _buildTile(AppStrings.premierShop, Icons.storefront_outlined, () => Get.toNamed(AppRoutes.mainScreen)),
            _buildTile(AppStrings.sellerAnalytics, Icons.shopping_bag_outlined, () => Get.toNamed(AppRoutes.mainScreen)),
            SizedBoxWidget(height: 20.h),

// Settings Section
            CustomText(text: AppStrings.settings, fontSize: 18, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            _buildTile(AppStrings.shipping, Icons.local_shipping_outlined, () => Get.toNamed(AppRoutes.shippingScreen)),
            _buildTile(AppStrings.sellerStatus, Icons.home_work_outlined, () => Get.toNamed(AppRoutes.permissionsScreen)),
            _buildTile(AppStrings.rehearsalMode, Icons.videocam_outlined, () => Get.toNamed(AppRoutes.rehearsalScreen)),

          ],
        ),
      ),
    );
  }

  // Your requested helper method
  Widget _buildTile(String title, IconData icon, VoidCallback onTap) {
    return Column(
      children:[
        TileButton(
          title: title,
          defaultIcon: icon,
          onClick: onTap,
          isIconDefault: true,
        ),
        SizedBoxWidget(height: 10),
      ],
    );
  }
}