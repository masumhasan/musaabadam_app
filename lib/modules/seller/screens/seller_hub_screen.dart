import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../controllers/seller_hub_controller.dart';

class SellerHubScreen extends StatelessWidget {
  const SellerHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellerHubController());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(text: AppStrings.sellerHub, fontWeight: FontWeight.w700),
        centerTitle: true,
        ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            SizedBoxWidget(height: 20.h),

            // 1. Top Action Buttons
            Row(
              spacing: 15.w,
              children:[
                _buildMainAction(AppStrings.createAProduct, Icons.add_chart, colorScheme, 
                (){
                  Get.toNamed(AppRoutes.createQualityListingScreen);
                },),
                _buildMainAction(AppStrings.scheduleAShow, Icons.play_circle_outline, colorScheme,
                    (){
                  Get.toNamed(AppRoutes.scheduleLiveShowScreen);
                    }
                ),
              ],
            ),
            SizedBoxWidget(height: 20.h),

            // 2. Verify Account Card
            _buildVerifyCard(colorScheme, context),
            SizedBoxWidget(height: 20.h),

            // 3. Fulfillment Section
            CustomText(text: AppStrings.fulfillment, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            _buildFulfillmentTile(AppStrings.readyToShip, colorScheme,
                (){
              Get.toNamed(AppRoutes.fulfillmentScreen);
                }
            ),
            SizedBoxWidget(height: 10.h),
            Obx(() {
              final count = controller.upcomingShowsCount.value;
              final label = count > 0 ? '$count Upcoming Shows' : 'No Upcoming Shows';
              return _buildFulfillmentTile(label, colorScheme, () {
                Get.toNamed(AppRoutes.showsScreen);
              });
            }),
            SizedBoxWidget(height: 20.h),

            // 4. Boost Card
            _buildBoostCard(colorScheme),
            SizedBoxWidget(height: 20.h),

            // 5. Account Health
            CustomText(text: AppStrings.accountHealth, fontWeight: FontWeight.w700),
            CustomText(text: AppStrings.policyStanding),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.primary),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: CustomText(text: AppStrings.excellent, textAlignment: TextAlign.start),
            ),
            SizedBoxWidget(height: 20.h),

            // 6. Upcoming Shows
            CustomText(text: AppStrings.upcomingShows, fontWeight: FontWeight.w700),
            SizedBoxWidget(height: 10.h),
            Center(child: SvgPicture.asset("assets/icons/shows_graphic.svg")),
            SizedBoxWidget(height: 20.h),
            CustomButton(label: AppStrings.scheduleAShow,
            onPressed: (){
              Get.toNamed(AppRoutes.scheduleLiveShowScreen);
            },
            ),
            SizedBoxWidget(height: 30.h),

            // 7. Bottom Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 15.h,
              crossAxisSpacing: 15.w,
              childAspectRatio: 2.2,
              children:[
                _buildBottomAction(AppStrings.payouts, Icons.currency_pound, colorScheme,
                    (){
                      Get.toNamed(AppRoutes.sellerPayoutScreen);
                    }
                ),
                _buildBottomAction(AppStrings.orders, Icons.description_outlined, colorScheme,
                    (){
                  Get.toNamed(AppRoutes.sellerOrderScreen);
                    }
                ),
                _buildBottomAction(AppStrings.inventory, Icons.sell_outlined, colorScheme,
                    (){
                  Get.toNamed(AppRoutes.sellerInventoryScreen);
                    }
                ),
                _buildBottomAction(AppStrings.rehearsalMode, Icons.videocam_outlined, colorScheme,
                    (){
                  Get.toNamed(AppRoutes.startShowScreen, arguments: {'isRehearsal': true});
                    }
                ),
              ],
            ),
            SizedBoxWidget(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMainAction(String label, IconData icon, ColorScheme colorScheme, VoidCallback onPressed) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          onPressed();
        },
        child: Container(
          height: 100.h,
          decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(12.r)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Icon(icon, color: Colors.white, size: 30.sp),
              CustomText(text: label, fontColor: Colors.white, fontWeight: FontWeight.w600),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyCard(ColorScheme colorScheme, BuildContext context) {
    return GestureDetector(
      onTap: (){
        showScanIdDialog(context);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          children:[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  CustomText(text: AppStrings.verifyAccount, fontWeight: FontWeight.w700),
                  CustomText(text: AppStrings.verifyAccountDesc, fontSize: 12, maxLines: 2),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurface),
          ],
        ),
      ),
    );
  }

  void showScanIdDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Get.dialog(
      Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Important: Wraps content
            children:[
              // Icon Placeholder (Use SvgPicture.asset if you have the asset)
              Icon(Icons.qr_code_scanner, size: 80.sp, color: colorScheme.onSurface),
              SizedBoxWidget(height: 25.h),

              // Title
              CustomText(
                text: AppStrings.getReadyToScan.tr,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontColor: colorScheme.onSurface,
              ),
              SizedBoxWidget(height: 15.h),

              // Description
              CustomText(
                text: AppStrings.acceptedIdForms.tr,
                fontSize: 14,
                fontColor: colorScheme.outline,
                textAlignment: TextAlign.center,
              ),
              SizedBoxWidget(height: 20.h),

              // "Well-lit" instruction
              CustomText(
                text: AppStrings.wellLitSpace.tr,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontColor: colorScheme.onSurface,
              ),
              SizedBoxWidget(height: 25.h),

              // Button
              CustomButton(
                label: AppStrings.imReady.tr,
                buttonWidth: double.infinity,
                textColor: Colors.white,
                backgroundColor: colorScheme.primary,
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildFulfillmentTile(String label, ColorScheme colorScheme, VoidCallback onPressed) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            CustomText(text: label, fontColor: Colors.white, fontWeight: FontWeight.w600),
            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildBoostCard(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          CustomText(text: AppStrings.alwaysHaveAShow, fontWeight: FontWeight.w700),
          CustomText(text: AppStrings.alwaysHaveAShowDesc, fontSize: 12),
          SizedBoxWidget(height: 10.h),
          IntrinsicWidth(child: CustomButton(label: AppStrings.getStarted)),
        ],
      ),
    );
  }

  Widget _buildBottomAction(String label, IconData icon, ColorScheme colorScheme, VoidCallback onClick) {
    return GestureDetector(
      onTap: (){
        onClick();
      },
      child: Container(
        decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Icon(icon, color: Colors.white),
            SizedBoxWidget(width: 8.w),
            CustomText(
                text: label, fontColor: Colors.white, fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}