import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';

import '../../../core/widgets/sized_box_widget.dart';
import '../../../core/widgets/tile_button.dart';

class ShippingScreen extends StatelessWidget {
  ShippingScreen({super.key});

  final RxBool isFreePickup = false.obs;
  final RxBool isRoyalMail = false.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.shipping,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children:[
            // 1. Free Pickup Switch
            _buildSwitchTile(
              title: AppStrings.freePickup,
              icon: Icons.inventory_2_outlined,
              state: isFreePickup,
              colorScheme: colorScheme,
            ),
            SizedBoxWidget(height: 15.h),

            // 2. Royal Mail Switch
            _buildSwitchTile(
              title: AppStrings.royalMail,
              icon: Icons.description_outlined,
              state: isRoyalMail,
              colorScheme: colorScheme,
            ),
            SizedBoxWidget(height: 15.h),

            // 3. Shipping Profiles (Button)
            TileButton(
              title: AppStrings.shippingProfiles,
              defaultIcon: Icons.local_shipping_outlined,
              onClick: () {
                Get.toNamed(AppRoutes.shippingProfilesScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      {required String title, required IconData icon, required RxBool state, required ColorScheme colorScheme}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.primary, // Matches the blocky design in screenshot
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children:[
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBoxWidget(width: 12),
          Expanded(
            child: CustomText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontColor: Colors.white,
              textAlignment: TextAlign.start,
            ),
          ),
          Obx(() => Switch(
            value: state.value,
            activeColor: Colors.white,
            activeTrackColor: colorScheme.surface.withValues(alpha: 0.3),
            onChanged: (val) => state.value = val,
          )),
        ],
      ),
    );
  }
}