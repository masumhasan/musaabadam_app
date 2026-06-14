import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/role_service.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';
import 'package:musaab_adam/modules/profile/components/payment_shipping_dialog.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/labeled_iconbutton.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/tile_button.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/utils/app_constants.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final RoleService roleService = Get.find<RoleService>();
  final AuthController _authCtrl = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                SizedBoxWidget(height: 12),
                //======================PHOTO SECTION======================//
                Obx(() {
                  final user = _authCtrl.currentUser.value;
                  return Row(
                    children:[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedImageWidget(
                          imageUrl: user?.avatarUrl ?? '',
                          height: 45.h,
                          width: 45.w,
                        ),
                      ),
                      SizedBoxWidget(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          CustomText(
                            text: user?.displayNameOrUsername ?? '',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                          CustomButton(
                            label: AppStrings.viewProfile,
                            fontSize: 12,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            buttonHeight: 30,
                            onPressed: () => Get.toNamed(AppRoutes.profileScreen),
                          ),
                        ],
                      )
                    ],
                  );
                }),
                SizedBoxWidget(height: 10),
                //======================SELLER TOOLS======================//
                if( roleService.getUpdatedRole() == Role.seller )...[
                  CustomText(text: AppStrings.tools, fontWeight: FontWeight.w600, fontSize: 20),
                  _buildTile(AppStrings.sellerTool, Icons.pan_tool_alt_outlined,
                          () => Get.toNamed(AppRoutes.sellerToolsScreen)
                  ),
                ],
                 //======================ACCOUNT SETTINGS======================//
                CustomText(text: AppStrings.account, fontWeight: FontWeight.w600, fontSize: 20),
                SizedBoxWidget(height: 8),
                //==========================REFERRAL AND REWARDS============================//
                Row(
                  children:[
                    Expanded(
                      child: LabeledIconButton(
                        iconPath: Assets.icons.referalCash,
                        iconHeight: 33,
                        iconWidth: 33,
                        text: AppStrings.referralsCredit,
                        fontColor: Colors.white, // Kept static if brand requirement
                        isLabelInside: true,
                        borderRadius: 8,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        padding: [0, 18],
                        onClick: () => Get.toNamed(AppRoutes.inviteScreen),
                      ),
                    ),
                    SizedBoxWidget(width: 15),
                    Expanded(
                      child: LabeledIconButton(
                        iconPath: Assets.icons.myRewards,
                        iconHeight: 33,
                        iconWidth: 33,
                        text: AppStrings.myRewards,
                        fontColor: Colors.white,
                        isLabelInside: true,
                        borderRadius: 8,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        padding: [0, 18],
                        onClick: () => Get.toNamed(AppRoutes.myRewardsScreen),
                      ),
                    )
                  ],
                ),
                SizedBoxWidget(height: 20),
                _buildTile(AppStrings.accountHealth, Icons.verified_user_outlined, () => Get.toNamed(AppRoutes.accountHealthScreen)),
                _buildTile(AppStrings.paymentsShipping, Icons.payment, showPaymentDialog),
                _buildTile(AppStrings.addresses, Icons.location_pin, () => Get.toNamed(AppRoutes.addressesScreen)),
                _buildTile(AppStrings.notificationSettings, Icons.notifications_none_rounded, () => Get.toNamed(AppRoutes.notificationSettingsScreen)),
                _buildTile(AppStrings.changeEmail, Icons.mail_outline_rounded, () => Get.toNamed(AppRoutes.changeCredential, arguments: {'isPasswordChange': false})),
                _buildTile(AppStrings.changePassword, Icons.key, () => Get.toNamed(AppRoutes.changeCredential, arguments: {'isPasswordChange': true})),

                TileButton(
                  title: AppStrings.preferences,
                  isIconDefault: false,
                  svgIconPath: Assets.icons.preferences,
                  onClick: () => Get.toNamed(AppRoutes.preferencesScreen),
                ),
                SizedBoxWidget(height: 30),

                //======================HELP AND LEGAL======================//
                CustomText(text: AppStrings.helpLegal, fontWeight: FontWeight.w600, fontSize: 20),
                SizedBoxWidget(height: 15),
                _buildTile(AppStrings.contactUs, Icons.perm_contact_calendar_sharp, () => Get.toNamed(AppRoutes.contactUsScreen)),
                _buildTile(AppStrings.userReports, Icons.info_outline_rounded, () => Get.toNamed(AppRoutes.userReports)),
                _buildTile(AppStrings.salesTaxExemption, Icons.percent, () => Get.toNamed(AppRoutes.salesTaxExemptionScreen)),
                _buildTile(AppStrings.privacyPolicy, Icons.privacy_tip_outlined, () => Get.toNamed(AppRoutes.privacyPolicy, arguments: AppStrings.privacyPolicy)),
                _buildTile(AppStrings.termsConditions, Icons.bookmark_add_outlined, () => Get.toNamed(AppRoutes.privacyPolicy, arguments: AppStrings.termsConditions)),
                _buildTile(AppStrings.faqs, Icons.question_mark, () => Get.toNamed(AppRoutes.privacyPolicy, arguments: AppStrings.faqs)),

                SizedBoxWidget(height: 20),
                CustomButton(
                  label: AppStrings.signOut,
                  buttonHeight: 40,
                  prefixIcon: Icons.output_rounded,
                  buttonWidth: double.infinity,
                  onPressed: _authCtrl.logout,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper to reduce boilerplate
  Widget _buildTile(String title, IconData icon, VoidCallback onTap) {
    return Column(
      children:[
        TileButton(title: title, defaultIcon: icon, onClick: onTap),
        SizedBoxWidget(height: 10),
      ],
    );
  }

  void showPaymentDialog() {
    Get.dialog(
      const PaymentShippingDialog(),
      barrierDismissible: true,
      transitionCurve: Curves.easeOutBack,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}